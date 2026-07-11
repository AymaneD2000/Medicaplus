import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/Models/amo.dart';
import 'package:medpharm/Screens/AmoView.dart';
import 'package:medpharm/Utils/transitions.dart';

// ignore: must_be_immutable
class SearchAmoScreenAmo extends StatefulWidget {
  List<Amo> listes;
  String hintText;

  SearchAmoScreenAmo({super.key, required this.listes, required this.hintText});

  @override
  State<SearchAmoScreenAmo> createState() => _SearchAmoScreenAmoState();
}

class _SearchAmoScreenAmoState extends State<SearchAmoScreenAmo> {
  TextEditingController searchController = TextEditingController();
  List<Amo> filtered = [];

  // Modern color scheme
  final Color _primaryColor = const Color(0xFF4CAF50);

  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);

  @override
  void initState() {
    super.initState();
    // Filter only AMO medications
    filtered = widget.listes.where((med) => med.amo).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filtered = widget.listes.where((med) => med.amo).toList();
      } else {
        filtered = widget.listes.where((med) {
          final medNameLower = removeDiacritics(med.name.toLowerCase());
          final queryLower = removeDiacritics(query.toLowerCase());
          return med.amo && medNameLower.contains(queryLower);
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
          Expanded(
            child:
                filtered.isEmpty ? _buildEmptyState() : _buildSearchResults(),
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
          colors: [_primaryColor, const Color(0xFF42A5F5)],
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.3),
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
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Médicaments AMO',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Assurance Maladie Obligatoire',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
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
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  cursorColor: _primaryColor,
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
                      color: _primaryColor,
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
                      borderSide: BorderSide(
                        color: _primaryColor.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: _primaryColor.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: _primaryColor,
                        width: 2,
                      ),
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
              if (filtered.isNotEmpty && searchController.text.isNotEmpty) ...[
                const Gap(12),
                Text(
                  '${filtered.length} médicament${filtered.length > 1 ? 's' : ''} AMO trouvé${filtered.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
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
                    ? Icons.verified_outlined
                    : Icons.search_off_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const Gap(24),
            Text(
              searchController.text.isEmpty
                  ? 'Recherchez dans les médicaments AMO'
                  : 'Aucun médicament AMO trouvé',
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

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final pharmacy = filtered[index];
        return _buildPharmacyCard(pharmacy);
      },
    );
  }

  Widget _buildPharmacyCard(Amo pharmacy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              PremiumPageRoute(
                page: AmoDetailsScreen(medicament: pharmacy),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(pharmacy.icon)),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pharmacy.name,
                              style: TextStyle(
                                color: _textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'AMO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (pharmacy.prix.isNotEmpty) ...[
                        const Gap(4),
                        Text(
                          pharmacy.prix.take(2).join(', '),
                          style: TextStyle(
                            color: _primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      // if (pharmacy.classtherapique.isNotEmpty) ...[
                      //   const Gap(4),
                      //   Text(
                      //     pharmacy.classtherapique.first.toString(),
                      //     style: TextStyle(
                      //       color: _textColor.withValues(alpha: 0.7),
                      //       fontSize: 12,
                      //     ),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ],
                      // if (pharmacy.presantation.isNotEmpty) ...[
                      //   const Gap(4),
                      //   Text(
                      //     pharmacy.presantation.first.toString(),
                      //     style: TextStyle(
                      //       color: _secondaryColor,
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ],
                    ],
                  ),
                ),
                const Gap(8),
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
