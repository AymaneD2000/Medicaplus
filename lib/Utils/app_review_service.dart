import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks app usage and triggers the native store rating prompt once the user
/// has opened the app enough times.
///
/// The native in-app review popup (App Store / Play Store) is only requested
/// once. The OS itself may also decide not to show it (Apple/Google throttle
/// how often it can appear), which is expected behaviour.
class AppReviewService {
  const AppReviewService();

  static const String _launchCountKey = 'app_launch_count';
  static const String _reviewRequestedKey = 'review_requested';
  static const int _launchThreshold = 5;

  /// Records one app session and requests a review once the threshold is met.
  /// Safe to call on every app open; it self-throttles.
  Future<void> registerSessionAndMaybeRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Already asked once — never prompt again.
      if (prefs.getBool(_reviewRequestedKey) ?? false) return;

      final launchCount = (prefs.getInt(_launchCountKey) ?? 0) + 1;
      await prefs.setInt(_launchCountKey, launchCount);

      if (launchCount < _launchThreshold) return;

      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        await prefs.setBool(_reviewRequestedKey, true);
      }
    } catch (e) {
      debugPrint('AppReviewService error: $e');
    }
  }
}
