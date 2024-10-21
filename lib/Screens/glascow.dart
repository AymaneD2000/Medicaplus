// import 'package:flutter/material.dart';

// class GlasgowHomePage extends StatefulWidget {
//   const GlasgowHomePage({super.key});

//   @override
//   _GlasgowHomePageState createState() => _GlasgowHomePageState();
// }

// class _GlasgowHomePageState extends State<GlasgowHomePage> {
//   int eyeOpeningScore = 0;
//   int verbalResponseScore = 0;
//   int motorResponseScore = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Glasgow Coma Scale',
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//                 "Le score Glascow est classification pronostique des comas traumastiques la plus utilisee dans le monde",
//                 style: TextStyle(
// fontFamily: 'TimesNewRoman',
//                     fontSize: 14, color: Colors.black.withOpacity(0.60))),
//             const Text(
//               'Ouverture des yeux',
//               style: TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             ...buildEyeOpeningOptions(),
//             const SizedBox(height: 16),
//             const Text(
//               'Réponse verbale',
//               style: TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             ...buildVerbalResponseOptions(),
//             const SizedBox(height: 16),
//             const Text(
//               'Réponse motrice',
//               style: TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             ...buildMotorResponseOptions(),
//             const SizedBox(height: 16),
//             buildScoreAnalysis(),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> buildEyeOpeningOptions() {
//     return [
//       RadioListTile<int>(
//         title: const Text('Spontanée'),
//         value: 4,
//         groupValue: eyeOpeningScore,
//         onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
//       ),
//       RadioListTile<int>(
//         title: const Text('À la demande verbale'),
//         value: 3,
//         groupValue: eyeOpeningScore,
//         onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
//       ),
//       RadioListTile<int>(
//         title: const Text('À la douleur'),
//         value: 2,
//         groupValue: eyeOpeningScore,
//         onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
//       ),
//       RadioListTile<int>(
//         title: const Text('Nulle'),
//         value: 1,
//         groupValue: eyeOpeningScore,
//         onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
//       ),
//     ];
//   }

//   List<Widget> buildVerbalResponseOptions() {
//     return [
//       RadioListTile<int>(
//         title: const Text('Appropriée, orientée'),
//         value: 5,
//         groupValue: verbalResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'verbalResponse')),
//       ),
//       RadioListTile<int>(
//         title: const Text('Confuse'),
//         value: 4,
//         groupValue: verbalResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'verbalResponse')),
//       ),
//       RadioListTile<int>(
//         title: const Text('Incohérente'),
//         value: 3,
//         groupValue: verbalResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'verbalResponse')),
//       ),
//       RadioListTile<int>(
//         title: const Text('Incompréhensible'),
//         value: 2,
//         groupValue: verbalResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'verbalResponse')),
//       ),
//       RadioListTile<int>(
//         title: const Text('Nulle'),
//         value: 1,
//         groupValue: verbalResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'verbalResponse')),
//       ),
//     ];
//   }

//   List<Widget> buildMotorResponseOptions() {
//     return [
//       RadioListTile<int>(
//         title: const Text('Obéissance aux ordres verbaux'),
//         value: 6,
//         groupValue: motorResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'motorResponse')),
//       ),
//       RadioListTile<int>(
//         title: const Text('Réaction orientée à la douleur'),
//         value: 5,
//         groupValue: motorResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'motorResponse')),
//       ),
//       RadioListTile<int>(
//         title: const Text('Réaction non orientée à la douleur'),
//         value: 4,
//         groupValue: motorResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'motorResponse')),
//       ),
//       RadioListTile<int>(
//         title: const Text('À type de décortication'),
//         value: 3,
//         groupValue: motorResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'motorResponse')),
//       ),
//       RadioListTile<int>(
//         title: const Text('À type de décérébration'),
//         value: 2,
//         groupValue: motorResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'motorResponse')),
//       ),
//       RadioListTile<int>(
//         title: const Text('Nulle'),
//         value: 1,
//         groupValue: motorResponseScore,
//         onChanged: (value) =>
//             setState(() => updateScore(value!, 'motorResponse')),
//       ),
//     ];
//   }

//   void updateScore(int value, String category) {
//     switch (category) {
//       case 'eyeOpening':
//         eyeOpeningScore = value;
//         break;
//       case 'verbalResponse':
//         verbalResponseScore = value;
//         break;
//       case 'motorResponse':
//         motorResponseScore = value;
//         break;
//     }
//   }

//   // Widget buildScoreAnalysis() {
//   //   int totalScore = eyeOpeningScore + verbalResponseScore + motorResponseScore;
//   //   String analysis;

//   //   if (totalScore <= 4) {
//   //     analysis =
//   //         'Score de 3 ou 4 : environ 7% de bonne récupération. Environ 87% de mortalité.';
//   //   } else if (totalScore <= 7) {
//   //     analysis =
//   //         'Score de 5 à 7 : environ 34% de bonne récupération. Environ 53% de mortalité.';
//   //   } else if (totalScore <= 10) {
//   //     analysis =
//   //         'Score de 8 à 10 : environ 68% de bonne récupération. Environ 27% de mortalité.';
//   //   } else {
//   //     analysis =
//   //         'Score supérieur à 10 : environ 82% de bonne récupération. Environ 12% de mortalité.';
//   //   }

