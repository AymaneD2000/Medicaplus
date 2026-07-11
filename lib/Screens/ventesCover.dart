import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/Models/materiels.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VenteCover extends StatefulWidget {
  final Materiel materiel;

  const VenteCover({Key? key, required this.materiel}) : super(key: key);

  @override
  _VenteCoverState createState() => _VenteCoverState();
}

class _VenteCoverState extends State<VenteCover> {
  // Modern color scheme
  final Color _primaryColor = const Color(0xFF1E88E5);
  final Color _secondaryColor = const Color(0xFF42A5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final Color _backgroundColor = const Color(0xFFF8F9FA);

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    if (widget.materiel.id == null) return;

    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_materials') ?? [];
    setState(() {
      _isFavorite = favorites.contains(widget.materiel.id.toString());
    });
  }

  Future<void> _toggleFavorite() async {
    // Check if materiel has an id
    if (widget.materiel.id == null) {
      _showErrorSnackBar(
          context, "Impossible d'ajouter ce matériel aux favoris");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorite_materials') ?? [];
    final materialId = widget.materiel.id!.toString();

    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      if (!favorites.contains(materialId)) {
        favorites.add(materialId);
      }
    } else {
      favorites.remove(materialId);
    }

    await prefs.setStringList('favorite_materials', favorites);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite ? 'Ajouté aux favoris ✓' : 'Retiré des favoris',
          ),
          backgroundColor: _isFavorite ? Colors.green : _primaryColor,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  String _formatPrice(String price) {
    try {
      String cleanPrice = price.replaceAll('.', '');
      int number = int.parse(cleanPrice);
      return number.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          );
    } catch (e) {
      return price;
    }
  }

  String _normalizeWhatsAppPhone(String phone) {
    var normalized = phone.replaceAll(RegExp(r'[^0-9+]'), '');

    if (normalized.startsWith('00')) {
      normalized = '+${normalized.substring(2)}';
    }

    if (normalized.startsWith('+')) {
      final digits = normalized.substring(1).replaceAll(RegExp(r'\D'), '');
      return '+$digits';
    }

    return normalized.replaceAll(RegExp(r'\D'), '');
  }

  Future<bool> _safeLaunchExternal(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  Future<void> launchWhatsApp(String phone, String message) async {
    final normalizedPhone = _normalizeWhatsAppPhone(phone);
    final waMePhone = normalizedPhone.startsWith('+')
        ? normalizedPhone.substring(1)
        : normalizedPhone;

    if (waMePhone.isEmpty) {
      if (!mounted) return;
      _showErrorSnackBar(context, 'Numéro WhatsApp invalide.');
      return;
    }

    final appUri = Uri.parse('whatsapp://send').replace(queryParameters: {
      'phone': waMePhone,
      'text': message,
    });

    final waMeUri = Uri.https('wa.me', '/$waMePhone', {
      'text': message,
    });

    final apiUri = Uri.https('api.whatsapp.com', '/send', {
      'phone': waMePhone,
      'text': message,
    });

    final appUriNoPhone =
        Uri.parse('whatsapp://send').replace(queryParameters: {
      'text': message,
    });

    var launched = await _safeLaunchExternal(appUri);

    if (!launched) {
      launched = await _safeLaunchExternal(waMeUri);
    }

    if (!launched) {
      launched = await _safeLaunchExternal(apiUri);
    }

    if (!launched) {
      launched = await _safeLaunchExternal(appUriNoPhone);
    }

    if (!launched && mounted) {
      _showErrorSnackBar(
        context,
        "Impossible d'ouvrir WhatsApp sur cet appareil.",
      );
    }
  }

  Future<void> launchPhoneDialer(String phoneNumber) async {
    final normalizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    if (normalizedPhone.isEmpty) {
      if (!mounted) return;
      _showErrorSnackBar(context, 'Numéro de téléphone invalide.');
      return;
    }

    final launched =
        await _safeLaunchExternal(Uri.parse('tel:$normalizedPhone'));

    if (!launched && mounted) {
      _showErrorSnackBar(
        context,
        "L'application téléphone n'est pas disponible sur cet appareil.",
      );
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 10,
            collapsedHeight: 60,
            toolbarHeight: 60,
            floating: false,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: _primaryColor,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            titleSpacing: 0,
            title: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Détail du matériel',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
            leadingWidth: 58,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12, top: 9, bottom: 9),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.28),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 9, bottom: 9),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _toggleFavorite,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _isFavorite
                            ? Colors.redAccent.withValues(alpha: 0.9)
                            : Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isFavorite
                              ? Colors.white.withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.28),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (_isFavorite ? Colors.redAccent : Colors.black)
                                    .withValues(alpha: 0.12),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1565C0),
                    _primaryColor,
                    _secondaryColor,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -42,
                    right: -26,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -34,
                    bottom: -62,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                          width: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 72,
                    bottom: 10,
                    child: Icon(
                      Icons.medical_services_outlined,
                      color: Colors.white.withValues(alpha: 0.08),
                      size: 42,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildImageSection(),
                  const Gap(24),
                  _buildInfoSection(),
                  const Gap(24),
                  _buildPriceSection(),
                  const Gap(32),
                  _buildActionButtons(),
                  const Gap(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: widget.materiel.image,
          fit: BoxFit.contain,
          width: double.infinity,
          placeholder: (context, url) => Container(
            color: _primaryColor.withValues(alpha: 0.1),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                    strokeWidth: 3,
                  ),
                  const Gap(16),
                  Text(
                    'Chargement de l\'image...',
                    style: TextStyle(
                      color: _textColor.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: _primaryColor.withValues(alpha: 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  color: _primaryColor,
                  size: 64,
                ),
                const Gap(16),
                Text(
                  'Image indisponible',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(8),
                Text(
                  'Impossible de charger l\'image',
                  style: TextStyle(
                    color: _textColor.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: _primaryColor,
                  size: 24,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Text(
                  'Informations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          Text(
            widget.materiel.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          if (widget.materiel.description != null &&
              widget.materiel.description!.isNotEmpty) ...[
            const Gap(16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.materiel.description!,
                style: TextStyle(
                  fontSize: 16,
                  color: _textColor.withValues(alpha: 0.8),
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    final hasPrice = widget.materiel.price.trim().isNotEmpty;
    final formattedPrice =
        hasPrice ? _formatPrice(widget.materiel.price) : 'Prix sur demande';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _primaryColor.withValues(alpha: 0.95),
            _secondaryColor.withValues(alpha: 0.72),
            const Color(0xFF90CAF9).withValues(alpha: 0.45),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.24),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned(
                top: -46,
                right: -34,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _primaryColor.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Positioned(
                bottom: -58,
                left: -44,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _secondaryColor.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_primaryColor, _secondaryColor],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withValues(alpha: 0.25),
                                blurRadius: 14,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.payments_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        const Gap(14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prix unitaire',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: _textColor,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const Gap(3),
                              Text(
                                'Montant affiché par article',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: _textColor.withValues(alpha: 0.55),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.green.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: Colors.green.shade700,
                                size: 14,
                              ),
                              const Gap(5),
                              Text(
                                'Disponible',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(22),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFF7FBFF),
                            _primaryColor.withValues(alpha: 0.055),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: _primaryColor.withValues(alpha: 0.1),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            hasPrice ? 'MONTANT À PAYER' : 'PRIX',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: _primaryColor.withValues(alpha: 0.72),
                              letterSpacing: 1.6,
                            ),
                          ),
                          const Gap(10),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formattedPrice,
                                  style: TextStyle(
                                    fontSize: hasPrice ? 44 : 28,
                                    fontWeight: FontWeight.w900,
                                    color: _primaryColor,
                                    letterSpacing: -1.2,
                                    height: 1,
                                  ),
                                ),
                                if (hasPrice) ...[
                                  const Gap(8),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      'FCFA',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                        color: _textColor.withValues(alpha: 0.68),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Commander button (WhatsApp)
        _buildModernActionButton(
          onPressed: () {
            launchWhatsApp(
              widget.materiel.telephone,
              "Bonjour! Je suis intéressé(e) par ce matériel médical :\n\n"
              "📋 Nom: ${widget.materiel.title}\n"
              "💰 Prix: ${_formatPrice(widget.materiel.price)} FCFA\n"
              "${widget.materiel.description != null && widget.materiel.description!.isNotEmpty ? '📝 Description: ${widget.materiel.description}\n' : ''}"
              "\nPouvez-vous me donner plus d'informations ?",
            );
          },
          icon: 'assets/materiel/commander.png',
          label: 'Commander via WhatsApp',
          subtitle: 'Envoyer une demande au vendeur',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF25D366),
              Color(0xFF1FAF68),
              Color(0xFF128C7E),
            ],
            stops: [0.0, 0.52, 1.0],
          ),
          shadowColor: const Color(0xFF25D366),
          actionIcon: Icons.chat_rounded,
        ),
        const Gap(16),

        // Appeler button
        _buildModernActionButton(
          onPressed: () {
            launchPhoneDialer(widget.materiel.telephone);
          },
          icon: 'assets/materiel/appeler.png',
          label: 'Appeler maintenant',
          subtitle: 'Contacter directement le vendeur',
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1565C0),
              _primaryColor,
              _secondaryColor,
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
          shadowColor: _primaryColor,
          actionIcon: Icons.call_rounded,
        ),
      ],
    );
  }

  Widget _buildModernActionButton({
    required VoidCallback onPressed,
    required String icon,
    required String label,
    required String subtitle,
    required Gradient gradient,
    required Color shadowColor,
    required IconData actionIcon,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned(
                    top: -28,
                    right: -18,
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -36,
                    left: -26,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 18,
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 78),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.28),
                                width: 1,
                              ),
                            ),
                            child: Image.asset(
                              icon,
                              width: 26,
                              height: 26,
                              color: Colors.white,
                            ),
                          ),
                          const Gap(14),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.2,
                                    height: 1.15,
                                  ),
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.visible,
                                ),
                                const Gap(4),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.78),
                                    height: 1.2,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                          const Gap(12),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Icon(
                              actionIcon,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
