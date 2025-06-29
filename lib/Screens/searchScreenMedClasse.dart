import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:moussa_project/Screens/AmoView.dart';
import 'package:moussa_project/Screens/medicamentdetailscreen.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class SearchMedicamentClasseScreen extends StatefulWidget {
  List<Med> listes;
  String hintText;

  SearchMedicamentClasseScreen(
      {super.key, required this.listes, required this.hintText});

  @override
  State<SearchMedicamentClasseScreen> createState() =>
      _SearchMedicamentClasseScreenState();
}

class _SearchMedicamentClasseScreenState
    extends State<SearchMedicamentClasseScreen> {
  TextEditingController searchController = TextEditingController();
  List<Med> filtered = [];
  bool _isLoading = false;

  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final Color _successColor = const Color(0xFF4CAF50);
  final Color _errorColor = const Color(0xFFE53935);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filtered = widget.listes;
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const Gap(10),
          Expanded(
            child: TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              style: TextStyle(fontSize: 16, color: _textColor),
              onChanged: (query) {
                setState(() {
                  _isLoading = true;
                });
                Future.delayed(const Duration(milliseconds: 200), () {
                  filtered = widget.listes.where((med) {
                    final medNameLower =
                        removeDiacritics(med.name.toLowerCase());
                    final queryLower = removeDiacritics(query.toLowerCase());
                    return medNameLower.contains(queryLower);
                  }).toList();
                  setState(() {
                    _isLoading = false;
                  });
                });
              },
            ),
          ),
          if (searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                searchController.clear();
                setState(() {
                  filtered = widget.listes;
                });
              },
              child: const Icon(Icons.close, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildMedCard(Med med, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _primaryColor.withOpacity(0.1),
          child: Icon(Icons.medication, color: _primaryColor),
        ),
        title: Text(
          med.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor,
            fontSize: 18,
          ),
        ),
        subtitle: med.nomCommercial.isNotEmpty
            ? Text(med.nomCommercial.join(', '),
                style: TextStyle(color: _textColor.withOpacity(0.7)))
            : null,
      ),
    );
  }

  Widget _buildEmptyState(String message,
      {IconData icon = Icons.info_outline}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const Gap(16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
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
        toolbarHeight: 80,
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Recherche Médicament',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator())),
          if (!_isLoading)
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState('Aucun résultat trouvé',
                      icon: Icons.search_off)
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final med = filtered[index];
                        return _buildMedCard(
                          med,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MedicamentDetailsScreen(medicament: med),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}
