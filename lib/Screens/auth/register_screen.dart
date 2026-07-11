import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medpharm/Screens/auth/auth_layout.dart';
import 'package:medpharm/auth/auth_controller.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    TextInput.finishAutofillContext();
    FocusScope.of(context).unfocus();

    final result = await context.read<AuthController>().signUp(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!mounted) return;

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Création du compte impossible.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (result.requiresEmailConfirmation) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(
            Icons.mark_email_read_outlined,
            size: 42,
            color: Color(0xFF02B1EC),
          ),
          title: const Text('Confirmez votre adresse e-mail'),
          content: Text(
            'Un lien de confirmation a été envoyé à ${_emailController.text.trim()}.',
            textAlign: TextAlign.center,
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('J’ai compris'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context);
      return;
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<AuthController>().isBusy;

    return AuthLayout(
      title: 'Créer votre compte',
      subtitle:
          'Quelques informations suffisent pour sécuriser votre espace MedPharm.',
      showBackButton: true,
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                decoration: const InputDecoration(
                  labelText: 'Nom complet',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) => (value?.trim().length ?? 0) < 2
                    ? 'Saisissez votre nom complet.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.newUsername,
                  AutofillHints.email
                ],
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Adresse e-mail',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              PasswordField(
                controller: _passwordController,
                label: 'Mot de passe',
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
              const SizedBox(height: 12),
              const Text(
                'Utilisez au moins 8 caractères avec une lettre et un chiffre.',
                style: TextStyle(fontSize: 12.5, color: Colors.blueGrey),
              ),
              const SizedBox(height: 22),
              AuthPrimaryButton(
                label: 'Créer mon compte',
                loading: busy,
                icon: Icons.person_add_alt_1_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Saisissez une adresse e-mail valide.';
    }
    return null;
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
