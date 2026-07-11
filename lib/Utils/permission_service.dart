import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

class PermissionService {
  /// Checks and requests storage permission for external PDF downloads.
  /// Returns true if permission is granted, false otherwise.
  /// Shows an error dialog with a button to open app settings if denied.
  static Future<bool> requestStoragePermission(BuildContext context) async {
    // On Android 10+ (API 29+), scoped storage is used and no permission needed
    // for app-specific directories. But for Downloads folder we need to check.
    if (Platform.isAndroid) {
      final status = await _getStoragePermissionStatus();

      if (status.isGranted) {
        return true;
      }

      if (status.isDenied) {
        final result = await _requestStoragePermission();
        if (result.isGranted) {
          return true;
        }
      }

      // Permission permanently denied or still denied after request
      if (context.mounted) {
        await _showPermissionDeniedDialog(context);
      }
      return false;
    }

    // iOS doesn't need storage permission for app documents
    return true;
  }

  static Future<PermissionStatus> _getStoragePermissionStatus() async {
    // Android 13+ (API 33) doesn't need storage permission for Downloads
    // Android 10-12 uses scoped storage but we write to public Downloads
    // Android 9 and below needs WRITE_EXTERNAL_STORAGE
    if (Platform.isAndroid) {
      return await Permission.storage.status;
    }
    return PermissionStatus.granted;
  }

  static Future<PermissionStatus> _requestStoragePermission() async {
    return await Permission.storage.request();
  }

  static Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.folder_off_rounded,
                  color: Colors.orange,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Permission requise',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tu dois donner la permission dans les paramètres pour télécharger le PDF en dehors de l\'application.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Accède aux paramètres de l\'application et active la permission de stockage.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    AppSettings.openAppSettings();
                  },
                  icon: const Icon(Icons.settings, color: Colors.white),
                  label: const Text(
                    'Ouvrir les paramètres',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
