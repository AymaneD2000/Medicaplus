import 'dart:math';

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
  String _selectedUnit = 'm';
  bool _hasCalculated = false;

  // Modern color scheme matching Appgar.dart
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _secondaryColor = const Color(0xFF33CCCC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    // Check if fields are empty
    if (_weightController.text.trim().isEmpty) {
      _showErrorDialog('Veuillez entrer votre poids.');
      return false;
    }

    if (_heightController.text.trim().isEmpty) {
      _showErrorDialog('Veuillez entrer votre taille.');
      return false;
    }

    // Try to parse the values
    final weightText = _weightController.text.replaceAll(',', '.');
    final heightText = _heightController.text.replaceAll(',', '.');

    final weight = double.tryParse(weightText);
    final height = double.tryParse(heightText);

    if (weight == null) {
      _showErrorDialog('Le poids doit être une valeur numérique valide.');
      return false;
    }

    if (height == null) {
      _showErrorDialog('La taille doit être une valeur numérique valide.');
      return false;
    }

    // Validate weight range
    if (weight <= 0) {
      _showErrorDialog('Le poids doit être supérieur à 0.');
      return false;
    }

    if (weight > 1000) {
      _showErrorDialog(
          'Le poids semble trop élevé. Veuillez vérifier la valeur saisie.');
      return false;
    }

    if (weight < 0.5) {
      _showErrorDialog(
          'Le poids semble trop faible. Veuillez vérifier la valeur saisie.');
      return false;
    }

    // Validate height range
    if (height <= 0) {
      _showErrorDialog('La taille doit être supérieure à 0.');
      return false;
    }

    if (_selectedUnit == 'm') {
      if (height > 3.0) {
        _showErrorDialog(
            'La taille semble trop élevée. Veuillez vérifier la valeur saisie.');
        return false;
      }
      if (height < 0.3) {
        _showErrorDialog(
            'La taille semble trop faible. Veuillez vérifier la valeur saisie.');
        return false;
      }
    } else {
      // cm
      if (height > 300) {
        _showErrorDialog(
            'La taille semble trop élevée. Veuillez vérifier la valeur saisie.');
        return false;
      }
      if (height < 30) {
        _showErrorDialog(
            'La taille semble trop faible. Veuillez vérifier la valeur saisie.');
        return false;
      }
    }

    return true;
  }

  void _calculateIMC() {
    if (!_validateInputs()) return;

    try {
      double weight = double.parse(_weightController.text.replaceAll(',', '.'));
      double height = double.parse(_heightController.text.replaceAll(',', '.'));

      if (_selectedUnit == 'cm') {
        height = height / 100;
      }

      setState(() {
        _imc = weight / pow(height, 2);
        _hasCalculated = true;
      });
    } catch (e) {
      _showErrorDialog('Une erreur est survenue lors du calcul de l\'IMC.');
    }
  }

  void _resetCalculator() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _imc = 0.0;
      _hasCalculated = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text(
              'Erreur',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: _textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: _primaryColor,
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _getInterpretation() {
    if (_imc < 16) {
      return 'Anorexie/dénutrition';
    } else if (_imc >= 16 && _imc < 18.5) {
      return 'Maigreur';
    } else if (_imc >= 18.5 && _imc < 25) {
      return 'Corpulence normale';
    } else if (_imc >= 25 && _imc < 30) {
      return 'Surpoids';
    } else if (_imc >= 30 && _imc < 35) {
      return 'Obésité modérée';
    } else if (_imc >= 35 && _imc < 40) {
      return 'Obésité sévère';
    } else {
      return 'Obésité morbide ou massive';
    }
  }

  Color _getInterpretationColor() {
    if (_imc < 16) {
      return Colors.red;
    } else if (_imc >= 16 && _imc < 18.5) {
      return Colors.orange;
    } else if (_imc >= 18.5 && _imc < 25) {
      return Colors.green;
    } else if (_imc >= 25 && _imc < 30) {
      return const Color(0xFFB1CA39);
    } else if (_imc >= 30 && _imc < 35) {
      return const Color(0xFFF39201);
    } else if (_imc >= 35 && _imc < 40) {
      return const Color(0xFFEB5C41);
    } else {
      return const Color(0xFFE70516);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text(
          'Calculateur IMC',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDefinitionCard(),
            const SizedBox(height: 16),
            _buildInputCard(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            if (_hasCalculated && _imc > 0) ...[
              const SizedBox(height: 24),
              _buildResultCard(),
            ],
            const SizedBox(height: 24),
            _buildFormulaCard(),
            const SizedBox(height: 16),
            // _buildRangesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDefinitionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Définition de l\'IMC',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'L\'indice de masse corporelle (IMC) est une mesure utilisée pour estimer la corpulence d\'une personne en fonction de son poids et de sa taille.',
            style: TextStyle(
              fontSize: 16,
              color: _textColor.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calculate_outlined,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Entrez vos données',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInputField('Poids (kg)', _weightController),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  'Taille (${_selectedUnit})',
                  _heightController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Unité de taille',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: _primaryColor.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              value: _selectedUnit,
              isExpanded: true,
              underline: Container(),
              items: const [
                DropdownMenuItem(value: 'm', child: Text('Mètres (m)')),
                DropdownMenuItem(value: 'cm', child: Text('Centimètres (cm)')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUnit = newValue!;
                });
              },
              style: TextStyle(
                color: _textColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _primaryColor.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _primaryColor.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _calculateIMC,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Calculer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _resetCalculator,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
            ),
            child: const Text(
              'Réinitialiser',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    final interpretation = _getInterpretation();
    final color = _getInterpretationColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Votre IMC',
                    style: TextStyle(
                      fontSize: 16,
                      color: _textColor.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    _imc.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Interprétation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  interpretation,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _secondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.functions,
                  color: _secondaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Formule de calcul',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _secondaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _secondaryColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              'IMC = Poids (kg) / Taille² (m)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _secondaryColor,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildRangesCard() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: _cardColor,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: _primaryColor.withValues(alpha: 0.1),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Icon(
  //                 Icons.straighten,
  //                 color: _primaryColor,
  //                 size: 20,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Text(
  //               'Classification de l\'IMC',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: _textColor,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         // _buildRangeItem('< 16', 'Anorexie/dénutrition', Colors.red),
  //         // _buildRangeItem('16 - 18.5', 'Maigreur', Colors.orange),
  //         // _buildRangeItem('18.5 - 25', 'Corpulence normale', Colors.green),
  //         // _buildRangeItem('25 - 30', 'Surpoids', const Color(0xFFB1CA39)),
  //         // _buildRangeItem(
  //         //     '30 - 35', 'Obésité modérée', const Color(0xFFF39201)),
  //         // _buildRangeItem('35 - 40', 'Obésité sévère', const Color(0xFFEB5C41)),
  //         // _buildRangeItem('> 40', 'Obésité morbide', const Color(0xFFE70516)),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildRangeItem(String range, String description, Color color) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 12,
  //           height: 12,
  //           decoration: BoxDecoration(
  //             color: color,
  //             borderRadius: BorderRadius.circular(6),
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           flex: 2,
  //           child: Text(
  //             range,
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600,
  //               color: _textColor,
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 3,
  //           child: Text(
  //             description,
  //             style: TextStyle(
  //               fontSize: 14,
  //               color: _textColor.withValues(alpha: 0.8),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
