import 'package:flutter/material.dart';

class IMCCalculator extends StatefulWidget {
  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _imc = 0.0;

  void _calculateIMC() {
    final double weight = double.parse(_weightController.text);
    final double height = double.parse(_heightController.text) / 100;
    setState(() {
      _imc = weight / (height * height);
    });
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
      appBar: AppBar(
        title: Text('IMC'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInputField('Poids', 'KG', _weightController),
                  _buildInputField('Taille', 'CM', _heightController),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                  ),
                  Text('Surprise'),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _calculateIMC,
                    child: Text('CALCULER L\'IMC'),
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.grey),
                  ),
                  ElevatedButton(
                    onPressed: _resetFields,
                    child: Text('RAZ'),
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Résultat:',
                style: TextStyle(
fontFamily: 'TimesNewRoman',fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('Votre IMC est $_imc'),
              SizedBox(height: 16.0),
              Text(
                'Pour rappel (selon l\'OMS), un résultat:',
                style: TextStyle(
fontFamily: 'TimesNewRoman',fontWeight: FontWeight.bold),
              ),
              Text('- Inférieur à 16 correspond à "Anorexie/dénutrition".'),
              Text('- Entre 16,5 et 18 correspond à "Maigreur".'),
              Text('- Entre 18,5 et 25 correspond à "Normal".'),
              Text('- Entre 25 et 30 correspond à "Surpoid".'),
              Text('- Entre 30 et 35 correspond à "Obésité modérée".'),
              Text('- Entre 35 et 40 correspond à "Obésité sévère".'),
              Text('- Supérieur à 40 correspond à "Obésité morbide".'),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Plus d\'infos sur : www.calculersonimc.fr',
                  style: TextStyle(
fontFamily: 'TimesNewRoman',
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, String unit, TextEditingController controller) {
    return Column(
      children: [
        Text(label),
        Container(
          width: 100,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixText: unit,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
