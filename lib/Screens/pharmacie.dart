import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Screens/searchScreen.dart';
import 'package:moussa_project/Screens/searchScreenAmoAmo.dart';
import 'package:moussa_project/Screens/searchScreenAmoDCI.dart';
import 'package:provider/provider.dart';
import 'package:moussa_project/Screens/AmoView.dart';

class PharmacieScreen extends StatefulWidget {
  const PharmacieScreen({super.key});

  @override
  _PharmacieScreenState createState() => _PharmacieScreenState();
}

class _PharmacieScreenState extends State<PharmacieScreen> {
  // Modern color scheme
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _secondaryColor = const Color(0xFF4CAF50);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final provider = context.read<MyProvider>();
    if (provider.pharmacies.isEmpty) {
      await provider.loadPharmacieData();
    }
  }

  Widget _buildHeader(String title, {String? subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_secondaryColor, const Color(0xFF66BB6A)],
        ),
        boxShadow: [
          BoxShadow(
            color: _secondaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_pharmacy,
                  color: Colors.white, size: 28),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
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

  Widget _buildSearchBar({required String hint, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        child: Row(
          children: [
            Icon(Icons.search, color: _secondaryColor, size: 24),
            const Gap(12),
            Expanded(
              child: Text(
                hint,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPharmacyCard(Amo pharmacy,
      {VoidCallback? onTap, VoidCallback? onFavorite}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(pharmacy.icon),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                          fontSize: 16,
                        ),
                      ),
                      if (pharmacy.dci.isNotEmpty) ...[
                        const Gap(4),
                        Text(
                          pharmacy.dci.take(2).join(', '),
                          style: TextStyle(
                            color: _textColor.withOpacity(0.7),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      // if (pharmacy.classtherapique.isNotEmpty) ...[
                      //   const Gap(4),
                      //   Text(
                      //     pharmacy.classtherapique.first.toString(),
                      //     style: TextStyle(
                      //       color: _secondaryColor,
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ],
                      if (pharmacy.amo) ...[
                        const Gap(4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'AMO',
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Gap(8),
                IconButton(
                  icon: Icon(
                    pharmacy.favoris ? Icons.star : Icons.star_border,
                    color: pharmacy.favoris ? Colors.amber : Colors.grey[400],
                    size: 24,
                  ),
                  onPressed: onFavorite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message,
      {IconData icon = Icons.info_outline}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 64, color: Colors.grey[400]),
            ),
            const Gap(24),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent({
    required List<Amo> pharmacies,
    required String searchHint,
    required VoidCallback onSearchTap,
    String? emptyMessage,
  }) {
    return Column(
      children: [
        _buildHeader('MedicaPlus', subtitle: 'Base de données pharmaceutique'),
        _buildSearchBar(hint: searchHint, onTap: onSearchTap),
        Expanded(
          child: pharmacies.isEmpty
              ? _buildEmptyState(
                  emptyMessage ?? 'Aucun médicament trouvé',
                  icon: Icons.local_pharmacy_outlined,
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: pharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacy = pharmacies[index];
                    return _buildPharmacyCard(
                      pharmacy,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AmoDetailsScreen(medicament: pharmacy),
                          ),
                        );
                      },
                      onFavorite: () async {
                        final success = await context
                            .read<MyProvider>()
                            .changeFavorisPharmacie(pharmacy.name);
                        if (success && mounted) {
                          setState(() {
                            pharmacy.favoris = !pharmacy.favoris;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                pharmacy.favoris
                                    ? 'Ajouté aux favoris'
                                    : 'Retiré des favoris',
                              ),
                              backgroundColor: _secondaryColor,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: Column(
          children: [
            Container(
              color: _cardColor,
              child: TabBar(
                labelColor: _secondaryColor,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: _secondaryColor,
                indicatorWeight: 3,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                tabs: [
                  Tab(
                    icon: Icon(Icons.medication_outlined, size: 20),
                    text: "Nom",
                  ),
                  Tab(
                    icon: Icon(Icons.science_outlined, size: 20),
                    text: "D.C.I",
                  ),
                  Tab(
                    icon: Icon(Icons.verified_outlined, size: 20),
                    text: "AMO",
                  ),
                  Tab(
                    icon: Icon(Icons.star_outline, size: 20),
                    text: "Favoris",
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<MyProvider>(
                builder: (context, provider, child) {
                  return TabBarView(
                    children: [
                      // Nom Tab
                      _buildTabContent(
                        pharmacies: provider.pharmacies,
                        searchHint: 'Rechercher par nom...',
                        onSearchTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchAmoScreen(
                                listes: provider.pharmacies,
                                hintText: 'Rechercher par nom...',
                              ),
                            ),
                          );
                        },
                      ),
                      // D.C.I Tab
                      _buildTabContent(
                        pharmacies: provider.pharmacies,
                        searchHint: 'Rechercher par D.C.I...',
                        onSearchTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchAmoScreenDCI(
                                listes: provider.pharmacies,
                                hintText: 'Rechercher par D.C.I...',
                              ),
                            ),
                          );
                        },
                      ),
                      // AMO Tab
                      _buildTabContent(
                        pharmacies:
                            provider.pharmacies.where((p) => p.amo).toList(),
                        searchHint: 'Médicaments AMO...',
                        onSearchTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchAmoScreenAmo(
                                listes: provider.pharmacies
                                    .where((p) => p.amo)
                                    .toList(),
                                hintText: 'Médicaments AMO...',
                              ),
                            ),
                          );
                        },
                        emptyMessage: 'Aucun médicament AMO trouvé',
                      ),
                      // Favoris Tab
                      _buildTabContent(
                        pharmacies: provider.favorisPharmacies,
                        searchHint: 'Rechercher dans les favoris...',
                        onSearchTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchAmoScreen(
                                listes: provider.favorisPharmacies,
                                hintText: 'Rechercher dans les favoris...',
                              ),
                            ),
                          );
                        },
                        emptyMessage:
                            'Aucun favori ajouté\nAjoutez des médicaments à vos favoris en appuyant sur l\'étoile',
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
