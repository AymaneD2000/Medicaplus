import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
  final Color _secondaryColor = const Color(0xFF33CCCC);
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
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
                    'Définition du score de Glasgow',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const Gap(8),
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
            ),
            const Gap(24),
            buildEyeOpeningCard(),
            const Gap(16),
            buildVerbalResponseCard(),
            const Gap(16),
            buildMotorResponseCard(),
            const Gap(16),
            buildScoreAnalysis(),
          ],
        ),
      ),
    );
  }

  Widget buildEyeOpeningCard() {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ouverture des yeux',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const Gap(8),
            ...buildEyeOpeningOptions(),
            const Gap(16),
            Container(
              alignment: Alignment.center,
              child: Text(
                "$eyeOpeningScore /4",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVerbalResponseCard() {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Réponse verbale',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const Gap(8),
            ...buildVerbalResponseOptions(),
            const Gap(16),
            Container(
              alignment: Alignment.center,
              child: Text(
                "$verbalResponseScore /5",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMotorResponseCard() {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Réponse motrice',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const Gap(8),
            ...buildMotorResponseOptions(),
            const Gap(16),
            Container(
              alignment: Alignment.center,
              child: Text(
                "$motorResponseScore /6",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildEyeOpeningOptions() {
    return [
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Spontanée',
          style: TextStyle(color: _textColor),
        ),
        value: 4,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'À la voix',
          style: TextStyle(color: _textColor),
        ),
        value: 3,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'À la douleur',
          style: TextStyle(color: _textColor),
        ),
        value: 2,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Absente',
          style: TextStyle(color: _textColor),
        ),
        value: 1,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
    ];
  }

  List<Widget> buildVerbalResponseOptions() {
    return [
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Précise, orientée',
          style: TextStyle(color: _textColor),
        ),
        value: 5,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Confuse, déorientée',
          style: TextStyle(color: _textColor),
        ),
        value: 4,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Inappropriée, Incohérente',
          style: TextStyle(color: _textColor),
        ),
        value: 3,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Sons incompréhensibles',
          style: TextStyle(color: _textColor),
        ),
        value: 2,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Absente',
          style: TextStyle(color: _textColor),
        ),
        value: 1,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
    ];
  }

  List<Widget> buildMotorResponseOptions() {
    return [
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Obéissance aux ordres verbaux',
          style: TextStyle(color: _textColor),
        ),
        value: 6,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Réaction orientée à la douleur (Adaptée)',
          style: TextStyle(color: _textColor),
        ),
        value: 5,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Réaction non orientée à la douleur (Evitement)',
          style: TextStyle(color: _textColor),
        ),
        value: 4,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Flexion stéréotypée (décortication)',
          style: TextStyle(color: _textColor),
        ),
        value: 3,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Extension stéréotypée (décérébration)',
          style: TextStyle(color: _textColor),
        ),
        value: 2,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        activeColor: _primaryColor,
        title: Text(
          'Absente',
          style: TextStyle(color: _textColor),
        ),
        value: 1,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
    ];
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

  Widget buildScoreAnalysis() {
    int totalScore = eyeOpeningScore + verbalResponseScore + motorResponseScore;

    return Container(
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
            'Score final : $totalScore',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const Gap(16),
          Text(
            'Interprétation :',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const Gap(8),
          buildAnalysisText(totalScore),
        ],
      ),
    );
  }

  Widget buildAnalysisText(int totalScore) {
    String analysis;
    Text text = const Text("");
    if (eyeOpeningScore != 0 &&
        motorResponseScore != 0 &&
        verbalResponseScore != 0) {
      if (totalScore == 3) {
        analysis = 'Coma très profond voir état de mort cérébrale';
        text = Text(
          textAlign: TextAlign.center,
          analysis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE70516),
          ),
        );
      } else if (totalScore >= 4 && totalScore <= 6) {
        analysis = 'Coma profond';
        text = Text(
          textAlign: TextAlign.center,
          analysis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE70516),
          ),
        );
      } else if (totalScore >= 7 && totalScore <= 8) {
        analysis = 'Coma grave nécessitant une potencielle intubation';
        text = Text(
          textAlign: TextAlign.center,
          analysis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE70516),
          ),
        );
      } else if (totalScore >= 9 && totalScore <= 14) {
        analysis = 'Trouble de la conscience';
        text = Text(
          textAlign: TextAlign.center,
          analysis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF39201),
          ),
        );
      } else if (totalScore == 15) {
        analysis = 'Vigilance normale';
        text = Text(
          textAlign: TextAlign.center,
          analysis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        );
      } else {
        analysis = 'Score non valide.';
        text = const Text("");
      }
    }

    return text;
  }
}
