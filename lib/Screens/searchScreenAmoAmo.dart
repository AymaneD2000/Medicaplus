import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Screens/AmoView.dart';
import 'package:provider/provider.dart';
import 'package:sticky_az_list/sticky_az_list.dart';

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
      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filtered = widget.listes;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height*0.15,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Image.asset('assets/images/back.png', scale: 13,)),
              const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.75,
              child: TextField(
                autofocus: true,
                controller: searchController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0),borderSide: const BorderSide(color: Colors.green)),
                  suffixIcon: GestureDetector(onTap: (){
                    searchController.clear();
                    filtered = widget.listes;
                    setState(() {
                      
                    });
                  }, child: Image.asset('assets/images/fermer noir.png', scale: 20,)),
                  labelText: widget.hintText,
                  labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onChanged: (query){
                  filtered = widget.listes.where((med) {
                    final medNameLower = removeDiacritics(med.name.toLowerCase());
                    final queryLower = removeDiacritics(query.toLowerCase());
                    return medNameLower.contains(queryLower);
                  }).toList();
              
                  setState(() {
                    filtered;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text("Aucun résultat trouvé", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)))
                    : StickyAzList(
                        options: const StickyAzOptions(
                          safeArea: EnableSafeArea(top: false, bottom: false
                          ),
                          startWithSpecialSymbol: true,
                            listOptions: ListOptions(showSectionHeader: false)),
                        items:  filtered,
                        builder: (context, index, items) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AmoDetailsScreen(
                                        medicament: items),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: BorderDirectional(
                                        bottom: BorderSide(width: 0.5))),
                                child: ListTile(
                                  leading: Image.asset(items.icon, scale: 12,),
                                  title: Text(
                                    items.name,
                                    style: const TextStyle(
                                        fontFamily: 'TimesNewRoman',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  subtitle: Text(items.prix.join(','),),
                                ),
                              ));
                        }),
              ),
    );

  }
}