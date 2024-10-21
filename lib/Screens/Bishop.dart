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
      appBar: AppBar(
        title: const Text(
          'Score de Bishop',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Le score Glascow est classification pronostique des comas traumastiques la plus utilisee dans le monde",
                style: TextStyle(
fontFamily: 'TimesNewRoman',
                    fontSize: 14, color: Colors.black.withOpacity(0.60))),
            const Text(
              'Dilatation du col utérin',
              style: TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...buildColUterinOptions(),
            const SizedBox(height: 16),
            const Text(
              'Effacement du col utérin',
              style: TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...buildEffacementUterinOptions(),
            const SizedBox(height: 16),
            const Text(
              'Consistance du col utérin',
              style: TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...buildConsistanceUterinOptions(),
            const SizedBox(height: 16),
            const Text(
              'Posistion du col utérin',
              style: TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...buildPositionUterinOptions(),
            const SizedBox(height: 16),
            const Text(
              'Hauteur de la tete',
              style: TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...buildHauteurTeteOptions(),
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
        title: const Text('Fermé'),
        value: 4,
        groupValue: colUterinScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ColUterin')),
      ),
      RadioListTile<int>(
        title: const Text('1-2 cm'),
        value: 3,
        groupValue: colUterinScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ColUterin')),
      ),
      RadioListTile<int>(
        title: const Text('3-4 cm'),
        value: 2,
        groupValue: colUterinScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ColUterin')),
      ),
      RadioListTile<int>(
        title: const Text('5 cm ou plus'),
        value: 2,
        groupValue: colUterinScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ColUterin')),
      ),
      RadioListTile<int>(
        title: const Text('Nulle'),
        value: 1,
        groupValue: colUterinScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ColUterin')),
      ),
    ];
  }

  List<Widget> buildEffacementUterinOptions() {
    return [
      RadioListTile<int>(
        title: const Text('Long (0-30%)'),
        value: 5,
        groupValue: effacementUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'effacementCol')),
      ),
      RadioListTile<int>(
        title: const Text('1/2 long(40-50%)'),
        value: 4,
        groupValue: effacementUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'effacementCol')),
      ),
      RadioListTile<int>(
        title: const Text('Court (60-70%)'),
        value: 3,
        groupValue: effacementUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'effacementCol')),
      ),
      RadioListTile<int>(
        title: const Text('Effacé (>80%)'),
        value: 2,
        groupValue: effacementUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'effacementCol')),
      ),
      RadioListTile<int>(
        title: const Text('Nulle'),
        value: 1,
        groupValue: effacementUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'effacementCol')),
      ),
    ];
  }

  List<Widget> buildConsistanceUterinOptions() {
    return [
      RadioListTile<int>(
        title: const Text('Ferme'),
        value: 5,
        groupValue: consistenceUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'consistanceCol')),
      ),
      RadioListTile<int>(
        title: const Text('Moyenne'),
        value: 4,
        groupValue: consistenceUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'consistanceCol')),
      ),
      RadioListTile<int>(
        title: const Text('Molle'),
        value: 3,
        groupValue: consistenceUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'consistanceCol')),
      ),
      RadioListTile<int>(
        title: const Text('Nulle'),
        value: 1,
        groupValue: consistenceUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'consistanceCol')),
      ),
    ];
  }

List<Widget> buildPositionUterinOptions() {
    return [
      RadioListTile<int>(
        title: const Text('Postérieure'),
        value: 5,
        groupValue: positionUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'positionCol')),
      ),
      RadioListTile<int>(
        title: const Text('Centrer'),
        value: 4,
        groupValue: positionUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'positionCol')),
      ),
      RadioListTile<int>(
        title: const Text('Antérieure'),
        value: 3,
        groupValue: positionUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'positionCol')),
      ),
      RadioListTile<int>(
        title: const Text('Nulle'),
        value: 1,
        groupValue: positionUterinScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'positionCol')),
      ),
    ];
  }


  List<Widget> buildHauteurTeteOptions() {
    return [
      RadioListTile<int>(
        title: const Text('Haute et mobile (3 cm au-dessus)'),
        value: 6,
        groupValue: hauteurTeteScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'hauteurTete')),
      ),
      RadioListTile<int>(
        title: const Text('Amorcée (2 cm au-dessus)'),
        value: 5,
        groupValue: hauteurTeteScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'hauteurTete')),
      ),
      RadioListTile<int>(
        title: const Text('Fixé (< 1 cm au-dessus)'),
        value: 4,
        groupValue: hauteurTeteScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'hauteurTete')),
      ),
      RadioListTile<int>(
        title: const Text('Engagé (1-2 cm au-dessous)'),
        value: 3,
        groupValue: hauteurTeteScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'hauteurTete')),
      ),
      RadioListTile<int>(
        title: const Text('Nulle'),
        value: 1,
        groupValue: hauteurTeteScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'hauteurTete')),
      ),
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

  // Widget buildScoreAnalysis() {
  //   int totalScore = eyeOpeningScore + consistenceUterinScore + hauteurTeteScore;
  //   String analysis;

  //   if (totalScore <= 4) {
  //     analysis =
  //         'Score de 3 ou 4 : environ 7% de bonne récupération. Environ 87% de mortalité.';
  //   } else if (totalScore <= 7) {
  //     analysis =
  //         'Score de 5 à 7 : environ 34% de bonne récupération. Environ 53% de mortalité.';
  //   } else if (totalScore <= 10) {
  //     analysis =
  //         'Score de 8 à 10 : environ 68% de bonne récupération. Environ 27% de mortalité.';
  //   } else {
  //     analysis =
  //         'Score supérieur à 10 : environ 82% de bonne récupération. Environ 12% de mortalité.';
  //   }

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Score final: $totalScore',
  //         style: TextStyle(
//fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(height: 8),
  //       Text(
  //         'Analyse:',
  //         style: TextStyle(
//fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
  //       ),
  //       Text(
  //         analysis,
  //         style: TextStyle(
//fontFamily: 'TimesNewRoman',fontSize: 16),
  //       ),
  //     ],
  //   );
  // }
  Widget buildScoreAnalysis() {
    int totalScore = effacementUterinScore + colUterinScore + positionUterinScore + consistenceUterinScore + hauteurTeteScore;
    String analysis;

    if (totalScore <= 3) {
      analysis =
          'Score < 3 : pronostic tres defavorable';
    } else if (totalScore >= 4 && totalScore <= 5) {
      analysis =
          'Score entre 4 à 5 : pronostic intermediaire.';
    } else if (totalScore >= 6 && totalScore <= 9) {
      analysis =
          'Score entre 6 à 9 : pronostic favorable';
    } else {
      analysis =
          'Score > 9 : Tres pronostic favorable';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Score final: $totalScore',
          style: const TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Analyse:',
          style: TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          "Score < 3 : pronostic tres defavorable",
          style: TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60)),
        ),
//         Text("- Environ 87% de mortalité.",
//             style:
//                 TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60))),
        Text(
          "Score entre 4 à 5 : pronostic intermediaire.",
          style: TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60)),
        ),
//         Text("- Environ 53% de mortalité..",
//             style:
//                 TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60))),
        Text(
          "Score entre 6 à 9 : pronostic favorable",
          style: TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60)),
        ),
//         Text("- Environ 27% de mortalité.",
//             style:
//                 TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60))),
        Text(
          "Score > 9 : Tres pronostic favorable",
          style: TextStyle(
fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60)),
        ),
//         Text("- Environ 12% de mortalité.",
//             style:
//                 TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60))),
      ],
    );
  }
}
