class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.emailConfirmed = false,
  });

  final String id;
  final String email;
  final String? displayName;
  final bool emailConfirmed;

  String get initials {
    final source = (displayName?.trim().isNotEmpty ?? false)
        ? displayName!.trim()
        : email.trim();
    if (source.isEmpty) return 'M';

    final parts = source.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

enum AuthEventType {
  initialSession,
  signedIn,
  signedOut,
  passwordRecovery,
  tokenRefreshed,
  userUpdated,
}

class AuthStateUpdate {
  const AuthStateUpdate({
    required this.event,
    required this.user,
  });

  final AuthEventType event;
  final AppUser? user;
}

class SignUpResult {
  const SignUpResult({
    required this.user,
    required this.requiresEmailConfirmation,
  });

  final AppUser? user;
  final bool requiresEmailConfirmation;
}

abstract interface class AuthRepository {
  AppUser? get currentUser;

  Stream<AuthStateUpdate> get authStateChanges;

  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  Future<SignUpResult> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> resendConfirmation(String email);

  Future<void> sendPasswordReset(String email);

  Future<void> updatePassword(String password);

  Future<void> signOut();
}
