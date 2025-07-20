import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/DatabaseManagement/provider.dart';
import 'package:medpharm/Models/amo.dart';
import 'package:provider/provider.dart';

// Définition des styles de texte
const TextStyle sectionTitleStyle = TextStyle(
  fontFamily: 'TimesNewRoman',
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.teal,
);

const TextStyle detailTextStyle = TextStyle(
  fontFamily: 'TimesNewRoman',
  fontSize: 16.0,
  color: Colors.black,
);

class AmoDetailsScreen extends StatefulWidget {
  final Amo medicament;
  const AmoDetailsScreen({Key? key, required this.medicament})
      : super(key: key);

  @override
  State<AmoDetailsScreen> createState() => _AmoDetailsScreenState();
}

class _AmoDetailsScreenState extends State<AmoDetailsScreen> {
  // Modern color scheme
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _secondaryColor = const Color(0xFF4CAF50);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final Color _warningColor = const Color(0xFFFF9800);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildModernAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  _buildDetailsSection(),
                  const Gap(20),
                  _buildDefinitionCard2()
                  // _buildPriceDisclaimer(
                  //     'Les prix indiqués peuvent varier d\'environ 10% selon les pharmacies',
                  //     _warningColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.green,
      expandedHeight: 120,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_secondaryColor, const Color(0xFF66BB6A)],
            ),
          ),
        ),
        title: Text(
          'Détails du médicament',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.medicament.favoris ? Icons.star : Icons.star_border,
                color: widget.medicament.favoris ? Colors.amber : Colors.white,
                size: 24,
              ),
            ),
            onPressed: () async {
              final success = await context
                  .read<MyProvider>()
                  .changeFavorisPharmacie(widget.medicament.name);
              if (success && mounted) {
                setState(() {
                  widget.medicament.favoris = !widget.medicament.favoris;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.medicament.favoris
                          ? 'Ajouté aux favoris'
                          : 'Retiré des favoris',
                    ),
                    backgroundColor: _secondaryColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDefinitionCard2() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: widget.medicament.amo
              ? _primaryColor.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: widget.medicament.amo ? _primaryColor : Colors.red,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color:
                            widget.medicament.amo ? _primaryColor : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Information importante',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: widget.medicament.amo
                                ? _primaryColor
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Les prix indiqués peuvent varier d\'environ 10% selon les pharmacies',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: _textColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!widget.medicament.amo) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Ce médicament n\'est pas couvert par l\'AMO',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                  if (widget.medicament.amo) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Ce médicament est couvert par l\'AMO',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailCard(
          title: 'Nom commercial',
          icon: "assets/icon/nom commercial.png",
          color: _secondaryColor,
          // color: _primaryColor,
          content: [widget.medicament.name],
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'D.C.I/Composition',
          icon: "assets/icon/dci3.png",
          color: _primaryColor,
          content: widget.medicament.dci,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Classe Thérapeutique',
          icon: "assets/icon/classe2.png",
          color: const Color(0xFF607D8B),
          content: widget.medicament.classtherapique,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Forme et dosage',
          icon: "assets/icon/forme.png",
          color: const Color(0xFF795548),
          content: widget.medicament.formedosage,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Présentation',
          icon: "assets/icon/presentation.png",
          color: const Color(0xFFE91E63),
          content: widget.medicament.presantation,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Prix public',
          icon: "assets/icon/prix2.png",
          color: _warningColor,
          content: widget.medicament.prix,
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String icon,
    required Color color,
    required List<dynamic> content,
  }) {
    if (content.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Image.asset(icon, width: 24, height: 24, color: color),
                const Gap(12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   width: 6,
                      //   height: 6,
                      //   margin: const EdgeInsets.only(top: 8, right: 12),
                      //   decoration: BoxDecoration(
                      //     color: color.withOpacity(0.6),
                      //     borderRadius: BorderRadius.circular(3),
                      //   ),
                      // ),
                      Expanded(
                        child: Text(
                          item.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: _textColor,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
