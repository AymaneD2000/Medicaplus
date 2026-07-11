import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medpharm/Screens/AddClasseScreen.dart';
import 'package:medpharm/Screens/manageMateriels.dart';
import 'package:medpharm/Screens/managePublication.dart';
import 'package:medpharm/Utils/admin_gate.dart';
import 'package:medpharm/Utils/app_review_service.dart';
import 'package:medpharm/auth/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medpharm/Screens/home.dart';
import 'package:medpharm/Screens/downloaded_pdfs_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // Modern color scheme
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _secondaryColor = const Color(0xFF33CCCC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
    _maybeRequestReview();
  }

  Future<void> _maybeRequestReview() async {
    // Delay so the prompt appears once the user is settled in the app rather
    // than during startup.
    await Future.delayed(const Duration(seconds: 3));
    await const AppReviewService().registerSessionAndMaybeRequest();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    // Check if terms have been accepted. If key doesn't exist (first time), it will be null
    final termsAccepted = prefs.getBool('terms_accepted');

    // Show dialog only on first launch (when termsAccepted is null or false)
    if (termsAccepted == null || !termsAccepted) {
      if (mounted) {
        // Show the terms dialog on first launch
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _showAboutDialog(context, isFirstLaunch: true);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.84,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF7FCFF),
                Color(0xFFEFF8FF),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildDrawerHeader(),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
                    children: [
                      _buildDrawerSectionLabel('NAVIGATION'),
                      const SizedBox(height: 10),
                      _buildDrawerSectionCard(
                        children: [
                          _buildDrawerItem(
                            icon: Icons.home_rounded,
                            title: 'Accueil',
                            onTap: () => Navigator.pop(context),
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.7,
                            color: Colors.grey.withValues(alpha: 0.12),
                            indent: 68,
                          ),
                          _buildDrawerItem(
                            icon: Icons.download_done_rounded,
                            title: 'Téléchargements PDF',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DownloadedPdfsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _buildDrawerSectionLabel('CONTACT & SUPPORT'),
                      const SizedBox(height: 10),
                      _buildDrawerSectionCard(
                        children: [
                          _buildDrawerItem(
                            icon: Icons.alternate_email_rounded,
                            title: 'Envoyer un e-mail',
                            onTap: () => _launchEmail(),
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.7,
                            color: Colors.grey.withValues(alpha: 0.12),
                            indent: 68,
                          ),
                          _buildDrawerItem(
                            icon: Icons.star_rate_rounded,
                            title: 'Noter sur Play Store',
                            onTap: () => _launchPlayStore(),
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.7,
                            color: Colors.grey.withValues(alpha: 0.12),
                            indent: 68,
                          ),
                          _buildDrawerItem(
                            icon: Icons.info_rounded,
                            title: 'Informations sur nous',
                            onTap: () => _showAboutDialog(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _buildDrawerSectionLabel('COMPTE'),
                      const SizedBox(height: 10),
                      _buildDrawerSectionCard(
                        children: [
                          _buildDrawerItem(
                            icon: Icons.logout_rounded,
                            title: 'Se déconnecter',
                            onTap: _confirmSignOut,
                            destructive: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // _buildDrawerFooter(),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primaryColor, _secondaryColor],
            ),
          ),
        ),
        title: const Text(
          'MedPharm',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // ========================================
          // ADMIN ACTIONS (Protected by admin gate)
          //========================================
          // _buildAppBarAction(
          //   onPressed: () async {
          //     final authenticated = await AdminGate.authenticate(context);
          //     if (authenticated && mounted) {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const CategorySelectionScreen()),
          //       );
          //     }
          //   },
          //   icon: Icons.school_outlined,
          //   tooltip: 'Gérer les Classes',
          // ),
          // _buildAppBarAction(
          //   onPressed: () async {
          //     final authenticated = await AdminGate.authenticate(context);
          //     if (authenticated && mounted) {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const MaterielHomePage()),
          //       );
          //     }
          //   },
          //   icon: Icons.medical_services_outlined,
          //   tooltip: 'Gérer les Equipements',
          // ),
          // _buildAppBarAction(
          //   onPressed: () async {
          //     final authenticated = await AdminGate.authenticate(context);
          //     if (authenticated && mounted) {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const PublicationHomePage()),
          //       );
          //     }
          //   },
          //   icon: Icons.article_outlined,
          //   tooltip: 'Gérer les Publications',
          // ),
          //========================================

          _buildAppBarAction(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DownloadedPdfsScreen()),
              );
            },
            icon: Icons.download_done_outlined,
            tooltip: 'Téléchargements PDF',
          ),
        ],
      ),
      body: const Home(),
    );
  }

  Widget _buildAppBarAction({
    required VoidCallback onPressed,
    required IconData icon,
    required String tooltip,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildDrawerHeader() {
    final user = context.watch<AuthController>().user;
    final displayName = user?.displayName ?? 'Utilisateur MedPharm';
    final email = user?.email ?? '';

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.26),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _primaryColor,
                _secondaryColor,
                const Color(0xFF6FE7E7),
              ],
              stops: const [0.0, 0.68, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -36,
                right: -30,
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Positioned(
                bottom: -48,
                left: -42,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                      width: 18,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Text(
                      user?.initials ?? 'M',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  Widget _buildDrawerSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 3,
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: Colors.grey[650],
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _primaryColor.withValues(alpha: 0.16),
                      _secondaryColor.withValues(alpha: 0.12),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: destructive ? Colors.red.shade600 : _primaryColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: destructive
                        ? Colors.red.shade700
                        : const Color(0xFF1D1B20),
                    letterSpacing: -0.1,
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F8FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[500],
                  size: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    Navigator.pop(context);
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF02B1EC)),
            title: const Text('Se déconnecter ?'),
            content: const Text(
              'Vous devrez saisir à nouveau vos identifiants pour accéder à MedPharm.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Annuler'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Se déconnecter'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed || !mounted) return;
    final result = await context.read<AuthController>().signOut();
    if (!result.success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? 'Déconnexion impossible.')),
      );
    }
  }

  Widget _buildDrawerFooter() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'MedPharm',
              style: TextStyle(
                color: Color(0xFF4A5568),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail() async {
    const String email = 'medpharm223@gmail.com';
    const String subject = 'Contact depuis MedPharm';
    const String body = 'Bonjour,\n\n';

    // Try different approaches to open email
    final Uri mailtoUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters({
        'subject': subject,
        'body': body,
      }),
    );

    try {
      // Try to launch directly without checking canLaunchUrl
      // canLaunchUrl often returns false for mailto on some devices
      final launched = await launchUrl(
        mailtoUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // If mailto fails, try opening Gmail directly on Android
        final Uri gmailUri = Uri.parse(
            'https://mail.google.com/mail/?view=cm&to=$email&su=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}');

        final gmailLaunched = await launchUrl(
          gmailUri,
          mode: LaunchMode.externalApplication,
        );

        if (!gmailLaunched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Envoyez un e-mail à: $email'),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Copier',
                textColor: Colors.white,
                onPressed: () {
                  // Copy email to clipboard
                  Clipboard.setData(ClipboardData(text: email));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('E-mail copié dans le presse-papiers'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Envoyez un e-mail à: $email'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> _launchPlayStore() async {
    const String packageName = 'com.medical.medpharm';
    final Uri playStoreUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );

    try {
      if (await canLaunchUrl(playStoreUri)) {
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible d\'ouvrir le Play Store'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAboutDialog(BuildContext context, {bool isFirstLaunch = false}) {
    showDialog(
      context: context,
      barrierDismissible: !isFirstLaunch,
      builder: (BuildContext context) {
        bool isAccepted = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return PopScope(
              canPop: !isFirstLaunch,
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Welcome header
                        const Text(
                          'Bonjour et bienvenue sur MedPharm',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Introduction text
                        const Text(
                          'MedPharm est une application médicale compléte qui fournit des informations détaillées sur les médicaments, les équipements médicaux, offre des outils de calcul médical et les cours de la Faculté de Médecine et d\'Odontostomatologie (FMOS) et la Faculté de Pharmacie (FAPH)',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Conditions section
                        const Text(
                          'Conditions générales d\'utilisation:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Disclaimer in red
                        const Text(
                          'Les informations fournies dans cette application sont destinées à un public averti ainsi qu\'aux professionnels de santé. En aucun cas les informations éditées dans MedPharm sont susceptibles de se substituer à une consultation, une visite ou un diagnostic formulé par un médecin. L\'utilisateur reconnait que les informations qui sont mises à sa disposition ne sont ni complètes, ni exhaustives et que ces informations ne traitent pas de l\'intégralité des différents symptômes et traitements appropriés aux pathologies et différents maux intéressant l\'utilisateur. Les professionnels de santé se doivent de respecter en premier lieu les protocoles et bonnes pratiques liées à leur profession.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFFFF5722),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Feedback section
                        const Text(
                          'Cette application étant en amélioration permanente je vous encourage à me faire part de vos remarques afin de vous satisfaire au plus vite. Merci.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Report inconsistency box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'L\'icône ci-joint permet de signaler toute incohérence concernant la page où vous vous trouvez, n\'hésitez pas.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.bug_report,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Contact information with Row to avoid overflow
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () async {
                            final Uri emailUri = Uri(
                              scheme: 'mailto',
                              path: 'medpharm223@gmail.com',
                              queryParameters: {
                                'subject': 'Contact depuis MedPharm App',
                              },
                            );
                            if (await canLaunchUrl(emailUri)) {
                              await launchUrl(emailUri);
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.email,
                                  size: 18, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(text: 'Contact: '),
                                      TextSpan(
                                        text: 'medpharm223@gmail.com',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Version and copyright
                        const Text(
                          'Version: MedPharm© 1.0.9 - 2026 tous droits réservés.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Checkbox for terms acceptance
                        Row(
                          children: [
                            Checkbox(
                              value: isAccepted,
                              onChanged: (bool? value) {
                                setState(() {
                                  isAccepted = value ?? false;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text(
                                'J\'ai bien lu et accepte les conditions d\'utilisation énoncées ci-dessus.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Validate button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isAccepted || !isFirstLaunch
                                ? () async {
                                    if (isFirstLaunch && isAccepted) {
                                      // Save that user has accepted terms
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setBool(
                                          'terms_accepted', true);
                                    }
                                    Navigator.pop(context);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey,
                              disabledForegroundColor: Colors.white70,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Valider',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Acknowledgments
                        Text(
                          'J\'aimerai remercier spécialement tous ceux qui m\'ont aidé à réaliser ce projet.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Copyright
                        Text(
                          'MedPharm© 1.0.9 - 2026 tous droits réservés.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
