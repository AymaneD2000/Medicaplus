import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ParacetamolScreen extends StatefulWidget {
  const ParacetamolScreen({super.key});

  @override
  _ParacetamolScreenState createState() => _ParacetamolScreenState();
}

class _ParacetamolScreenState extends State<ParacetamolScreen> {
  final TextEditingController _controller = TextEditingController();
  int personne = 0;
  double dose = 0;
  double? _glycemiaGpl;
  String interpretation = "";
  Text intreprete = const Text("");
  double? _glycemiaMmol;
  
  List<Widget> buildEyeOpeningOptions() {
    return [
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Nouveau-né'),
        value: 1,
        groupValue: personne,
        onChanged: (value){
          setState(() {
            personne = value!;
          });
        },
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Enfant de moins de 1 mois'),
        value: 2,
        groupValue: personne,
        onChanged: (value){
          setState(() {
            personne = value!;
          });
        },
      ),
      RadioListTile<int>(
        activeColor: const Color(0xff33CCCC),
        title: const Text('Enfant de 1 mois ou plus'),
        value: 3,
        groupValue: personne,
        onChanged: (value){
          setState(() {
            personne = value!;
          });
        },
      )
    ];
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
              'Age',
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

  void _calculatePoids() {
    final t = _controller.text.replaceAll(RegExp(','),'.');
    print(t);
    setState(() {
      double paracetamol = double.tryParse(t) ?? 0.0;
      if (personne != 0) {
        if(personne == 1){
          dose = paracetamol * 0.75;
          intreprete = Text("");
        }
        else if(personne == 2)
        {
         dose = paracetamol; 
         intreprete = Text("");
        }
        else if(personne == 3)
        {
          dose = paracetamol * 1.5;
          intreprete = Text("");
        }
        else{
          dose = 0;
          intreprete = Text("");
        }

        }else{
          interpretation = "Merci de selectionnez un age";
            intreprete = Text(
                textAlign: TextAlign.center,
                interpretation,
                style: const TextStyle(
                fontFamily: 'TimesNewRoman',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: Colors.red,
                ));
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
                child: Text(
                  'Paracetamol vers Glycémie Plasmatique Moyenne',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               buildEyeOpeningCard(),
              const SizedBox(height: 16),
              // Center(
              //   child: Image.asset('assets/images/diabete.gif',scale: 6,),
              // ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Poids :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    fontFamily: 'TimesNewRoman',fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(125, 50, 204, 204),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all()),
                                  width: MediaQuery.of(context).size.width*0.4,
                                  height: 45,
                                  child: TextField(
                                    onSubmitted: (s)async{
                                      //await tester.testTextInput.receiveAction(TextInputAction.done);
                  
                                    },
                                    textAlign: TextAlign.start,
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      hintText: 'en Kg',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                  // Expanded(
                  //   child: TextField(
                  //     textAlign: TextAlign.center,
                  //     controller: _controller,
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 4)),
                  //       contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  //     ),
                  //     keyboardType: TextInputType.number,
                  //   ),
                  // ),
                  // const SizedBox(width: 8),
                  // Container(
                  //   // /padding: EdgeInsets.all(4),
                  //   width: MediaQuery.of(context).size.width*0.15,
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xff33CCCC),
                  //     borderRadius:  BorderRadius.circular(15),
                  //     border: Border.all()),
                  //   child: MaterialButton(
                  //     child: const Text("%", style: TextStyle(fontWeight: FontWeight.bold),),
                  //     onPressed: () {
                  //     },
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: _calculatePoids,
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff33CCCC))),
                      child: const Text('Calculer', style: TextStyle(
                            fontFamily: 'TimesNewRoman',color: Colors.black, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Center(
                    child: ElevatedButton(
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff33CCCC))),
                      onPressed:(){
                        setState(() {
                          _controller.clear();
                          personne = 0;
                        dose = 0;
                        });
                      },
                      child: const Text('Reprendre', style: TextStyle(
                      fontFamily: 'TimesNewRoman',color: Colors.black, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'La dose',
                  style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (dose !=0 && _controller.text != "")
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dose.toStringAsFixed(2),
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 28,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ml',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      fontFamily: 'TimesNewRoman',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              Center(child: intreprete),
              const SizedBox(height: 16),
              const Text(
                'Références :',
                style: TextStyle(
                fontFamily: 'TimesNewRoman',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                """Nouveau-né : 7,5 mg/kg (0,75 ml/kg) 3 ou 4 fois par jour (max. 30 mg/kg par jour),
Enfant de moins de 1 mois : 10 mg/kg 3 ou 4 fois par jour (max. 40 mg/kg par jour),
Enfant de 1 mois et plus : 15 mg/kg 3 ou 4 fois par jour (max. 60 mg/kg par jour),
Adulte : 1 g 3 ou 4 fois par jour (max. 4 g par jour)
                """,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          Positioned(
            bottom: dose == 0? MediaQuery.of(context).size.height*0.55:MediaQuery.of(context).size.height*0.60,
            left: MediaQuery.of(context).size.width*0.16,
            child: Image.asset("assets/Interface/weight-scale.png", height: 60,width: 50,)),
            ],
          )
        ),
      ),
    );
  }
}