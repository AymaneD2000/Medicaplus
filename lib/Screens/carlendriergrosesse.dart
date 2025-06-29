import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // For input formatters

class PregnancyCalculatorScreen extends StatefulWidget {
  const PregnancyCalculatorScreen({super.key});

  @override
  _PregnancyCalculatorScreenState createState() =>
      _PregnancyCalculatorScreenState();
}

class _PregnancyCalculatorScreenState extends State<PregnancyCalculatorScreen> {
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  final FocusNode _dayFocus = FocusNode();
  final FocusNode _monthFocus = FocusNode();
  final FocusNode _yearFocus = FocusNode();

  final _weeksController = TextEditingController();
  final _daysController = TextEditingController();

  String _selectedOption = 'Date du premier jour des dernières règles';
  String _resultLMP = '';
  String _resultConception = '';
  String _resultEDD = '';
  String _resultCurrent = '';
  double _resultsOpacity = 0.0;
  bool _isCalculating = false;

  // Constants for pregnancy calculations
  static const int GESTATION_PERIOD_DAYS = 280;
  static const int CONCEPTION_DAYS_AFTER_LMP = 14;
  static const int CONCEPTION_TO_EDD_DAYS = 266;
  static const int DAYS_IN_WEEK = 7;

  // Custom colors
  final Color _primaryColor = const Color(0xFF4CAF50);
  final Color _secondaryColor = const Color(0xFF81C784);
  final Color _accentColor = const Color(0xFFFF4081);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _textColor = const Color(0xFF333333);

  @override
  void initState() {
    super.initState();
    _yearController.text = DateTime.now().year.toString();
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _dayFocus.dispose();
    _monthFocus.dispose();
    _yearFocus.dispose();
    _weeksController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Calendrier de Grossesse',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 24.0),
              _buildDateSelectionSection(),
              const SizedBox(height: 24.0),
              _buildOptions(),
              if (_selectedOption == "Date d'échographie")
                _buildEchographyInputs(),
              const SizedBox(height: 24.0),
              _buildCalculateButton(),
              const SizedBox(height: 24.0),
              _buildResultsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.pregnant_woman,
            size: 40,
            color: Color(0xFF4CAF50),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Calculez les dates importantes de votre grossesse',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sélectionnez une date :',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildCustomDateInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDateInput() {
    return Row(
      children: [
        Expanded(
          child: _buildDateTextField(
            controller: _dayController,
            focusNode: _dayFocus,
            label: 'Jour',
            hint: 'JJ',
            onChanged: (value) {
              int? day = int.tryParse(value);
              if (day != null && day >= 1 && day <= 31 && value.length == 2) {
                FocusScope.of(context).requestFocus(_monthFocus);
              }
            },
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: _buildDateTextField(
            controller: _monthController,
            focusNode: _monthFocus,
            label: 'Mois',
            hint: 'MM',
            onChanged: (value) {
              int? month = int.tryParse(value);
              if (month != null &&
                  month >= 1 &&
                  month <= 12 &&
                  value.length == 2) {
                FocusScope.of(context).requestFocus(_yearFocus);
              }
            },
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: _buildDateTextField(
            controller: _yearController,
            focusNode: _yearFocus,
            label: 'Année',
            hint: 'AAAA',
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          icon: Icon(
            Icons.calendar_today,
            color: _primaryColor,
            size: 32,
          ),
          onPressed: _selectDate,
        ),
      ],
    );
  }

  Widget _buildDateTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: _textColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(hint.length),
      ],
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      onSubmitted: (_) {
        _calculateDates();
      },
      onChanged: onChanged,
    );
  }

  Future<void> _selectDate() async {
    DateTime initialDate;
    try {
      int day = int.parse(_dayController.text);
      int month = int.parse(_monthController.text);
      int year = int.parse(_yearController.text);
      initialDate = DateTime(year, month, day);
    } catch (e) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('fr', 'FR'),
    );

    if (picked != null) {
      setState(() {
        _dayController.text = picked.day.toString().padLeft(2, '0');
        _monthController.text = picked.month.toString().padLeft(2, '0');
        _yearController.text = picked.year.toString();
      });
    }
  }

  Widget _buildOptions() {
    final options = [
      'Date du premier jour des dernières règles',
      'Date de conception',
      'Date du terme théorique',
      "Date d'échographie"
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: options.map((option) => _buildRadioOption(option)).toList(),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: _textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Radio<String>(
        value: title,
        groupValue: _selectedOption,
        onChanged: (value) {
          setState(() {
            _selectedOption = value!;
          });
        },
        activeColor: _primaryColor,
      ),
    );
  }

