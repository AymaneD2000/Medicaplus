import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/DatabaseManagement/providers/medicament_provider.dart';
import 'package:medpharm/Models/med.dart';
import 'package:provider/provider.dart';

class MedicamentDetailsScreen extends StatefulWidget {
  final Med medicament;
  const MedicamentDetailsScreen({Key? key, required this.medicament})
      : super(key: key);

  @override
  State<MedicamentDetailsScreen> createState() =>
      _MedicamentDetailsScreenState();
}

class _MedicamentDetailsScreenState extends State<MedicamentDetailsScreen> {
  // Modern color scheme
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final Color _successColor = const Color(0xFF4CAF50);
  final Color _warningColor = const Color(0xFFFF9800);
  final Color _errorColor = const Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildModernAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  _buildDetailsSection(),
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
      backgroundColor: _primaryColor,
      expandedHeight: 120,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primaryColor, const Color(0xFF4FC3F7)],
            ),
          ),
        ),
        title: const Text(
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
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.medicament.isFavoris ? Icons.star : Icons.star_border,
                color:
                    widget.medicament.isFavoris ? Colors.amber : Colors.white,
                size: 24,
              ),
            ),
            onPressed: () async {
              final success = await context
                  .read<MedicamentProvider>()
                  .changeFavoris(widget.medicament.name);
              if (success && mounted) {
                setState(() {
                  widget.medicament.isFavoris = !widget.medicament.isFavoris;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.medicament.isFavoris
                          ? 'Ajouté aux favoris'
                          : 'Retiré des favoris',
                    ),
                    backgroundColor: _primaryColor,
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

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailCard(
          title: 'Médicament/D.C.I (Alias)',
          icon: 'assets/medicament/dci.png',
          color: _primaryColor,
          content: widget.medicament.dci,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Nom commercial',
          icon: 'assets/medicament/nomcommercial.png',
          color: Color(0xFF4CAF50),
          content: widget.medicament.nomCommercial,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Classe Thérapeutique',
          icon: 'assets/medicament/classe.png',
          color: const Color(0xFF607D8B),
          content: widget.medicament.classtherapique,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Propriétés',
          icon: 'assets/medicament/propriete.png',
          color: const Color.fromARGB(255, 6, 214, 214),
          content: widget.medicament.propriete,
        ),
        const Gap(16),
        if (widget.medicament.activiteantibacterienne.isNotEmpty)
          _buildDetailCard(
            title: 'Activité antibactérienne',
            icon: 'assets/medicament/bacteries.png',
            color: const Color(0xFF9C27B0),
            content: widget.medicament.activiteantibacterienne,
          ),
        const Gap(16),
        _buildDetailCard(
          title: 'Indications',
          icon: 'assets/medicament/indication.png',
          color: _successColor,
          content: widget.medicament.indication,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Posologie et durée',
          icon: 'assets/medicament/posologie.png',
          color: const Color(0xFF607D8B),
          content: widget.medicament.posologie,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Effets indésirables',
          icon: 'assets/medicament/effetsindesirables.png',
          color: _warningColor,
          content: widget.medicament.effetindesirable,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Contre-indications',
          icon: 'assets/medicament/contreindications.png',
          color: _errorColor,
          content: widget.medicament.contreindication,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Précautions d\'emploi',
          icon: 'assets/medicament/precaution.png',
          color: const Color(0xFF795548),
          content: widget.medicament.precaution,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Interactions médicamenteuses',
          icon: 'assets/medicament/interactions.png',
          color: _successColor,
          content: widget.medicament.interactions,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Grossesse et Allaitement',
          icon: 'assets/medicament/grossesse.png',
          color: const Color(0xFFE91E63),
          content: widget.medicament.grosseseallaitement,
        ),
        const Gap(20),
        _buildAvertissementsCard(),
        const Gap(20), // Extra space at bottom
      ],
    );
  }

  Widget _buildAvertissementsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _primaryColor.withValues(alpha: 0.2),
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
                color: _primaryColor,
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
                        color: _primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Avertissements',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cet ouvrage résume les données essentielles à retenir et ne décharge nullement l\'utilisateur de son devoir de se référer aux dictionnaires des médicaments et aux recommandations officielles actualisées des sociétés savantes. Le prescripteur est le seul responsable de son choix thérapeutique.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: _textColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            color: Colors.black.withValues(alpha: 0.05),
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
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  width: 24,
                  height: 24,
                  color: color,
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
              children: content.asMap().entries.map((entry) {
                final isLast = entry.key == content.length - 1;
                final item = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 8, right: 12),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
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
