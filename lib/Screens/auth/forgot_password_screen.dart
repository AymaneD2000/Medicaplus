import 'package:flutter/material.dart';
import 'package:medpharm/Screens/auth/auth_layout.dart';
import 'package:medpharm/auth/auth_controller.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    final result = await context
        .read<AuthController>()
        .sendPasswordReset(_emailController.text);
    if (!mounted) return;

    if (result.success) {
      setState(() => _sent = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Envoi impossible.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.watch<AuthController>().isBusy;

    return AuthLayout(
      title: 'Mot de passe oublié',
      subtitle:
          'Nous vous enverrons un lien sécurisé pour choisir un nouveau mot de passe.',
      showBackButton: true,
      child: _sent
          ? Column(
              children: [
                const Icon(
                  Icons.outgoing_mail,
                  size: 58,
                  color: Color(0xFF02B1EC),
                ),
                const SizedBox(height: 18),
                const Text(
                  'E-mail envoyé',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Consultez ${_emailController.text.trim()} et ouvrez le lien de réinitialisation.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.blueGrey, height: 1.45),
                ),
                const SizedBox(height: 22),
                AuthPrimaryButton(
                  label: 'Retour à la connexion',
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.email],
                    onFieldSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      labelText: 'Adresse e-mail',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(email)) {
                        return 'Saisissez une adresse e-mail valide.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),
                  AuthPrimaryButton(
                    label: 'Envoyer le lien',
                    loading: busy,
                    icon: Icons.send_rounded,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
    );
  }
}
