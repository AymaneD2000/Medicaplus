import 'package:flutter/material.dart';
import 'package:medpharm/theme/app_theme.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.title,
    required this.subtitle,
    required this.child,
    super.key,
    this.showBackButton = false,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEAF9FF),
              Color(0xFFF7FFFF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: -60,
                right: -45,
                child: _DecorativeCircle(
                  size: 190,
                  color: Color(0x2202B1EC),
                ),
              ),
              const Positioned(
                bottom: -90,
                left: -70,
                child: _DecorativeCircle(
                  size: 240,
                  color: Color(0x2233CCCC),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 470),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showBackButton)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton.filledTonal(
                              onPressed: () => Navigator.maybePop(context),
                              icon: const Icon(Icons.arrow_back_rounded),
                              tooltip: 'Retour',
                            ),
                          ),
                        const SizedBox(height: 14),
                        const _BrandMark(),
                        const SizedBox(height: 24),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blueGrey.shade600,
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 26),
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.96),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.12),
                            ),
                            boxShadow: AppShadows.card,
                          ),
                          child: child,
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'MedPharm • Votre espace médical sécurisé',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blueGrey.shade400,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.loading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Icon(icon ?? Icons.arrow_forward_rounded),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.controller,
    required this.label,
    super.key,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      enableSuggestions: false,
      autocorrect: false,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          tooltip: _obscure ? 'Afficher' : 'Masquer',
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 82,
        height: 82,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Image.asset(
          'assets/icon/MedPharm1.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.local_pharmacy_rounded,
            color: Colors.white,
            size: 44,
          ),
        ),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
