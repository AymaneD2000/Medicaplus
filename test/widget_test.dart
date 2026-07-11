import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medpharm/auth/auth_controller.dart';
import 'package:medpharm/auth/auth_gate.dart';
import 'package:medpharm/auth/auth_repository.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('AuthGate shows the login form without a persisted session',
      (tester) async {
    final repository = _WidgetTestAuthRepository();
    final controller = AuthController(repository)..initialize();
    addTearDown(() {
      controller.dispose();
      repository.dispose();
    });

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthController>.value(
        value: controller,
        child: const MaterialApp(home: AuthGate()),
      ),
    );
    await tester.pump();

    expect(find.text('Bienvenue sur MedPharm'), findsOneWidget);
    expect(find.text('Adresse e-mail'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Créer un compte'), findsOneWidget);
  });
}

class _WidgetTestAuthRepository implements AuthRepository {
  final StreamController<AuthStateUpdate> _controller =
      StreamController<AuthStateUpdate>.broadcast();

  @override
  AppUser? get currentUser => null;

  @override
  Stream<AuthStateUpdate> get authStateChanges => _controller.stream;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) =>
      throw UnimplementedError();

  @override
  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> resendConfirmation(String email) async {}

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> updatePassword(String password) async {}

  @override
  Future<void> signOut() async {}

  void dispose() => _controller.close();
}
