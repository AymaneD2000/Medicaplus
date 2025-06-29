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
  final Color _secondaryColor = const Color(0xFF33CCCC);
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
              frequenceCardiaqueScore,
              [
                {'text': 'Absente', 'value': 0},
                {'text': '< 100/min', 'value': 1},
                {'text': '≥ 100/min', 'value': 2},
              ],
              (value) => setState(() => frequenceCardiaqueScore = value),
            ),
            const SizedBox(height: 16),
            _buildCriteriaCard(
              'Mouvements respiratoires',
              mouvementRespirationScore,
              [
                {'text': 'Absents', 'value': 0},
                {'text': 'Lents, irréguliers', 'value': 1},
                {'text': 'Normaux', 'value': 2},
              ],
              (value) => setState(() => mouvementRespirationScore = value),
            ),
            const SizedBox(height: 16),
            _buildCriteriaCard(
              'Tonus musculaire',
              tonusMusculaireScore,
              [
                {'text': 'Hypotonie globale', 'value': 0},
                {'text': 'Léger tonus en flexion', 'value': 1},
                {'text': 'Mouvements actifs', 'value': 2},
              ],
              (value) => setState(() => tonusMusculaireScore = value),
            ),
            const SizedBox(height: 16),
            _buildCriteriaCard(
              'Réactivité réflexe',
              reactiviteReflexeScore,
              [
                {'text': 'Nulle', 'value': 0},
                {'text': 'Grimaces', 'value': 1},
                {'text': 'Vive', 'value': 2},
              ],
              (value) => setState(() => reactiviteReflexeScore = value),
            ),
            const SizedBox(height: 16),
            _buildCriteriaCard(
              'Coloration',
              colorationScore,
              [
                {'text': 'Cyanose ou pâleur', 'value': 0},
                {'text': 'Corps rose, extrémités cyanosées', 'value': 1},
                {'text': 'Totalement rose', 'value': 2},
              ],
              (value) => setState(() => colorationScore = value),
            ),
            const SizedBox(height: 24),
            _buildResultCard(totalScore),
          ],
        ),
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
                'Définition du Score d\'Apgar',
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
            'Le score d\'Apgar est une méthode d\'évaluation de la vitalité du nouveau-né. '
            'Il évalue 5 critères cotés de 0 à 2, pour un score total de 0 à 10.',
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
    int currentValue,
    List<Map<String, dynamic>> options,
    Function(int) onChanged,
  ) {
    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    '$currentValue/2',
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
            ...options.map((option) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: currentValue == option['value']
                          ? _primaryColor
                          : Colors.grey.withOpacity(0.3),
                      width: currentValue == option['value'] ? 2 : 1,
                    ),
                    color: currentValue == option['value']
                        ? _primaryColor.withOpacity(0.05)
                        : Colors.transparent,
                  ),
                  child: RadioListTile<int>(
                    activeColor: _primaryColor,
                    title: Text(
                      option['text'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: currentValue == option['value']
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: _textColor,
                      ),
                    ),
                    value: option['value'],
                    groupValue: currentValue,
                    onChanged: (value) => onChanged(value!),
                    dense: true,
                  ),
                )),
          ],
        ),
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
          const SizedBox(height: 16),
          _buildScoreRanges(),
        ],
      ),
    );
  }

  Widget _buildScoreRanges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interprétation des scores :',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 12),
        _buildScoreRangeItem('0-3', 'Asphyxie sévère', Colors.red),
        _buildScoreRangeItem('4-6', 'Asphyxie modérée', Colors.orange),
        _buildScoreRangeItem('7-10', 'Nouveau-né vigoureux', Colors.green),
      ],
    );
  }

  Widget _buildScoreRangeItem(String range, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$range: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: _textColor.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInterpretation(int score) {
    if (score >= 0 && score <= 3) {
      return 'Asphyxie sévère - Réanimation urgente nécessaire';
    } else if (score >= 4 && score <= 6) {
      return 'Asphyxie modérée - Surveillance et soins appropriés';
    } else if (score >= 7 && score <= 10) {
      return 'Nouveau-né vigoureux - État satisfaisant';
    }
    return 'Score non valide';
  }

  Color _getInterpretationColor(int score) {
    if (score >= 0 && score <= 3) {
      return Colors.red;
    } else if (score >= 4 && score <= 6) {
      return Colors.orange;
    } else if (score >= 7 && score <= 10) {
      return Colors.green;
    }
    return Colors.grey;
  }
}
