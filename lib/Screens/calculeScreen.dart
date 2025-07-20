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
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        title: const Text(
          "Calculateurs Médicaux",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
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
                color: _textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _calculators.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }

  List<Map<String, dynamic>> get _calculators => [
        {
          'title': 'IMC',
          'subtitle': 'Indice de Masse Corporelle',
          'icon': Image.asset(
            'assets/Interface/imc.png',
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
            'assets/Interface/glasgow.png',
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
            'assets/Interface/hba1c.png',
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
            'assets/Interface/wells.png',
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
            'assets/Interface/apgar.png',
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
            'assets/Interface/caldose.png',
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
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      // color: color.withOpacity(0.1),
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
