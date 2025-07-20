import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:medpharm/Models/amo.dart';
import 'package:gap/gap.dart';

class SearchClasseTheuraScreenDCI extends StatefulWidget {
  List<ClassMed> listes;
  List<String> iconMeds;
  String hintText;

  SearchClasseTheuraScreenDCI(
      {super.key,
      required this.iconMeds,
      required this.listes,
      required this.hintText});

  @override
  State<SearchClasseTheuraScreenDCI> createState() =>
      _SearchClasseTheuraScreenDCIState();
}

class _SearchClasseTheuraScreenDCIState
    extends State<SearchClasseTheuraScreenDCI> {
  TextEditingController searchController = TextEditingController();
  List<ClassMed> filtered = [];
  bool _isLoading = false;

  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final Color _successColor = const Color(0xFF4CAF50);
  final Color _errorColor = const Color(0xFFE53935);

  @override
  void initState() {
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
                        removeDiacritics(med.clname.toLowerCase());
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

  Widget _buildClassCard(ClassMed med, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _primaryColor.withOpacity(0.1),
          child: Icon(Icons.category, color: _primaryColor),
        ),
        title: Text(
          med.clname,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor,
            fontSize: 18,
          ),
        ),
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
        title: const Text('Recherche Classe',
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
                  ? _buildEmptyState('Aucune classe trouvée',
                      icon: Icons.search_off)
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final med = filtered[index];
                        return _buildClassCard(
                          med,
                          onTap: () {
                            // You may want to navigate to a class details screen or show related meds
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
