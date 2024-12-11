import 'package:flutter/material.dart';

class ChildupPage extends StatefulWidget {
  const ChildupPage({super.key});

  @override
  _ChildupPageState createState() => _ChildupPageState();
}

class _ChildupPageState extends State<ChildupPage> {
  int asciteScore = 0;
  int encephalotapieScore = 0;
  int tauxdeprothrombineScore = 0;
  int albumineScore = 0;
  int bilirubineScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
        'Score de Child Pugh',
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
                        "Score d'évaluation de la sévérité de la cirrhose. En cas de cirrhose compensée, la plupart des malades sont en classe A. La cirrhose décompensée correspond à une classe B ou C. Ce score ne prend pas en compte certaines complications comme l'hémorragie digestive ou carcinome hépatocellulaire (CHC)  ",
                        style:
                        TextStyle(
                          //fontFamily: 'TimesNewRoman',
                          fontSize: 17,
                          // fontFamily: 'TimesNewRoman',
                          color: Colors.black,
                        ),
                      ),
            const SizedBox(height: 16),
            buildasciteCard(),
            const SizedBox(height: 16),
            buildencephalotapieCard(),
            const SizedBox(height: 16),
            buildtauxdeprothrombineCard(),
            const SizedBox(height: 16),
            buildalbumineCard(),
            const SizedBox(height: 16),
            buildbilirubineCard(),
            const SizedBox(height: 16),
            buildScoreAnalysis(),
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
                "Grade de encéphalopathie",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'TimesNewRoman',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildClassRow("I", "Trouble de l'attention et du caratere (euphorie, anxiété)."),
              _buildClassRow("II", "Léthargie et apathie, désorientation dans le temps ou dans l'espace, comportement inapproprié."),
              _buildClassRow("III", "Somnolence marquée, confusion, désorientation temporo-spatiale"),
              _buildClassRow("IV", 'Coma.'), 
          ],
        ),
      ),
    ),
          ],
        ),
      ),
    );
  }

  Widget buildasciteCard() {
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
              'Ascite',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildasciteOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$asciteScore /3",
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

  Widget buildencephalotapieCard() {
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
              'Encéphalopathie (grade)',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildencephalotapieOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$encephalotapieScore /3",
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

  Widget buildtauxdeprothrombineCard() {
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
              'Taux de prothrombine (%)',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildtauxdeprothrombineOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$tauxdeprothrombineScore /3",
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

  Widget buildalbumineCard() {
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
              'Albumine (g/L)',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildalbumineOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$tauxdeprothrombineScore /3",
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

  Widget buildbilirubineCard() {
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
              'Bilirubine (mmol/L)',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...buildbilirubineOptions(),
            Container(
              alignment: Alignment.center,
              child: Text("$tauxdeprothrombineScore /3",
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

  List<Widget> buildasciteOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Absente'),
        value: 1,
        groupValue: asciteScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ascite')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Modérée'),
        value: 2,
        groupValue: asciteScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ascite')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Volumineuse'),
        value: 3,
        groupValue: asciteScore,
        onChanged: (value) => setState(() => updateScore(value!, 'ascite')),
      )
    ];
  }

  List<Widget> buildencephalotapieOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Absente'),
        value: 1,
        groupValue: encephalotapieScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'encephalotapie')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Grade I ou II'),
        value: 2,
        groupValue: encephalotapieScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'encephalotapie')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Grade III ou IV'),
        value: 3,
        groupValue: encephalotapieScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'encephalotapie')),
      )
    ];
  }

  List<Widget> buildtauxdeprothrombineOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('> 50'),
        value: 1,
        groupValue: tauxdeprothrombineScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'tauxdeprothrombine')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('40 à 50'),
        value: 2,
        groupValue: tauxdeprothrombineScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'tauxdeprothrombine')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('< 40'),
        value: 3,
        groupValue: tauxdeprothrombineScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'tauxdeprothrombine')),
      ),
    ];
  }

  List<Widget> buildalbumineOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('> 35'),
        value: 1,
        groupValue: albumineScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'albumine')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('28 à 35'),
        value: 2,
        groupValue: albumineScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'albumine')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('< 28'),
        value: 3,
        groupValue: albumineScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'albumine')),
      ),
    ];
  }

  List<Widget> buildbilirubineOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('< 35'),
        value: 1,
        groupValue: bilirubineScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'bilirubine')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('35 à 50'),
        value: 2,
        groupValue: bilirubineScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'bilirubine')),
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('> 50'),
        value: 3,
        groupValue: bilirubineScore,
        onChanged: (value) =>
            setState(() => updateScore(value!, 'bilirubine')),
      ),
    ];
  }

  void updateScore(int value, String category) {
    setState(() {
      switch (category) {
        case 'ascite':
          asciteScore = value;
          break;
        case 'encephalotapie':
          encephalotapieScore = value;
          break;
        case 'tauxdeprothrombine':
          tauxdeprothrombineScore = value;
          break;
        case 'albumine':
          albumineScore = value;
          break;
        case 'bilirubine':
         bilirubineScore = value;
         break;
      }
    });
  }

  Widget buildScoreAnalysis() {
    int totalScore = asciteScore + encephalotapieScore + tauxdeprothrombineScore + albumineScore + bilirubineScore;

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
    if(asciteScore != 0 && tauxdeprothrombineScore !=0 && encephalotapieScore != 0){
      if (totalScore >=5 && totalScore <=6) {
      analysis =
          'Child Pugh A';
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
    } else if (totalScore >= 7 && totalScore <=9) {
      
      analysis =
          'Child Pugh B';
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
    } else if (totalScore >= 10 && totalScore <=15) {
      analysis =
          'Child Pugh C';
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
    } else {
      analysis = 'Score non valide.';
      text = const Text("");
    }
    }

    return text;
  }

  Widget _buildClassRow(String number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number : ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff33CCCC),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}

