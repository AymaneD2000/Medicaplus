import 'package:flutter/material.dart';

class HbA1cScreen extends StatefulWidget {
  const HbA1cScreen({super.key});

  @override
  _HbA1cScreenState createState() => _HbA1cScreenState();
}

class _HbA1cScreenState extends State<HbA1cScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedUnit = '%';
  double? _glycemiaGpl;
  double? _glycemiaMmol;
  bool _hasCalculated = false;

  // Modern color scheme matching Appgar.dart
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _secondaryColor = const Color(0xFF33CCCC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _validateInput() {
    // Check if field is empty
    if (_controller.text.trim().isEmpty) {
      _showErrorDialog('Veuillez entrer une valeur HbA1c.');
      return false;
    }

    // Try to parse the value
    final inputText = _controller.text.replaceAll(',', '.');
    final hbA1c = double.tryParse(inputText);

    if (hbA1c == null) {
      _showErrorDialog('La valeur HbA1c doit être numérique.');
      return false;
    }

    // Validate based on unit
    if (_selectedUnit == '%') {
      if (hbA1c < 0) {
        _showErrorDialog('La valeur HbA1c ne peut pas être négative.');
        return false;
      }

      if (hbA1c < 3.0) {
        _showErrorDialog(
            'La valeur HbA1c semble trop faible. Les valeurs normales sont généralement entre 4% et 20%.');
        return false;
      }

      if (hbA1c > 25.0) {
        _showErrorDialog(
            'La valeur HbA1c semble trop élevée. Veuillez vérifier la valeur saisie.');
        return false;
      }

      if (hbA1c < 4.0 || hbA1c > 20.0) {
        _showErrorDialog(
            'Pour une interprétation fiable, la valeur HbA1c doit être comprise entre 4% et 20%.');
        return false;
      }
    } else {
      // mmol/mol
      if (hbA1c < 0) {
        _showErrorDialog('La valeur HbA1c ne peut pas être négative.');
        return false;
      }

      if (hbA1c < 10) {
        _showErrorDialog(
            'La valeur HbA1c semble trop faible. Les valeurs normales sont généralement entre 20 et 200 mmol/mol.');
        return false;
      }

      if (hbA1c > 250) {
        _showErrorDialog(
            'La valeur HbA1c semble trop élevée. Veuillez vérifier la valeur saisie.');
        return false;
      }
    }

    return true;
  }

  void _calculateGlycemia() {
    if (!_validateInput()) return;

    try {
      double hbA1c = double.parse(_controller.text.replaceAll(',', '.'));

      setState(() {
        _hasCalculated = true;

        if (_selectedUnit == '%') {
          _glycemiaMmol = hbA1c * 1.59 - 2.59;
          _glycemiaGpl = _glycemiaMmol! / 0.055;
        } else {
          // Convert mmol/mol to %
          double hbA1cPercent = (hbA1c + 2.59) / 1.59;
          _glycemiaMmol = hbA1cPercent * 1.59 - 2.59;
          _glycemiaGpl = _glycemiaMmol! / 0.055;
        }
      });
    } catch (e) {
      _showErrorDialog(
          'Une erreur est survenue lors du calcul de la glycémie.');
    }
  }

  void _resetCalculator() {
    setState(() {
      _controller.clear();
      _glycemiaMmol = null;
      _glycemiaGpl = null;
      _hasCalculated = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 24),
            const SizedBox(width: 8),
            const Text(
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
    if (_selectedUnit == '%') {
      final hbA1c =
          double.tryParse(_controller.text.replaceAll(',', '.')) ?? 0.0;

      if (hbA1c >= 4 && hbA1c < 5.1) {
        return 'Optimale';
      } else if (hbA1c >= 5.2 && hbA1c <= 5.6) {
        return 'Normale';
      } else if (hbA1c >= 5.7 && hbA1c <= 6.4) {
        return 'Prédiabète';
      } else if (hbA1c >= 6.5 && hbA1c < 10) {
        return 'Diabète';
      } else if (hbA1c >= 10 && hbA1c <= 20) {
        return 'Diabète / Risque élevé de complication';
      } else {
        return 'Valeur hors norme';
      }
    }
    return 'Conversion effectuée';
  }

  Color _getInterpretationColor() {
    if (_selectedUnit == '%') {
      final hbA1c =
          double.tryParse(_controller.text.replaceAll(',', '.')) ?? 0.0;

      if (hbA1c >= 4 && hbA1c < 5.1) {
        return Colors.blue;
      } else if (hbA1c >= 5.2 && hbA1c <= 5.6) {
        return Colors.green;
      } else if (hbA1c >= 5.7 && hbA1c <= 6.4) {
        return const Color(0xFFF39201);
      } else if (hbA1c >= 6.5 && hbA1c < 10) {
        return const Color(0xFFEB5C41);
      } else if (hbA1c >= 10 && hbA1c <= 20) {
        return const Color(0xFFE70516);
      } else {
        return Colors.red;
      }
    }
    return _primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text(
          'HbA1c vers Glycémie',
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
            if (_hasCalculated &&
                (_glycemiaGpl != null || _glycemiaMmol != null)) ...[
              const SizedBox(height: 24),
              _buildResultCard(),
            ],
            const SizedBox(height: 24),
            _buildFormulaCard(),
            const SizedBox(height: 16),
            _buildRangesCard(),
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
            color: Colors.black.withOpacity(0.05),
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
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Définition de l\'HbA1c',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'L\'hémoglobine glyquée (HbA1c) est le reflet de l\'équilibre glycémique des trois derniers mois. Cette formule permet de faire le lien entre HbA1c et la glycémie plasmatique moyenne présente chez un patient.',
            style: TextStyle(
              fontSize: 16,
              color: _textColor.withOpacity(0.8),
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
            color: Colors.black.withOpacity(0.05),
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
                  color: _primaryColor.withOpacity(0.1),
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
                'Entrez la valeur HbA1c',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Valeur HbA1c',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: _selectedUnit == '%' ? 'Ex: 7.5' : 'Ex: 58',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _primaryColor.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _primaryColor.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _primaryColor, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: true,
              fillColor: Colors.grey[50],
              suffixText: _selectedUnit,
              suffixStyle: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Unité',
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
              border: Border.all(color: _primaryColor.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _selectedUnit,
              isExpanded: true,
              underline: Container(),
              items: const [
                DropdownMenuItem(value: '%', child: Text('Pourcentage (%)')),
                DropdownMenuItem(value: 'mmol/mol', child: Text('mmol/mol')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUnit = newValue!;
                  _hasCalculated = false;
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _calculateGlycemia,
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
            color: Colors.black.withOpacity(0.05),
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Résultats de conversion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_glycemiaGpl != null) ...[
            _buildResultItem(
              'Glycémie plasmatique moyenne',
              '${_glycemiaGpl!.toStringAsFixed(1)} mg/dL',
              Colors.blue,
            ),
            const SizedBox(height: 12),
          ],
          if (_glycemiaMmol != null) ...[
            _buildResultItem(
              'Glycémie plasmatique moyenne',
              '${_glycemiaMmol!.toStringAsFixed(1)} mmol/L',
              Colors.green,
            ),
            const SizedBox(height: 20),
          ],
          if (_selectedUnit == '%') ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
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
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: _textColor.withOpacity(0.8),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
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
            color: Colors.black.withOpacity(0.05),
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
                  color: _secondaryColor.withOpacity(0.1),
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
                'Formules de conversion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormulaItem(
            'HbA1c (%) vers mmol/L',
            'Glycémie (mmol/L) = HbA1c × 1.59 - 2.59',
          ),
          const SizedBox(height: 12),
          _buildFormulaItem(
            'mmol/L vers mg/dL',
            'Glycémie (mg/dL) = Glycémie (mmol/L) ÷ 0.055',
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaItem(String title, String formula) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _secondaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _secondaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formula,
            style: TextStyle(
              fontSize: 13,
              color: _secondaryColor,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.straighten,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Interprétation HbA1c (%)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRangeItem('4.0 - 5.1%', 'Optimale', Colors.blue),
          _buildRangeItem('5.2 - 5.6%', 'Normale', Colors.green),
          _buildRangeItem('5.7 - 6.4%', 'Prédiabète', const Color(0xFFF39201)),
          _buildRangeItem('6.5 - 9.9%', 'Diabète', const Color(0xFFEB5C41)),
          _buildRangeItem(
              '≥ 10%', 'Diabète / Risque élevé', const Color(0xFFE70516)),
        ],
      ),
    );
  }

  Widget _buildRangeItem(String range, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              range,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: _textColor.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
