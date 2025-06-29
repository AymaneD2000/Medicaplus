import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WellsScorePage extends StatefulWidget {
  const WellsScorePage({super.key});

  @override
  _WellsScorePageState createState() => _WellsScorePageState();
}

class _WellsScorePageState extends State<WellsScorePage> {
  // Variables to track selected criteria
  bool hasTVPHistory = false;
  bool hasHeartRateOver100 = false;
  bool hasRecentSurgeryOrImmobilization = false;
  bool hasTVPSigns = false;
  bool hasAlternativeDiagnosisLessLikely = false;
  bool hasHemoptysis = false;
  bool hasCancer = false;

  // Custom colors
  final Color _primaryColor =
      const Color(0xFF02B1EC); // Orange theme from image
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  double calculateTotalScore() {
    double total = 0;
    if (hasTVPHistory) total += 1.5;
    if (hasHeartRateOver100) total += 1.5;
    if (hasRecentSurgeryOrImmobilization) total += 1.5;
    if (hasTVPSigns) total += 3.0;
    if (hasAlternativeDiagnosisLessLikely) total += 3.0;
    if (hasHemoptysis) total += 1.0;
    if (hasCancer) total += 1.0;
    return total;
  }

  String getInterpretation(double score) {
    if (score >= 7) return 'Forte';
    if (score >= 2) return 'Moyenne';
    return 'Faible';
  }

  Color getInterpretationColor(double score) {
    if (score >= 7) return Colors.red;
    if (score >= 2) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final double totalScore = calculateTotalScore();

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text(
          'Score de Wells',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                    'Définition du score de Wells',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    "Le score de Wells est une méthode d'estimation de la probabilité clinique d'embolie pulmonaire.",
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
            Container(
              width: double.infinity,
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
                  _buildCriteriaCheckbox(
                    'Antécédent de TVP ou EP',
                    1.5,
                    hasTVPHistory,
                    (value) => setState(() => hasTVPHistory = value ?? false),
                  ),
                  _buildCriteriaCheckbox(
                    'Rythme cardiaque > 100/min',
                    1.5,
                    hasHeartRateOver100,
                    (value) =>
                        setState(() => hasHeartRateOver100 = value ?? false),
                  ),
                  _buildCriteriaCheckbox(
                    'Chirurgie récente ou immobilisation',
                    1.5,
                    hasRecentSurgeryOrImmobilization,
                    (value) => setState(() =>
                        hasRecentSurgeryOrImmobilization = value ?? false),
                  ),
                  _buildCriteriaCheckbox(
                    'Signe de TVP',
                    3.0,
                    hasTVPSigns,
                    (value) => setState(() => hasTVPSigns = value ?? false),
                  ),
                  _buildCriteriaCheckbox(
                    'Diagnostic autre moins probable que l\'EP',
                    3.0,
                    hasAlternativeDiagnosisLessLikely,
                    (value) => setState(() =>
                        hasAlternativeDiagnosisLessLikely = value ?? false),
                  ),
                  _buildCriteriaCheckbox(
                    'Hémoptysie',
                    1.0,
                    hasHemoptysis,
                    (value) => setState(() => hasHemoptysis = value ?? false),
                  ),
                  _buildCriteriaCheckbox(
                    'Cancer',
                    1.0,
                    hasCancer,
                    (value) => setState(() => hasCancer = value ?? false),
                  ),
                ],
              ),
            ),
            const Gap(16),
            Container(
              width: double.infinity,
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
                    'Score total : ${totalScore.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const Gap(16),
                  Text(
                    'Probabilité clinique : ${getInterpretation(totalScore)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: getInterpretationColor(totalScore),
                    ),
                  ),
                  const Gap(16),
                  _buildProbabilityRangeRow('Faible', '0 - 1'),
                  _buildProbabilityRangeRow('Moyenne', '2 - 6'),
                  _buildProbabilityRangeRow('Forte', '≥ 7'),
                ],
              ),
            ),
            const Gap(16),
            Container(
              width: double.infinity,
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
                    'Légende',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'EP : embolie pulmonaire\nTVP : thrombose veineuse profonde',
                    style: TextStyle(
                      fontSize: 16,
                      color: _textColor.withOpacity(0.8),
                      height: 1.5,
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

  Widget _buildCriteriaCheckbox(
    String title,
    double points,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: value ? _primaryColor.withOpacity(0.1) : _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? _primaryColor : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: _textColor,
            fontWeight: value ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          '${points.toStringAsFixed(1)} points',
          style: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: _primaryColor,
        checkColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildProbabilityRangeRow(String probability, String range) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            probability,
            style: TextStyle(
              fontSize: 16,
              color: _textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            range,
            style: TextStyle(
              fontSize: 16,
              color: _primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
