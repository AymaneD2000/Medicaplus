import 'package:medpharm/auth/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(
    this._client, {
    this.redirectUrl,
  });

  final SupabaseClient _client;
  final String? redirectUrl;

  @override
  AppUser? get currentUser => _mapUser(_client.auth.currentUser);

  @override
  Stream<AuthStateUpdate> get authStateChanges =>
      _client.auth.onAuthStateChange.map(
        (state) => AuthStateUpdate(
          event: _mapEvent(state.event),
          user: _mapUser(state.session?.user),
        ),
      );

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    final user = _mapUser(response.user);
    if (user == null) {
      throw const AuthException('Aucun utilisateur retourné après connexion.');
    }
    return user;
  }

  @override
  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      emailRedirectTo: redirectUrl,
      data: {'full_name': name.trim()},
    );

    return SignUpResult(
      user: _mapUser(response.user),
      requiresEmailConfirmation: response.session == null,
    );
  }

  @override
  Future<void> resendConfirmation(String email) {
    return _client.auth
        .resend(
          type: OtpType.signup,
          email: email.trim(),
          emailRedirectTo: redirectUrl,
        )
        .then((_) {});
  }

  @override
  Future<void> sendPasswordReset(String email) {
    return _client.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: redirectUrl,
    );
  }

  @override
  Future<void> updatePassword(String password) {
    return _client.auth
        .updateUser(UserAttributes(password: password))
        .then((_) {});
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  AuthEventType _mapEvent(AuthChangeEvent event) {
    return switch (event) {
      AuthChangeEvent.initialSession => AuthEventType.initialSession,
      AuthChangeEvent.signedIn => AuthEventType.signedIn,
      AuthChangeEvent.signedOut => AuthEventType.signedOut,
      AuthChangeEvent.passwordRecovery => AuthEventType.passwordRecovery,
      AuthChangeEvent.tokenRefreshed => AuthEventType.tokenRefreshed,
      AuthChangeEvent.userUpdated => AuthEventType.userUpdated,
      _ => AuthEventType.userUpdated,
    };
  }

  AppUser? _mapUser(User? user) {
    if (user == null) return null;

    final metadataName = user.userMetadata?['full_name']?.toString().trim();
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      displayName:
          metadataName == null || metadataName.isEmpty ? null : metadataName,
      emailConfirmed: user.emailConfirmedAt != null,
    );
  }
}