//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Text(
//   //         'Score final: $totalScore',
//   //         style: TextStyle(
// //fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
//   //       ),
//   //       SizedBox(height: 8),
//   //       Text(
//   //         'Analyse:',
//   //         style: TextStyle(
// //fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
//   //       ),
//   //       Text(
//   //         analysis,
//   //         style: TextStyle(
// //fontFamily: 'TimesNewRoman',fontSize: 16),
//   //       ),
//   //     ],
//   //   );
//   // }
//   Widget buildScoreAnalysis() {
//     int totalScore = eyeOpeningScore + verbalResponseScore + motorResponseScore;
//     String analysis;

//     if (totalScore <= 4) {
//       analysis =
//           'Score de 3 ou 4 : environ 7% de bonne récupération. Environ 87% de mortalité.';
//     } else if (totalScore <= 7) {
//       analysis =
//           'Score de 5 à 7 : environ 34% de bonne récupération. Environ 53% de mortalité.';
//     } else if (totalScore <= 10) {
//       analysis =
//           'Score de 8 à 10 : environ 68% de bonne récupération. Environ 27% de mortalité.';
//     } else {
//       analysis =
//           'Score supérieur à 10 : environ 82% de bonne récupération. Environ 12% de mortalité.';
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Score final: $totalScore',
//           style: const TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'Analyse:',
//           style: TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           "Score de 3 ou 4 : environ 7% de bonne récupération.",
//           style: TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60)),
//         ),
//         Text("- Environ 87% de mortalité.",
//             style:
//                 TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60))),
//         Text(
//           "Score de 5 à 7 : environ 34% de bonne récupération.",
//           style: TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60)),
//         ),
//         Text("- Environ 53% de mortalité..",
//             style:
//                 TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60))),
//         Text(
//           "Score de 8 à 10 : environ 68% de bonne récupération.",
//           style: TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60)),
//         ),
//         Text("- Environ 27% de mortalité.",
//             style:
//                 TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60))),
//         Text(
//           "Score supérieur à 10 : environ 82% de bonne récupération.",
//           style: TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60)),
//         ),
//         Text("- Environ 12% de mortalité.",
//             style:
//                 TextStyle(
// fontFamily: 'TimesNewRoman',fontSize: 14, color: Colors.black.withOpacity(0.60))),
//       ],
//     );
//   }
// }

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
      appBar: AppBar(
        title: const Text(
          'Glasgow Coma Scale',
          style: TextStyle(fontFamily: 'TimesNewRoman'),
        ),
        centerTitle: true,
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
                        "Le score Glasgow est la classification pronostique des comas traumatiques la plus utilisée dans le monde",
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
          ],
        ),
      ),
    );
  }

  List<Widget> buildEyeOpeningOptions() {
    return [
      RadioListTile<int>(
        title: const Text('Spontanée'),
        value: 4,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      RadioListTile<int>(
        title: const Text('À la demande verbale'),
        value: 3,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      RadioListTile<int>(
        title: const Text('À la douleur'),
        value: 2,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
      RadioListTile<int>(
        title: const Text('Nulle'),
        value: 1,
        groupValue: eyeOpeningScore,
        onChanged: (value) => setState(() => updateScore(value!, 'eyeOpening')),
      ),
    ];
  }

  List<Widget> buildVerbalResponseOptions() {
    return [
      RadioListTile<int>(
        title: const Text('Appropriée, orientée'),
        value: 5,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        title: const Text('Confuse'),
        value: 4,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        title: const Text('Incohérente'),
        value: 3,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        title: const Text('Incompréhensible'),
        value: 2,
        groupValue: verbalResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'verbalResponse')),
      ),
      RadioListTile<int>(
        title: const Text('Nulle'),
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
        title: const Text('Obéissance aux ordres verbaux'),
        value: 6,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        title: const Text('Réaction orientée à la douleur'),
        value: 5,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        title: const Text('Réaction non orientée à la douleur'),
        value: 4,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        title: const Text('À type de décortication'),
        value: 3,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        title: const Text('À type de décérébration'),
        value: 2,
        groupValue: motorResponseScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'motorResponse')),
      ),
      RadioListTile<int>(
        title: const Text('Nulle'),
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
          'Score final: $totalScore',
          style: const TextStyle(
            fontFamily: 'TimesNewRoman',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Analyse:',
          style: TextStyle(
            fontFamily: 'TimesNewRoman',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        buildAnalysisText(totalScore),
      ],
    );
  }

  Widget buildAnalysisText(int totalScore) {
    String analysis;
    if (totalScore <= 4) {
      analysis =
          'Score de 3 ou 4 : environ 7% de bonne récupération.\n- Environ 87% de mortalité.';
    } else if (totalScore <= 7) {
      analysis =
          'Score de 5 à 7 : environ 34% de bonne récupération.\n- Environ 53% de mortalité.';
    } else if (totalScore <= 10) {
      analysis =
          'Score de 8 à 10 : environ 68% de bonne récupération.\n- Environ 27% de mortalité.';
    } else if (totalScore <= 12) {
      analysis =
          'Score de 11 à 12 : environ 87% de bonne récupération.\n- Environ 7% de mortalité.';
    } else if (totalScore <= 15) {
      analysis =
          'Score de 13 à 15 : environ 87% de bonne récupération.\n- Environ 7% de mortalité.';
    } else {
      analysis = 'Score non valide.';
    }

    return Text(
      analysis,
      style: TextStyle(
        fontFamily: 'TimesNewRoman',
        fontSize: 14,
        color: Colors.black.withOpacity(0.60),
      ),
    );
  }
}

