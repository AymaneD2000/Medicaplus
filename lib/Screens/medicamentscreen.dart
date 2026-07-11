import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/DatabaseManagement/providers/medicament_provider.dart';

import 'package:medpharm/Models/med.dart';

import 'package:medpharm/Screens/searchScreenMedicaments.dart';
import 'package:provider/provider.dart';
import 'package:medpharm/Screens/medicamentdetailscreen.dart';
import 'package:medpharm/Utils/transitions.dart';
import 'package:medpharm/Widgets/az_navigation.dart';

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

  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provider = context.read<MedicamentProvider>();
    print('Starting to load medicament data...');
    await provider.loadMedicamentData();
    print(
        'Finished loading medicament data. Count: ${provider.medicament.length}');
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildHeader(String title, {String? subtitle}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: isSmallScreen ? 12 : 16,
        top: statusBarHeight + 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _primaryColor,
            _primaryColor.withValues(alpha: 0.8),
            const Color(0xFF4FC3F7),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative elements
          Positioned(
            right: -15,
            top: statusBarHeight - 5,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 25,
            top: statusBarHeight + 10,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Back button
          Positioned(
            left: 0,
            top: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const SizedBox(width: 50), // Space for back button
                // Compact icon container
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.25),
                        Colors.white.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    "assets/accueil/medicament.png",
                    width: isSmallScreen ? 20 : 22,
                    height: isSmallScreen ? 20 : 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                // Enhanced text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 16 : 18,
                          letterSpacing: 0.3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              offset: const Offset(0, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (subtitle != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 10 : 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Smaller decorative element
                Container(
                  width: 2,
                  height: isSmallScreen ? 25 : 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.25),
                        Colors.white.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ],
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
              color: Colors.black.withValues(alpha: 0.05),
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PremiumPageRoute(
                page: MedicamentDetailsScreen(
                  medicament: med,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
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
                            color: _primaryColor.withValues(alpha: 0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      // if (med.classtherapique.isNotEmpty) ...[
                      //   const Gap(4),
                      //   Text(
                      //     med.classtherapique.first.toString(),
                      //     style: TextStyle(
                      //       color: _primaryColor,
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ],
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

  Widget _buildMedicationsTab(MedicamentProvider provider) {
    return Column(
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
              : Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
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
                                    MedicamentDetailsScreen(medicament: med),
                              ),
                            );
                          },
                          onFavorite: () async {
                            final success =
                                await provider.changeFavoris(med.name);
                            if (success && mounted) {
                              setState(() {
                                med.isFavoris = !med.isFavoris;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    med.isFavoris
                                        ? 'Ajouté aux favoris'
                                        : 'Retiré des favoris',
                                  ),
                                  backgroundColor: _primaryColor,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                    Positioned(
                      right: 16,
                      top: 0,
                      bottom: 0,
                      child: AZNavigation(
                        availableLetters: provider.medicament
                            .map((med) => med.name[0].toUpperCase())
                            .toSet(),
                        onLetterSelected: (letter) {
                          // Find the first item starting with the selected letter
                          final index = provider.medicament.indexWhere(
                            (med) => med.name.toUpperCase().startsWith(letter),
                          );
                          if (index != -1) {
                            _scrollController.animateTo(
                              index * 80.0, // Approximate item height
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        itemSize: 20,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab(MedicamentProvider provider) {
    return Column(
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
              : Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: provider.favorisMedicaments.length,
                      itemBuilder: (context, index) {
                        final med = provider.favorisMedicaments[index];
                        return _buildMedCard(
                          med,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MedicamentDetailsScreen(medicament: med),
                              ),
                            );
                          },
                          onFavorite: () async {
                            final success =
                                await provider.changeFavoris(med.name);
                            if (success && mounted) {
                              setState(() {
                                med.isFavoris = !med.isFavoris;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    med.isFavoris
                                        ? 'Ajouté aux favoris'
                                        : 'Retiré des favoris',
                                  ),
                                  backgroundColor: _primaryColor,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                    Positioned(
                      right: 16,
                      top: 0,
                      bottom: 0,
                      child: AZNavigation(
                        availableLetters: provider.favorisMedicaments
                            .map((med) => med.name[0].toUpperCase())
                            .toSet(),
                        onLetterSelected: (letter) {
                          // Find the first favorite starting with the selected letter
                          final index = provider.favorisMedicaments.indexWhere(
                            (med) => med.name.toUpperCase().startsWith(letter),
                          );
                          if (index != -1) {
                            _scrollController.animateTo(
                              index * 80.0, // Approximate item height
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        itemSize: 20,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          _buildHeader('Medicaments', subtitle: 'Base de données médicale'),
          Expanded(
            child: Consumer<MedicamentProvider>(
              builder: (context, provider, child) {
                print(
                    'Consumer builder called. Medicament count: ${provider.medicament.length}');

                switch (_currentIndex) {
                  case 0:
                    return _buildMedicationsTab(provider);
                  // case 1:
                  //   return _buildClassesTab(provider);
                  case 1:
                    return _buildFavoritesTab(provider);
                  default:
                    return _buildMedicationsTab(provider);
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: _cardColor,
          selectedItemColor: _primaryColor,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/medicament/nom.png',
                  width: 24, height: 24),
              label: "Médicaments",
            ),
            // BottomNavigationBarItem(
            //   icon:
            //       Image.asset('assets/medicament/classe.png', width: 24, height: 24),
            //   label: "Classes",
            // ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/medicament/favoris.png',
                  width: 24, height: 24),
              label: "Favoris",
            ),
          ],
        ),
      ),
    );
  }
}
