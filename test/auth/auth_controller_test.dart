import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:medpharm/auth/auth_controller.dart';
import 'package:medpharm/auth/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  const user = AppUser(
    id: 'user-1',
    email: 'user@medpharm.test',
    displayName: 'Awa Traore',
    emailConfirmed: true,
  );

  group('AuthController', () {
    test('starts unauthenticated when no persisted session exists', () {
      final repository = FakeAuthRepository();
      final controller = AuthController(repository)..initialize();

      expect(controller.status, AuthStatus.unauthenticated);
      expect(controller.user, isNull);

      controller.dispose();
      repository.dispose();
    });

    test('restores an authenticated persisted session', () {
      final repository = FakeAuthRepository(currentUser: user);
      final controller = AuthController(repository)..initialize();

      expect(controller.status, AuthStatus.authenticated);
      expect(controller.user?.email, user.email);

      controller.dispose();
      repository.dispose();
    });

    test('signs in and exposes the authenticated user', () async {
      final repository = FakeAuthRepository(signInUser: user);
      final controller = AuthController(repository)..initialize();

      final result = await controller.signIn(
        email: user.email,
        password: 'Password1',
      );

      expect(result.success, isTrue);
      expect(controller.status, AuthStatus.authenticated);
      expect(controller.user, same(user));

      controller.dispose();
      repository.dispose();
    });

    test('keeps signup unauthenticated while email confirmation is required',
        () async {
      final repository = FakeAuthRepository(
        signUpResult: const SignUpResult(
          user: user,
          requiresEmailConfirmation: true,
        ),
      );
      final controller = AuthController(repository)..initialize();

      final result = await controller.signUp(
        name: 'Awa Traore',
        email: user.email,
        password: 'Password1',
      );

      expect(result.success, isTrue);
      expect(result.requiresEmailConfirmation, isTrue);
      expect(controller.status, AuthStatus.unauthenticated);

      controller.dispose();
      repository.dispose();
    });

    test('opens password recovery state from the auth event stream', () async {
      final repository = FakeAuthRepository();
      final controller = AuthController(repository)..initialize();

      repository.emit(
        const AuthStateUpdate(
          event: AuthEventType.passwordRecovery,
          user: user,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(controller.status, AuthStatus.passwordRecovery);
      expect(controller.user, same(user));

      controller.dispose();
      repository.dispose();
    });

    test('localizes invalid credential errors', () async {
      final repository = FakeAuthRepository(
        signInError: const AuthException(
          'Invalid login credentials',
          code: 'invalid_credentials',
        ),
      );
      final controller = AuthController(repository)..initialize();

      final result = await controller.signIn(
        email: user.email,
        password: 'wrong',
      );

      expect(result.success, isFalse);
      expect(result.message, 'Adresse e-mail ou mot de passe incorrect.');
      expect(controller.status, AuthStatus.unauthenticated);

      controller.dispose();
      repository.dispose();
    });

    test('clears the user after logout', () async {
      final repository = FakeAuthRepository(currentUser: user);
      final controller = AuthController(repository)..initialize();

      final result = await controller.signOut();

      expect(result.success, isTrue);
      expect(controller.status, AuthStatus.unauthenticated);
      expect(controller.user, isNull);
      expect(repository.signOutCalls, 1);

      controller.dispose();
      repository.dispose();
    });
  });
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AppUser? currentUser,
    this.signInUser,
    this.signUpResult,
    this.signInError,
  }) : _currentUser = currentUser;

  final StreamController<AuthStateUpdate> _controller =
      StreamController<AuthStateUpdate>.broadcast();
  AppUser? _currentUser;
  final AppUser? signInUser;
  final SignUpResult? signUpResult;
  final Object? signInError;
  int signOutCalls = 0;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AuthStateUpdate> get authStateChanges => _controller.stream;

  void emit(AuthStateUpdate update) => _controller.add(update);

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    if (signInError != null) throw signInError!;
    final user = signInUser ?? _currentUser;
    if (user == null) throw StateError('No fake sign-in user configured.');
    _currentUser = user;
    return user;
  }

  @override
  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = signUpResult ??
        SignUpResult(
          user: _currentUser,
          requiresEmailConfirmation: _currentUser == null,
        );
    if (!result.requiresEmailConfirmation) _currentUser = result.user;
    return result;
  }

  @override
  Future<void> resendConfirmation(String email) async {}

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> updatePassword(String password) async {}

  @override
  Future<void> signOut() async {
    signOutCalls++;
    _currentUser = null;
  }

  void dispose() => _controller.close();
}
