import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ArtemetherScreen extends StatefulWidget {
  const ArtemetherScreen({super.key});

  @override
  _ArtemetherScreenState createState() => _ArtemetherScreenState();
}

class _ArtemetherScreenState extends State<ArtemetherScreen> {
  final TextEditingController _controller = TextEditingController();
  double dose = 0;
  double dosecharge = 0;
  bool _hasCalculated = false;
  String _errorMessage = '';
  bool _isLoading = false;

  // Custom colors
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final Color _successColor = const Color(0xFF4CAF50);
  final Color _errorColor = const Color(0xFFE53935);

  void _calculatePoids() async {
    if (_controller.text.isEmpty) {
      setState(() {
        _errorMessage = "Veuillez entrer un poids";
        _hasCalculated = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate calculation delay
    await Future.delayed(const Duration(milliseconds: 500));

    final t = _controller.text.replaceAll(RegExp(','), '.');
    setState(() {
      double weight = double.tryParse(t) ?? 0.0;
      if (weight <= 0) {
        _errorMessage = "Veuillez entrer un poids valide";
        _hasCalculated = false;
        dose = 0;
        dosecharge = 0;
      } else {
        _errorMessage = '';
        _hasCalculated = true;
        dose = weight * 1.6; // Dose d'entretien
        dosecharge = weight * 3.2; // Dose de charge
      }
      _isLoading = false;
    });
  }

  void _reset() {
    setState(() {
      _controller.clear();
      dose = 0;
      dosecharge = 0;
      _hasCalculated = false;
      _errorMessage = '';
    });
  }

  Widget _buildInputCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              Icon(
                Icons.scale,
                color: _primaryColor,
                size: 24,
              ),
              const Gap(8),
              Text(
                'Poids du patient',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const Gap(16),
          Container(
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primaryColor.withOpacity(0.2)),
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _calculatePoids(),
              style: TextStyle(
                fontSize: 16,
                color: _textColor,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Entrez le poids en kg',
                hintStyle: TextStyle(
                  color: _textColor.withOpacity(0.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
                suffixText: 'kg',
                suffixStyle: TextStyle(
                  color: _textColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(
                  Icons.monitor_weight,
                  color: _primaryColor.withOpacity(0.7),
                ),
              ),
            ),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: _errorColor,
                    size: 16,
                  ),
                  const Gap(4),
                  Text(
                    _errorMessage,
                    style: TextStyle(
                      color: _errorColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          const Gap(20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _calculatePoids,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Calculer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const Gap(12),
              ElevatedButton(
                onPressed: _reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Réinitialiser',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    if (!_hasCalculated) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              Icon(
                Icons.medication,
                color: _successColor,
                size: 24,
              ),
              const Gap(8),
              Text(
                'Doses calculées',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _successColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                _buildDoseItem(
                  label: 'Dose de charge',
                  value: dosecharge,
                ),
                const Gap(12),
                _buildDoseItem(
                  label: "Dose d'entretien",
                  value: dose,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoseItem({required String label, required double value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _textColor.withOpacity(0.8),
            ),
          ),
          Row(
            children: [
              Text(
                value.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _successColor,
                ),
              ),
              const Gap(4),
              Text(
                'mg',
                style: TextStyle(
                  fontSize: 14,
                  color: _textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              Icon(
                Icons.info_outline,
                color: _primaryColor,
                size: 24,
              ),
              const Gap(8),
              Text(
                'Références',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const Gap(16),
          _buildReferenceItem(
            title: 'Dose de charge',
            value: '3,2 mg/kg',
            icon: Icons.bolt,
          ),
          const Gap(12),
          _buildReferenceItem(
            title: "Dose d'entretien",
            value: '1,6 mg/kg',
            icon: Icons.schedule,
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: _primaryColor,
            size: 20,
          ),
          const Gap(12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 16,
                      color: _textColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text(
          'Artémether',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(16),
            _buildInputCard(),
            const Gap(16),
            _buildResultCard(),
            const Gap(16),
            _buildReferenceCard(),
            const Gap(16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
