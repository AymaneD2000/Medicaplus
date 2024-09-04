import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Screens/searchScreen.dart';
import 'package:moussa_project/Screens/searchScreenAmoAmo.dart';
import 'package:moussa_project/Screens/searchScreenAmoDCI.dart';
import 'package:provider/provider.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'package:moussa_project/Screens/AmoView.dart';

class PharmacieScreen extends StatefulWidget {
  const PharmacieScreen({super.key});

  @override
  _PharmacieScreenState createState() => _PharmacieScreenState();
}

class _PharmacieScreenState extends State<PharmacieScreen> {
  Future<String>? data;
  List<dynamic> classth = [];
  final tabs = <Tab>[
    Tab(
      icon: Image.asset("assets/images/az.png", height: 25,),
      text: "Nom",
    ),
    Tab(
      icon: Image.asset("assets/images/dci.png", height: 25,),
      text: "D.C.I",
      //child: Container(color: Colors.amber,),
    ),
    Tab(
      icon: Image.asset("assets/images/amo1.png", height: 25,),
      text: "Amo",
    ),
    Tab(
      icon: Image.asset("assets/images/star.png", height: 25,),
      text: "Favoris",
    )
  ];
 
  // List<Amo> medNameList = [];
  // List<Amo> filteredMedNameList = [];
  // TextEditingController searchController = TextEditingController();
  // TextEditingController searchController1 = TextEditingController();
  // TextEditingController searchController2 = TextEditingController();
  // TextEditingController searchController3 = TextEditingController();
  // List<Amo> filtered = [];
  // List<Amo> filtered1 = [];
  // List<Amo> filtered2 = [];
  // List<Amo> filtered3 = [];

  @override
  void initState() {
    super.initState();
    //  filtered = context.read<MyProvider>().pharmacies;
    //  filtered1 = context.read<MyProvider>().pharmacies;
    //  filtered2 = context.read<MyProvider>().pharmacies;
    //  filtered3 = context.read<MyProvider>().favorisPharmacies;
    //_loadMedicamentsData();
  }

  // Future<void> _loadMedicamentsData() async {
  //   try {
  //     String jsonData =
  //         await DefaultAssetBundle.of(context).loadString('assets/Pharmacie 1.json');
  //     setState(() {
  //       medNameList = (json.decode(jsonData) as List)
  //           .map((item) => Amo.fromSanpshot(item))
  //           .toList();
  //       filteredMedNameList = medNameList;
  //     });
  //   } catch (e) {
  //     print("Error loading JSON data: $e");
  //   }
  // }


  // void _filterMedicamentsDCI(String query) {
    
  // }

