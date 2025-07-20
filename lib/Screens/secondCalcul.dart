import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/Screens/Quinine.dart';
import 'package:medpharm/Screens/artemether.dart';
import 'package:medpharm/Screens/artesunate.dart';
import 'package:medpharm/Screens/paracetamol.dart';

class SecondCalcule extends StatefulWidget {
  const SecondCalcule({super.key});

  @override
  State<SecondCalcule> createState() => _SecondCalculeState();
}

class _SecondCalculeState extends State<SecondCalcule> {
  // Custom colors
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  Widget _buildOptionCard({
    required String title,
    required VoidCallback onTap,
    required String image,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: _textColor.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text(
          'Calculer la dose',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(16),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
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
                  Text(
                    'Sélectionnez le médicament',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Choisissez le médicament pour calculer la dose appropriée',
                    style: TextStyle(
                      fontSize: 16,
                      color: _textColor.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            _buildOptionCard(
              title: 'Paracétamol',
              image: 'assets/Interface/paracetamol.png',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ParacetamolScreen()),
              ),
            ),
            _buildOptionCard(
              title: 'Artesunate',
              image: 'assets/Interface/artesunate.png',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ArtesunateScreen()),
              ),
            ),
            _buildOptionCard(
              title: 'Artémether',
              image: 'assets/Interface/artemether.png',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ArtemetherScreen()),
              ),
            ),
            _buildOptionCard(
              title: 'Quinine',
              image: 'assets/Interface/quinine.png',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuinineScreen()),
              ),
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}
