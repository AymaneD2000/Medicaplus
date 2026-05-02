import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class LocalJsonDatasource {
  const LocalJsonDatasource();

  Future<File> getLocalFile({
    required String assetPath,
    String? localFileName,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = localFileName ?? _fileNameFromAssetPath(assetPath);
    return File('${directory.path}/$fileName');
  }

  Future<File> ensureAssetCopied({
    required String assetPath,
    String? localFileName,
    bool overwrite = false,
  }) async {
    final file = await getLocalFile(
      assetPath: assetPath,
      localFileName: localFileName,
    );

    if (!overwrite && await file.exists()) {
      return file;
    }

    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }

  Future<String> readRaw({
    required String assetPath,
    String? localFileName,
  }) async {
    final file = await ensureAssetCopied(
      assetPath: assetPath,
      localFileName: localFileName,
    );

    return file.readAsString();
  }

  Future<void> writeRaw({
    required String assetPath,
    required String content,
    String? localFileName,
  }) async {
    final file = await getLocalFile(
      assetPath: assetPath,
      localFileName: localFileName,
    );

    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    await file.writeAsString(content, flush: true);
  }

  Future<List<dynamic>> readJsonList({
    required String assetPath,
    String? localFileName,
  }) async {
    final raw = await readRaw(
      assetPath: assetPath,
      localFileName: localFileName,
    );

    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      throw const FormatException('Expected JSON root to be a list.');
    }

    return decoded;
  }

  Future<Map<String, dynamic>> readJsonMap({
    required String assetPath,
    String? localFileName,
  }) async {
    final raw = await readRaw(
      assetPath: assetPath,
      localFileName: localFileName,
    );

    final decoded = jsonDecode(raw);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected JSON root to be an object.');
    }

    return decoded;
  }

  Future<void> writeJsonList({
    required String assetPath,
    required List<dynamic> data,
    String? localFileName,
  }) {
    return writeRaw(
      assetPath: assetPath,
      localFileName: localFileName,
      content: jsonEncode(data),
    );
  }

  Future<void> writeJsonMap({
    required String assetPath,
    required Map<String, dynamic> data,
    String? localFileName,
  }) {
    return writeRaw(
      assetPath: assetPath,
      localFileName: localFileName,
      content: jsonEncode(data),
    );
  }

  Future<void> resetFromAsset({
    required String assetPath,
    String? localFileName,
  }) async {
    await ensureAssetCopied(
      assetPath: assetPath,
      localFileName: localFileName,
      overwrite: true,
    );
  }

  Future<bool> localFileExists({
    required String assetPath,
    String? localFileName,
  }) async {
    final file = await getLocalFile(
      assetPath: assetPath,
      localFileName: localFileName,
    );

    return file.exists();
  }

  String _fileNameFromAssetPath(String assetPath) {
    final normalizedPath = assetPath.replaceAll('\\', '/');
    final segments = normalizedPath.split('/').where((part) => part.isNotEmpty);

    if (segments.isEmpty) {
      throw ArgumentError.value(
        assetPath,
        'assetPath',
        'Asset path must not be empty.',
      );
    }

    return segments.last;
  }
}
