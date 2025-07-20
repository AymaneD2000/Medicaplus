import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:timeline_tile/timeline_tile.dart'; // For pregnancy timeline

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
  int _currentWeek = 0;
  String _trimesterInfo = '';
  String? _errorMessage;

  // Constants for pregnancy calculations
  static const int GESTATION_PERIOD_DAYS = 280;
  static const int CONCEPTION_DAYS_AFTER_LMP = 14;
  static const int CONCEPTION_TO_EDD_DAYS = 266;
  static const int DAYS_IN_WEEK = 7;

  // Custom colors
  final Color _primaryColor = const Color(0xFFE91E63);
  final Color _secondaryColor = const Color(0xFF1976D2);
  final Color _accentColor = const Color(0xFFFF4081);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _textColor = const Color(0xFF222222);

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildIntroCard(),
                    const SizedBox(height: 16),
                    _buildDateInputCard(),
                    const SizedBox(height: 16),
                    _buildOptionsCard(),
                    if (_selectedOption == "Date d'échographie") ...[
                      const SizedBox(height: 16),
                      _buildEchographyCard(),
                    ],
                    const SizedBox(height: 16),
                    _buildInfoCard(),
                    const SizedBox(height: 24),
                    _buildCalculateButton(),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _buildErrorCard(_errorMessage!),
                    ],
                    const SizedBox(height: 24),
                    _buildResultsSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.pregnant_woman,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Calendrier de Grossesse',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Calculateur professionnel',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.monitor_heart, color: _primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suivi de Grossesse',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Calculez les dates importantes de votre grossesse avec précision',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInputCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.calendar_today,
                      color: _secondaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Sélectionnez une date',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildOutlinedInput(_dayController, 'Jour', width: 70),
                const SizedBox(width: 8),
                _buildOutlinedInput(_monthController, 'Mois', width: 70),
                const SizedBox(width: 8),
                _buildOutlinedInput(_yearController, 'Année',
                    width: 90, bold: true),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _selectDate,
                icon: Icon(Icons.calendar_month, color: _secondaryColor),
                label: Text('Sélectionner avec le calendrier',
                    style: TextStyle(color: _secondaryColor)),
                style: TextButton.styleFrom(
                  backgroundColor: _secondaryColor.withOpacity(0.07),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedInput(TextEditingController controller, String hint,
      {double width = 80, bool bold = false}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _secondaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(hint == 'Année' ? 4 : 2),
        ],
      ),
    );
  }

  Widget _buildOptionsCard() {
    final options = [
      {
        'title': 'Date du premier jour des dernières règles',
        'desc': 'Date de début des dernières menstruations',
        'icon': Icons.calendar_today,
        'color': _secondaryColor,
      },
      {
        'title': 'Date de conception',
        'desc': 'Date estimée de la fécondation',
        'icon': Icons.favorite,
        'color': Colors.pink,
      },
      {
        'title': 'Date du terme théorique',
        'desc': "Date prévue d'accouchement",
        'icon': Icons.emoji_emotions,
        'color': Colors.orange,
      },
      {
        'title': "Date d'échographie",
        'desc': "Basé sur l'âge gestationnel échographique",
        'icon': Icons.monitor_heart,
        'color': Colors.blue,
      },
    ];
    return Column(
      children: options.map((option) => _buildOptionRadio(option)).toList(),
    );
  }

  Widget _buildOptionRadio(Map option) {
    final isSelected = _selectedOption == option['title'];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? option['color'].withOpacity(0.08) : Colors.white,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: option['color'].withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(option['icon'], color: option['color'], size: 24),
        ),
        title: Text(option['title'],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? option['color'] : _textColor)),
        subtitle: Text(option['desc'], style: TextStyle(color: Colors.black54)),
        trailing: Radio<String>(
          value: option['title'],
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
          activeColor: option['color'],
        ),
        onTap: () {
          setState(() {
            _selectedOption = option['title'];
          });
        },
      ),
    );
  }

  Widget _buildEchographyCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.monitor_heart,
                      color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 12),
                const Text('Âge gestationnel',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildOutlinedInput(_weeksController, 'Semaines', width: 90),
                const SizedBox(width: 12),
                _buildOutlinedInput(_daysController, 'Jours', width: 90),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: const [
            Icon(Icons.info_outline, color: Colors.blue, size: 22),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Exemple: 12 semaines et 3 jours = 12 SA + 3 J',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isCalculating ? null : _calculateDates,
        icon: const Icon(Icons.calculate),
        label: const Text('Calculer les dates',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      color: Colors.red[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_resultsOpacity == 0.0) return const SizedBox.shrink();
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow(
                Icons.event, 'Premier jour des dernières règles', _resultLMP),
            const Divider(height: 24),
            _buildResultRow(
                Icons.favorite, 'Date de conception', _resultConception),
            const Divider(height: 24),
            _buildResultRow(Icons.today, 'Age gestationnel', _resultCurrent),
            const Divider(height: 24),
            _buildResultRow(
                Icons.child_care, 'Date prévue d\'accouchement', _resultEDD),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: _primaryColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _textColor)),
            ],
          ),
        ),
      ],
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

  bool _validateDateInput() {
    if (_dayController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _yearController.text.isEmpty) {
      _showError('Veuillez renseigner le jour, le mois et l\'année.');
      return false;
    }
    final day = int.tryParse(_dayController.text);
    final month = int.parse(_monthController.text);
    final year = int.parse(_yearController.text);
    if (day == null || month == null || year == null) {
      _showError('Les valeurs de date doivent être numériques.');
      return false;
    }
    if (day < 1 || day > 31) {
      _showError('Le jour doit être compris entre 1 et 31.');
      return false;
    }
    if (month < 1 || month > 12) {
      _showError('Le mois doit être compris entre 1 et 12.');
      return false;
    }
    if (year < 1900 || year > 2100) {
      _showError('L\'année doit être comprise entre 1900 et 2100.');
      return false;
    }
    try {
      DateTime(year, month, day);
    } catch (e) {
      _showError('La date saisie est invalide.');
      return false;
    }
    return true;
  }

  bool _validateEchographyInput() {
    if (_selectedOption != "Date d'échographie") return true;
    final weeks = int.tryParse(_weeksController.text);
    final days = int.parse(_daysController.text);
    if (weeks == null || days == null) {
      _showError('Les semaines et jours doivent être numériques.');
      return false;
    }
    if (weeks < 0 || weeks > 42) {
      _showError('Les semaines doivent être comprises entre 0 et 42.');
      return false;
    }
    if (days < 0 || days >= 7) {
      _showError('Les jours doivent être compris entre 0 et 6.');
      return false;
    }
    return true;
  }

  void _calculateDates() async {
    setState(() {
      _errorMessage = null;
      _resultsOpacity = 0.0;
    });
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
        _showError('La date ne peut pas être dans le futur.');
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
        case "Date d'échographie":
          final weeks = int.parse(_weeksController.text);
          final days = int.parse(_daysController.text);
          final totalDays = (weeks * 7) + days;
          if (totalDays > 280) {
            _showError('L\'âge gestationnel ne peut pas dépasser 40 semaines.');
            return;
          }
          lmpDate = baseDate.subtract(Duration(days: totalDays));
          conceptionDate = lmpDate.add(const Duration(days: 14));
          eddDate = lmpDate.add(const Duration(days: 280));
          break;
        default:
          return;
      }
      final gestationalAgeDays = currentDate.difference(lmpDate).inDays;
      if (gestationalAgeDays < 0 &&
          _selectedOption != "Date du terme théorique") {
        _showError('La date sélectionnée est dans le futur.');
        return;
      }
      final weeks = gestationalAgeDays ~/ 7;
      final days = gestationalAgeDays % 7;
      setState(() {
        _resultLMP = DateFormat('dd/MM/yyyy').format(lmpDate);
        _resultConception = DateFormat('dd/MM/yyyy').format(conceptionDate);
        _resultEDD = DateFormat('dd/MM/yyyy').format(eddDate);
        _resultCurrent = '$weeks sem. $days jr.';
        _resultsOpacity = 1.0;
      });
    } catch (e) {
      _showError('Une erreur est survenue lors du calcul.');
    } finally {
      setState(() => _isCalculating = false);
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }
}
