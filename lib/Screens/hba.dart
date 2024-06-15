import 'package:flutter/material.dart';


class HbA1cScreen extends StatefulWidget {
  @override
  _HbA1cScreenState createState() => _HbA1cScreenState();
}

class _HbA1cScreenState extends State<HbA1cScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedUnit = '%';
  double? _glycemiaGpl;
  double? _glycemiaMmol;

  void _calculateGlycemia() {
    setState(() {
      double hbA1c = double.tryParse(_controller.text) ?? 0.0;
      if (_selectedUnit == '%') {
        _glycemiaGpl = hbA1c * 1.59 - 2.59;
        _glycemiaMmol = _glycemiaGpl! * 5.5;
      } else {
        _glycemiaGpl = hbA1c / 10.929;
        _glycemiaMmol = hbA1c / 1.098;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'HbA1c vers Glycémie Plasmatique Moyenne',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Icon(
                  Icons.medical_services,
                  size: 50,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'HbA1c :',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedUnit,
                    items: <String>['%', 'mmol/mol'].map((String value) {
                      return DropdownMenuItem<String>(
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
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _calculateGlycemia,
                  child: Text('Calculer'),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Glycémie plasmatique moyenne :',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 8),
              if (_glycemiaGpl != null && _glycemiaMmol != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _glycemiaGpl!.toStringAsFixed(4),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'g/l',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      _glycemiaMmol!.toStringAsFixed(4),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'mmol/l',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 16),
              Text(
                'Interprétation:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "L'hémoglobine glyquée (HbA1C) est le reflet de l'équilibre glycémique des trois derniers mois. "
                "Cette formule permet de faire le lien entre HbA1c et la glycémie plasmatique moyenne présente chez un patient.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Références:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Formule: Glycémie Moyenne = HbA1c (en %) x 1,59 - 2,59.\n"
                "David M. Nathan, Judith Kuenen, Rikke Borg et al.\n"
                "Translating the A1C Assay Into Estimated Average Glucose Values. Diabetes Care. 2008 Aug; 31(8): 1473–1478.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('[Racine]'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('[Alphabétique]'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('[Spécialités]'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}