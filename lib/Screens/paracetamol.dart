import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ParacetamolScreen extends StatefulWidget {
  const ParacetamolScreen({super.key});

  @override
  _ParacetamolScreenState createState() => _ParacetamolScreenState();
}

class _ParacetamolScreenState extends State<ParacetamolScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedUnit = '%';
  double? _glycemiaGpl;
  String interpretation = "";
  Text intreprete = const Text("");
  double? _glycemiaMmol;
  

  void _calculateGlycemia() {
    final t = _controller.text.replaceAll(RegExp(','),'.');
    print(t);
    setState(() {
      double paracetamol = double.tryParse(t) ?? 0.0;
      if (_selectedUnit == '%') {
        if(paracetamol >=2 && paracetamol<=20){
          _glycemiaMmol = paracetamol * 1.59 - 2.59;
        print("-----------------------------");
        print(_glycemiaMmol);
        _glycemiaGpl = _glycemiaMmol! / 0.055;
        if(paracetamol >= 2 && paracetamol < 4){
          setState(() {
            interpretation = "Hypo-Glycémie chronique\n Risque de pathologies hépatiques";
            intreprete = Text(
              textAlign: TextAlign.center,
                      interpretation,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    );
          });
        }
        // else if(paracetamol >= 4 && paracetamol <= 4.6){
        //   setState(() {
        //     interpretation = "Super Optimal";
        //     intreprete = Text(
        //         interpretation,
        //         style: TextStyle(
        //         fontFamily: 'TimesNewRoman',
        //           fontSize: 20,
        //           fontStyle: FontStyle.italic,
        //           color: Color(0xff056906),
        //         ),
        //       );
        //   });
        // }
        else if(paracetamol >= 4 && paracetamol <= 5.1)
        {
          setState(() {
            interpretation = "Optimal";
            intreprete = Text(
                interpretation,
                style: const TextStyle(
                fontFamily: 'TimesNewRoman',
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Color(0xff369736),
                ));
          });
        }
        else if(paracetamol >= 5.2 && paracetamol <= 5.7)
        {
          setState(() {
            interpretation = "Normal";
            intreprete = Text(
                interpretation,
                style: const TextStyle(
                fontFamily: 'TimesNewRoman',
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Color(0xff19FD05),
                ));
          });
        }
        else if(paracetamol >= 5.8 && paracetamol <= 6.4)
        {
          setState(() {
            interpretation = "Pré-Diabete\n Risque d'hyperglycémie";
            intreprete = Text(
                interpretation,
                style: const TextStyle(
                fontFamily: 'TimesNewRoman',
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Color(0xffFFFE06),
                ));
          });
        }
        else if(paracetamol >= 6.5 && paracetamol <= 7.1){
          setState(() {
            interpretation = "Diabete";
            intreprete = Text(
                interpretation,
                style: const TextStyle(
                fontFamily: 'TimesNewRoman',
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Color(0xffFF6501),
                ));
          });
        }
        else if(paracetamol >= 7.2 && paracetamol <= 9){
          setState(() {
            interpretation = "Diabetes sucré";
            intreprete = Text(
                interpretation,
                style: const TextStyle(
                fontFamily: 'TimesNewRoman',
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Color(0xffFE0000),
                ));
          });
        }else if(paracetamol >= 9.1 && paracetamol <= 20){
          setState(() {
            interpretation = "dangereux ou risque lever de complication";
            intreprete = Text(
                interpretation,
                style: const TextStyle(
                fontFamily: 'TimesNewRoman',
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Color(0xffC20000),
                ));
          });
        }
        else{

        }

        }else{
          interpretation = "Merci de renseignez un nombre entre 2% et 20%";
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
        
      } else {
        _glycemiaGpl = paracetamol / 10.929;
        _glycemiaMmol = paracetamol / 1.098;
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
              const SizedBox(height: 8),
              const Text(
                "L'hémoglobine glyquée (Paracetamol) est le reflet de l'équilibre glycémique des trois derniers mois. "
                "Cette formule permet de faire le lien entre Paracetamol et la glycémie plasmatique moyenne présente chez un patient.",
                style:
                TextStyle(
                  //fontFamily: 'TimesNewRoman',
                  fontSize: 17,
                  // fontFamily: 'TimesNewRoman',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // Center(
              //   child: Image.asset('assets/images/diabete.gif',scale: 6,),
              // ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Paracetamol :',
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
                                      _calculateGlycemia();
                                    },
                                    textAlign: TextAlign.start,
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      hintText: 'en %',
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
                      onPressed: _calculateGlycemia,
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
                        _glycemiaMmol = 0;
                        _glycemiaGpl = 0;
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
                  'Glycémie plasmatique moyenne',
                  style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (_glycemiaGpl != null && _glycemiaMmol != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _glycemiaGpl!.toStringAsFixed(2),
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
                      'mg/dL',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      fontFamily: 'TimesNewRoman',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _glycemiaMmol!.toStringAsFixed(2),
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
                      'mmol/L',
                      style: TextStyle(
                        fontFamily: 'TimesNewRoman',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Interprétation',
                  style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff33CCCC),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: intreprete),
              const SizedBox(height: 16),
              const Text(
                'Références:',
                style: TextStyle(
                fontFamily: 'TimesNewRoman',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Formule: Glycémie Moyenne = Paracetamol (en %) x 1,59 - 2,59.\n",
                style: TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}