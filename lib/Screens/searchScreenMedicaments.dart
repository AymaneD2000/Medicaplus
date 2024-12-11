import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:moussa_project/Screens/medicamentdetailscreen.dart';
import 'package:sticky_az_list/sticky_az_list.dart';

class SearchMedicamentScreen extends StatefulWidget {
  List<Med> listes;
  String hintText;

  SearchMedicamentScreen({super.key, required this.listes, required this.hintText});

  @override
  State<SearchMedicamentScreen> createState() => _SearchMedicamentScreenState();
}

class _SearchMedicamentScreenState extends State<SearchMedicamentScreen> {
    TextEditingController searchController = TextEditingController();
      List<Med> filtered = [];
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
                  focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0),borderSide: const BorderSide(color: Colors.blue)),
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
      body: filtered.isEmpty
              ? const Center(child: Text("Aucun résultat trouvé", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)))
              : StickyAzList(
                  options: const StickyAzOptions(
                      listOptions: ListOptions(showSectionHeader: false, stickySectionHeader: false)),
                  items: filtered,
                  builder: (context, index, items) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicamentDetailsScreen(
                                  medicament: items),
                            ),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              border: BorderDirectional(
                                  bottom: BorderSide(width: 0.5))),
                          child: ListTile(
                              title: Text(items.name, style: const TextStyle(fontWeight: FontWeight.w700),),
                              subtitle: Text(items.nomCommercial.join('\n')),),
                        ));
                  })
    );

  }
}