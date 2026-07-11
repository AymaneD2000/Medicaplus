import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../Models/downloaded_pdf.dart';
import '../Utils/permission_service.dart';

class PdfDownloadService {
  static Database? _database;
  static const String _tableName = 'downloaded_pdfs';

  static String _sanitizeFileName(String input) {
    final withoutControls = input.replaceAll(RegExp(r'[\x00-\x1F]'), ' ');
    final withoutInvalidPathChars =
        withoutControls.replaceAll(RegExp(r'[\\/:*?"<>|]'), ' ');
    final collapsed =
        withoutInvalidPathChars.replaceAll(RegExp(r'\s+'), ' ').trim();

    return collapsed.isEmpty ? 'document' : collapsed;
  }

  static String _buildPdfFileName(String name, {String? suffix}) {
    final sanitizedName = _sanitizeFileName(name);
    final suffixPart = (suffix == null || suffix.trim().isEmpty)
        ? ''
        : '_${_sanitizeFileName(suffix)}';

    return 'MedPharm_$sanitizedName$suffixPart.pdf';
  }

  static Future<Directory> _getMedPharmDownloadsDirectory() async {
    Directory baseDownloadsDir;

    if (Platform.isAndroid) {
      final publicDownloadsDir = Directory('/storage/emulated/0/Download');
      if (await publicDownloadsDir.exists()) {
        baseDownloadsDir = publicDownloadsDir;
      } else {
        baseDownloadsDir = await getDownloadsDirectory() ??
            await getApplicationDocumentsDirectory();
      }
    } else {
      baseDownloadsDir = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
    }

    final medpharmDir = Directory('${baseDownloadsDir.path}/MedPharm');
    if (!await medpharmDir.exists()) {
      await medpharmDir.create(recursive: true);
    }

    return medpharmDir;
  }

