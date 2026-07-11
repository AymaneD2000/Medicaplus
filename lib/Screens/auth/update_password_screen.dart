import 'package:flutter/material.dart';
import 'package:medpharm/Screens/auth/auth_layout.dart';
import 'package:medpharm/auth/auth_controller.dart';
import 'package:provider/provider.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final result = await context
        .read<AuthController>()
        .updatePassword(_passwordController.text);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Mise à jour impossible.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<AuthController>().isBusy;

    return AuthLayout(
      title: 'Nouveau mot de passe',
      subtitle:
          'Choisissez un nouveau mot de passe pour terminer la récupération de votre compte.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PasswordField(
              controller: _passwordController,
              label: 'Nouveau mot de passe',
              textInputAction: TextInputAction.next,
              validator: _validatePassword,
            ),
            const SizedBox(height: 16),
            PasswordField(
              controller: _confirmationController,
              label: 'Confirmer le mot de passe',
              onFieldSubmitted: (_) => _submit(),
              validator: (value) => value != _passwordController.text
                  ? 'Les mots de passe ne correspondent pas.'
                  : null,
            ),
            const SizedBox(height: 22),
            AuthPrimaryButton(
              label: 'Mettre à jour',
              loading: busy,
              icon: Icons.lock_reset_rounded,
              onPressed: _submit,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed:
                  busy ? null : () => context.read<AuthController>().signOut(),
              child: const Text('Annuler et se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.length < 8) return 'Utilisez au moins 8 caractères.';
    if (!RegExp(r'[A-Za-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password)) {
      return 'Ajoutez au moins une lettre et un chiffre.';
    }
    return null;
  }
}
