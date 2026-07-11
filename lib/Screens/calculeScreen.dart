import 'package:flutter/material.dart';
import 'package:medpharm/Screens/Appgar.dart';
import 'package:medpharm/Screens/IMC.dart';
import 'package:medpharm/Screens/glascow.dart';
import 'package:medpharm/Screens/hba.dart';
import 'package:medpharm/Screens/secondCalcul.dart';
import 'package:medpharm/Screens/wells_score.dart';

class CalculeScreen extends StatefulWidget {
  const CalculeScreen({super.key});

  @override
  State<CalculeScreen> createState() => _CalculeScreenState();
}

class _CalculeScreenState extends State<CalculeScreen> {
  // Modern color scheme
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

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
            const Color(0xFF02B0EC), // Custom blue primary color for tools
            const Color(0xFF02B0EC).withValues(alpha: 0.8),
            const Color(0xFF4FC3F7), // Light blue accent
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF02B0EC).withValues(alpha: 0.2),
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
                    "assets/accueil/outils.png",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          _buildHeader("Outils de calcul", subtitle: "Outils de calcul"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Choisissez un calculateur',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Outils de calcul médical pour votre pratique clinique',
                    style: TextStyle(
                      fontSize: 16,
                      color: _textColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _calculators.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final calculator = _calculators[index];
                      return _buildCalculatorCard(
                        title: calculator['title'],
                        icon: calculator['icon'],
                        color: calculator['color'],
                        onTap: calculator['onTap'],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _calculators => [
        {
          'title': 'IMC',
          'subtitle': 'Indice de Masse Corporelle',
          'icon': Image.asset(
            'assets/outils/imc.png',
            width: 24,
            height: 24,
          ),
          'color': const Color(0xFF4CAF50),
          'onTap': () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const IMCCalculator())),
        },
        {
          'title': 'Glasgow',
          'subtitle': 'Échelle de Coma de Glasgow',
          'icon': Image.asset(
            'assets/outils/glasgow.png',
            width: 24,
            height: 24,
          ),
          'color': const Color(0xFF2196F3),
          'onTap': () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const GlasgowHomePage())),
        },
        {
          'title': 'HbA1c',
          'subtitle': 'Hémoglobine Glyquée',
          'icon': Image.asset(
            'assets/outils/hba1c.png',
            width: 24,
            height: 24,
          ),
          'color': const Color(0xFF9C27B0),
          'onTap': () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HbA1cScreen())),
        },
        {
          'title': 'Wells',
          'subtitle': 'Score de Wells',
          'icon': Image.asset(
            'assets/outils/wells.png',
            width: 24,
            height: 24,
          ),
          'color': const Color(0xFFF44336),
          'onTap': () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WellsScorePage())),
        },
        {
          'title': 'Apgar',
          'subtitle': 'Score d\'Apgar',
          'icon': Image.asset(
            'assets/outils/apgar.png',
            width: 24,
            height: 24,
          ),
          'color': const Color(0xFF795548),
          'onTap': () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AppgarHomePage())),
        },
        {
          'title': 'Caldose',
          'subtitle': 'Autres Calculateurs',
          'icon': Image.asset(
            'assets/outils/caldose.png',
            width: 24,
            height: 24,
          ),
          'color': const Color(0xFF607D8B),
          'onTap': () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SecondCalcule())),
        },
      ];

  Widget _buildCalculatorCard({
    required String title,
    required Image icon,
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
              color: Colors.black.withValues(alpha: 0.08),
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
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      // color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: icon,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
