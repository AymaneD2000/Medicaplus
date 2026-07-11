import 'package:flutter/material.dart';

import 'package:medpharm/Screens/force_update_screen.dart';
import 'package:medpharm/Utils/version_check_service.dart';
import 'package:medpharm/auth/auth_gate.dart';

/// Runs the remote version check once on startup and shows either the
/// [ForceUpdateScreen] (when an update is required) or the [AuthGate].
///
/// While the check is in flight a lightweight splash is displayed. If the
/// check fails for any reason the app opens normally (fail-open).
class VersionGate extends StatefulWidget {
  const VersionGate({super.key});

  @override
  State<VersionGate> createState() => _VersionGateState();
}

class _VersionGateState extends State<VersionGate> {
  final VersionCheckService _service = const VersionCheckService();
  late Future<VersionCheckResult> _checkFuture;

  @override
  void initState() {
    super.initState();
    _checkFuture = _service.check();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VersionCheckResult>(
      future: _checkFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _VersionSplash();
        }

        final result = snapshot.data ?? VersionCheckResult.allowed;
        if (result.updateRequired && result.config != null) {
          return ForceUpdateScreen(config: result.config!);
        }

        return const AuthGate();
      },
    );
  }
}

class _VersionSplash extends StatelessWidget {
  const _VersionSplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF02B1EC),
        ),
      ),
    );
  }
}
