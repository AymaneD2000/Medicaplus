import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:medpharm/Models/med.dart';
import 'package:medpharm/Screens/medicamentdetailscreen.dart';
import 'package:medpharm/Utils/transitions.dart';
import 'package:gap/gap.dart';
import 'package:medpharm/Widgets/az_navigation.dart';

class SearchMedicamentScreen extends StatefulWidget {
  final List<Med> listes;
  final String hintText;

  const SearchMedicamentScreen(
      {super.key, required this.listes, required this.hintText});

  @override
  State<SearchMedicamentScreen> createState() => _SearchMedicamentScreenState();
}

class _SearchMedicamentScreenState extends State<SearchMedicamentScreen> {
  TextEditingController searchController = TextEditingController();
  List<Med> filtered = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  final Color _primaryColor = const Color(0xFF02B1EC);
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
    _scrollController.dispose();
    super.dispose();
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
            color: Colors.black.withValues(alpha: 0.05),
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

  // Widget _buildMedCard(Med med, {VoidCallback? onTap}) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  //     decoration: BoxDecoration(
  //       color: _cardColor,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.05),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Material(
  //       color: Colors.transparent,
  //       borderRadius: BorderRadius.circular(16),
  //       child: InkWell(
  //         onTap: onTap,
  //         borderRadius: BorderRadius.circular(16),
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Row(
  //             children: [
  //               const Gap(16),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       med.name,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         color: _textColor,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                     if (med.nomCommercial.isNotEmpty) ...[
  //                       const Gap(4),
  //                       Text(
  //                         med.nomCommercial.take(2).join(', '),
  //                         style: TextStyle(
  //                           color: _textColor.withValues(alpha: 0.7),
  //                           fontSize: 14,
  //                         ),
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ],
  //                     if (med.classtherapique.isNotEmpty) ...[
  //                       const Gap(4),
  //                       Text(
  //                         med.classtherapique.first.toString(),
  //                         style: TextStyle(
  //                           color: _primaryColor,
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ],
  //                   ],
  //                 ),
  //               ),
  //               Icon(
  //                 Icons.arrow_forward_ios,
  //                 color: Colors.grey[400],
  //                 size: 16,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMedCard(Med med,
      {VoidCallback? onTap, VoidCallback? onFavorite}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _primaryColor.withValues(alpha: 0.7),
                          fontSize: 16,
                        ),
                      ),
                      if (med.nomCommercial.isNotEmpty) ...[
                        const Gap(4),
                        Text(
                          med.nomCommercial.take(2).join(', '),
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      // if (med.classtherapique.isNotEmpty) ...[
                      //   const Gap(4),
                      //   Text(
                      //     med.classtherapique.first.toString(),
                      //     style: TextStyle(
                      //       color: _primaryColor,
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
                IconButton(
                  icon: Icon(
                    med.isFavoris ? Icons.star : Icons.star_border,
                    color: med.isFavoris ? Colors.amber : Colors.grey[400],
                    size: 24,
                  ),
                  onPressed: onFavorite,
                ),
              ],
            ),
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
                  : Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final med = filtered[index];
                            return _buildMedCard(
                              med,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PremiumPageRoute(
                                    page: MedicamentDetailsScreen(
                                      medicament: med,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Positioned(
                          right: 16,
                          top: 0,
                          bottom: 0,
                          child: AZNavigation(
                            availableLetters: filtered
                                .map((med) => med.name[0].toUpperCase())
                                .toSet(),
                            onLetterSelected: (letter) {
                              // Find the first item starting with the selected letter
                              final index = filtered.indexWhere(
                                (med) =>
                                    med.name.toUpperCase().startsWith(letter),
                              );
                              if (index != -1) {
                                _scrollController.animateTo(
                                  index * 80.0, // Approximate item height
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            // backgroundColor: _primaryColor.withValues(alpha: 0.1),
                            // selectedColor: _primaryColor,
                            // textColor: _primaryColor,
                            // selectedTextColor: Colors.white,
                            itemSize: 20,
                            //itemPadding: 2,
                          ),
                        ),
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}
