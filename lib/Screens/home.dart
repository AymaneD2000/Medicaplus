import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Screens/calculeScreen.dart';
import 'package:moussa_project/Screens/carlendriergrosesse.dart';
import 'package:moussa_project/Screens/faculterScreenPage.dart';
import 'package:moussa_project/Screens/medicamentscreen.dart';
import 'package:moussa_project/Screens/pharmacie.dart';
import 'package:moussa_project/Screens/venteMaetiels.dart';
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
  List<Widget> grid = [];

  // Modern color scheme
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  @override
  void initState() {
    super.initState();
    provider = context.read<MyProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = context.read<MyProvider>();
      provider.loadMedicamentData();
      provider.loadPharmacieData();
      provider.getPublication();
    });

    grid = _buildGrid();
    _checkConnectivity();
    connectivityStream = Connectivity().onConnectivityChanged;
  }

  List<Widget> _buildGrid() {
    final List<Map<String, dynamic>> gridItems = [
      {
        'title': 'Medicament',
        'icon': Icons.medication_outlined,
        'color': const Color(0xFF4CAF50),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MedicamentsScreen()),
            ),
      },
      {
        'title': 'Cours',
        'icon': Icons.school_outlined,
        'color': const Color(0xFF2196F3),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Faculter()),
            ),
      },
      {
        'title': 'Pharmacie',
        'icon': Icons.local_pharmacy_outlined,
        'color': const Color(0xFF9C27B0),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PharmacieScreen()),
            ),
      },
      {
        'title': 'Matériels',
        'icon': Icons.medical_services_outlined,
        'color': const Color(0xFFFF9800),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BooksHomePage()),
            ),
      },
      {
        'title': 'Calcule',
        'icon': Icons.calculate_outlined,
        'color': const Color(0xFFF44336),
        'route': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalculeScreen()),
            ),
      },
      {
        'title': 'Grossesse',
        'icon': Icons.pregnant_woman_outlined,
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
              icon: item['icon'],
              color: item['color'],
              onTap: item['route'],
            ))
        .toList();
  }

  Widget _buildModernCard({
    required String title,
    required IconData icon,
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
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: color,
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
      child: SingleChildScrollView(
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
