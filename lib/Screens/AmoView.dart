import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/amo.dart';
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
                  // _buildHeaderCard(),
                  _buildPriceDisclaimer(
                      'Medicament assurer a l\'AMO', Colors.blue),
                  const Gap(20),
                  _buildDetailsSection(),
                  const Gap(20),
                  _buildPriceDisclaimer(
                      'Les prix indiqués peuvent varier d\'environ 10% selon les pharmacies',
                      _warningColor),
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

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                  color: _secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_pharmacy,
                  color: _secondaryColor,
                  size: 28,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nom commercial',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textColor.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      widget.medicament.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            children: [
              if (widget.medicament.amo) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'AMO',
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(8),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailCard(
          title: 'Nom commercial',
          icon: Icons.local_pharmacy,
          color: _secondaryColor,
          // color: _primaryColor,
          content: [widget.medicament.name],
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'D.C.I/Composition',
          icon: Icons.science_outlined,
          color: _primaryColor,
          content: widget.medicament.dci,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Classe Thérapeutique',
          icon: Icons.category_outlined,
          color: const Color(0xFF9C27B0),
          content: widget.medicament.classtherapique,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Forme et dosage',
          icon: Icons.medication_liquid_outlined,
          color: const Color(0xFF795548),
          content: widget.medicament.formedosage,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Présentation',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFFE91E63),
          content: widget.medicament.presantation,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Prix public',
          icon: Icons.attach_money_outlined,
          color: _warningColor,
          content: widget.medicament.prix,
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
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
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
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

  Widget _buildPriceDisclaimer(String message, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: color,
            size: 24,
          ),
          const Gap(12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: _textColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
