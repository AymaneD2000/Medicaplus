import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:medpharm/auth/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus {
  initializing,
  unauthenticated,
  authenticated,
  passwordRecovery,
}

class AuthOperationResult {
  const AuthOperationResult._({
    required this.success,
    this.message,
    this.code,
    this.requiresEmailConfirmation = false,
  });

  const AuthOperationResult.success({
    String? message,
    bool requiresEmailConfirmation = false,
  }) : this._(
          success: true,
          message: message,
          requiresEmailConfirmation: requiresEmailConfirmation,
        );

  const AuthOperationResult.failure({
    required String message,
    String? code,
  }) : this._(
          success: false,
          message: message,
          code: code,
        );

  final bool success;
  final String? message;
  final String? code;
  final bool requiresEmailConfirmation;
}

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;
  StreamSubscription<AuthStateUpdate>? _subscription;

  AuthStatus _status = AuthStatus.initializing;
  AppUser? _user;
  bool _isBusy = false;
  bool _initialized = false;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  bool get isBusy => _isBusy;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  void initialize() {
    if (_initialized) return;
    _initialized = true;

    _user = _repository.currentUser;
    _status =
        _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    _subscription = _repository.authStateChanges.listen(
      _handleAuthUpdate,
      onError: (_) {
        if (_status == AuthStatus.initializing) {
          _status = AuthStatus.unauthenticated;
          notifyListeners();
        }
      },
    );
    notifyListeners();
  }

  Future<AuthOperationResult> signIn({
    required String email,
    required String password,
  }) async {
    return _perform(() async {
      _user = await _repository.signIn(email: email, password: password);
      _status = AuthStatus.authenticated;
      return const AuthOperationResult.success();
    });
  }

  Future<AuthOperationResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _perform(() async {
      final result = await _repository.signUp(
        name: name,
        email: email,
        password: password,
      );
      _user = result.user;
      _status = result.requiresEmailConfirmation
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated;
      return AuthOperationResult.success(
        requiresEmailConfirmation: result.requiresEmailConfirmation,
      );
    });
  }

  Future<AuthOperationResult> resendConfirmation(String email) {
    return _perform(() async {
      await _repository.resendConfirmation(email);
      return const AuthOperationResult.success(
        message: 'Un nouvel e-mail de confirmation a été envoyé.',
      );
    });
  }

  Future<AuthOperationResult> sendPasswordReset(String email) {
    return _perform(() async {
      await _repository.sendPasswordReset(email);
      return const AuthOperationResult.success(
        message:
            'Consultez votre boîte mail pour réinitialiser le mot de passe.',
      );
    });
  }

  Future<AuthOperationResult> updatePassword(String password) {
    return _perform(() async {
      await _repository.updatePassword(password);
      _user = _repository.currentUser ?? _user;
      _status =
          _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
      return const AuthOperationResult.success(
        message: 'Votre mot de passe a été mis à jour.',
      );
    });
  }

  Future<AuthOperationResult> signOut() {
    return _perform(() async {
      await _repository.signOut();
      _user = null;
      _status = AuthStatus.unauthenticated;
      return const AuthOperationResult.success();
    });
  }

  Future<AuthOperationResult> _perform(
    Future<AuthOperationResult> Function() operation,
  ) async {
    if (_isBusy) {
      return const AuthOperationResult.failure(
        message: 'Une opération est déjà en cours.',
      );
    }

    _isBusy = true;
    notifyListeners();
    try {
      return await operation();
    } on AuthException catch (error) {
      return AuthOperationResult.failure(
        message: _friendlyAuthError(error),
        code: error.code,
      );
    } catch (_) {
      return const AuthOperationResult.failure(
        message:
            'Une erreur inattendue est survenue. Vérifiez votre connexion puis réessayez.',
      );
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  void _handleAuthUpdate(AuthStateUpdate update) {
    _user = update.user;
    if (update.event == AuthEventType.passwordRecovery) {
      _status = AuthStatus.passwordRecovery;
    } else if (update.event == AuthEventType.signedOut || update.user == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  String _friendlyAuthError(AuthException error) {
    final code = error.code?.toLowerCase();
    final message = error.message.toLowerCase();

    if (code == 'invalid_credentials' ||
        message.contains('invalid login credentials')) {
      return 'Adresse e-mail ou mot de passe incorrect.';
    }
    if (code == 'email_not_confirmed' ||
        message.contains('email not confirmed')) {
      return 'Confirmez votre adresse e-mail avant de vous connecter.';
    }
    if (code == 'user_already_exists' ||
        message.contains('user already registered')) {
      return 'Un compte existe déjà avec cette adresse e-mail.';
    }
    if (code == 'weak_password' || message.contains('password')) {
      return 'Le mot de passe ne respecte pas les règles de sécurité.';
    }
    if (code == 'over_email_send_rate_limit' ||
        message.contains('rate limit')) {
      return 'Trop de demandes ont été envoyées. Réessayez dans quelques minutes.';
    }
    if (message.contains('network') || message.contains('socket')) {
      return 'Connexion impossible. Vérifiez votre accès à Internet.';
    }
    return error.message;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
