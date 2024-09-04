// import 'package:flutter/material.dart';

// class PregnancyCalculatorScreen extends StatefulWidget {
//   @override
//   _PregnancyCalculatorScreenState createState() =>
//       _PregnancyCalculatorScreenState();
// }

// class _PregnancyCalculatorScreenState
//     extends State<PregnancyCalculatorScreen> {
//   final _dateController = TextEditingController();
//   String _selectedOption = 'Date du premier jour des dernières règles';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFF7E1),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Text(
//                   'Calendrier de grossesse',
//                   style: TextStyle(
//fontFamily: 'TimesNewRoman',
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF4A90E2),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               TextField(
//                 controller: _dateController,
//                 decoration: InputDecoration(
//                   labelText: 'Date',
//                   hintText: 'Format: jj/mm/aaaa ou aaaa-mm-jj',
//                   border: OutlineInputBorder(),
//                   suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF4A90E2)),
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               _buildRadioOption(
//                 'Date du premier jour des dernières règles',
//               ),
//               _buildRadioOption('Date de conception'),
//               _buildRadioOption('Date du terme théorique'),
//               _buildRadioOption('Date échographie, datation'),
//               if (_selectedOption == 'Date échographie, datation')
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'S.A.',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.0),
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'J.',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               SizedBox(height: 20.0),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Implémentez la logique de calcul ici
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Color(0xFF4A90E2),
//                   ),
//                   child: Text('Calculer'),
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               _buildResultField('Premier jour dernières règles :'),
//               _buildResultField('Date conception :'),
//               _buildResultField('Terme théorique :', isAdjustable: true),
//               _buildResultField('Terme actuel :', isAdjustable: true),
//               _buildResultField('Post terme :'),
//               SizedBox(height: 20.0),
//               Text(
//                 '- Échographies -',
//                 style: TextStyle(
//fontFamily: 'TimesNewRoman',
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF4A90E2),
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               _buildResultField('N°1 :', isAdjustable: true),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRadioOption(String title) {
//     return ListTile(
//       title: Text(title),
//       leading: Radio<String>(
//         value: title,
//         groupValue: _selectedOption,
//         onChanged: (value) {
//           setState(() {
//             _selectedOption = value!;
//           });
//         },
//         activeColor: Color(0xFF4A90E2),
//       ),
//     );
//   }

//   Widget _buildResultField(String label, {bool isAdjustable = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: label,
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           if (isAdjustable) ...[
//             SizedBox(width: 10.0),
//             Text('+/-'),
//             SizedBox(width: 10.0),
//             Expanded(
//               child: TextField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PregnancyCalculatorScreen extends StatefulWidget {
  const PregnancyCalculatorScreen({super.key});

  @override
  _PregnancyCalculatorScreenState createState() =>
      _PregnancyCalculatorScreenState();
}

class _PregnancyCalculatorScreenState
    extends State<PregnancyCalculatorScreen> {
  final _dateController = TextEditingController();
  final _weeksController = TextEditingController();
  final _daysController = TextEditingController();
  String _selectedOption = 'Date du premier jour des dernières règles';
  String _resultLMP = '';
  String _resultConception = '';
  String _resultEDD = '';
  String _resultCurrent = '';
  String _resultPostTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Calendrier de grossesse',
                  style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  hintText: 'Format: jj/mm/aaaa ou aaaa-mm-jj',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF4A90E2)),
                ),
              ),
              const SizedBox(height: 20.0),
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
                          controller: _weeksController,
                          decoration: const InputDecoration(
                            labelText: 'S.A.',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextField(
                          controller: _daysController,
                          decoration: const InputDecoration(
                            labelText: 'J.',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _calculateDates,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF4A90E2),
                  ),
                  child: const Text('Calculer'),
                ),
              ),
              const SizedBox(height: 20.0),
              _buildResultField('Premier jour dernières règles :', result: _resultLMP),
              _buildResultField('Date conception :', result: _resultConception),
              _buildResultField('Terme théorique :', result: _resultEDD, isAdjustable: true),
              _buildResultField('Terme actuel :', result: _resultCurrent, isAdjustable: true),
              _buildResultField('Post terme :', result: _resultPostTerm),
              const SizedBox(height: 20.0),
              const Text(
                '- Échographies -',
                style: TextStyle(
                  fontFamily: 'TimesNewRoman',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
              const SizedBox(height: 10.0),
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
        activeColor: const Color(0xFF4A90E2),
      ),
    );
  }

  Widget _buildResultField(String label, {String result = '', bool isAdjustable = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              controller: TextEditingController(text: result),
              readOnly: !isAdjustable,
            ),
          ),
          if (isAdjustable) ...[
            const SizedBox(width: 10.0),
            const Text('+/-'),
            const SizedBox(width: 10.0),
            const Expanded(
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

  void _calculateDates() {
    final dateInput = _dateController.text;
    DateTime? baseDate;

    try {
      if (dateInput.contains('/')) {
        baseDate = DateFormat('dd/MM/yyyy').parseStrict(dateInput);
      } else {
        baseDate = DateFormat('yyyy-MM-dd').parseStrict(dateInput);
      }
    } catch (e) {
      _showErrorDialog('Date invalide');
      return;
    }

    DateTime lmpDate, conceptionDate, eddDate;

    switch (_selectedOption) {
      case 'Date du premier jour des dernières règles':
        lmpDate = baseDate;
        conceptionDate = lmpDate.add(const Duration(days: 14));
        eddDate = lmpDate.add(const Duration(days: 280));
        break;
      case 'Date de conception':
        conceptionDate = baseDate;
        lmpDate = conceptionDate.subtract(const Duration(days: 14));
        eddDate = conceptionDate.add(const Duration(days: 266));
        break;
      case 'Date du terme théorique':
        eddDate = baseDate;
        lmpDate = eddDate.subtract(const Duration(days: 280));
        conceptionDate = lmpDate.add(const Duration(days: 14));
        break;
      case 'Date échographie, datation':
        int weeks = int.tryParse(_weeksController.text) ?? 0;
        int days = int.tryParse(_daysController.text) ?? 0;
        int totalDays = (weeks * 7) + days;
        lmpDate = baseDate.subtract(Duration(days: totalDays));
        conceptionDate = lmpDate.add(const Duration(days: 14));
        eddDate = lmpDate.add(const Duration(days: 280));
        break;
      default:
        return;
    }

    setState(() {
      _resultLMP = DateFormat('dd/MM/yyyy').format(lmpDate);
      _resultConception = DateFormat('dd/MM/yyyy').format(conceptionDate);
      _resultEDD = DateFormat('dd/MM/yyyy').format(eddDate);
      _resultCurrent = DateFormat('dd/MM/yyyy').format(DateTime.now());
      _resultPostTerm = DateFormat('dd/MM/yyyy').format(eddDate.add(const Duration(days: 14)));
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