  // void _filterMedicamentsAMO(String query) {
    
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        body: TabBarView(
          children: [Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                color: Colors.green,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_information,
                      size: 40,
                    ),
                    Text(
                      "MedicaPlus",
                      style: TextStyle(
                      fontFamily: 'TimesNewRoman',fontSize: 23),
                    ),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     GestureDetector(onTap: (){
              //             Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchAmoScreen(listes: context.read<MyProvider>().pharmacies, hintText: 'Rechercher des Noms...')));
              //           }, child: Image.asset('assets/images/recherche.png', scale: 20,)),
              //           Gap(40)
              //   ],
              // ),
              GestureDetector(
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchAmoScreen(listes: context.read<MyProvider>().pharmacies, hintText: 'Rechercher des Noms...')));
                    },
                child: Padding(  
                  padding: const EdgeInsets.only(left:  16.0, right: 16.0, top: 8),
                  child: TextField(
                    enabled: false,
                    autofocus: false,
                    //controller: searchController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0),borderSide: const BorderSide(color: Colors.green)),
                      suffixIcon: Image.asset('assets/images/recherche.png', scale: 20,),
                      hintText: 'Rechercher des Noms...',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    // onChanged: (query){
                    //   // filtered = context.read<MyProvider>().pharmacies.where((med) {
                    //   //   final medNameLower = removeDiacritics(med.name.toLowerCase());
                    //   //   final queryLower = removeDiacritics(query.toLowerCase());
                    //   //   return medNameLower.contains(queryLower);
                    //   // }).toList();
                
                    //   // setState(() {
                    //   //   filtered;
                    //   // });
                
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchAmoScreen(listes: context.read<MyProvider>().pharmacies, hintText: 'Rechercher des Noms...')));
                
                    // },
                  ),
                ),
              ),
              Expanded(
                child: context.watch<MyProvider>().pharmacies.isEmpty
                    ? const Center(child: Text("Aucun résultat trouvé", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)))
                    : StickyAzList(
                        options: const StickyAzOptions(
                          safeArea: EnableSafeArea(top: false, bottom: false
                          ),
                          startWithSpecialSymbol: true,
                            listOptions: ListOptions(showSectionHeader: false)),
                        items:  context.watch<MyProvider>().pharmacies,
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
                                  subtitle: Text(items.presantation.join(','),),
                                ),
                              ));
                        }),
              )
            ],
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                color: Colors.green,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_information,
                      size: 40,
                    ),
                    Text(
                      "MedicaPlus",
                      style: TextStyle(
                fontFamily: 'TimesNewRoman',fontSize: 23),
                    )
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left:  16.0, right: 16.0, top: 8),
              //   child: TextField(
              //     controller: searchController1,
              //     enabled: false,
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0),borderSide: BorderSide(color: Colors.green)),
              //       suffixIcon: Image.asset('assets/images/recherche.png', scale: 20,),
              //       hintText: 'Rechercher des D.C.I...',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(30.0),
              //       ),
              //     ),
              //     onChanged: (query){
              //       filtered1 = context.read<MyProvider>().pharmacies.where((med) {
              //         final medNameLower = removeDiacritics(med.dci.join().toLowerCase());
              //         final queryLower = removeDiacritics(query.toLowerCase());
              //         return medNameLower.contains(queryLower);
              //       }).toList();

              //       setState(() {
              //         filtered1;
              //       });
              //     },
              //   ),
              // ),
              GestureDetector(
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchAmoScreenDCI(listes: context.read<MyProvider>().pharmacies, hintText: 'Rechercher des D.C.I....')));
                    },
                child: Padding(  
                  padding: const EdgeInsets.only(left:  16.0, right: 16.0, top: 8),
                  child: TextField(
                    enabled: false,
                    autofocus: false,
                    //controller: searchController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0),borderSide: const BorderSide(color: Colors.green)),
                      suffixIcon: Image.asset('assets/images/recherche.png', scale: 20,),
                      hintText: 'Rechercher des D.C.I....',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),))),
              Expanded(
                child: context.watch<MyProvider>().pharmacies.isEmpty
                    ? const Center(child: Text("Aucun résultat trouvé", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28)))
                    : StickyAzList(
                        options: const StickyAzOptions(
                          safeArea: EnableSafeArea(top: false, bottom: false
                          ),
                          startWithSpecialSymbol: true,
                            listOptions: ListOptions(showSectionHeader: false)),
                        items: context.watch<MyProvider>().pharmacies,
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
                                        color: Colors.black),
                                  ),
                                  subtitle: Text(items.dci.join(','),
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold,),),
                                ),
                              ));
                        }),
              )
            ],
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                color: Colors.green,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_information,
                      size: 40,
                    ),
                    Text(
                      "MedicaPlus",
                      style: TextStyle(
                fontFamily: 'TimesNewRoman',fontSize: 23),
                    )
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left:  16.0, right: 16.0, top: 8),
              //   child: TextField(
              //     controller: searchController2,
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0),borderSide: BorderSide(color: Colors.green)),
              //       suffixIcon: Image.asset('assets/images/recherche.png', scale: 20,),
              //       hintText: 'Medicaments à l\'AMO...',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(30.0),
              //       ),
              //     ),
              //     onChanged: (query){
              //       filtered2 = context.read<MyProvider>().pharmacies.where((med) {
              //         final medNameLower = removeDiacritics(med.name.toLowerCase());
              //         final queryLower = removeDiacritics(query.toLowerCase());
              //         if(medNameLower.contains(queryLower) && med.amo == true)
              //         {
              //           return medNameLower.contains(queryLower);  
              //         }
              //         return false;
              //       }).toList();

              //       setState(() {
              //         filtered2;
              //       });
              //     },
              //   ),
              // ),
              GestureDetector(
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchAmoScreenAmo(listes: context.read<MyProvider>().pharmacies, hintText: 'Medicaments à l\'AMO...')));
                    },
                child: Padding(  
                  padding: const EdgeInsets.only(left:  16.0, right: 16.0, top: 8),
                  child: TextField(
                    enabled: false,
                    autofocus: false,
                    //controller: searchController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0),borderSide: const BorderSide(color: Colors.green)),
                      suffixIcon: Image.asset('assets/images/recherche.png', scale: 20,),
                      hintText: 'Medicaments à l\'AMO...',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),))),
              Expanded(
                child: context.watch<MyProvider>().pharmacies.isEmpty
                    ? const Center(child: Text("Aucun résultat trouvé",style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28)))
                    : StickyAzList(
                        options: const StickyAzOptions(
                          safeArea: EnableSafeArea(top: false, bottom: false
                          ),
                          startWithSpecialSymbol: true,
                            listOptions: ListOptions(showSectionHeader: false)),
                        items: context.watch<MyProvider>().pharmacies,
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
                                  subtitle: Text(items.prix.join(',')),
                                ),
                              ));
                        }),
              )
            ],
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                color: Colors.green,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_information,
                      size: 40,
                    ),
                    Text(
                      "MedicaPlus",
                      style: TextStyle(
                fontFamily: 'TimesNewRoman',fontSize: 23),
                    )
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left:  16.0, right: 16.0, top: 8),
              //   child: TextField(
              //     controller: searchController3,
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0),borderSide: BorderSide(color: Colors.green)),
              //       suffixIcon: Image.asset('assets/images/recherche.png', scale: 20,),
              //       hintText: 'Rechercher des Favoris...',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(30.0),
              //       ),
              //     ),
              //     onChanged: (query){
              //       filtered3 = context.read<MyProvider>().favorisPharmacies.where((med) {
              //         final medNameLower = removeDiacritics(med.name.toLowerCase());
              //         final queryLower = removeDiacritics(query.toLowerCase());
              //         return medNameLower.contains(queryLower);
              //       }).toList();
                
              //       setState(() {
              //         filtered3;
              //       });
              //     },
              //   ),
              // ),
              GestureDetector(
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchAmoScreen(listes: context.read<MyProvider>().favorisPharmacies, hintText: 'Rechercher des Favoris...')));
                    },
                child: Padding(  
                  padding: const EdgeInsets.only(left:  16.0, right: 16.0, top: 8),
                  child: TextField(
                    enabled: false,
                    autofocus: false,
                    //controller: searchController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(30.0),borderSide: const BorderSide(color: Colors.green)),
                      suffixIcon: Image.asset('assets/images/recherche.png', scale: 20,),
                      hintText: 'Rechercher des Favoris...',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),))),
              Expanded(
                child: context.watch<MyProvider>().favorisPharmacies.isEmpty
                    ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("Votre Favoris est vide", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                        Gap(10),
                        Center(child: Text("Favoris vous permet",style: TextStyle( fontSize: 16))),
                        Center(child: Text("de mettre de côté vos",style: TextStyle( fontSize: 16))),
                        Center(child: Text("médicaments préférés",style: TextStyle(fontSize: 16))),
                      ],
                    )
                    : StickyAzList(
                        options: const StickyAzOptions(
                          safeArea: EnableSafeArea(top: false, bottom: false
                          ),
                          startWithSpecialSymbol: true,
                            listOptions: ListOptions(showSectionHeader: false)),
                        items: context.watch<MyProvider>().favorisPharmacies,
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
                                  subtitle: Text(items.dci.join(',')),
                                ),
                              ));
                        }),
              )
            ],
          )
        ]),
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height*0.08, 
          child: TabBar(
            //indicator: BoxDecoration(color: Colors.green),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabs,
            labelColor: Colors.green,
            indicatorColor:Colors.green,)),
      ),
    );
  }
}
