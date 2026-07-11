import 'package:medpharm/Models/classemodel.dart';
import 'package:medpharm/Models/faculter.dart';
import 'package:medpharm/Models/filiere.dart';
import 'package:medpharm/Models/materiels.dart';
import 'package:medpharm/Models/pdf.dart';
import 'package:medpharm/Models/publication.dart';
import 'package:medpharm/Models/semestre.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class _CachedSignedUrl {
  final String url;
  final DateTime expiresAt;

  const _CachedSignedUrl({
    required this.url,
    required this.expiresAt,
  });

  bool get isValid => DateTime.now().isBefore(expiresAt);
}

class SupabaseManagement {
  static final supabase = Supabase.instance.client;
  static const int signedUrlExpiryInSeconds = 60 * 60 * 24 * 365 * 2;
  static const Duration _signedUrlRefreshBuffer = Duration(hours: 1);
  static final Map<String, _CachedSignedUrl> _signedUrlCache = {};

  String? _extractStoragePath(String? storageValue,
      {String bucketName = 'avatars'}) {
    if (storageValue == null) return null;

    final trimmed = storageValue.trim();
    if (trimmed.isEmpty) return null;

    if (!trimmed.startsWith('http')) {
      var path = trimmed;
      while (path.startsWith('/')) {
        path = path.substring(1);
      }
      if (path.startsWith('$bucketName/')) {
        path = path.substring(bucketName.length + 1);
      }
      return path.isEmpty ? null : path;
    }

    try {
      final uri = Uri.parse(trimmed);
      final bucketIndex = uri.pathSegments.indexOf(bucketName);
      if (bucketIndex == -1 || bucketIndex >= uri.pathSegments.length - 1) {
        return null;
      }

      final rawPath = uri.pathSegments.sublist(bucketIndex + 1).join('/');
      if (rawPath.isEmpty) {
        return null;
      }

      return Uri.decodeComponent(rawPath);
    } catch (_) {
      return null;
    }
  }

  Future<String> _resolveSignedUrl(String? storageValue,
      {String bucketName = 'avatars'}) async {
    if (storageValue == null || storageValue.trim().isEmpty) {
      return '';
    }

    final filePath = _extractStoragePath(storageValue, bucketName: bucketName);
    if (filePath == null || filePath.isEmpty) {
      return storageValue;
    }

    final cacheKey = '$bucketName/$filePath';
    final cachedUrl = _signedUrlCache[cacheKey];

    if (cachedUrl != null && cachedUrl.isValid) {
      return cachedUrl.url;
    }

    if (cachedUrl != null) {
      _signedUrlCache.remove(cacheKey);
    }

    try {
      final signedUrl = await supabase.storage
          .from(bucketName)
          .createSignedUrl(filePath, signedUrlExpiryInSeconds);

      _signedUrlCache[cacheKey] = _CachedSignedUrl(
        url: signedUrl,
        expiresAt: DateTime.now().add(
          Duration(
            seconds:
                signedUrlExpiryInSeconds - _signedUrlRefreshBuffer.inSeconds,
          ),
        ),
      );

      return signedUrl;
    } catch (e) {
      debugPrint('Could not create signed URL for "$filePath": $e');
      return storageValue;
    }
  }

  Future<List<Map<String, dynamic>>> _withFreshSignedUrls(
    List<dynamic> rows, {
    List<String> storageFields = const ['image'],
    String bucketName = 'avatars',
  }) {
    return Future.wait(rows.map((row) async {
      final mappedRow = Map<String, dynamic>.from(row as Map);

      for (final field in storageFields) {
        final value = mappedRow[field];
        if (value is String && value.isNotEmpty) {
          mappedRow[field] =
              await _resolveSignedUrl(value, bucketName: bucketName);
        }
      }

      return mappedRow;
    }));
  }

  Map<String, dynamic> _withStoragePaths(
    Map<String, dynamic> data, {
    List<String> storageFields = const ['image'],
    String bucketName = 'avatars',
  }) {
    final sanitized = Map<String, dynamic>.from(data);

    for (final field in storageFields) {
      final value = sanitized[field];
      if (value is String && value.isNotEmpty) {
        sanitized[field] =
            _extractStoragePath(value, bucketName: bucketName) ?? value;
      }
    }

    return sanitized;
  }