  Widget _buildEchographyInputs() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: _buildDateTextField(
                controller: _weeksController,
                focusNode: FocusNode(),
                label: 'Semaines',
                hint: 'SA',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateTextField(
                controller: _daysController,
                focusNode: FocusNode(),
                label: 'Jours',
                hint: 'J',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _isCalculating ? null : _calculateDates,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isCalculating
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Calculer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  bool _validateDateInput() {
    if (_dayController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _yearController.text.isEmpty) {
      _showErrorDialog('Veuillez renseigner le jour, le mois et l\'année.');
      return false;
    }

    final day = int.tryParse(_dayController.text);
    final month = int.tryParse(_monthController.text);
    final year = int.tryParse(_yearController.text);

    if (day == null || month == null || year == null) {
      _showErrorDialog('Les valeurs de date doivent être numériques.');
      return false;
    }

    if (day < 1 || day > 31) {
      _showErrorDialog('Le jour doit être compris entre 1 et 31.');
      return false;
    }

    if (month < 1 || month > 12) {
      _showErrorDialog('Le mois doit être compris entre 1 et 12.');
      return false;
    }

    if (year < 1900 || year > 2100) {
      _showErrorDialog('L\'année doit être comprise entre 1900 et 2100.');
      return false;
    }

    // Validate if the date is valid (e.g., not February 30)
    try {
      DateTime(year, month, day);
    } catch (e) {
      _showErrorDialog('La date saisie est invalide.');
      return false;
    }

    return true;
  }

  bool _validateEchographyInput() {
    if (_selectedOption != "Date d'échographie") return true;

    final weeks = int.tryParse(_weeksController.text);
    final days = int.tryParse(_daysController.text);

    if (weeks == null || days == null) {
      _showErrorDialog('Les semaines et jours doivent être numériques.');
      return false;
    }

    if (weeks < 0 || weeks > 42) {
      _showErrorDialog('Les semaines doivent être comprises entre 0 et 42.');
      return false;
    }

    if (days < 0 || days >= DAYS_IN_WEEK) {
      _showErrorDialog('Les jours doivent être compris entre 0 et 6.');
      return false;
    }

    return true;
  }

  void _calculateDates() async {
    if (!_validateDateInput() || !_validateEchographyInput()) return;

    setState(() => _isCalculating = true);

    try {
      final baseDate = DateTime(
        int.parse(_yearController.text),
        int.parse(_monthController.text),
        int.parse(_dayController.text),
      );

      final currentDate = DateTime.now();
      if (baseDate.isAfter(currentDate) &&
          _selectedOption != "Date du terme théorique") {
        _showErrorDialog('La date ne peut pas être dans le futur.');
        return;
      }

      DateTime lmpDate, conceptionDate, eddDate;

      switch (_selectedOption) {
        case 'Date du premier jour des dernières règles':
          lmpDate = baseDate;
          conceptionDate =
              lmpDate.add(const Duration(days: CONCEPTION_DAYS_AFTER_LMP));
          eddDate = lmpDate.add(const Duration(days: GESTATION_PERIOD_DAYS));
          break;

        case 'Date de conception':
          conceptionDate = baseDate;
          lmpDate = conceptionDate
              .subtract(const Duration(days: CONCEPTION_DAYS_AFTER_LMP));
          eddDate =
              conceptionDate.add(const Duration(days: CONCEPTION_TO_EDD_DAYS));
          break;

        case 'Date du terme théorique':
          eddDate = baseDate;
          lmpDate =
              eddDate.subtract(const Duration(days: GESTATION_PERIOD_DAYS));
          conceptionDate =
              lmpDate.add(const Duration(days: CONCEPTION_DAYS_AFTER_LMP));
          break;

        case "Date d'échographie":
          final weeks = int.parse(_weeksController.text);
          final days = int.parse(_daysController.text);
          final totalDays = (weeks * DAYS_IN_WEEK) + days;

          if (totalDays > GESTATION_PERIOD_DAYS) {
            _showErrorDialog(
                'L\'âge gestationnel ne peut pas dépasser 40 semaines.');
            return;
          }

          lmpDate = baseDate.subtract(Duration(days: totalDays));
          conceptionDate =
              lmpDate.add(const Duration(days: CONCEPTION_DAYS_AFTER_LMP));
          eddDate = lmpDate.add(const Duration(days: GESTATION_PERIOD_DAYS));
          break;

        default:
          return;
      }

      // Calculate gestational age
      final gestationalAgeDays = currentDate.difference(lmpDate).inDays;
      if (gestationalAgeDays < 0 &&
          _selectedOption != "Date du terme théorique") {
        _showErrorDialog('La date sélectionnée est dans le futur.');
        return;
      }

      final weeks = gestationalAgeDays ~/ DAYS_IN_WEEK;
      final days = gestationalAgeDays % DAYS_IN_WEEK;

      setState(() {
        _resultLMP = DateFormat('dd/MM/yyyy').format(lmpDate);
        _resultConception = DateFormat('dd/MM/yyyy').format(conceptionDate);
        _resultEDD = DateFormat('dd/MM/yyyy').format(eddDate);
        _resultCurrent = '$weeks sem. $days jr.';
        _resultsOpacity = 1.0;
      });
    } catch (e) {
      _showErrorDialog('Une erreur est survenue lors du calcul.');
    } finally {
      setState(() => _isCalculating = false);
    }
  }

  Widget _buildResultsSection() {
    return AnimatedOpacity(
      opacity: _resultsOpacity,
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildResultTile(
                Icons.event,
                'Premier jour des dernières règles :',
                _resultLMP,
                color: _primaryColor,
              ),
              const Divider(height: 24),
              _buildResultTile(
                Icons.favorite,
                'Date de conception :',
                _resultConception,
                color: _accentColor,
              ),
              const Divider(height: 24),
              _buildResultTile(
                Icons.today,
                'Age gestationnel :',
                _resultCurrent,
                color: _secondaryColor,
              ),
              const Divider(height: 24),
              _buildResultTile(
                Icons.child_care,
                'Date prévue d\'accouchement :',
                _resultEDD,
                color: _primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultTile(IconData icon, String label, String value,
      {required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  void _showAdjustmentDialog(String label, String currentValue) {
    // Implement adjustment dialog if needed
  }
}
