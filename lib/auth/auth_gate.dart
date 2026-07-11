import 'package:flutter/material.dart';
import 'package:medpharm/Screens/auth/login_screen.dart';
import 'package:medpharm/Screens/auth/update_password_screen.dart';
import 'package:medpharm/Screens/dashboard.dart';
import 'package:medpharm/auth/auth_controller.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select<AuthController, AuthStatus>(
      (controller) => controller.status,
    );

    return switch (status) {
      AuthStatus.initializing => const _AuthSplash(),
      AuthStatus.unauthenticated => const LoginScreen(),
      AuthStatus.authenticated => const DashBoard(),
      AuthStatus.passwordRecovery => const UpdatePasswordScreen(),
    };
  }
}

class _AuthSplash extends StatelessWidget {
  const _AuthSplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF02B1EC)),
      ),
    );
  }
}
