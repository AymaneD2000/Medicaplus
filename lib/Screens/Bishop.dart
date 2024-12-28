import 'package:flutter/material.dart';

class BishopPage extends StatefulWidget {
  const BishopPage ({super.key});

  @override
  _BishopPageState createState() => _BishopPageState();
}

class _BishopPageState extends State<BishopPage > {
  int colUterinScore = 0;
  int effacementUterinScore = 0;
  int hauteurTeteScore = 0;
  int consistenceUterinScore = 0;
  int positionUterinScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Score de Bishop',
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
                "Le score de Bishop est une méthode globale d'évaluation du pronostic d'accouchement.",
                style:
                        TextStyle(
                          //fontFamily: 'TimesNewRoman',
                          fontSize: 17,
                          // fontFamily: 'TimesNewRoman',
                          color: Colors.black,
                        ),),
            Card(
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
              'Dilatation du col utérin',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
             ...buildColUterinOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$colUterinScore /4",
              style: const TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,)),
            )
          ],
        ),
      ),
    ),
            const SizedBox(height: 16),
            Card(
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
              'Effacement du col utérin',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildEffacementUterinOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$effacementUterinScore /4",
              style: const TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,)),
            )
          ],
        ),
      ),
    ),
            const SizedBox(height: 16),
            Card(
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
              'Consistance du col utérin',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildConsistanceUterinOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$consistenceUterinScore /3",
              style: const TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,)),
            )
          ],
        ),
      ),
    ),
            const SizedBox(height: 16),
            Card(
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
              'Posistion du col utérin',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildPositionUterinOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$positionUterinScore /3",
              style: const TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,)),
            )
          ],
        ),
      ),
    ),
            const SizedBox(height: 16),
            Card(
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
              'Hauteur de la tete',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildHauteurTeteOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$hauteurTeteScore /4",
              style: const TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,)),
            )
          ],
        ),
      ),
    ),
            const SizedBox(height: 16),
            buildScoreAnalysis(),
          ],
        ),
      ),
    );
  }

  List<Widget> buildColUterinOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Fermé'),
        value: 0,
        groupValue: colUterinScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ColUterin')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('1-2 cm'),
        value: 1,
        groupValue: colUterinScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ColUterin')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('3-4 cm'),
        value: 2,
        groupValue: colUterinScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ColUterin')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('5 cm ou plus'),
        value: 3,
        groupValue: colUterinScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ColUterin')),
      ),
    ];
  }

  List<Widget> buildEffacementUterinOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Long (0-30%)'),
        value: 0,
        groupValue: effacementUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'effacementCol')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('1/2 long(40-50%)'),
        value: 1,
        groupValue: effacementUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'effacementCol')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Court (60-70%)'),
        value: 2,
        groupValue: effacementUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'effacementCol')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Effacé (>80%)'),
        value: 3,
        groupValue: effacementUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'effacementCol')),
      )
    ];
  }

  List<Widget> buildConsistanceUterinOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Ferme'),
        value: 0,
        groupValue: consistenceUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'consistanceCol')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Moyenne'),
        value: 1,
        groupValue: consistenceUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'consistanceCol')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Molle'),
        value: 2,
        groupValue: consistenceUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'consistanceCol')),
      )
    ];
  }

List<Widget> buildPositionUterinOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Postérieure'),
        value: 0,
        groupValue: positionUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'positionCol')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Centrer'),
        value: 1,
        groupValue: positionUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'positionCol')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Antérieure'),
        value: 2,
        groupValue: positionUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'positionCol')),
      )
    ];
  }


  List<Widget> buildHauteurTeteOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Haute et mobile (3 cm au-dessus)'),
        value: 0,
        groupValue: hauteurTeteScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'hauteurTete')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Amorcée (2 cm au-dessus)'),
        value: 1,
        groupValue: hauteurTeteScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'hauteurTete')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Fixé (< 1 cm au-dessus)'),
        value: 2,
        groupValue: hauteurTeteScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'hauteurTete')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Engagé (1-2 cm au-dessous)'),
        value: 3,
        groupValue: hauteurTeteScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'hauteurTete')),
      )
    ];
  }

  void updateScore(int value, String category) {
    switch (category) {
      case 'ColUterin':
        colUterinScore = value;
        break;
      case 'consistanceCol':
        consistenceUterinScore = value;
        break;
      case 'positionCol':
        positionUterinScore = value;
        break;
      case 'hauteurTete':
        hauteurTeteScore = value;
        break;
      case 'effacementCol':
        effacementUterinScore = value;
        break;
    }
  }


  Widget buildScoreAnalysis() {
    int totalScore = colUterinScore + effacementUterinScore + hauteurTeteScore + consistenceUterinScore + positionUterinScore;

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
      if (totalScore <= 3) {
      analysis =
          'Pronostic très défavorable';
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
    } else if (totalScore >= 4 && totalScore <=5) {
      
      analysis =
          'Pronostic intermédiaire';
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
    } else if (totalScore >= 6 && totalScore <=8) {
      analysis =
          'Pronostic Favorable';
          text = Text(
              textAlign: TextAlign.center,
                      analysis,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),);
    } else if (totalScore >=9) {
      analysis =
          'Pronostic très favorable (travail de moins de 4 heures chez les multipares)';
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
      text = Text(analysis);
    }

    return text;
  }
}
