import 'package:flutter/material.dart';

class PregnancyCalculatorScreen extends StatefulWidget {
  @override
  _PregnancyCalculatorScreenState createState() =>
      _PregnancyCalculatorScreenState();
}

class _PregnancyCalculatorScreenState
    extends State<PregnancyCalculatorScreen> {
  final _dateController = TextEditingController();
  String _selectedOption = 'Date du premier jour des dernières règles';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF7E1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Calendrier de grossesse',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Format: jj/mm/aaaa ou aaaa-mm-jj',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF4A90E2)),
                ),
              ),
              SizedBox(height: 20.0),
              _buildRadioOption(
                'Date du premier jour des dernières règles',
              ),
              _buildRadioOption('Date de conception'),
              _buildRadioOption('Date du terme théorique'),
              _buildRadioOption('Date échographie, datation'),
              if (_selectedOption == 'Date échographie, datation')
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'S.A.',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'J.',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implémentez la logique de calcul ici
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFF4A90E2),
                  ),
                  child: Text('Calculer'),
                ),
              ),
              SizedBox(height: 20.0),
              _buildResultField('Premier jour dernières règles :'),
              _buildResultField('Date conception :'),
              _buildResultField('Terme théorique :', isAdjustable: true),
              _buildResultField('Terme actuel :', isAdjustable: true),
              _buildResultField('Post terme :'),
              SizedBox(height: 20.0),
              Text(
                '- Échographies -',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
              SizedBox(height: 10.0),
              _buildResultField('N°1 :', isAdjustable: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    return ListTile(
      title: Text(title),
      leading: Radio<String>(
        value: title,
        groupValue: _selectedOption,
        onChanged: (value) {
          setState(() {
            _selectedOption = value!;
          });
        },
        activeColor: Color(0xFF4A90E2),
      ),
    );
  }

  Widget _buildResultField(String label, {bool isAdjustable = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (isAdjustable) ...[
            SizedBox(width: 10.0),
            Text('+/-'),
            SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
