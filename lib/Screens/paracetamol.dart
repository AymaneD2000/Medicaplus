import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ParacetamolScreen extends StatefulWidget {
  const ParacetamolScreen({super.key});

  @override
  _ParacetamolScreenState createState() => _ParacetamolScreenState();
}

class _ParacetamolScreenState extends State<ParacetamolScreen> {
  final TextEditingController _controller = TextEditingController();
  int _selectedAge = 0;
  double _dose = 0;
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

  void _calculateDose() async {
    if (_selectedAge == 0) {
      setState(() {
        _errorMessage = "Veuillez sélectionner un âge";
        _hasCalculated = false;
      });
      return;
    }

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
        _dose = 0;
      } else {
        _errorMessage = '';
        _hasCalculated = true;
        switch (_selectedAge) {
          case 1: // Nouveau-né
            _dose = weight * 0.75;
            break;
          case 2: // Enfant de moins de 1 mois
            _dose = weight;
            break;
          case 3: // Enfant de 1 mois ou plus
            _dose = weight * 1.5;
            break;
        }
      }
      _isLoading = false;
    });
  }

  void _reset() {
    setState(() {
      _controller.clear();
      _selectedAge = 0;
      _dose = 0;
      _hasCalculated = false;
      _errorMessage = '';
    });
  }

  Widget _buildAgeCard() {
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
                Icons.child_care,
                color: _primaryColor,
                size: 24,
              ),
              const Gap(8),
              Text(
                'Âge du patient',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ],
          ),
          const Gap(16),
          ..._buildAgeOptions(),
        ],
      ),
    );
  }

  List<Widget> _buildAgeOptions() {
    return [
      _buildAgeOption(
        title: 'Nouveau-né',
        value: 1,
        icon: Icons.baby_changing_station,
      ),
      const Gap(8),
      _buildAgeOption(
        title: 'Enfant de moins de 1 mois',
        value: 2,
        icon: Icons.child_friendly,
      ),
      const Gap(8),
      _buildAgeOption(
        title: 'Enfant de 1 mois ou plus',
        value: 3,
        icon: Icons.child_care,
      ),
    ];
  }

  Widget _buildAgeOption({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedAge == value ? _primaryColor : Colors.transparent,
        ),
      ),
      child: RadioListTile<int>(
        activeColor: _primaryColor,
        title: Row(
          children: [
            Icon(
              icon,
              color: _primaryColor,
              size: 20,
            ),
            const Gap(8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: _textColor,
                  fontWeight: _selectedAge == value
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        value: value,
        groupValue: _selectedAge,
        onChanged: (value) {
          setState(() {
            _selectedAge = value!;
            _errorMessage = '';
          });
        },
      ),
    );
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
              onSubmitted: (_) => _calculateDose(),
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
                  onPressed: _isLoading ? null : _calculateDose,
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
                'Dose calculée',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _dose.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _successColor,
                  ),
                ),
                const Gap(8),
                Text(
                  'ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: _textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: _successColor.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: _successColor.withOpacity(0.3)),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           Text(
          //             _dose.toStringAsFixed(2),
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //               color: _successColor,
          //             ),
          //           ),
          //           const Gap(4),
          //           Text(
          //             'ml',
          //             style: TextStyle(
          //               fontSize: 14,
          //               color: _textColor.withOpacity(0.7),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
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
            title: 'Nouveau-né',
            value: '7,5 mg/kg ou 0,75 ml/kg (max. 30 mg/kg par jour)',
            icon: Icons.baby_changing_station,
          ),
          const Gap(12),
          _buildReferenceItem(
            title: 'Enfant de moins de 1 mois',
            value: '10 mg/kg 3 ou 4 fois par jour (max. 40 mg/kg par jour)',
            icon: Icons.child_friendly,
          ),
          const Gap(12),
          _buildReferenceItem(
            title: 'Enfant de 1 mois ou plus',
            value: '15 mg/kg ou 1,5 ml/kg (max. 60 mg/kg par jour)',
            icon: Icons.child_care,
          ),
          const Gap(12),
          _buildReferenceItem(
            title: 'Adulte',
            value: '1 g (max. 4 g par jour)',
            icon: Icons.person,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          'Paracétamol',
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
            _buildAgeCard(),
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
