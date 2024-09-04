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
        title: const Text('IMC'),
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
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                  ),
                  const Text('Surprise'),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _calculateIMC,
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.grey),
                    child: Text('CALCULER L\'IMC'),
                  ),
                  ElevatedButton(
                    onPressed: _resetFields,
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.grey),
                    child: Text('RAZ'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Résultat:',
                style: TextStyle(
fontFamily: 'TimesNewRoman',fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text('Votre IMC est $_imc'),
              const SizedBox(height: 16.0),
              const Text(
                'Pour rappel (selon l\'OMS), un résultat:',
                style: TextStyle(
fontFamily: 'TimesNewRoman',fontWeight: FontWeight.bold),
              ),
              const Text('- Inférieur à 16 correspond à "Anorexie/dénutrition".'),
              const Text('- Entre 16,5 et 18 correspond à "Maigreur".'),
              const Text('- Entre 18,5 et 25 correspond à "Normal".'),
              const Text('- Entre 25 et 30 correspond à "Surpoid".'),
              const Text('- Entre 30 et 35 correspond à "Obésité modérée".'),
              const Text('- Entre 35 et 40 correspond à "Obésité sévère".'),
              const Text('- Supérieur à 40 correspond à "Obésité morbide".'),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {},
                child: const Text(
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
