import 'package:alphabet_navigation/alphabet_navigation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:moussa_project/Screens/SearchScreenTheurapetique.dart';
import 'package:moussa_project/Screens/searchScreenMedicaments.dart';
import 'package:provider/provider.dart';
import 'package:moussa_project/Screens/medicamentdetailscreen.dart';
import 'package:moussa_project/Widgets/card.dart';

// Styles personnalisés
const TextStyle headerStyle = TextStyle(
  fontFamily: 'TimesNewRoman',
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const TextStyle subHeaderStyle = TextStyle(
  fontFamily: 'TimesNewRoman',
  fontSize: 16.0,
  color: Colors.grey,
);

class MedicamentsScreen extends StatefulWidget {
  const MedicamentsScreen({super.key});

  @override
  _MedicamentsScreenState createState() => _MedicamentsScreenState();
}

class _MedicamentsScreenState extends State<MedicamentsScreen> {
  final Color _primaryColor = const Color(0xFF02B1EC);
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
    print('Starting to load medicament data...');
    await provider.loadMedicamentData();
    print(
        'Finished loading medicament data. Count: ${provider.medicament.length}');
    if (mounted) {
      setState(() {});
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
          colors: [_primaryColor, const Color(0xFF33CCCC)],
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
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
              child: const Icon(Icons.medical_information,
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
            Icon(Icons.search, color: _primaryColor, size: 24),
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

  Widget _buildMedCard(Med med,
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
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.medication_liquid_outlined,
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
                        med.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                          fontSize: 16,
                        ),
                      ),
                      if (med.nomCommercial.isNotEmpty) ...[
                        const Gap(4),
                        Text(
                          med.nomCommercial.take(2).join(', '),
                          style: TextStyle(
                            color: _textColor.withOpacity(0.7),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (med.classtherapique.isNotEmpty) ...[
                        const Gap(4),
                        Text(
                          med.classtherapique.first.toString(),
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const Gap(8),
                IconButton(
                  icon: Icon(
                    med.isFavoris ? Icons.star : Icons.star_border,
                    color: med.isFavoris ? Colors.amber : Colors.grey[400],
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

  Widget _buildClassCard(ClassMed classItem, {VoidCallback? onTap}) {
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
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.category_outlined,
                    color: Color(0xFF4CAF50),
                    size: 28,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Text(
                    classItem.clname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
            strokeWidth: 3,
          ),
          const Gap(16),
          Text(
            'Chargement des médicaments...',
            style: TextStyle(
              color: _textColor.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: Column(
          children: [
            _buildHeader('MedicaPlus', subtitle: 'Base de données médicale'),
            Container(
              color: _cardColor,
              child: TabBar(
                labelColor: _primaryColor,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: _primaryColor,
                indicatorWeight: 3,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                tabs: [
                  Tab(
                    icon: Icon(Icons.medication_outlined, size: 20),
                    text: "Médicaments",
                  ),
                  Tab(
                    icon: Icon(Icons.category_outlined, size: 20),
                    text: "Classes",
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
                  print(
                      'Consumer builder called. Medicament count: ${provider.medicament.length}');

                  return TabBarView(
                    children: [
                      // Medications Tab
                      Column(
                        children: [
                          _buildSearchBar(
                            hint: 'Rechercher des médicaments...',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchMedicamentScreen(
                                    listes: provider.medicament,
                                    hintText: 'Rechercher des médicaments...',
                                  ),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: provider.medicament.isEmpty
                                ? _buildEmptyState(
                                    'Aucun médicament trouvé\nVerifiez votre connexion ou réessayez',
                                    icon: Icons.medication_outlined,
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    itemCount: provider.medicament.length,
                                    itemBuilder: (context, index) {
                                      final med = provider.medicament[index];
                                      return _buildMedCard(
                                        med,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MedicamentDetailsScreen(
                                                      medicament: med),
                                            ),
                                          );
                                        },
                                        onFavorite: () async {
                                          final success = await provider
                                              .changeFavoris(med.name);
                                          if (success && mounted) {
                                            setState(() {
                                              med.isFavoris = !med.isFavoris;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  med.isFavoris
                                                      ? 'Ajouté aux favoris'
                                                      : 'Retiré des favoris',
                                                ),
                                                backgroundColor: _primaryColor,
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                      // Classes Tab
                      Column(
                        children: [
                          _buildSearchBar(
                            hint: 'Rechercher des classes...',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchClasseTheuraScreenDCI(
                                    listes: provider.classMedicament,
                                    iconMeds: provider.imagesMed,
                                    hintText: 'Rechercher des classes...',
                                  ),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: provider.classMedicament.isEmpty
                                ? _buildEmptyState(
                                    'Aucune classe trouvée',
                                    icon: Icons.category_outlined,
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    itemCount: provider.classMedicament.length,
                                    itemBuilder: (context, index) {
                                      final classItem =
                                          provider.classMedicament[index];
                                      return _buildClassCard(
                                        classItem,
                                        onTap: () {
                                          // Navigate to class details or filter by class
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                      // Favorites Tab
                      Column(
                        children: [
                          _buildSearchBar(
                            hint: 'Rechercher dans les favoris...',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchMedicamentScreen(
                                    listes: provider.favorisMedicaments,
                                    hintText: 'Rechercher dans les favoris...',
                                  ),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: provider.favorisMedicaments.isEmpty
                                ? _buildEmptyState(
                                    'Aucun favori ajouté\nAjoutez des médicaments à vos favoris en appuyant sur l\'étoile',
                                    icon: Icons.star_outline,
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    itemCount:
                                        provider.favorisMedicaments.length,
                                    itemBuilder: (context, index) {
                                      final med =
                                          provider.favorisMedicaments[index];
                                      return _buildMedCard(
                                        med,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MedicamentDetailsScreen(
                                                      medicament: med),
                                            ),
                                          );
                                        },
                                        onFavorite: () async {
                                          final success = await provider
                                              .changeFavoris(med.name);
                                          if (success && mounted) {
                                            setState(() {
                                              med.isFavoris = !med.isFavoris;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  med.isFavoris
                                                      ? 'Ajouté aux favoris'
                                                      : 'Retiré des favoris',
                                                ),
                                                backgroundColor: _primaryColor,
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
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
