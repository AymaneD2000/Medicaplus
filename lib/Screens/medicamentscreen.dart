import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/DatabaseManagement/provider.dart';
import 'package:medpharm/Models/amo.dart';
import 'package:medpharm/Models/med.dart';
import 'package:medpharm/Screens/SearchScreenTheurapetique.dart';
import 'package:medpharm/Screens/searchScreenMedicaments.dart';
import 'package:provider/provider.dart';
import 'package:medpharm/Screens/medicamentdetailscreen.dart';
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
        color: _primaryColor,
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
                            color: _primaryColor.withOpacity(0.7),
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

  Widget _buildMedicationsTab(MyProvider provider) {
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

  Widget _buildClassesTab(MyProvider provider) {
    return Column(
      children: [
        _buildSearchBar(
          hint: 'Rechercher des classes...',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchClasseTheuraScreenDCI(
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
              : Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: provider.classMedicament.length,
                      itemBuilder: (context, index) {
                        final classItem = provider.classMedicament[index];
                        return _buildClassCard(
                          classItem,
                          onTap: () {
                            // Navigate to class details or filter by class
                          },
                        );
                      },
                    ),
                    Positioned(
                      right: 16,
                      top: 0,
                      bottom: 0,
                      child: AZNavigation(
                        availableLetters: provider.classMedicament
                            .map((classItem) =>
                                classItem.clname[0].toUpperCase())
                            .toSet(),
                        onLetterSelected: (letter) {
                          // Find the first class starting with the selected letter
                          final index = provider.classMedicament.indexWhere(
                            (classItem) => classItem.clname
                                .toUpperCase()
                                .startsWith(letter),
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

  Widget _buildFavoritesTab(MyProvider provider) {
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
          _buildHeader('MedPharm', subtitle: 'Base de données médicale'),
          Expanded(
            child: Consumer<MyProvider>(
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
              color: Colors.black.withOpacity(0.1),
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
              icon: Image.asset('assets/icon/nom.png', width: 24, height: 24),
              label: "Médicaments",
            ),
            // BottomNavigationBarItem(
            //   icon:
            //       Image.asset('assets/icon/classe.png', width: 24, height: 24),
            //   label: "Classes",
            // ),
            BottomNavigationBarItem(
              icon:
                  Image.asset('assets/icon/favoris.png', width: 24, height: 24),
              label: "Favoris",
            ),
          ],
        ),
      ),
    );
  }
}
