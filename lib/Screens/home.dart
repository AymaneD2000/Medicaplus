import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:medpharm/DatabaseManagement/provider.dart';
import 'package:medpharm/Screens/calculeScreen.dart';
import 'package:medpharm/Screens/carlendriergrosesse.dart';
import 'package:medpharm/Screens/faculterScreenPage.dart';
import 'package:medpharm/Screens/medicamentscreen.dart';
import 'package:medpharm/Screens/pharmacie.dart';
import 'package:medpharm/Screens/venteMaetiels.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MyProvider provider;
  bool isConnected = true;
  late Stream<List<ConnectivityResult>> connectivityStream;
  late List<Widget> grid;
  bool _isLoading = true;

  // Modern color scheme
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  @override
  void initState() {
    super.initState();
    provider = context.read<MyProvider>();
    grid = _buildGrid(); // Build grid once
    _initializeData();
    _setupConnectivity();
  }

  Future<void> _initializeData() async {
    try {
      await Future.wait([
        provider.loadMedicamentData(),
        provider.loadPharmacieData(),
      ]);
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setupConnectivity() {
    connectivityStream = Connectivity().onConnectivityChanged;
    _checkConnectivity();
  }

  @override
  void dispose() {
    // Clean up any subscriptions or controllers here
    super.dispose();
  }

  List<Widget> _buildGrid() {
    final List<Map<String, dynamic>> gridItems = [
      {
        'title': 'Médicament',
        'image': 'assets/Interface/medicament.png',
        'color': const Color(0xFF4CAF50),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MedicamentsScreen()),
            ),
      },
      {
        'title': 'Cours',
        'image': 'assets/Interface/cours.png',
        'color': const Color(0xFF2196F3),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Faculter()),
            ),
      },
      {
        'title': 'Pharmacie',
        'image': 'assets/Interface/pharmacie.png',
        'color': const Color(0xFF9C27B0),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PharmacieScreen()),
            ),
      },
      {
        'title': 'Matériels',
        'image': 'assets/Interface/materiel.png',
        'color': const Color(0xFFFF9800),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BooksHomePage()),
            ),
      },
      {
        'title': 'Outils',
        'image': 'assets/Interface/outils.png',
        'color': const Color(0xFFF44336),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalculeScreen()),
            ),
      },
      {
        'title': 'Grossesse',
        'image': 'assets/Interface/grossesse.png',
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        imagePath,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() => isConnected = connectivityResult != ConnectivityResult.none);

    connectivityStream.listen((result) {
      for (var result in result) {
        setState(() => isConnected = result != ConnectivityResult.none);

        if (isConnected) {
          provider.getPublication();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildPublicationCard(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Services Disponibles',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: grid.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) => grid[index],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
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
          future: provider.getPublication(),
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
            } else if (snapshot.hasData && isConnected) {
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
                          fit: BoxFit.cover,
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
            } else if (!isConnected) {
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
