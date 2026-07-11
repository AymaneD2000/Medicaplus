import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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
  String? _errorMessage;

  // Custom colors
  final Color _primaryColor = const Color(0xFFE91E63);
  final Color _secondaryColor = const Color(0xFF1976D2);
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // _buildIntroCard(),
                  // const SizedBox(height: 20),
                  _buildDateInputCard(),
                  const SizedBox(height: 20),
                  _buildOptionsCard(),
                  if (_selectedOption == "Date d'échographie") ...[
                    const SizedBox(height: 20),
                    _buildEchographyCard(),
                  ],
                  const SizedBox(height: 20),
                  _buildCalculateButton(),
                  const SizedBox(height: 30),
                  _buildResultsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: isSmallScreen ? 12 : 16,
        top: statusBarHeight + 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _primaryColor,
            _primaryColor.withValues(alpha: 0.8),
            const Color(0xFFF06292),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative elements
          Positioned(
            right: -15,
            top: statusBarHeight - 5,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 25,
            top: statusBarHeight + 10,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Back button
          Positioned(
            left: 0,
            top: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const SizedBox(width: 50), // Space for back button
                // Compact icon container
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.25),
                        Colors.white.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.pregnant_woman,
                    color: Colors.white,
                    size: isSmallScreen ? 20 : 22,
                  ),
                ),
                const SizedBox(width: 12),
                // Enhanced text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calendrier de Grossesse',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 16 : 18,
                          letterSpacing: 0.3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              offset: const Offset(0, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          'Calculateur professionnel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 10 : 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Smaller decorative element
                Container(
                  width: 2,
                  height: isSmallScreen ? 25 : 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.25),
                        Colors.white.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInputCard() {
    DateTime? selectedDate;
    final day = int.tryParse(_dayController.text);
    final month = int.tryParse(_monthController.text);
    final year = int.tryParse(_yearController.text);

    if (day != null && month != null && year != null) {
      final parsedDate = DateTime(year, month, day);
      if (parsedDate.year == year &&
          parsedDate.month == month &&
          parsedDate.day == day) {
        selectedDate = parsedDate;
      }
    }

    final dateTitle = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate)
        : 'Aucune date sélectionnée';

    final rawDateSubtitle = selectedDate != null
        ? DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(selectedDate)
        : 'Choisissez la date avec le calendrier';
    final dateSubtitle = rawDateSubtitle.isNotEmpty
        ? '${rawDateSubtitle[0].toUpperCase()}${rawDateSubtitle.substring(1)}'
        : rawDateSubtitle;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: _secondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.calendar_today,
                  color: _secondaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Sélectionnez une date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _secondaryColor.withValues(alpha: 0.09),
                  _primaryColor.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _secondaryColor.withValues(alpha: 0.22),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.event_available_rounded,
                    color: _secondaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateTitle,
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateSubtitle,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: _textColor.withValues(alpha: 0.72),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _buildOutlinedInput(_dayController, 'Jour')),
              const SizedBox(width: 12),
              Expanded(child: _buildOutlinedInput(_monthController, 'Mois')),
              const SizedBox(width: 12),
              Expanded(
                child:
                    _buildOutlinedInput(_yearController, 'Année', bold: true),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _selectDate,
              icon: const Icon(Icons.calendar_month_rounded, size: 20),
              label: const Text(
                'Ouvrir le calendrier',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _secondaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedInput(TextEditingController controller, String hint,
      {bool bold = false}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        fontSize: 16,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _secondaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(hint == 'Année' ? 4 : 2),
      ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? option['color'] : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          decoration: BoxDecoration(
            color: option['color'].withValues(alpha: isSelected ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            option['icon'],
            color: option['color'],
            size: 24,
          ),
        ),
        title: Text(
          option['title'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isSelected ? option['color'] : Colors.black87,
          ),
        ),
        subtitle: Text(
          option['desc'],
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
            height: 1.2,
          ),
        ),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? option['color'] : Colors.grey.shade400,
              width: 2,
            ),
          ),
          child: isSelected
              ? Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: option['color'],
                  ),
                )
              : null,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.monitor_heart,
                    color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Âge gestationnel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildOutlinedInput(_weeksController, 'Semaines')),
              const SizedBox(width: 12),
              Expanded(child: _buildOutlinedInput(_daysController, 'Jours')),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.blue, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Exemple: 12 semaines et 3 jours = 12 SA + 3 J',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return Column(
      children: [
        if (_errorMessage != null) ...[
          _buildErrorCard(_errorMessage!),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isCalculating ? null : _calculateDates,
            icon: _isCalculating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.calculate, size: 24),
            label: Text(
              _isCalculating ? 'Calcul en cours...' : 'Calculer les dates',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              shadowColor: _primaryColor.withValues(alpha: 0.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_resultsOpacity == 0.0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.check_circle, color: _primaryColor, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Résultats du calcul',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          'Premier jour des dernières règles',
          _resultLMP,
          Icons.calendar_today,
          const Color(0xFF2196F3),
        ),
        const SizedBox(height: 12),
        _buildResultCard(
          'Date de conception',
          _resultConception,
          Icons.favorite,
          _primaryColor,
        ),
        const SizedBox(height: 12),
        _buildResultCard(
          'Âge gestationnel actuel',
          _resultCurrent,
          Icons.trending_up,
          const Color(0xFF2196F3),
        ),
        const SizedBox(height: 12),
        _buildResultCard(
          'Date prévue d\'accouchement',
          _resultEDD,
          Icons.emoji_emotions,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildResultCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
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
          ),
        ],
      ),
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _textColor,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              headerBackgroundColor: _primaryColor,
              headerForegroundColor: Colors.white,
              weekdayStyle: TextStyle(
                color: _secondaryColor.withValues(alpha: 0.9),
                fontWeight: FontWeight.w700,
              ),
              dayStyle: TextStyle(
                color: _textColor,
                fontWeight: FontWeight.w600,
              ),
              yearStyle: TextStyle(
                color: _textColor,
                fontWeight: FontWeight.w600,
              ),
              todayForegroundColor: WidgetStatePropertyAll(_primaryColor),
              todayBackgroundColor: WidgetStatePropertyAll(
                _primaryColor.withValues(alpha: 0.15),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: _secondaryColor,
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
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
    final month = int.tryParse(_monthController.text);
    final year = int.tryParse(_yearController.text);
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
    final days = int.tryParse(_daysController.text);
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
