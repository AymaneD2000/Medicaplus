import 'package:flutter/material.dart';

class AppgarHomePage extends StatefulWidget {
  const AppgarHomePage({super.key});

  @override
  _AppgarHomePageState createState() => _AppgarHomePageState();
}

class _AppgarHomePageState extends State<AppgarHomePage> {
  int frequenceCardiaqueScore = 0;
  int mouvementVespirationScore = 0;
  int tonusMusculaireScore = 0;
  int reactiviterScore = 0;
  int colorationScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
        'Score Apgar',
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
                        "Le score d'Apgar est une méthode globale d'évaluation de l'état de conscience. Il est égale à la somme des scores de trois items coté de 3 à 15.",
                        style:
                        TextStyle(
                          //fontFamily: 'TimesNewRoman',
                          fontSize: 17,
                          // fontFamily: 'TimesNewRoman',
                          color: Colors.black,
                        ),
                      ),
            const SizedBox(height: 16),
            buildfrequenceCardiaqueCard(),
            const SizedBox(height: 16),
            buildmouvementVespirationCard(),
            const SizedBox(height: 16),
            buildtonusMusculaireCard(),
            const SizedBox(height: 16),
            buildreactiviterCard(),
            const SizedBox(height: 16),
            buildcolorationCard(),
            const SizedBox(height: 16),
            buildScoreAnalysis(),
          ],
        ),
      ),
    );
  }

  Widget buildfrequenceCardiaqueCard() {
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
              'Fréquence cardiaque',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildfrequenceCardiaqueOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$frequenceCardiaqueScore /3",
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

  Widget buildmouvementVespirationCard() {
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
              'Mouvements respiratoires',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildmouvementVespirationOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$mouvementVespirationScore /3",
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

  Widget buildtonusMusculaireCard() {
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
              'Tonus musculaire',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildtonusMusculaireOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$tonusMusculaireScore /3",
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

  Widget buildreactiviterCard() {
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
              'Réactivité réflexe',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildreactiviterOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$tonusMusculaireScore /3",
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

  Widget buildcolorationCard() {
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
              'Coloration',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildcolorationOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$tonusMusculaireScore /3",
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

  List<Widget> buildfrequenceCardiaqueOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('<80/min'),
        value: 0,
        groupValue: frequenceCardiaqueScore,
        onChanged: (value) => setState(() => updateScore(value!, 'frequenceCardiaque')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('80-100/min'),
        value: 1,
        groupValue: frequenceCardiaqueScore,
        onChanged: (value) => setState(() => updateScore(value!, 'frequenceCardiaque')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('>100/min'),
        value: 2,
        groupValue: frequenceCardiaqueScore,
        onChanged: (value) => setState(() => updateScore(value!, 'frequenceCardiaque')),
      )
    ];
  }

  List<Widget> buildmouvementVespirationOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Absente'),
        value: 0,
        groupValue: mouvementVespirationScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'mouvementVespiration')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Lente, irréguliere'),
        value: 1,
        groupValue: mouvementVespirationScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'mouvementVespiration')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Normale'),
        value: 2,
        groupValue: mouvementVespirationScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'mouvementVespiration')),
      )
    ];
  }

  List<Widget> buildtonusMusculaireOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Hypotonie globale'),
        value: 0,
        groupValue: tonusMusculaireScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'tonusMusculaire')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Léger tonus en flexion'),
        value: 1,
        groupValue: tonusMusculaireScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'tonusMusculaire')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Mouvements actifs'),
        value: 2,
        groupValue: tonusMusculaireScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'tonusMusculaire')),
      ),
    ];
  }

  List<Widget> buildreactiviterOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Nulle'),
        value: 0,
        groupValue: tonusMusculaireScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'reactiviter')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Grimaces'),
        value: 1,
        groupValue: tonusMusculaireScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'reactiviter')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Vive'),
        value: 2,
        groupValue: tonusMusculaireScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'reactiviter')),
      ),
    ];
  }

  List<Widget> buildcolorationOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Cyanose ou paleur'),
        value: 0,
        groupValue: colorationScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'coloration')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Corps rose et extrémités cyanosées'),
        value: 1,
        groupValue: tonusMusculaireScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'coloration')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Totalement rose'),
        value: 2,
        groupValue: tonusMusculaireScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'coloration')),
      ),
    ];
  }

  void updateScore(int value, String category) {
    setState(() {
      switch (category) {
        case 'frequenceCardiaque':
          frequenceCardiaqueScore = value;
          break;
        case 'mouvementVespiration':
          mouvementVespirationScore = value;
          break;
        case 'tonusMusculaire':
          tonusMusculaireScore = value;
          break;
        case 'reactiviter':
          reactiviterScore = value;
          break;
        case 'coloration':
         colorationScore = value;
         break;
      }
    });
  }

  Widget buildScoreAnalysis() {
    int totalScore = frequenceCardiaqueScore + mouvementVespirationScore + tonusMusculaireScore + reactiviterScore + colorationScore;

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
    if(frequenceCardiaqueScore != 0 && tonusMusculaireScore !=0 && mouvementVespirationScore != 0){
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
                        color: Color(0xFFF39201),
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

