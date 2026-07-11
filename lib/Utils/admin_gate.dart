import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple password-based admin gate for admin screens.
/// Stores authentication state in SharedPreferences for the session.
class AdminGate {
  static const String _adminKey = 'admin_authenticated';
  static const String _adminPassword = 'medpharm2024';

  /// Check if admin is already authenticated in this session.
  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_adminKey) ?? false;
  }

  /// Clear admin authentication (logout).
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adminKey, false);
  }

  /// Show admin login dialog. Returns true if authenticated successfully.
  static Future<bool> authenticate(BuildContext context) async {
    // Check if already authenticated
    if (await isAuthenticated()) return true;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final controller = TextEditingController();
        String? errorText;

        return StatefulBuilder(
          builder: (context, setState) {
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
                      color: const Color(0xFF1E88E5).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Color(0xFF1E88E5),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Accès Administrateur',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Entrez le mot de passe administrateur pour accéder à cette section.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Mot de passe',
                      errorText: errorText,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF1E88E5),
                      ),
                      filled: true,
                      fillColor:
                          const Color(0xFF1E88E5).withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color:
                              const Color(0xFF1E88E5).withValues(alpha: 0.25),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFF1E88E5),
                          width: 1.8,
                        ),
                      ),
                    ),
                    onSubmitted: (value) async {
                      if (value == _adminPassword) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool(_adminKey, true);
                        if (dialogContext.mounted) {
                          Navigator.of(dialogContext).pop(true);
                        }
                      } else {
                        setState(() {
                          errorText = 'Mot de passe incorrect';
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (controller.text == _adminPassword) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(_adminKey, true);
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop(true);
                      }
                    } else {
                      setState(() {
                        errorText = 'Mot de passe incorrect';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirmer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    return result ?? false;
  }
}
