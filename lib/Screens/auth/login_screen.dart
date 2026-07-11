import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medpharm/Screens/auth/auth_layout.dart';
import 'package:medpharm/Screens/auth/forgot_password_screen.dart';
import 'package:medpharm/Screens/auth/register_screen.dart';
import 'package:medpharm/auth/auth_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    TextInput.finishAutofillContext();
    FocusScope.of(context).unfocus();

    final result = await context.read<AuthController>().signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!mounted || result.success) return;

    final isUnconfirmed = result.code == 'email_not_confirmed' ||
        (result.message?.contains('Confirmez') ?? false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Connexion impossible.'),
        behavior: SnackBarBehavior.floating,
        action: isUnconfirmed
            ? SnackBarAction(
                label: 'Renvoyer',
                onPressed: _resendConfirmation,
              )
            : null,
      ),
    );
  }

  Future<void> _resendConfirmation() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    final result =
        await context.read<AuthController>().resendConfirmation(email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Envoi impossible.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<AuthController>().isBusy;

    return AuthLayout(
      title: 'Bienvenue sur MedPharm',
      subtitle:
          'Connectez-vous pour retrouver vos contenus médicaux et vos téléchargements.',
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.username,
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
                onFieldSubmitted: (_) => _submit(),
                validator: (value) => value == null || value.isEmpty
                    ? 'Saisissez votre mot de passe.'
                    : null,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: busy
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          ),
                  child: const Text('Mot de passe oublié ?'),
                ),
              ),
              const SizedBox(height: 8),
              AuthPrimaryButton(
                label: 'Se connecter',
                loading: busy,
                icon: Icons.login_rounded,
                onPressed: _submit,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(child: Text('Vous n’avez pas de compte ?')),
                  TextButton(
                    onPressed: busy
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            ),
                    child: const Text('Créer un compte'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: Colors.blueGrey),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Votre session est conservée de façon sécurisée.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Saisissez votre adresse e-mail.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Saisissez une adresse e-mail valide.';
    }
    return null;
  }
}