  /// Helper function to extract file path from Supabase storage URL and delete it
  /// Returns true if deletion was successful, false otherwise
  Future<bool> _deleteFileFromStorage(String? fileUrl) async {
    if (fileUrl == null || fileUrl.isEmpty) {
      debugPrint('File URL is null or empty, skipping deletion');
      return false;
    }

    String filePath = '';
    String bucketName = 'avatars'; // Default bucket

    try {
      // Extract the file path from the Supabase storage URL
      // URL formats can be:
      // 1. https://[project].supabase.co/storage/v1/object/sign/avatars/[path]?token=...
      // 2. https://[project].supabase.co/storage/v1/object/public/avatars/[path]
      // 3. Direct path like 'classes/filename.png' or 'pdfs/filename.pdf' (if stored as path)

      // Check if it's already a path (doesn't start with http)
      if (!fileUrl.startsWith('http')) {
        filePath = fileUrl;
        debugPrint('Using direct path: $filePath');
      } else {
        // Parse the URL
        final uri = Uri.parse(fileUrl);
        final pathSegments = uri.pathSegments;

        debugPrint('Parsing URL: $fileUrl');
        debugPrint('Path segments: $pathSegments');

        // Find the index of 'avatars' or other bucket names in the path
        int bucketIndex = -1;
        final possibleBuckets = ['avatars', 'pdfs', 'images', 'files'];

        for (final bucket in possibleBuckets) {
          final index = pathSegments.indexOf(bucket);
          if (index != -1) {
            bucketIndex = index;
            bucketName = bucket;
            break;
          }
        }

        if (bucketIndex == -1 || bucketIndex >= pathSegments.length - 1) {
          debugPrint(
              'Could not find bucket name in path segments. URL: $fileUrl');
          // Try alternative: look for the path after 'object'
          final objectIndex = pathSegments.indexOf('object');
          if (objectIndex != -1 && objectIndex < pathSegments.length - 3) {
            // Structure: ['storage', 'v1', 'object', 'sign'/'public', 'avatars', 'path', 'to', 'file']
            // The bucket is at objectIndex + 2 (after 'object' and 'sign'/'public')
            bucketName = pathSegments[objectIndex + 2];
            // Get everything after the bucket name
            filePath = pathSegments.sublist(objectIndex + 3).join('/');
            debugPrint('Extracted bucket: $bucketName, path: $filePath');
          } else {
            debugPrint('Could not parse URL structure. URL: $fileUrl');
            return false;
          }
        } else {
          // Get the path after the bucket name (e.g., 'pdfs/filename.pdf' or 'pdf_images/filename.png')
          filePath = pathSegments.sublist(bucketIndex + 1).join('/');
          debugPrint('Extracted bucket: $bucketName, path: $filePath');
        }
      }

      if (filePath.isEmpty) {
        debugPrint('Extracted file path is empty, cannot delete');
        return false;
      }

      // Remove query parameters if any (e.g., ?token=...)
      if (filePath.contains('?')) {
        filePath = filePath.split('?').first;
      }

      // URL decode the file path in case it contains encoded characters
      try {
        filePath = Uri.decodeComponent(filePath);
      } catch (e) {
        debugPrint('Warning: Could not URL decode path, using as-is: $e');
      }

      // Normalize the path: remove leading/trailing slashes and ensure proper format
      filePath = filePath.trim();
      while (filePath.startsWith('/')) {
        filePath = filePath.substring(1);
      }
      while (filePath.endsWith('/')) {
        filePath = filePath.substring(0, filePath.length - 1);
      }

      if (filePath.isEmpty) {
        debugPrint('File path is empty after normalization, cannot delete');
        return false;
      }

      // Delete the file from Supabase storage
      debugPrint(
          'Attempting to delete file from storage. Bucket: $bucketName, Path: $filePath');

      try {
        // Extract directory and filename for verification
        final lastSlashIndex = filePath.lastIndexOf('/');
        final directory =
            lastSlashIndex >= 0 ? filePath.substring(0, lastSlashIndex) : '';
        final fileName = lastSlashIndex >= 0
            ? filePath.substring(lastSlashIndex + 1)
            : filePath;

        // Check if file exists before deletion
        bool fileExisted = false;
        try {
          if (directory.isNotEmpty) {
            final files = await supabase.storage.from(bucketName).list(
                  path: directory,
                );
            fileExisted = files.any((file) => file.name == fileName);
          } else {
            // If no directory, list root
            final files = await supabase.storage.from(bucketName).list();
            fileExisted = files.any((file) => file.name == fileName);
          }
          debugPrint('File exists before deletion: $fileExisted');
        } catch (e) {
          debugPrint('Could not check if file exists: $e');
        }

        // Attempt to delete the file
        final result =
            await supabase.storage.from(bucketName).remove([filePath]);
        debugPrint('Storage remove result: $result (length: ${result.length})');

        // If result is not empty, deletion was successful
        if (result.isNotEmpty) {
          debugPrint('Successfully deleted file from storage: $filePath');
          return true;
        }

        // If result is empty, verify if file still exists
        debugPrint(
            'remove() returned empty array. Verifying if file still exists...');
        bool stillExists = false;
        try {
          if (directory.isNotEmpty) {
            final files = await supabase.storage.from(bucketName).list(
                  path: directory,
                );
            stillExists = files.any((file) => file.name == fileName);
          } else {
            final files = await supabase.storage.from(bucketName).list();
            stillExists = files.any((file) => file.name == fileName);
          }
        } catch (e) {
          debugPrint('Could not verify deletion: $e');
          // If we can't verify, assume failure if file existed before
          return !fileExisted;
        }

        if (stillExists) {
          debugPrint('ERROR: File still exists after deletion attempt!');
          debugPrint('Bucket: $bucketName, Path: $filePath');
          return false;
        } else {
          // File doesn't exist - either was deleted or never existed
          // Both cases are acceptable (idempotent operation)
          debugPrint(
              'File does not exist (deleted or never existed) - considering success');
          return true;
        }
      } on StorageException catch (storageError) {
        debugPrint(
            'StorageException when deleting file: ${storageError.message}');
        debugPrint('Error code: ${storageError.statusCode}');
        debugPrint('Bucket: $bucketName, Path: $filePath');
        rethrow; // Re-throw to be caught by outer catch
      }
    } catch (e, stackTrace) {
      debugPrint('Error deleting file from storage: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('File URL was: $fileUrl');
      debugPrint('Bucket: $bucketName, Path: $filePath');
      // Don't throw - we still want to delete the database record even if file deletion fails
      return false;
    }
  }

  Future<List<Classe>> getClasse(int id) async {
    final response =
        await supabase.from('classe').select("*").eq("faculter", id);
    final rows =
        await _withFreshSignedUrls(response, storageFields: const ['image']);
    List<Classe> classes = rows.map((e) => Classe.fromSnapshot(e)).toList();
    return classes;
  }

  Future<List<Classe>> getAllClasse() async {
    final response = await supabase.from('classe').select("*");
    final rows =
        await _withFreshSignedUrls(response, storageFields: const ['image']);
    List<Classe> classes = rows.map((e) => Classe.fromSnapshot(e)).toList();
    return classes;
  }

  // Future<List<Materiel>> getAllMaterial() async {
  //   final response = await supabase.from('classe').select("*");
  //   List<Materiel> materiels =
  //       response.map((e) => Materiel.fromSnapshot(e)).toList();
  //   return materiels;
  // }

  Future<List<Fac>> faculter() async {
    final response = await supabase.from('faculter').select("*");
    List<Fac> classes = response.map((e) => Fac.fromSnapshot(e)).toList();
    return classes;
  }

  addClasse(Classe c) async {
    await supabase
        .from('classe')
        .insert(_withStoragePaths(c.toMap(), storageFields: const ['image']))
        .then((value) {
      getAllClasse();
    });
  }

  Future<void> updateClasse(Classe c, {required String originalNom}) async {
    await supabase
        .from('classe')
        .update(_withStoragePaths(c.toMap(), storageFields: const ['image']))
        .eq('nom', originalNom)
        .then((value) {
      getAllClasse();
    });
  }

  Future<List<Filiere>> getClasseFilieres(String id) async {
    final response =
        await supabase.from('filiere').select("*").eq("semestre_id", id);
    final rows =
        await _withFreshSignedUrls(response, storageFields: const ['image']);
    List<Filiere> filieres = rows.map((e) => Filiere.fromSnapshot(e)).toList();
    return filieres;
  }

  Future<void> addFiliere(Filiere f) async {
    try {
      debugPrint('Attempting to insert filiere into Supabase: ${f.toMap()}');
      final response = await supabase
          .from('filiere')
          .insert(_withStoragePaths(f.toMap(), storageFields: const ['image']));
      debugPrint('Filiere inserted successfully: $response');
      await getClasseFilieres(f.semestreId);
    } catch (e) {
      debugPrint('Error in supabase addFiliere: $e');
      if (e is PostgrestException) {
        debugPrint('PostgrestException details:');
        debugPrint('Message: ${e.message}');
        debugPrint('Code: ${e.code}');
        debugPrint('Details: ${e.details}');
        debugPrint('Hint: ${e.hint}');
      }
      rethrow;
    }
  }

  Future<void> updateFiliere(Filiere f) async {
    try {
      debugPrint('Attempting to update filiere in Supabase: ${f.toMap()}');
      await supabase
          .from('filiere')
          .update(_withStoragePaths(f.toMap(), storageFields: const ['image']))
          .eq('id', f.id);
      debugPrint('Filiere updated successfully');
      await getClasseFilieres(f.semestreId);
    } catch (e) {
      debugPrint('Error in supabase updateFiliere: $e');
      if (e is PostgrestException) {
        debugPrint('PostgrestException details:');
        debugPrint('Message: ${e.message}');
        debugPrint('Code: ${e.code}');
        debugPrint('Details: ${e.details}');
        debugPrint('Hint: ${e.hint}');
      }
      rethrow;
    }
  }

  addPdf(Pdf p) async {
    await supabase
        .from('pdf')
        .insert(
            _withStoragePaths(p.toMap(), storageFields: const ['pdf', 'image']))
        .then((value) {});
    getDocuments();
  }

  addMateriel(Materiel p) async {
    await supabase
        .from('materiel')
        .insert(_withStoragePaths(p.toMap(), storageFields: const ['image']))
        .then((value) {});

    ///getMateriel();
  }

  addPublication(Publication p) async {
    await supabase
        .from('publication')
        .insert(_withStoragePaths(p.toMap(), storageFields: const ['image']))
        .then((value) {});

    ///getMateriel();
  }

  removeClasse(Classe c) async {
    // Delete the associated image from storage
    await _deleteFileFromStorage(c.image);

    // Delete the database record
    await supabase.from('classe').delete().eq('nom', c.nom).then((value) {});
  }

  removeMateriel(Materiel c) async {
    // Delete the associated image from storage
    await _deleteFileFromStorage(c.image);
    if (c.id == null) {
      throw Exception('Materiel ID is required for deletion');
    }
    // Delete the database record
    await supabase.from('materiel').delete().eq('id', c.id!).then((value) {});
  }

  updateMateriel(Materiel c) async {
    if (c.id == null) {
      throw Exception('Materiel ID is required for updates');
    }
    await supabase
        .from('materiel')
        .update(_withStoragePaths(c.toMap(), storageFields: const ['image']))
        .eq('id', c.id!)
        .then((value) {});
  }

  removeFiliere(Filiere f) async {
    // Delete the associated image from storage
    await _deleteFileFromStorage(f.image);
    // Delete the database record
    await supabase.from('filiere').delete().eq('id', f.id).then((value) {});
  }

  removePdf(Pdf p) async {
    try {
      // Delete the associated PDF file from storage
      debugPrint('Deleting PDF file: ${p.url}');
      final pdfDeleted = await _deleteFileFromStorage(p.url);
      if (pdfDeleted) {
        debugPrint('PDF file deleted successfully');
      } else {
        debugPrint('Failed to delete PDF file (may not exist or invalid URL)');
      }

      // Delete the associated PDF image from storage
      debugPrint('Deleting PDF image: ${p.image}');
      final imageDeleted = await _deleteFileFromStorage(p.image);
      if (imageDeleted) {
        debugPrint('PDF image deleted successfully');
      } else {
        debugPrint('Failed to delete PDF image (may not exist or invalid URL)');
      }
    } catch (e) {
      debugPrint('Error deleting PDF files from storage: $e');
      // Continue with database deletion even if file deletion fails
    }

    // Delete the database record
    await supabase.from('pdf').delete().eq('id', p.id).then((value) {});
  }

  Future<void> updatePdf(Pdf p,
      {String? oldPdfUrl, String? oldImageUrl}) async {
    try {
      // Delete old PDF file if a new one was uploaded
      if (oldPdfUrl != null && oldPdfUrl != p.url) {
        debugPrint('Deleting old PDF file: $oldPdfUrl');
        await _deleteFileFromStorage(oldPdfUrl);
      }

      // Delete old image file if a new one was uploaded
      if (oldImageUrl != null && oldImageUrl != p.image) {
        debugPrint('Deleting old PDF image: $oldImageUrl');
        await _deleteFileFromStorage(oldImageUrl);
      }

      // Update the database record
      await supabase
          .from('pdf')
          .update(_withStoragePaths(p.toMap(),
              storageFields: const ['pdf', 'image']))
          .eq('id', p.id);
      debugPrint('PDF updated successfully');
    } catch (e) {
      debugPrint('Error updating PDF: $e');
      rethrow;
    }
  }

  updatePublication(Publication p) async {
    if (p.idpublication == null) {
      throw Exception('Publication ID is required for updates');
    }
    await supabase
        .from('publication')
        .update(_withStoragePaths(p.toMap(), storageFields: const ['image']))
        .eq('id', p.idpublication!)
        .then((value) {});
  }

  deletePublication(Publication p) async {
    // Delete the associated image from storage
    await _deleteFileFromStorage(p.image);
    if (p.idpublication == null) {
      throw Exception('Publication ID is required for deletion');
    }
    // Delete the database record
    await supabase
        .from('publication')
        .delete()
        .eq('id', p.idpublication!)
        .then((value) {});
  }

  Future<List<Pdf>> getDocuments() async {
    final response = await supabase.from('pdf').select("*");
    final rows = await _withFreshSignedUrls(
      response,
      storageFields: const ['pdf', 'image'],
    );
    List<Pdf> documents = rows.map((e) => Pdf.fromSnapshot(e)).toList();
    return documents;
  }

  Future<List<Materiel>> getMateriel() async {
    final response = await supabase.from('materiel').select("*");
    final rows = await _withFreshSignedUrls(
      response,
      storageFields: const ['image'],
    );
    List<Materiel> documents =
        rows.map((e) => Materiel.fromSnapshot(e)).toList();
    return documents;
  }

  Future<List<Publication>> getPublication() async {
    final response = await supabase.from('publication').select("*");
    final rows = await _withFreshSignedUrls(
      response,
      storageFields: const ['image'],
    );
    List<Publication> documents =
        rows.map((e) => Publication.fromSnapshot(e)).toList();
    return documents;
  }

  Future<List<Pdf>> getPDF(String id) async {
    final response =
        await supabase.from('pdf').select("*").eq("filiere_id", id);
    final rows = await _withFreshSignedUrls(
      response,
      storageFields: const ['pdf', 'image'],
    );
    List<Pdf> documents = rows.map((e) => Pdf.fromSnapshot(e)).toList();
    return documents;
  }

  Future<List<Filiere>> getFiliere(String id) async {
    final response =
        await supabase.from('filiere').select("*").eq("semestre_id", id);
    List<Filiere> filieres =
        response.map((e) => Filiere.fromSnapshot(e)).toList();
    return filieres;
  }

  Future<List<Semestre>> getSemestres(String classeName) async {
    final response =
        await supabase.from('semestre').select().eq('nomClasse', classeName);
    List<Semestre> semestres =
        response.map((e) => Semestre.fromJson(e)).toList();
    return semestres;
  }

  Future<void> addSemestre(Semestre semestre) async {
    await supabase.from('semestre').insert(semestre.toJson());
  }

  Future<void> updateSemestre(Semestre semestre) async {
    await supabase
        .from('semestre')
        .update(semestre.toJson())
        .eq('id', semestre.id);
  }

  Future<void> deleteSemestre(String id, String? imageUrl) async {
    // Delete the associated image from storage
    if (imageUrl != null) {
      await _deleteFileFromStorage(imageUrl);
    }
    // Delete the database record
    await supabase.from('semestre').delete().eq('id', id);
  }
}
