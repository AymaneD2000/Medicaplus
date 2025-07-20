import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/DatabaseManagement/provider.dart';
import 'package:medpharm/Models/materiels.dart';
import 'package:medpharm/Screens/ventesCover.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BooksHomePage extends StatefulWidget {
  const BooksHomePage({super.key});

  @override
  _BooksHomePageState createState() => _BooksHomePageState();
}

class _BooksHomePageState extends State<BooksHomePage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isGridView = true;
  String _sortBy = 'name'; // name, price_low, price_high, newest
  String _selectedCategory = 'all';
  Set<String> _favorites = <String>{};
  bool _showFilters = false;
  String _priceRange = 'all'; // all, low, medium, high

  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Modern color scheme
  final Color _primaryColor = const Color(0xFF1E88E5);
  final Color _secondaryColor = const Color(0xFF42A5F5);
  final Color _accentColor = const Color(0xFF1976D2);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _warningColor = const Color(0xFFFF9800);

  @override
  void initState() {
    super.initState();
    _loadPreferences();

    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _filterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    ));

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGridView = prefs.getBool('materials_grid_view') ?? true;
      _favorites =
          prefs.getStringList('materials_favorites')?.toSet() ?? <String>{};
    });
  }

  void _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('materials_grid_view', _isGridView);
    await prefs.setStringList('materials_favorites', _favorites.toList());
  }

  void _toggleFavorite(String materialId) {
    setState(() {
      if (_favorites.contains(materialId)) {
        _favorites.remove(materialId);
      } else {
        _favorites.add(materialId);
      }
    });
    _savePreferences();
  }

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

  int _getPriceValue(String price) {
    try {
      String cleanPrice = price.replaceAll('.', '');
      return int.parse(cleanPrice);
    } catch (e) {
      return 0;
    }
  }

  String _getCategoryFromTitle(String title) {
    final titleLower = title.toLowerCase();
    if (titleLower.contains('stethoscope') ||
        titleLower.contains('diagnostic')) {
      return 'diagnostic';
    } else if (titleLower.contains('surgical') ||
        titleLower.contains('scalpel')) {
      return 'surgical';
    } else if (titleLower.contains('monitor') || titleLower.contains('ecg')) {
      return 'monitoring';
    } else if (titleLower.contains('emergency') ||
        titleLower.contains('defibrillator')) {
      return 'emergency';
    } else if (titleLower.contains('lab') ||
        titleLower.contains('microscope')) {
      return 'laboratory';
    }
    return 'diagnostic'; // default category
  }

  List<Materiel> _filterAndSortMaterials(List<Materiel> materials) {
    List<Materiel> filtered = materials;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((material) {
        final titleLower = material.title.toLowerCase();
        final descriptionLower = material.description?.toLowerCase() ?? '';
        final searchLower = _searchQuery.toLowerCase();
        return titleLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'all') {
      filtered = filtered.where((material) {
        return _getCategoryFromTitle(material.title) == _selectedCategory;
      }).toList();
    }

    // Apply price range filter
    if (_priceRange != 'all') {
      filtered = filtered.where((material) {
        final price = _getPriceValue(material.price);
        switch (_priceRange) {
          case 'low':
            return price < 100000;
          case 'medium':
            return price >= 100000 && price < 500000;
          case 'high':
            return price >= 500000;
          default:
            return true;
        }
      }).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'name':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'price_low':
        filtered.sort((a, b) =>
            _getPriceValue(a.price).compareTo(_getPriceValue(b.price)));
        break;
      case 'price_high':
        filtered.sort((a, b) =>
            _getPriceValue(b.price).compareTo(_getPriceValue(a.price)));
        break;
      case 'newest':
        // Assuming newer items have higher IDs or you can add a timestamp field
        filtered = filtered.reversed.toList();
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchAndFilters(),
                if (_showFilters) _buildAdvancedFilters(),
                // _buildCategoryTabs(),
              ],
            ),
          ),
          FutureBuilder<List<Materiel>>(
            future: context.read<MyProvider>().getMateriel(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(child: _buildLoadingView());
              }

              if (snapshot.hasError) {
                return SliverToBoxAdapter(child: _buildErrorView());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmptyView());
              }

              final materials = _filterAndSortMaterials(snapshot.data!);

              if (materials.isEmpty) {
                return SliverToBoxAdapter(child: _buildNoResultsView());
              }

              return SliverToBoxAdapter(
                child: _buildMaterialsList(materials),
              );
            },
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120, // Reduced from 160
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
              padding: const EdgeInsets.fromLTRB(
                  20, 40, 20, 20), // Adjusted padding from 80 to 40
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8), // Reduced from 12
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8), // Reduced from 12
                    ),
                    child: const Icon(
                      Icons.medical_services,
                      color: Colors.white,
                      size: 24, // Reduced from 28
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Matériels Médicaux',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20, // Reduced from 24
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2), // Reduced from 4
                        Text(
                          'Équipements professionnels',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12, // Reduced from 14
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isGridView ? Icons.view_list : Icons.grid_view,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
            _savePreferences();
          },
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
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
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher des matériels...',
                hintStyle: TextStyle(
                  color: _textColor.withOpacity(0.5),
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: _primaryColor,
                  size: 24,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: _textColor.withOpacity(0.5),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        _showFilters
                            ? Icons.filter_list_off
                            : Icons.filter_list,
                        color: _primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _showFilters = !_showFilters;
                        });
                        if (_showFilters) {
                          _filterAnimationController.forward();
                        } else {
                          _filterAnimationController.reverse();
                        }
                      },
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              style: TextStyle(
                color: _textColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return AnimatedBuilder(
      animation: _filterAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _filterAnimation.value,
          child: Opacity(
            opacity: _filterAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
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
                  Row(
                    children: [
                      Icon(Icons.tune, color: _primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Filtres avancés',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSortOptions(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trier par',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildSortChip('name', 'Nom', Icons.sort_by_alpha),
            _buildSortChip('newest', 'Récent', Icons.new_releases),
          ],
        ),
      ],
    );
  }

  Widget _buildSortChip(String value, String label, IconData icon) {
    final isSelected = _sortBy == value;
    return FilterChip(
      backgroundColor: Colors.white,
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 16, color: isSelected ? Colors.white : _primaryColor),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _sortBy = value;
        });
      },
      selectedColor: _primaryColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : _primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Widget _buildCategoryTabs() {
  //   return Container(
  //     height: 80,
  //     margin: const EdgeInsets.symmetric(vertical: 10),
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 20),
  //       itemCount: _categories.length,
  //       itemBuilder: (context, index) {
  //         final category = _categories[index];
  //         final isSelected = _selectedCategory == category['id'];

  //         return Container(
  //           margin: const EdgeInsets.only(right: 12),
  //           child: Material(
  //             color: Colors.transparent,
  //             child: InkWell(
  //               onTap: () {
  //                 setState(() {
  //                   _selectedCategory = category['id'];
  //                 });
  //               },
  //               borderRadius: BorderRadius.circular(16),
  //               child: Container(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //                 decoration: BoxDecoration(
  //                   color: isSelected ? _primaryColor : _cardColor,
  //                   borderRadius: BorderRadius.circular(16),
  //                   border: Border.all(
  //                     color: isSelected ? _primaryColor : Colors.grey.shade300,
  //                     width: 1,
  //                   ),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.05),
  //                       blurRadius: 8,
  //                       offset: const Offset(0, 2),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Icon(
  //                       category['icon'],
  //                       color: isSelected ? Colors.white : _primaryColor,
  //                       size: 24,
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Text(
  //                       category['name'],
  //                       style: TextStyle(
  //                         color: isSelected ? Colors.white : _textColor,
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildMaterialsList(List<Materiel> materials) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(materials.length),
          const SizedBox(height: 20),
          _isGridView ? _buildGridView(materials) : _buildListView(materials),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(int count) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: _primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Matériels Disponibles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count matériel${count > 1 ? 's' : ''} trouvé${count > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: _textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (_favorites.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${_favorites.length}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Materiel> materials) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        return _buildMaterialCard(materials[index], index, isGrid: true);
      },
    );
  }

  Widget _buildListView(List<Materiel> materials) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildMaterialCard(materials[index], index, isGrid: false),
        );
      },
    );
  }

  Widget _buildMaterialCard(Materiel material, int index,
      {required bool isGrid}) {
    final colors = [
      _primaryColor,
      _secondaryColor,
      _accentColor,
      const Color(0xFF2196F3),
      const Color(0xFF1565C0),
      const Color(0xFF0D47A1),
    ];
    final cardColor = colors[index % colors.length];
    final isFavorite = _favorites.contains(material.id.toString());

    if (isGrid) {
      return _buildGridCard(material, cardColor, isFavorite);
    } else {
      return _buildListCard(material, cardColor, isFavorite);
    }
  }

  Widget _buildGridCard(Materiel material, Color cardColor, bool isFavorite) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VenteCover(materiel: material),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          //color: cardColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: material.image,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            placeholder: (context, url) => Container(
                              color: cardColor.withOpacity(0.1),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(cardColor),
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: cardColor.withOpacity(0.1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.medical_services_outlined,
                                    color: cardColor,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Image\nindisponible',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: cardColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _toggleFavorite(material.id.toString()),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  material.title,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${_formatPrice(material.price)} FCFA",
                    style: TextStyle(
                      color: cardColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(Materiel material, Color cardColor, bool isFavorite) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.1),
            blurRadius: 10,
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
              MaterialPageRoute(
                builder: (context) => VenteCover(materiel: material),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: material.image,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: cardColor.withOpacity(0.1),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(cardColor),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: cardColor.withOpacity(0.1),
                        child: Icon(
                          Icons.medical_services_outlined,
                          color: cardColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        material.title,
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${_formatPrice(material.price)} FCFA",
                          style: TextStyle(
                            color: cardColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _toggleFavorite(material.id.toString()),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isFavorite
                              ? Colors.red.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: cardColor,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return ScaleTransition(
      scale: _fabAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_favorites.isNotEmpty)
            FloatingActionButton(
              heroTag: "favorites",
              onPressed: () {
                _showFavoritesDialog();
              },
              backgroundColor: Colors.red,
              child: Stack(
                children: [
                  const Icon(Icons.favorite, color: Colors.white),
                  if (_favorites.length > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_favorites.length}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "scroll_top",
            onPressed: () {
              // Scroll to top functionality
              Scrollable.ensureVisible(
                context,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            backgroundColor: _primaryColor,
            child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showFavoritesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Favoris'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: _favorites.isEmpty
              ? const Center(
                  child: Text('Aucun favori pour le moment'),
                )
              : ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final favoriteId = _favorites.elementAt(index);
                    return ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.red),
                      title: Text('Matériel #$favoriteId'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _toggleFavorite(favoriteId);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Chargement des matériels...',
              style: TextStyle(
                fontSize: 16,
                color: _textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
              child: Icon(
                Icons.wifi_off_outlined,
                size: 64,
                color: _accentColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Erreur de connexion',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Impossible de charger les matériels\nVeuillez vérifier votre connexion",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _textColor.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                "Réessayer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
              child: Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Aucun matériel disponible",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Les matériels seront bientôt disponibles",
              style: TextStyle(
                fontSize: 16,
                color: _textColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.search_off,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Aucun résultat trouvé",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Essayez de modifier vos critères de recherche",
              style: TextStyle(
                fontSize: 16,
                color: _textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'all';
                  _priceRange = 'all';
                  _sortBy = 'name';
                });
                _searchController.clear();
              },
              icon: const Icon(Icons.clear_all, color: Colors.white),
              label: const Text(
                "Effacer les filtres",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
