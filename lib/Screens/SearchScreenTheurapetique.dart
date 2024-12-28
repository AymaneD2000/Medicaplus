import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Screens/AmoView.dart';
import 'package:moussa_project/Screens/categorieMedicamentView.dart';
import 'package:provider/provider.dart';
import 'package:sticky_az_list/sticky_az_list.dart';

class SearchClasseTheuraScreenDCI extends StatefulWidget {
  List<ClassMed> listes;
  List<String> iconMeds;
  String hintText;

  SearchClasseTheuraScreenDCI({super.key,required this.iconMeds, required this.listes, required this.hintText});

  @override
  State<SearchClasseTheuraScreenDCI> createState() => _SearchClasseTheuraScreenDCIState();
}

class _SearchClasseTheuraScreenDCIState extends State<SearchClasseTheuraScreenDCI> {
    TextEditingController searchController = TextEditingController();
      List<ClassMed> filtered = [];
      List<String> iconMeds = [];
      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filtered = widget.listes;
    iconMeds = widget.iconMeds;
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
                    final medNameLower = removeDiacritics(med.clname.toLowerCase());
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
                              ? const Center(child: Text("No data available"))
                              : StickyAzList(
                                  options: const StickyAzOptions(
                                      listOptions: ListOptions(showSectionHeader: false, stickySectionHeader: false)),
                                  items: filtered,
                                  builder: (context, index, items) {
                                    final aliasName = filtered[index].clname;
                                    final icons =  iconMeds;
                                    String icon = "";
                              for(final i in icons){
                                print(i.split('images/')[0]);
                                print(i.split('images/')[1].split('.')[0]);
                                if(i.split('images/')[1].split('.')[0] == aliasName){
                                  icon = i;
                                }
                              }
                                    return GestureDetector(
                                        onTap: () {
    List<dynamic> meds = [];
    context.read<MyProvider>().medicament.forEach((element) {
      if (element.classtherapique.contains(filtered[index].clname)) {
        meds.add(element);
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategorieMedicament(
          images: icon,
          meds: meds,
          name: filtered[index].clname,
        ),
      ),
    );
    print(meds.length);
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              border: BorderDirectional(
                                                  bottom: BorderSide(width: 0.5))),
                                          child: ListTile(
                                              title: Text(items.clname, style: const TextStyle(fontWeight: FontWeight.w700),),),
                                        ));
                                  }),
    );

  }
}