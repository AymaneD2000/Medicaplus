import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/Models/amo.dart';
import 'package:medpharm/Screens/AmoView.dart';
import 'package:medpharm/Widgets/az_navigation.dart';

class SearchAmoScreen extends StatefulWidget {
  List<Amo> listes;
  String hintText;

  SearchAmoScreen({super.key, required this.listes, required this.hintText});

  @override
  State<SearchAmoScreen> createState() => _SearchAmoScreenState();
}

class _SearchAmoScreenState extends State<SearchAmoScreen> {
  TextEditingController searchController = TextEditingController();
  List<Amo> filtered = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  // Modern color scheme
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _secondaryColor = const Color(0xFF4CAF50);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  @override
  void initState() {
    super.initState();
    filtered = widget.listes;
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filtered = widget.listes;
      } else {
        filtered = widget.listes.where((med) {
          final medNameLower = removeDiacritics(med.name.toLowerCase());
          final queryLower = removeDiacritics(query.toLowerCase());
          return medNameLower.contains(queryLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          _buildSearchHeader(),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator())),
          if (!_isLoading)
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final pharmacy = filtered[index];
                            return _buildPharmacyCard(pharmacy);
                          },
                        ),
                        // Positioned(
                        //   right: 16,
                        //   top: 0,
                        //   bottom: 0,
                        //   child: AZNavigation(
                        //     availableLetters: filtered
                        //         .map((pharmacy) =>
                        //             pharmacy.name[0].toUpperCase())
                        //         .toSet(),
                        //     onLetterSelected: (letter) {
                        //       // Find the first item starting with the selected letter
                        //       final index = filtered.indexWhere(
                        //         (pharmacy) => pharmacy.name
                        //             .toUpperCase()
                        //             .startsWith(letter),
                        //       );
                        //       if (index != -1) {
                        //         _scrollController.animateTo(
                        //           index * 80.0, // Approximate item height
                        //           duration: const Duration(milliseconds: 300),
                        //           curve: Curves.easeInOut,
                        //         );
                        //       }
                        //     },
                        //     // backgroundColor: _secondaryColor.withOpacity(0.1),
                        //     // selectedColor: _secondaryColor,
                        //     // textColor: _secondaryColor,
                        //     // selectedTextColor: Colors.white,
                        //     itemSize: 20,
                        //     //itemPadding: 2,
                        //   ),
                        // ),
                      ],
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_secondaryColor, const Color(0xFF66BB6A)],
        ),
        boxShadow: [
          BoxShadow(
            color: _secondaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Gap(16),
                  const Expanded(
                    child: Text(
                      'Recherche',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Container(
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: _secondaryColor,
                      size: 24,
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: _cardColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onChanged: _performSearch,
                ),
              ),
              if (filtered.isNotEmpty) ...[
                const Gap(12),
                Text(
                  '${filtered.length} résultat${filtered.length > 1 ? 's' : ''} trouvé${filtered.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                searchController.text.isEmpty
                    ? Icons.search_outlined
                    : Icons.search_off_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const Gap(24),
            Text(
              searchController.text.isEmpty
                  ? 'Commencez à taper pour rechercher'
                  : 'Aucun résultat trouvé',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (searchController.text.isNotEmpty) ...[
              const Gap(8),
              Text(
                'Essayez avec d\'autres mots-clés',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPharmacyCard(Amo pharmacy) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AmoDetailsScreen(medicament: pharmacy),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(pharmacy.icon),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                      if (pharmacy.presantation.isNotEmpty) ...[
                        const Gap(4),
                        Text(
                          pharmacy.presantation.take(2).join(', '),
                          style: TextStyle(
                            color: _textColor.withOpacity(0.7),
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      // if (pharmacy.classtherapique.isNotEmpty) ...[
                      //   const Gap(4),
                      //   Text(
                      //     pharmacy.classtherapique.first.toString(),
                      //     style: TextStyle(
                      //       color: _secondaryColor,
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ],
                      if (pharmacy.amo) ...[
                        const Gap(4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'AMO',
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      if (!pharmacy.amo) ...[
                        const Gap(4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'AMO',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
