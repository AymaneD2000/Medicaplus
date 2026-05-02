import 'package:flutter/material.dart';

class GlasgowHomePage extends StatefulWidget {
  const GlasgowHomePage({super.key});

  @override
  _GlasgowHomePageState createState() => _GlasgowHomePageState();
}

class _GlasgowHomePageState extends State<GlasgowHomePage> {
  int eyeOpeningScore = 0;
  int verbalResponseScore = 0;
  int motorResponseScore = 0;

  // Custom colors
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
        title: const Text(
          'Score de Glasgow',
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
            _buildEyeOpeningCard(),
            const SizedBox(height: 16),
            _buildVerbalResponseCard(),
            const SizedBox(height: 16),
            _buildMotorResponseCard(),
            const SizedBox(height: 16),
            _buildResultCard(),
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
                'Définition',
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
            "Le score de Glasgow est une méthode globale d'évaluation de l'état de conscience. Il est égale à la somme des scores de trois items coté de 3 à 15.",
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

  Widget _buildEyeOpeningCard() {
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
                  Icons.remove_red_eye_outlined,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Ouverture des yeux',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...buildEyeOpeningOptions(),
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$eyeOpeningScore /4",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerbalResponseCard() {
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
                  Icons.record_voice_over_outlined,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Réponse verbale',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...buildVerbalResponseOptions(),
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$verbalResponseScore /5",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorResponseCard() {
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
                  Icons.accessibility_new_outlined,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Réponse motrice',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...buildMotorResponseOptions(),
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$motorResponseScore /6",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildEyeOpeningOptions() {
    return [
      _buildRadioOption(
        'Spontanée',
        4,
        eyeOpeningScore,
        (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      _buildRadioOption(
        'À la voix',
        3,
        eyeOpeningScore,
        (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      _buildRadioOption(
        'À la douleur',
        2,
        eyeOpeningScore,
        (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      _buildRadioOption(
        'Absente',
        1,
        eyeOpeningScore,
        (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
    ];
  }

  List<Widget> buildVerbalResponseOptions() {
    return [
      _buildRadioOption(
        'Précise, Orientée',
        5,
        verbalResponseScore,
        (value) => setState(() => updateScore(value!, 'verbalResponse')),
      ),
      _buildRadioOption(
        'Confuse, Désorientée',
        4,
        verbalResponseScore,
        (value) => setState(() => updateScore(value!, 'verbalResponse')),
      ),
      _buildRadioOption(
        'Inappropriée, Incohérente',
        3,
        verbalResponseScore,
        (value) => setState(() => updateScore(value!, 'verbalResponse')),
      ),
      _buildRadioOption(
        'Sons incompréhensibles',
        2,
        verbalResponseScore,
        (value) => setState(() => updateScore(value!, 'verbalResponse')),
      ),
      _buildRadioOption(
        'Absente',
        1,
        verbalResponseScore,
        (value) => setState(() => updateScore(value!, 'verbalResponse')),
      ),
    ];
  }

  List<Widget> buildMotorResponseOptions() {
    return [
      _buildRadioOption(
        'Obéissance aux ordres verbaux',
        6,
        motorResponseScore,
        (value) => setState(() => updateScore(value!, 'motorResponse')),
      ),
      _buildRadioOption(
        'Réaction orientée à la douleur (Adaptée)',
        5,
        motorResponseScore,
        (value) => setState(() => updateScore(value!, 'motorResponse')),
      ),
      _buildRadioOption(
        'Réaction non orientée à la douleur (Evitement)',
        4,
        motorResponseScore,
        (value) => setState(() => updateScore(value!, 'motorResponse')),
      ),
      _buildRadioOption(
        'Flexion stéréotypée (décortication)',
        3,
        motorResponseScore,
        (value) => setState(() => updateScore(value!, 'motorResponse')),
      ),
      _buildRadioOption(
        'Extension stéréotypée (décérébration)',
        2,
        motorResponseScore,
        (value) => setState(() => updateScore(value!, 'motorResponse')),
      ),
      _buildRadioOption(
        'Absente',
        1,
        motorResponseScore,
        (value) => setState(() => updateScore(value!, 'motorResponse')),
      ),
    ];
  }

  Widget _buildRadioOption(
    String text,
    int value,
    int groupValue,
    Function(int?) onChanged,
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
        onChanged: onChanged,
        dense: true,
      ),
    );
  }

  Widget _buildResultCard() {
    final totalScore = _calculateTotalScore();
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
                    '$totalScore/15',
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

  void updateScore(int value, String category) {
    setState(() {
      switch (category) {
        case 'eyeOpening':
          eyeOpeningScore = value;
          break;
        case 'verbalResponse':
          verbalResponseScore = value;
          break;
        case 'motorResponse':
          motorResponseScore = value;
          break;
      }
    });
  }

  int _calculateTotalScore() {
    return eyeOpeningScore + verbalResponseScore + motorResponseScore;
  }

  String _getInterpretation(int score) {
    if (eyeOpeningScore != 0 &&
        motorResponseScore != 0 &&
        verbalResponseScore != 0) {
      if (score == 3) {
        return 'Coma très profond voir état de mort cérébrale';
      } else if (score >= 4 && score <= 6) {
        return 'Coma profond';
      } else if (score >= 7 && score <= 8) {
        return 'Coma grave nécessitant une potencielle intubation';
      } else if (score >= 9 && score <= 14) {
        return 'Trouble de la conscience';
      } else if (score == 15) {
        return 'Vigilance normale';
      }
    }
    return 'Score non valide';
  }

  Color _getInterpretationColor(int score) {
    if (score == 3) {
      return const Color(0xFFE70516);
    } else if (score >= 4 && score <= 6) {
      return const Color(0xFFE70516);
    } else if (score >= 7 && score <= 8) {
      return const Color(0xFFE70516);
    } else if (score >= 9 && score <= 14) {
      return const Color(0xFFF39201);
    } else if (score == 15) {
      return Colors.green;
    }
    return Colors.grey;
  }
}
