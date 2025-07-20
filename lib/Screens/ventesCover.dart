import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/Models/materiels.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final Color _accentColor = const Color(0xFF1976D2);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final Color _backgroundColor = const Color(0xFFF8F9FA);

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

  void launchWhatsApp(
      BuildContext context, String phone, String message) async {
    final whatsappUrl =
        "https://wa.me/$phone/?text=${Uri.encodeQueryComponent(message)}";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      _showErrorSnackBar(
          context, "WhatsApp n'est pas installé sur cet appareil.");
    }
  }

  void launchPhoneDialer(BuildContext context, String phoneNumber) async {
    final phoneUrl = "tel:$phoneNumber";
    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
      await launchUrl(Uri.parse(phoneUrl));
    } else {
      _showErrorSnackBar(context,
          "L'application téléphone n'est pas disponible sur cet appareil.");
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
            expandedHeight: 100,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: _primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primaryColor, _secondaryColor],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                    child: Text(
                      widget.materiel.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
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
            color: Colors.black.withOpacity(0.1),
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
            color: _primaryColor.withOpacity(0.1),
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
                      color: _textColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: _primaryColor.withOpacity(0.1),
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
                    color: _textColor.withOpacity(0.7),
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
            color: Colors.black.withOpacity(0.05),
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
                  color: _primaryColor.withOpacity(0.1),
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
                  color: _textColor.withOpacity(0.8),
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Image.asset('assets/icon/prix.png', width: 24, height: 24),
              ),
              const Gap(16),
              Expanded(
                child: Text(
                  'Prix unitaire',
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_primaryColor, _secondaryColor],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  "${_formatPrice(widget.materiel.price)} FCFA",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                onPressed: () {
                  launchWhatsApp(
                    context,
                    widget.materiel.telephone,
                    "Bonjour! Je suis intéressé(e) par ce matériel médical :\n\n"
                    "📋 Nom: ${widget.materiel.title}\n"
                    "💰 Prix: ${_formatPrice(widget.materiel.price)} FCFA\n"
                    "${widget.materiel.description != null && widget.materiel.description!.isNotEmpty ? '📝 Description: ${widget.materiel.description}\n' : ''}"
                    "\nPouvez-vous me donner plus d'informations ?",
                  );
                },
                icon: 'assets/icon/commander.png',
                label: 'Commander',
                color: Colors.blue.withOpacity(0.1),
                isWhatsApp: true,
              ),
            ),
            const Gap(16),
            Expanded(
              child: _buildActionButton(
                onPressed: () {
                  launchPhoneDialer(context, widget.materiel.telephone);
                },
                icon: 'assets/icon/appeler.png',
                label: 'Appeler',
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String icon,
    required String label,
    required Color color,
    bool isWhatsApp = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: color.withOpacity(0.3),
        //     blurRadius: 12,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isWhatsApp
            ? Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icon/commander.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : Image.asset(icon, width: 24, height: 24),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
