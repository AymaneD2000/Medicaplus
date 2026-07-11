# MedPharm authentication setup

The Flutter app now uses Supabase email/password authentication with persisted
sessions, email confirmation, password reset, password recovery, and logout.

## Supabase dashboard settings

1. Open **Authentication → Providers → Email** and enable the Email provider.
2. Decide whether **Confirm email** should be required. The app supports both:
   - enabled: registration asks the user to confirm their address;
   - disabled: registration creates an authenticated session immediately.
3. Open **Authentication → URL Configuration** and add this redirect URL:

   ```text
   medpharm://login-callback
   ```

4. For the web build, also add every deployed web origin that can receive an
   authentication callback.
5. Review the confirmation and password-recovery templates under
   **Authentication → Email Templates**.

## Database and Storage security

The Flutter `AuthGate` controls navigation, but it is not a backend security
boundary. Enable Row Level Security on every Supabase table used by the app and
create policies based on `auth.uid()` or an explicit role model.

Storage buckets also require policies. Apply least-privilege rules separately
for reading, uploading, updating, and deleting objects.

Do not use the client-side `AdminGate` password as authorization for database or
storage writes. Administrative access should be represented by trusted server-
managed claims or a protected profile/role table and enforced by RLS policies.

## Callback configuration included in the app

- Android handles `medpharm://login-callback` in `AndroidManifest.xml`.
- iOS registers the `medpharm` URL scheme in `Info.plist`.
- Supabase Flutter detects the returned recovery session and opens the new
  password screen automatically.

## Verification

```bash
flutter test
flutter build apk --debug
```

Before release, test registration, confirmation, login, logout, reset-password,
and recovery-link behavior using a non-production account on both Android and
iOS.
