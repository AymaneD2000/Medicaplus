import 'package:flutter/material.dart';

class IMCCalculator extends StatefulWidget {
  const IMCCalculator({super.key});

  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _imc = 0.0;
  String interpretation = "";
  String _selectedUnit = 'm';
  Text intreprete = const Text("");

  String imcvalue(double imc){
    return "Votre IMC est ${imc.toStringAsFixed(2)}";
  }

  String imcValue = "";

  void _calculateIMC() {
    //final t = _controller.text.replaceAll(RegExp(','),'.');
    
    if(_weightController.text.isNotEmpty && _heightController.text.isNotEmpty){
    double weight = double.parse(_weightController.text.replaceAll(RegExp(','),'.'));
    double height = double.parse(_heightController.text.replaceAll(RegExp(','),'.'));
    if(_selectedUnit == 'm'){
      height = height * 100;
    }
    setState(() {
      _imc = weight / (height * height);
      print("this is imc");
      print(_imc);
      if(_imc.isInfinite || _imc.isNaN || weight == 0 || height ==0 || (weight == 1 && height == 1)){
        imcValue = "";
        interpretation = "Merci de renseignez des valeurs correctes";
        intreprete = Text(
              textAlign: TextAlign.center,
                      interpretation,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    );
      }else if(_imc < 16){
        imcValue = "Votre IMC est ${_imc.toStringAsFixed(2)}";
        interpretation = "Anorexie/dénutrition";
        intreprete = Text(
              textAlign: TextAlign.center,
                      interpretation,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF02B1EC),
                      ),
                    );
      }else if(_imc >16.5 && _imc <=18.5){
        imcValue = "Votre IMC est ${_imc.toStringAsFixed(2)}";
        interpretation = "Maigreur";
        intreprete = Text(
              textAlign: TextAlign.center,
                      interpretation,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF02B1EC),
                      ),
                    );
      } else if(_imc > 18.5 && _imc <= 25){
        imcValue = "Votre IMC est ${_imc.toStringAsFixed(2)}";
        interpretation = "Corpulence normal";
        intreprete = Text(
              textAlign: TextAlign.center,
                      interpretation,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    );
      }else if(_imc > 25 && _imc <=30){
        imcValue = "Votre IMC est ${_imc.toStringAsFixed(2)}";
        interpretation = "Surpoid";
        intreprete = Text(
              textAlign: TextAlign.center,
                      interpretation,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB1CA39),
                      ),
                    );
      }else if(_imc > 30 && _imc <= 35){
        imcValue = "Votre IMC est ${_imc.toStringAsFixed(2)}";
        interpretation = "Obésité modérée";
        intreprete = Text(
              textAlign: TextAlign.center,
                      interpretation,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF39201),
                      ),
                    );
      }else if(_imc >35 && _imc <= 40){
        imcValue = "Votre IMC est ${_imc.toStringAsFixed(2)}";
        interpretation = "Obésité sévère";
        intreprete = Text(
              textAlign: TextAlign.center,
                      interpretation,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEB5C41),
                      ),
                    );
      }else if(_imc > 0){
        imcValue = "Votre IMC est ${_imc.toStringAsFixed(2)}";
        interpretation = "Obésité morbide ou massive";
        intreprete = Text(
              textAlign: TextAlign.center,
                      interpretation,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE70516),
                      ),
        );
      }
    });
    }
  }

  void _resetFields() {
    _weightController.clear();
    _heightController.clear();
    setState(() {
      _imc = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('IMC'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
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
                      const SizedBox(height: 8),
                      const Text(
                        "L\'indice de masse corporelle (IMC), est une mesure utilisée pour estimer la corpulance d'une personne en fonction de son poids et de sa taille.",
                        style:
                        TextStyle(
                          //fontFamily: 'TimesNewRoman',
                          fontSize: 17,
                          // fontFamily: 'TimesNewRoman',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //_buildInputField('Poids', 'KG', _weightController),
                          //_buildInputField('Taille', 'CM', _heightController),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                    color: Color.fromARGB(125, 50, 204, 204),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all()),
                                  width: MediaQuery.of(context).size.width*0.2,
                                  height: 45,
                                  child: TextField(
                                    textAlign: TextAlign.start,
                                    controller: _weightController,
                                    onSubmitted: (s)async{
                                      _calculateIMC();
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "en Kg",
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Taille :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  fontFamily: 'TimesNewRoman',fontSize: 18),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(125, 50, 204, 204),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all()),
                                  width: MediaQuery.of(context).size.width*0.2,
                                  height: 45,
                                  child: TextField(
                                    onSubmitted: (s)async{
                                      //await tester.testTextInput.receiveAction(TextInputAction.done);
                                      _calculateIMC();
                                    },
                                    textAlign: TextAlign.start,
                                    controller: _heightController,
                                    decoration: InputDecoration(
                                      hintText: _selectedUnit == 'm'? 'm':'cm',
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: false,
                      //       onChanged: (bool? value) {},
                      //     ),
                      //     const Text('Surprise'),
                      //   ],
                      // ),
                      // const SizedBox(height: 16.0),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: _calculateIMC,
                      //       style:
                      //           ElevatedButton.styleFrom(foregroundColor: Colors.grey),
                      //       child: Text('CALCULER L\'IMC'),
                      //     ),
                      //     ElevatedButton(
                      //       onPressed: _resetFields,
                      //       style:
                      //           ElevatedButton.styleFrom(foregroundColor: Colors.grey),
                      //       child: Text('RAZ'),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 16.0),
                      // const Text(
                      //   'Résultat:',
                      //   style: TextStyle(
                      //     fontFamily: 'TimesNewRoman',fontWeight: FontWeight.bold),
                      // ),
                      // const SizedBox(height: 8.0),
                      // Text('Votre IMC est $_imc'),
                      // const SizedBox(height: 16.0),
                      // const Text(
                      //   'Pour rappel (selon l\'OMS), un résultat:',
                      //   style: TextStyle(
                      //     fontFamily: 'TimesNewRoman',fontWeight: FontWeight.bold),
                      // ),
                      // const Text('- Inférieur à 16 correspond à "Anorexie/dénutrition".'),
                      // const Text('- Entre 16,5 et 18 correspond à "Maigreur".'),
                      // const Text('- Entre 18,5 et 25 correspond à "Normal".'),
                      // const Text('- Entre 25 et 30 correspond à "Surpoid".'),
                      // const Text('- Entre 30 et 35 correspond à "Obésité modérée".'),
                      // const Text('- Entre 35 et 40 correspond à "Obésité sévère".'),
                      // const Text('- Supérieur à 40 correspond à "Obésité morbide".'),
                      // const SizedBox(height: 16.0),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: const Text(
                      //     'Plus d\'infos sur : www.calculersonimc.fr',
                      //     style: TextStyle(
                      //     fontFamily: 'TimesNewRoman',
                      //       color: Colors.blue,
                      //       decoration: TextDecoration.underline,
                      //     ),
                      //   ),
                      // ),
                      Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff33CCCC),
                      borderRadius:  BorderRadius.circular(15)),
                    child: DropdownButton<String>(
                      underline: Container(),
                      alignment: Alignment.center,
                      borderRadius: BorderRadius.circular(20),
                      value: _selectedUnit,
                      items: <String>['m', 'cm'].map((String value) {
                        return DropdownMenuItem<String>(
                          alignment: Alignment.centerRight,
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedUnit = newValue!;
                        });
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _calculateIMC,
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff33CCCC))),
                      child: const Text('Calculer', style: TextStyle(
                            fontFamily: 'TimesNewRoman',color: Colors.black, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff33CCCC))),
                      onPressed:(){
                        setState(() {
                        _heightController.clear();
                        _weightController.clear();
                        _imc = 0;
                        intreprete = Text("");
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
                  'Indice de masse corporelle (IMC)',
                  style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              if (_imc != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    imcValue,
                      style: const TextStyle(
                          fontFamily: 'TimesNewRoman',
                        fontSize: 28,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              // if (_glycemiaGpl != null && _glycemiaMmol != null)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         _glycemiaGpl!.toStringAsFixed(2),
              //         style: const TextStyle(
              //             fontFamily: 'TimesNewRoman',
              //           fontSize: 28,
              //           fontStyle: FontStyle.italic,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black,
              //         ),
              //       ),
              //       const SizedBox(width: 8),
              //       const Text(
              //         'mg/dL',
              //         style: TextStyle(
              //           fontStyle: FontStyle.italic,
              //         fontFamily: 'TimesNewRoman',
              //           fontSize: 18,
              //           color: Colors.black,
              //         ),
              //       ),
              //       const SizedBox(width: 16),
              //       Text(
              //         _glycemiaMmol!.toStringAsFixed(2),
              //         style: const TextStyle(
              //           fontFamily: 'TimesNewRoman',
              //           fontSize: 28,
              //           fontStyle: FontStyle.italic,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black,
              //         ),
              //       ),
              //       const SizedBox(width: 8),
              //       const Text(
              //         'mmol/L',
              //         style: TextStyle(
              //           fontFamily: 'TimesNewRoman',
              //           fontSize: 18,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ],
              //   ),
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
                'Références :',
                style: TextStyle(
                fontFamily: 'TimesNewRoman',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Formule : IMC = Poids (en Kg) / Taille (m) au carrée",
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
                Positioned(
            bottom: _imc == 0? MediaQuery.of(context).size.height*0.45:MediaQuery.of(context).size.height*0.52,
            left: MediaQuery.of(context).size.width*0.08,
            child: Image.asset("assets/Interface/weight-scale.png", height: 60,width: 50,)),
            Positioned(
            bottom: _imc == 0? MediaQuery.of(context).size.height*0.45:MediaQuery.of(context).size.height*0.52,
            right: MediaQuery.of(context).size.width*0.315,
            child: Image.asset("assets/Interface/hauteur.png", height: 60,width: 50,)),
              ],
            ),
          ),
    );
  }

  Widget _buildInputField(
      String label, String unit, TextEditingController controller) {
    return Column(
      children: [
        Text(label),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixText: unit,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
