import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote configuration used to decide whether the user must update the app.
class AppVersionConfig {
  final String minVersion;
  final String latestVersion;
  final String? androidUrl;
  final String? iosUrl;
  final String? updateMessage;

  const AppVersionConfig({
    required this.minVersion,
    required this.latestVersion,
    this.androidUrl,
    this.iosUrl,
    this.updateMessage,
  });

  factory AppVersionConfig.fromMap(Map<String, dynamic> map) {
    return AppVersionConfig(
      minVersion: (map['min_version'] ?? '').toString().trim(),
      latestVersion: (map['latest_version'] ?? '').toString().trim(),
      androidUrl: (map['android_url'] as String?)?.trim(),
      iosUrl: (map['ios_url'] as String?)?.trim(),
      updateMessage: (map['update_message'] as String?)?.trim(),
    );
  }

  /// Store link for the current platform.
  String? get storeUrl {
    if (Platform.isIOS || Platform.isMacOS) return iosUrl;
    return androidUrl;
  }
}

/// Result of checking the running app version against the remote config.
class VersionCheckResult {
  final bool updateRequired;
  final AppVersionConfig? config;

  const VersionCheckResult({
    required this.updateRequired,
    this.config,
  });

  /// Non-blocking default used when the check cannot complete (offline, error).
  static const VersionCheckResult allowed =
      VersionCheckResult(updateRequired: false);
}

class VersionCheckService {
  const VersionCheckService();

  /// Reads the running app version, fetches the remote config and decides
  /// whether a forced update is required.
  ///
  /// Fails open: any error (offline, missing config, parse issue) returns
  /// [VersionCheckResult.allowed] so users are never locked out by a glitch.
  Future<VersionCheckResult> check() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final config = await _fetchConfig();
      if (config == null || config.minVersion.isEmpty) {
        return VersionCheckResult.allowed;
      }

      final updateRequired =
          compareVersions(currentVersion, config.minVersion) < 0;

      return VersionCheckResult(
        updateRequired: updateRequired,
        config: config,
      );
    } catch (e) {
      debugPrint('VersionCheckService error: $e');
      return VersionCheckResult.allowed;
    }
  }

  Future<AppVersionConfig?> _fetchConfig() async {
    try {
      final response = await Supabase.instance.client
          .from('app_config')
          .select('*')
          .order('id', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return AppVersionConfig.fromMap(Map<String, dynamic>.from(response));
    } catch (e) {
      debugPrint('Error fetching app_config: $e');
      return null;
    }
  }

  /// Compares two dot-separated version strings (e.g. "1.0.9" vs "1.1.0").
  /// Any build suffix after "+" is ignored. Returns a negative number if
  /// [a] < [b], zero if equal, positive if [a] > [b].
  static int compareVersions(String a, String b) {
    final partsA = _parse(a);
    final partsB = _parse(b);
    final length = partsA.length > partsB.length ? partsA.length : partsB.length;

    for (var i = 0; i < length; i++) {
      final numberA = i < partsA.length ? partsA[i] : 0;
      final numberB = i < partsB.length ? partsB[i] : 0;
      if (numberA != numberB) return numberA.compareTo(numberB);
    }
    return 0;
  }

  static List<int> _parse(String version) {
    return version
        .split('+')
        .first
        .trim()
        .split('.')
        .map((part) => int.tryParse(part.trim()) ?? 0)
        .toList();
  }
}
