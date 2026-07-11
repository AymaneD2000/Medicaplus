import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:medpharm/Utils/version_check_service.dart';

/// Full-screen, non-dismissible gate shown when the installed app version is
/// older than the minimum version required by the remote config.
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key, required this.config});

  final AppVersionConfig config;

  static const Color _primaryColor = Color(0xFF02B1EC);

  Future<void> _openStore(BuildContext context) async {
    final url = config.storeUrl;
    if (url == null || url.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lien de mise à jour indisponible.'),
          ),
        );
      }
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'ouvrir le magasin d'applications."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = (config.updateMessage != null &&
            config.updateMessage!.isNotEmpty)
        ? config.updateMessage!
        : "Une nouvelle version de l'application est disponible. "
            "Veuillez mettre à jour pour continuer à utiliser MedPharm.";

    // Blocks the Android hardware back button so the gate cannot be dismissed.
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.system_update_rounded,
                      color: _primaryColor,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Mise à jour requise',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1B20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  if (config.latestVersion.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Version disponible : ${config.latestVersion}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openStore(context),
                      icon: const Icon(Icons.download_rounded),
                      label: const Text(
                        'Mettre à jour',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
