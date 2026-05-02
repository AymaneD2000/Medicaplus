import 'package:flutter/material.dart';

class AppgarHomePage extends StatefulWidget {
  const AppgarHomePage({super.key});

  @override
  _AppgarHomePageState createState() => _AppgarHomePageState();
}

class _AppgarHomePageState extends State<AppgarHomePage> {
  int frequenceCardiaqueScore = 0;
  int mouvementRespirationScore = 0;
  int tonusMusculaireScore = 0;
  int reactiviteReflexeScore = 0;
  int colorationScore = 0;

  // Modern color scheme
  final Color _primaryColor = const Color(0xFF02B1EC);

  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  @override
  Widget build(BuildContext context) {
    final int totalScore = _calculateTotalScore();

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text(
          'Score d\'Apgar',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDefinitionCard(),
            const SizedBox(height: 16),
            _buildCriteriaCard(
              'Fréquence cardiaque',
              [
                {'score': 0, 'description': 'Absente'},
                {'score': 1, 'description': '< 100/min'},
                {'score': 2, 'description': '> 100/min'},
              ],
              frequenceCardiaqueScore,
              (value) => setState(() => frequenceCardiaqueScore = value),
              Icons.favorite_outline,
            ),
            const SizedBox(height: 16),
            _buildCriteriaCard(
              'Mouvements respiratoires',
              [
                {'score': 0, 'description': 'Absents'},
                {'score': 1, 'description': 'Lents, irréguliers'},
                {'score': 2, 'description': 'Vigoureux, cri'},
              ],
              mouvementRespirationScore,
              (value) => setState(() => mouvementRespirationScore = value),
              Icons.air,
            ),
            const SizedBox(height: 16),
            _buildCriteriaCard(
              'Tonus musculaire',
              [
                {'score': 0, 'description': 'Hypotonie globale'},
                {'score': 1, 'description': 'Flexion des extrémités'},
                {'score': 2, 'description': 'Bon tonus, mouvements actifs'},
              ],
              tonusMusculaireScore,
              (value) => setState(() => tonusMusculaireScore = value),
              Icons.fitness_center_outlined,
            ),
            const SizedBox(height: 16),
            _buildCriteriaCard(
              'Réactivité aux stimuli',
              [
                {'score': 0, 'description': 'Aucune réponse'},
                {'score': 1, 'description': 'Grimace'},
                {'score': 2, 'description': 'Cri vigoureux'},
              ],
              reactiviteReflexeScore,
              (value) => setState(() => reactiviteReflexeScore = value),
              Icons.touch_app_outlined,
            ),
            const SizedBox(height: 16),
            _buildCriteriaCard(
              'Coloration',
              [
                {'score': 0, 'description': 'Cyanose ou pâleur globale'},
                {'score': 1, 'description': 'Corps rose, extrémités bleues'},
                {'score': 2, 'description': 'Rose'},
              ],
              colorationScore,
              (value) => setState(() => colorationScore = value),
              Icons.palette_outlined,
            ),
            const SizedBox(height: 16),
            _buildResultCard(totalScore),
          ],
        ),
      ),
    );
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
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Score d\'Apgar',
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
            "Le score d'Apgar est une évaluation de l'état de santé d'un nouveau-né. Il est calculé à 1, 5 et 10 minutes après la naissance.",
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

  Widget _buildCriteriaCard(
    String title,
    List<Map<String, dynamic>> options,
    int currentScore,
    Function(int) onScoreChanged,
    IconData icon,
  ) {
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
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$currentScore/2",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...options.map((option) => _buildRadioOption(
                option['description'],
                option['score'],
                currentScore,
                onScoreChanged,
              )),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    String text,
    int value,
    int groupValue,
    Function(int) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: groupValue == value
              ? _primaryColor
              : Colors.grey.withOpacity(0.3),
          width: groupValue == value ? 2 : 1,
        ),
        color: groupValue == value
            ? _primaryColor.withOpacity(0.05)
            : Colors.transparent,
      ),
      child: RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight:
                groupValue == value ? FontWeight.w600 : FontWeight.normal,
            color: _textColor,
          ),
        ),
        value: value,
        groupValue: groupValue,
        onChanged: (value) => onChanged(value!),
        dense: true,
      ),
    );
  }

  Widget _buildResultCard(int totalScore) {
    final interpretation = _getInterpretation(totalScore);
    final color = _getInterpretationColor(totalScore);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score Total',
                    style: TextStyle(
                      fontSize: 16,
                      color: _textColor.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '$totalScore/10',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Interprétation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  interpretation,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateTotalScore() {
    return frequenceCardiaqueScore +
        mouvementRespirationScore +
        tonusMusculaireScore +
        reactiviteReflexeScore +
        colorationScore;
  }

  String _getInterpretation(int score) {
    if (score >= 7) {
      return 'État satisfaisant';
    } else if (score >= 4) {
      return 'État moyennement satisfaisant';
    } else {
      return 'État préoccupant';
    }
  }

  Color _getInterpretationColor(int score) {
    if (score >= 7) {
      return Colors.green;
    } else if (score >= 4) {
      return const Color(0xFFF39201);
    } else {
      return const Color(0xFFE70516);
    }
  }
}
