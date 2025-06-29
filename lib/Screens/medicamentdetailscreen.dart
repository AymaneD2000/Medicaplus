import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/med.dart';
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
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
      expandedHeight: 120,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primaryColor, const Color(0xFF33CCCC)],
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
                widget.medicament.isFavoris ? Icons.star : Icons.star_border,
                color:
                    widget.medicament.isFavoris ? Colors.amber : Colors.white,
                size: 24,
              ),
            ),
            onPressed: () async {
              final success = await context
                  .read<MyProvider>()
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
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medication_liquid,
                  color: _primaryColor,
                  size: 28,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.medicament.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    if (widget.medicament.nomCommercial.isNotEmpty) ...[
                      const Gap(4),
                      Text(
                        'Nom commercial',
                        style: TextStyle(
                          fontSize: 12,
                          color: _textColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.medicament.nomCommercial.take(3).join(', '),
                        style: TextStyle(
                          fontSize: 14,
                          color: _textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (widget.medicament.classtherapique.isNotEmpty) ...[
            const Gap(16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.medicament.classtherapique.first.toString(),
                style: TextStyle(
                  color: _successColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailCard(
          title: 'Propriétés',
          icon: Icons.science_outlined,
          color: _primaryColor,
          content: widget.medicament.propriete,
        ),
        const Gap(16),
        if (widget.medicament.activiteantibacterienne != null)
          _buildDetailCard(
            title: 'Activité antibactérienne',
            icon: Icons.biotech_outlined,
            color: const Color(0xFF9C27B0),
            content: widget.medicament.activiteantibacterienne!,
          ),
        const Gap(16),
        _buildDetailCard(
          title: 'Indications',
          icon: Icons.healing_outlined,
          color: _successColor,
          content: widget.medicament.indication,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Posologie et durée',
          icon: Icons.schedule_outlined,
          color: const Color(0xFF607D8B),
          content: widget.medicament.posologie,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Effets indésirables',
          icon: Icons.warning_outlined,
          color: _warningColor,
          content: widget.medicament.effetindesirable,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Contre-indications',
          icon: Icons.dangerous_outlined,
          color: _errorColor,
          content: widget.medicament.contreindication,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Précautions d\'emploi',
          icon: Icons.security_outlined,
          color: const Color(0xFF795548),
          content: widget.medicament.precaution,
        ),
        const Gap(16),
        _buildDetailCard(
          title: 'Grossesse et Allaitement',
          icon: Icons.pregnant_woman_outlined,
          color: const Color(0xFFE91E63),
          content: widget.medicament.grosseseallaitement,
        ),
        const Gap(40), // Extra space at bottom
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
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 8, right: 12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.6),
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
