import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/DatabaseManagement/provider.dart';
import 'package:medpharm/Models/amo.dart';
import 'package:medpharm/Screens/AmoView.dart';
import 'package:medpharm/Screens/searchScreen.dart';
import 'package:medpharm/Screens/searchScreenAmoAmo.dart';
import 'package:medpharm/Screens/searchScreenAmoDCI.dart';
import 'package:provider/provider.dart';
import 'package:medpharm/Widgets/az_navigation.dart';

class PharmacieScreen extends StatefulWidget {
  const PharmacieScreen({super.key});

  @override
  _PharmacieScreenState createState() => _PharmacieScreenState();
}

class _PharmacieScreenState extends State<PharmacieScreen> {
  // Modern color scheme
  final Color _secondaryColor = const Color(0xFF4CAF50);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  late Future<void>
      _loadingFuture; // Changed from Future<void> _loadingFuture = void;
  final Map<int, Map<String, int>> _letterIndexMaps = {};
  final Map<int, List<Amo>> _sortedLists = {};
  final _itemHeight = 120.0; // Fixed item height for precise scrolling

  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadingFuture = _loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadingFuture = _loadData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provider = context.read<MyProvider>();
    if (provider.pharmacies.isEmpty) {
      await provider.loadPharmacieData();
    }
  }

  void _updateSortedLists(MyProvider provider) {
    const tabs = [0, 1, 2, 3, 4];
    for (final index in tabs) {
      _sortedLists[index] = _getSortedList(provider, index);
      _letterIndexMaps[index] = _createIndexMap(_sortedLists[index]!, index);
    }
  }

  Widget _buildDefinitionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Mention Special',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Collection de médicament spécial s’imposant comme traitement de choix reconnu, recommandé et soutenu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: _textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  List<Amo> _getSortedList(MyProvider provider, int tabIndex) {
    List<Amo> list;

    switch (tabIndex) {
      case 0:
        list = List.from(provider.pharmacies);
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 1:
        list = List.from(provider.pharmacies);
        list.sort((a, b) {
          final aVal = a.dci.isNotEmpty ? a.dci.first.toString() : '';
          final bVal = b.dci.isNotEmpty ? b.dci.first.toString() : '';
          return aVal.compareTo(bVal);
        });
        break;
      case 2:
        list = provider.pharmacies.where((p) => p.amo).toList();
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 3:
        list = provider.pharmacies.where((p) => p.partenaire).toList();
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 4:
        list = List.from(provider.favorisPharmacies);
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        list = List.from(provider.pharmacies);
    }

    return list;
  }

  Map<String, int> _createIndexMap(List<Amo> list, int tabIndex) {
    final map = <String, int>{};

    for (int i = 0; i < list.length; i++) {
      final key = _getFirstLetter(list[i], tabIndex);
      if (!map.containsKey(key)) {
        map[key] = i;
      }
    }

    return map;
  }

  String _getFirstLetter(Amo item, int tabIndex) {
    if (tabIndex == 1 && item.dci.isNotEmpty) {
      return item.dci.first.toString().substring(0, 1).toUpperCase();
    }
    return item.name.substring(0, 1).toUpperCase();
  }

  Widget _buildTabContent({
    required int tabIndex,
    required String searchHint,
    required VoidCallback onSearchTap,
    bool showAmo = false,
    bool showSpecial = false,
    String? emptyMessage,
    bool showDCI = false,
    bool showPrice = false,
  }) {
    return FutureBuilder(
      future: _loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final provider = context.watch<MyProvider>();
        _updateSortedLists(provider); // Update on data change

        final sortedPharmacies = _sortedLists[tabIndex] ?? [];
        final letterIndexMap = _letterIndexMaps[tabIndex] ?? {};
        final availableLetters = letterIndexMap.keys.toSet();

        return Column(
          children: [
            showSpecial == false
                ? _buildSearchBar(hint: searchHint, onTap: onSearchTap)
                : _buildDefinitionCard(),
            if (sortedPharmacies.isEmpty)
              Expanded(
                child: _buildEmptyState(
                  emptyMessage ?? 'Aucun médicament trouvé',
                  icon: Icons.local_pharmacy_outlined,
                ),
              )
            else
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      itemCount: sortedPharmacies.length,
                      itemExtent: showDCI == false ? _itemHeight : null,
                      itemBuilder: (context, index) {
                        final pharmacy = sortedPharmacies[index];
                        return _buildPharmacyCard(
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
                          showAmo: showAmo,
                          showDCI: showDCI,
                          showPrice: showPrice,
                        );
                      },
                    ),
                    if (showDCI == false)
                      Positioned(
                        right: 8,
                        top: 0,
                        bottom: 0,
                        child: AZNavigation(
                          availableLetters: availableLetters,
                          onLetterSelected: (letter) {
                            final index = letterIndexMap[letter];
                            if (index != null) {
                              _scrollController.animateTo(
                                index * _itemHeight,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          },
                          itemSize: 22,
                          activeColor: _secondaryColor,
                        ),
                      ),
                    // Positioned(
                    //   right: 8,
                    //   top: 0,
                    //   bottom: 0,
                    //   child: AZNavigation(
                    //     availableLetters: availableLetters,
                    //     onLetterSelected: (letter) {
                    //       final index = letterIndexMap[letter];
                    //       if (index != null) {
                    //         _scrollController.animateTo(
                    //           index * _itemHeight,
                    //           duration: const Duration(milliseconds: 300),
                    //           curve: Curves.easeOut,
                    //         );
                    //       }
                    //     },
                    //     itemSize: 22,
                    //     activeColor: _secondaryColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
          ],
        );
      },
    );
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
      {VoidCallback? onTap,
      VoidCallback? onFavorite,
      bool showAmo = false,
      bool showDCI = false,
      bool showPrice = false}) {
    // Helper function to format list content
    String formatList(List<dynamic> list) {
      return list.take(2).map((item) => item.toString()).join(', ');
    }

    // Helper function to format price
    String formatPrice(List<dynamic> prices) {
      if (prices.isEmpty) return 'Prix non disponible';
      return '${prices.first}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                          fontWeight: showDCI
                              ? FontWeight.normal
                              : (showAmo ? FontWeight.normal : FontWeight.bold),
                          color: showDCI
                              ? _textColor
                              : (showAmo ? _textColor : _secondaryColor),
                          fontSize: 16,
                        ),
                      ),
                      const Gap(4),
                      if (showDCI && pharmacy.dci.isNotEmpty) ...[
                        Text(
                          formatList(pharmacy.dci),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                        const Gap(4),
                      ],
                      if (showPrice) ...[
                        Text(
                          formatPrice(pharmacy.prix),
                          style: TextStyle(
                            color: Colors.green.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ] else if (pharmacy.presantation.isNotEmpty &&
                          !showDCI) ...[
                        Text(
                          formatList(pharmacy.presantation),
                          style: TextStyle(
                            color: _textColor.withOpacity(0.7),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const Gap(4),
                    ],
                  ),
                ),
                const Gap(8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: pharmacy.amo
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pharmacy.amo ? 'AMO' : 'AMO',
                    style: TextStyle(
                      color: pharmacy.amo ? Colors.blue : Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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

  // Widget _buildTabContent({
  //   required List<Amo> pharmacies,
  //   required String searchHint,
  //   required VoidCallback onSearchTap,
  //   bool showAmo = false,
  //   String? emptyMessage,
  //   bool showDCI = false,
  //   bool showPrice = false,
  // }) {
  //   // Sort pharmacies based on the display field
  //   List<Amo> sortedPharmacies = List.from(pharmacies);
  //   if (showDCI) {
  //     sortedPharmacies.sort((a, b) {
  //       String aDCI = a.dci.isNotEmpty ? a.dci.first.toString() : '';
  //       String bDCI = b.dci.isNotEmpty ? b.dci.first.toString() : '';
  //       return aDCI.compareTo(bDCI);
  //     });
  //   } else {
  //     sortedPharmacies.sort((a, b) => a.name.compareTo(b.name));
  //   }

  //   return Column(
  //     children: [
  //       _buildSearchBar(hint: searchHint, onTap: onSearchTap),
  //       Expanded(
  //         child: pharmacies.isEmpty
  //             ? _buildEmptyState(
  //                 emptyMessage ?? 'Aucun médicament trouvé',
  //                 icon: Icons.local_pharmacy_outlined,
  //               )
  //             : Stack(
  //                 children: [
  //                   ListView.builder(
  //                     controller: _scrollController,
  //                     padding: const EdgeInsets.only(bottom: 20),
  //                     itemCount: sortedPharmacies.length,
  //                     itemExtent: 100,
  //                     itemBuilder: (context, index) {
  //                       final pharmacy = sortedPharmacies[index];
  //                       return _buildPharmacyCard(
  //                         pharmacy,
  //                         showDCI: showDCI,
  //                         showPrice: showPrice,
  //                         showAmo: showAmo,
  //                         onTap: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) =>
  //                                   AmoDetailsScreen(medicament: pharmacy),
  //                             ),
  //                           );
  //                         },
  //                         onFavorite: () async {
  //                           final success = await context
  //                               .read<MyProvider>()
  //                               .changeFavorisPharmacie(pharmacy.name);
  //                           if (success && mounted) {
  //                             setState(() {
  //                               pharmacy.favoris = !pharmacy.favoris;
  //                             });
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               SnackBar(
  //                                 content: Text(
  //                                   pharmacy.favoris
  //                                       ? 'Ajouté aux favoris'
  //                                       : 'Retiré des favoris',
  //                                 ),
  //                                 backgroundColor: _secondaryColor,
  //                                 duration: const Duration(seconds: 2),
  //                               ),
  //                             );
  //                           }
  //                         },
  //                       );
  //                     },
  //                   ),
  //                   Positioned(
  //                     right: 16,
  //                     top: 0,
  //                     bottom: 0,
  //                     child: AZNavigation(
  //                       availableLetters: sortedPharmacies
  //                           .map((p) => _getFirstLetter(p, showDCI ? 1 : 0))
  //                           .toSet(),
  //                       activeColor: _secondaryColor,
  //                       onLetterSelected: (letter) {
  //                         final index = sortedPharmacies.indexWhere(
  //                           (pharmacy) => (showDCI && pharmacy.dci.isNotEmpty
  //                                   ? pharmacy.dci.first.toString()
  //                                   : pharmacy.name)
  //                               .toUpperCase()
  //                               .startsWith(letter),
  //                         );
  //                         if (index != -1) {
  //                           _scrollController.animateTo(
  //                             index * 80.0,
  //                             duration: const Duration(milliseconds: 300),
  //                             curve: Curves.easeInOut,
  //                           );
  //                         }
  //                       },
  //                       // backgroundColor: _secondaryColor.withOpacity(0.1),
  //                       // selectedColor: _secondaryColor,
  //                       // textColor: _secondaryColor,
  //                       // selectedTextColor: Colors.white,
  //                       itemSize: 20,
  //                       // itemPadding: 2,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          _buildHeader('MedPharm', subtitle: 'Base de données pharmaceutique'),
          Expanded(
            child: Consumer<MyProvider>(
              builder: (context, provider, child) {
                switch (_currentIndex) {
                  case 0:
                    return _buildTabContent(
                      showDCI: false,
                      showAmo: false,
                      showPrice: false,
                      tabIndex: 0,
                      searchHint: 'Rechercher par nom commercial...',
                      onSearchTap: () => _navigateToSearch(provider, 0),
                    );
                  case 1:
                    return _buildTabContent(
                      showDCI: true,
                      showAmo: false,
                      showPrice: false,
                      tabIndex: 1,
                      searchHint: 'Rechercher par D.C.I...',
                      onSearchTap: () => _navigateToSearch(provider, 1),
                    );
                  case 2:
                    return _buildTabContent(
                      tabIndex: 3,
                      showSpecial: true,
                      searchHint: 'Rechercher par nom commercial...',
                      onSearchTap: () => _navigateToSearch(provider, 3),
                      emptyMessage: 'Aucun médicament Partenaire trouvé',
                    );
                  case 3:
                    return _buildTabContent(
                      showDCI: false,
                      showAmo: true,
                      showPrice: true,
                      tabIndex: 2,
                      searchHint: 'Rechercher par nom commercial...',
                      onSearchTap: () => _navigateToSearch(provider, 2),
                      emptyMessage: 'Aucun médicament AMO trouvé',
                    );
                  case 4:
                    return _buildTabContent(
                      tabIndex: 4,
                      searchHint: 'Rechercher par nom commercial...',
                      onSearchTap: () => _navigateToSearch(provider, 4),
                      emptyMessage:
                          'Aucun favori ajouté\nAjoutez des médicaments à vos favoris',
                    );
                  default:
                    return _buildTabContent(
                      tabIndex: 0,
                      searchHint: 'Rechercher par nom commercial...',
                      onSearchTap: () => _navigateToSearch(provider, 0),
                    );
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
          selectedItemColor: _secondaryColor,
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/pharma/nom.png', width: 24, height: 24),
              label: "Nom",
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/pharma/dci.png', width: 24, height: 24),
              label: "D.C.I",
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/pharma/partenaire.png',
                  width: 24, height: 24),
              label: "Special",
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/pharma/amo.png', width: 24, height: 24),
              label: "AMO",
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/pharma/favoris.png',
                  width: 24, height: 24),
              label: "Favoris",
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSearch(MyProvider provider, int tabIndex) {
    final routes = [
      () =>
          SearchAmoScreen(listes: _sortedLists[0]!, hintText: 'Rechercher...'),
      () => SearchAmoScreenDCI(
          listes: _sortedLists[1]!, hintText: 'Rechercher D.C.I...'),
      () => SearchAmoScreenAmo(
          listes: _sortedLists[2]!, hintText: 'Rechercher Special...'),
      () => SearchAmoScreenAmo(
          listes: _sortedLists[3]!, hintText: 'Rechercher AMO...'),
      () => SearchAmoScreen(
          listes: _sortedLists[4]!, hintText: 'Rechercher Favoris...'),
    ];

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => routes[tabIndex]()));
  }
}
