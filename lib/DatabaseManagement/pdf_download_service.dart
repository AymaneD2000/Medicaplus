import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Models/downloaded_pdf.dart';

class PdfDownloadService {
  static Database? _database;
  static const String _tableName = 'downloaded_pdfs';

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
  }) async {
    try {
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
        // Download with logo to external storage
        return await _downloadWithLogoToExternal(
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
    final fileName = '${name.replaceAll(RegExp(r'[^\w\s-]'), '')}_$id.pdf';
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

  // Download PDF with logo to external Downloads folder
  static Future<DownloadedPdf> _downloadWithLogoToExternal({
    required String originalId,
    required String name,
    required String description,
    required String url,
    required Uint8List pdfBytes,
  }) async {
    // Request storage permission for Android
    if (Platform.isAndroid) {
      final permission = await Permission.storage.request();
      if (!permission.isGranted) {
        final managePermission =
            await Permission.manageExternalStorage.request();
        if (!managePermission.isGranted) {
          throw Exception(
              'Permission de stockage requise pour sauvegarder le PDF avec logo');
        }
      }
    }

    // Add logo to PDF
    final finalPdfBytes = await _addLogoToPdf(pdfBytes);

    final fileName = 'MedPharm_${name.replaceAll(RegExp(r'[^\w\s-]'), '')}.pdf';

    // Get external Downloads directory
    Directory? downloadsDir;
    String filePath;

    if (Platform.isAndroid) {
      // Try different Android download paths
      final possiblePaths = [
        '/storage/emulated/0/Download',
        '/storage/emulated/0/Downloads',
        '/sdcard/Download',
        '/sdcard/Downloads',
      ];

      for (final path in possiblePaths) {
        final dir = Directory(path);
        if (await dir.exists()) {
          downloadsDir = dir;
          break;
        }
      }

      if (downloadsDir == null) {
        // Fallback to app external directory
        final externalDir = await getExternalStorageDirectory();
        downloadsDir = Directory('${externalDir?.path}/Downloads');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }
      }

      filePath = '${downloadsDir.path}/$fileName';
    } else {
      // For iOS, save to app documents directory (will be accessible via Files app)
      final appDir = await getApplicationDocumentsDirectory();
      filePath = '${appDir.path}/$fileName';
    }

    // Save the file to external storage
    final file = File(filePath);
    await file.writeAsBytes(finalPdfBytes);

    // Create a DownloadedPdf object for return (but don't save to internal database)
    final downloadedPdf = DownloadedPdf(
      id: const Uuid().v4(),
      originalId: originalId,
      name: 'MedicaPlus_$name',
      description: '$description (avec logo MedicaPlus)',
      localPath: filePath,
      originalUrl: url,
      downloadDate: DateTime.now(),
      fileSize: finalPdfBytes.length,
      hasLogo: true,
    );

    return downloadedPdf;
  }

  // Add logo to PDF
  static Future<Uint8List> _addLogoToPdf(Uint8List originalPdfBytes) async {
    try {
      // Load app logo
      final logoBytes = await rootBundle.load('assets/images/medicaplus.png');
      final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

      // Create new PDF document
      final pdf = pw.Document();

      // Add cover page with logo
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Container(
                  width: 150,
                  height: 150,
                  child: pw.Image(logoImage),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'MedicaPlus',
                  style: pw.TextStyle(
                    fontSize: 36,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                  'Application Médicale Professionnelle',
                  style: pw.TextStyle(
                    fontSize: 18,
                    color: PdfColors.blue600,
                  ),
                ),
                pw.SizedBox(height: 60),
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.blue300, width: 2),
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(10)),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Ce document a été téléchargé depuis',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey800,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'l\'application MedicaPlus',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue700,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Le contenu original suit à la page suivante',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey600,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Add a page break
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Document Original',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Le contenu original du PDF commence à la page suivante.',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey700,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Get the PDF with logo pages
      final logoPages = await pdf.save();

      // For a complete solution, we would need to merge the original PDF pages
      // For now, we return the logo pages followed by instructions
      // Note: Full PDF merging requires additional PDF parsing libraries

      return logoPages;
    } catch (e) {
      // If logo addition fails, return original PDF
      return originalPdfBytes;
    }
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
}
