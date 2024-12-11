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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Score de Glasgow',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Definition :',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),            
            const Text(
                        "Le score de Glasgow est une méthode globale d'évaluation de l'état de conscience. Il est égale à la somme des scores de trois items coté de 3 à 15.",
                        style:
                        TextStyle(
                          //fontFamily: 'TimesNewRoman',
                          fontSize: 17,
                          // fontFamily: 'TimesNewRoman',
                          color: Colors.black,
                        ),
                      ),
            const SizedBox(height: 16),
            buildEyeOpeningCard(),
            const SizedBox(height: 16),
            buildVerbalResponseCard(),
            const SizedBox(height: 16),
            buildMotorResponseCard(),
            const SizedBox(height: 16),
            buildScoreAnalysis(),
          ],
        ),
      ),
    );
  }

  Widget buildEyeOpeningCard() {
    return Card(
      color: Colors.white, // White background
      margin: const EdgeInsets.all(8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ouverture des yeux',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildEyeOpeningOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$eyeOpeningScore /4",
              style: const TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildVerbalResponseCard() {
    return Card(
      color: Colors.white, // White background
      margin: const EdgeInsets.all(8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Réponse verbale',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildVerbalResponseOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$verbalResponseScore /5",
              style: const TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,)
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMotorResponseCard() {
    return Card(
      color: Colors.white, // White background
      margin: const EdgeInsets.all(8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Réponse motrice',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildMotorResponseOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$motorResponseScore /6",
              style: const TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,)),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildEyeOpeningOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Spontanée'),
        value: 4,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('À la voix'),
        value: 3,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('À la douleur'),
        value: 2,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Absente'),
        value: 1,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
    ];
  }

  List<Widget> buildVerbalResponseOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Précise, orientée'),
        value: 5,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Confuse, déorientée'),
        value: 4,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Inappropriée, Incohérente'),
        value: 3,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Sons incompréhensibles'),
        value: 2,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Absente'),
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
        activeColor: const Color(0xff33CCCC),
        title: const Text('Obéissance aux ordres verbaux'),
        value: 6,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Réaction orientée à la douleur (Adaptée)'),
        value: 5,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Réaction non orientée à la douleur (Evitement)'),
        value: 4,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Flexion stéréotypée (décortication)'),
        value: 3,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Extension stéréotypée (décérébration)'),
        value: 2,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Absente'),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Score final : $totalScore',
          style: const TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
        ),
        const SizedBox(height: 8),
              const Text(
                'Interprétation : ',
                style: TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff33CCCC),
                ),
              ),
        buildAnalysisText(totalScore),
      ],
    );
  }

  Widget buildAnalysisText(int totalScore) {
    String analysis;
    Text text = const Text("");
    if(eyeOpeningScore != 0 && motorResponseScore !=0 && verbalResponseScore != 0){
      if (totalScore == 3) {
      analysis =
          'Coma tres profond voir état de mort cérébrale';
        text = Text(
              textAlign: TextAlign.center,
                      analysis,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE70516),
                      ),);
    } else if (totalScore >= 4 && totalScore <=6) {
      
      analysis =
          'Coma profond';
          text = Text(
              textAlign: TextAlign.center,
                      analysis,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE70516),
                      ),);
    } else if (totalScore >= 7 && totalScore <=8) {
      analysis =
          'Coma grave neccesitant une intubation';
          text = Text(
              textAlign: TextAlign.center,
                      analysis,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE70516),
                      ),);
    } else if (totalScore >=9 && totalScore<=14) {
      analysis =
          'Trouble de la conscience';
          text = Text(
              textAlign: TextAlign.center,
                      analysis,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF39201),
                      ),);
    } else if (totalScore == 15) {
      analysis =
          'Vigilance normale';
          text = Text(
              textAlign: TextAlign.center,
                      analysis,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),);
    } else {
      analysis = 'Score non valide.';
      text = const Text("");
    }
    }

    return text;
  }
}

