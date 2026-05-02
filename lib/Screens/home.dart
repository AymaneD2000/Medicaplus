import 'dart:async';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:medpharm/DatabaseManagement/provider.dart';
import 'package:medpharm/Models/publication.dart';
import 'package:medpharm/Screens/calculeScreen.dart';
import 'package:medpharm/Screens/carlendriergrosesse.dart';
import 'package:medpharm/Screens/faculterScreenPage.dart';
import 'package:medpharm/Screens/medicamentscreen.dart';
import 'package:medpharm/Screens/pharmacie.dart';
import 'package:medpharm/Screens/venteMaetiels.dart';
import 'package:medpharm/Utils/transitions.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isConnected = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  late List<Widget> grid;
  Future<List<Publication>>? _publicationFuture;
  bool _isLoading = true;

  // Modern color scheme
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
      _setupConnectivity();
    });
  }

  Future<void> _initializeData() async {
    final provider = context.read<MyProvider>();
    try {
      _publicationFuture = provider.getPublication();

      await Future.wait([
        provider.loadMedicamentData(),
        provider.loadPharmacieData(),
      ]);
      if (mounted) {
        setState(() {
          _isLoading = false;
          grid = _buildGrid();
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setupConnectivity() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
      final connected =
          results.any((result) => result != ConnectivityResult.none);

      if (!mounted) return;

      final wasConnected = _isConnected;
      setState(() => _isConnected = connected);

      if (!wasConnected && connected) {
        _refreshPublications();
      }
    });

    _checkConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void _refreshPublications() {
    final provider = context.read<MyProvider>();
    setState(() {
      _publicationFuture = provider.getPublication();
    });
  }

  double _calculateAspectRatio(Size screenSize, bool isTablet) {
    if (isTablet) return 1.0;
    final screenHeight = screenSize.height;
    if (screenHeight < 600) return 0.9;
    if (screenHeight < 700) return 1.0;
    if (screenHeight < 800) return 1.1;
    return 1.2;
  }

  List<Widget> _buildGrid() {
    final List<Map<String, dynamic>> gridItems = [
      {
        'title': 'Medicaments',
        'image': 'assets/accueil/medicament.png',
        'color': const Color(0xFF4CAF50),
        'route': () => Navigator.push(
              context,
              PremiumPageRoute(page: const MedicamentsScreen()),
            ),
      },
      {
        'title': 'Cours',
        'image': 'assets/accueil/cours.png',
        'color': const Color(0xFF2196F3),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Faculter()),
            ),
      },
      {
        'title': 'Pharmacie',
        'image': 'assets/accueil/pharmacie.png',
        'color': const Color(0xFF9C27B0),
        'route': () => Navigator.push(
              context,
              PremiumPageRoute(page: const PharmacieScreen()),
            ),
      },
      {
        'title': 'Equipements',
        'image': 'assets/accueil/materiel.png',
        'color': const Color(0xFFFF9800),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BooksHomePage()),
            ),
      },
      {
        'title': 'Outils',
        'image': 'assets/accueil/outils.png',
        'color': const Color(0xFFF44336),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalculeScreen()),
            ),
      },
      {
        'title': 'Grossesse',
        'image': 'assets/accueil/grossesse.png',
        'color': const Color(0xFF795548),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PregnancyCalculatorScreen()),
            ),
      },
    ];

    return gridItems
        .map((item) => _buildModernCard(
              title: item['title'],
              imagePath: item['image'],
              color: item['color'],
              onTap: item['route'],
            ))
        .toList();
  }

  Widget _buildModernCard({
    required String title,
    required String imagePath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = constraints.maxHeight;
        final isSmallCard = cardWidth < 150 || cardHeight < 150;

        final imageSize = isSmallCard ? 50.0 : 60.0;
        final padding = isSmallCard ? 12.0 : 16.0;
        final fontSize = isSmallCard ? 13.0 : 16.0;
        final iconPadding = isSmallCard ? 8.0 : 12.0;
        final spacing = isSmallCard ? 8.0 : 12.0;

        return Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(iconPadding),
                          child: Image.asset(
                            imagePath,
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.medical_services,
                                size: imageSize * 0.6,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing),
                    Flexible(
                      flex: 1,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _checkConnectivity() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final connected =
        connectivityResults.any((result) => result != ConnectivityResult.none);

    if (!mounted) return;

    final wasConnected = _isConnected;
    setState(() => _isConnected = connected);

    if (!wasConnected && connected) {
      _refreshPublications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    final isTablet = screenSize.width > 600;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _backgroundColor,
            _backgroundColor.withOpacity(0.8),
          ],
        ),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      _buildPublicationCard(),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Services Disponibles',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 3 : 2,
                      childAspectRatio:
                          _calculateAspectRatio(screenSize, isTablet),
                      crossAxisSpacing: isSmallScreen ? 12 : 16,
                      mainAxisSpacing: isSmallScreen ? 12 : 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => grid[index],
                      childCount: grid.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: isSmallScreen ? 16 : 20),
                ),
              ],
            ),
    );
  }

  Widget _buildPublicationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FutureBuilder(
          future: _publicationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 180,
                color: _cardColor,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                  ),
                ),
              );
            } else if (snapshot.hasData && _isConnected) {
              return SizedBox(
                height: 180,
                child: CarouselSlider(
                  items: snapshot.data!.map((item) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: _cardColor,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                  ),
                ),
              );
            } else if (!_isConnected) {
              return _buildErrorCard('Mode hors connexion');
            } else {
              return _buildErrorCard('Aucune publication disponible');
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