  // Initialize database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/downloaded_pdfs.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName(
            id TEXT PRIMARY KEY,
            originalId TEXT NOT NULL,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            localPath TEXT NOT NULL,
            originalUrl TEXT NOT NULL,
            downloadDate TEXT NOT NULL,
            fileSize INTEGER NOT NULL,
            hasLogo INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // Check if PDF is already downloaded
  static Future<bool> isPdfDownloaded(String originalId) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'originalId = ?',
      whereArgs: [originalId],
    );
    return result.isNotEmpty;
  }

  // Get downloaded PDF by original ID
  static Future<DownloadedPdf?> getDownloadedPdf(String originalId) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'originalId = ?',
      whereArgs: [originalId],
    );

    if (result.isNotEmpty) {
      return DownloadedPdf.fromMap(result.first);
    }
    return null;
  }

  // Get all downloaded PDFs
  static Future<List<DownloadedPdf>> getAllDownloadedPdfs() async {
    final db = await database;
    final result = await db.query(_tableName, orderBy: 'downloadDate DESC');
    return result.map((map) => DownloadedPdf.fromMap(map)).toList();
  }

  // Download PDF locally
  static Future<DownloadedPdf?> downloadPdf({
    required String originalId,
    required String name,
    required String description,
    required String url,
    bool addLogo = false,
    BuildContext? context,
  }) async {
    try {
      // For external download, check storage permission first
      if (addLogo && context != null && context.mounted) {
        final hasPermission =
            await PermissionService.requestStoragePermission(context);
        if (!hasPermission) {
          return null;
        }
      }

      // For simple download, check if already downloaded
      if (!addLogo && await isPdfDownloaded(originalId)) {
        return await getDownloadedPdf(originalId);
      }

      // Download PDF content
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download PDF');
      }

      final originalPdfBytes = response.bodyBytes;

      if (addLogo) {
        // Download to external storage
        return await _downloadToExternal(
          originalId: originalId,
          name: name,
          description: description,
          url: url,
          pdfBytes: originalPdfBytes,
        );
      } else {
        // Simple download to internal storage
        return await _downloadSimpleToInternal(
          originalId: originalId,
          name: name,
          description: description,
          url: url,
          pdfBytes: originalPdfBytes,
        );
      }
    } catch (e) {
      throw Exception('Error downloading PDF: $e');
    }
  }

  // Download simple PDF to internal app storage
  static Future<DownloadedPdf> _downloadSimpleToInternal({
    required String originalId,
    required String name,
    required String description,
    required String url,
    required Uint8List pdfBytes,
  }) async {
    // Get app documents directory
    final appDir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${appDir.path}/downloaded_pdfs');
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    // Generate unique filename
    final id = const Uuid().v4();
    final fileName = _buildPdfFileName(name, suffix: id);
    final filePath = '${pdfDir.path}/$fileName';

    // Save PDF file
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // Create DownloadedPdf object
    final downloadedPdf = DownloadedPdf(
      id: id,
      originalId: originalId,
      name: name,
      description: description,
      localPath: filePath,
      originalUrl: url,
      downloadDate: DateTime.now(),
      fileSize: pdfBytes.length,
      hasLogo: false,
    );

    // Save to database
    final db = await database;
    await db.insert(_tableName, downloadedPdf.toMap());

    return downloadedPdf;
  }

  // Export PDF to app-scoped storage (no broad storage permission required)
  static Future<DownloadedPdf> _downloadToExternal({
    required String originalId,
    required String name,
    required String description,
    required String url,
    required Uint8List pdfBytes,
  }) async {
    final fileName = _buildPdfFileName(name);

    // Save exported PDFs in the user's Downloads/MedPharm folder when available.
    final medpharmDir = await _getMedPharmDownloadsDirectory();

    final filePath = '${medpharmDir.path}/$fileName';

    // Save the file to app-scoped storage
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // Create a DownloadedPdf object for return (but don't save to internal database)
    final downloadedPdf = DownloadedPdf(
      id: const Uuid().v4(),
      originalId: originalId,
      name: name,
      description: description,
      localPath: filePath,
      originalUrl: url,
      downloadDate: DateTime.now(),
      fileSize: pdfBytes.length,
      hasLogo: false,
    );

    return downloadedPdf;
  }

  // Delete downloaded PDF
  static Future<bool> deleteDownloadedPdf(String id) async {
    try {
      final db = await database;

      // Get PDF info first
      final result = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isNotEmpty) {
        final downloadedPdf = DownloadedPdf.fromMap(result.first);

        // Delete file
        final file = File(downloadedPdf.localPath);
        if (await file.exists()) {
          await file.delete();
        }

        // Delete from database
        await db.delete(
          _tableName,
          where: 'id = ?',
          whereArgs: [id],
        );

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get total storage used
  static Future<int> getTotalStorageUsed() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(fileSize) as total FROM $_tableName');
    return result.first['total'] as int? ?? 0;
  }

  // Clear all downloads
  static Future<bool> clearAllDownloads() async {
    try {
      final db = await database;
      final pdfs = await getAllDownloadedPdfs();

      // Delete all files
      for (final pdf in pdfs) {
        final file = File(pdf.localPath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Clear database
      await db.delete(_tableName);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Export internal PDF to app-scoped storage
  static Future<DownloadedPdf?> exportToExternalStorage(
    String localPath,
    String originalId,
    String name,
    String description,
    String originalUrl, {
    BuildContext? context,
  }) async {
    try {
      // Check storage permission first
      if (context != null && context.mounted) {
        final hasPermission =
            await PermissionService.requestStoragePermission(context);
        if (!hasPermission) {
          return null;
        }
      }

      // Read the local PDF file
      final file = File(localPath);
      if (!await file.exists()) {
        throw Exception('Le fichier local n\'existe pas');
      }

      final pdfBytes = await file.readAsBytes();
      final fileName = _buildPdfFileName(name);

      // Save exported PDFs in the user's Downloads/MedPharm folder when available.
      final medpharmDir = await _getMedPharmDownloadsDirectory();

      final externalFilePath = '${medpharmDir.path}/$fileName';

      // Save the file to app-scoped storage
      final externalFile = File(externalFilePath);
      await externalFile.writeAsBytes(pdfBytes);

      // Create a DownloadedPdf object for return (but don't save to internal database)
      final downloadedPdf = DownloadedPdf(
        id: const Uuid().v4(),
        originalId: originalId,
        name: name,
        description: description,
        localPath: externalFilePath,
        originalUrl: originalUrl,
        downloadDate: DateTime.now(),
        fileSize: pdfBytes.length,
        hasLogo: false,
      );

      return downloadedPdf;
    } catch (e) {
      throw Exception('Erreur lors de l\'export: $e');
    }
  }
}
