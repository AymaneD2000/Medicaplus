// import 'dart:convert';
// import 'package:moussa_project/Models/med.dart';
// import 'package:sticky_az_list/sticky_az_list.dart';
// import 'package:flutter/material.dart';
// import 'package:moussa_project/Screens/medicamentdetailscreen.dart';

// // Styles personnalisés
// const TextStyle headerStyle = TextStyle(
//fontFamily: 'TimesNewRoman',
//   fontSize: 20.0,
//   fontWeight: FontWeight.bold,
// );

// const TextStyle subHeaderStyle = TextStyle(
//fontFamily: 'TimesNewRoman',
//   fontSize: 16.0,
//   color: Colors.grey,
// );

// class MedicamentsScreen extends StatefulWidget {
//   @override
//   _MedicamentsScreenState createState() => _MedicamentsScreenState();
// }

// class _MedicamentsScreenState extends State<MedicamentsScreen> {
//   List<dynamic> medicamentsData = [];
//  // List<dynamic> alias = [];
//   // final tabs = <Tab>[
//   //   const Tab(
//   //     icon: Icon(Icons.list, size: 30),
//   //     text: "Par Nom",
//   //   ),
//   //   const Tab(
//   //     icon: Icon(Icons.category, size: 30),
//   //     text: "Par Classe",
//   //   ),
//   // ];

//   @override
//   void initState() {
//     super.initState();
//     _loadMedicamentsData();
//   }

//   List<Med> medNameList = [];

//   Future<void> _loadMedicamentsData() async {
//     String data = await DefaultAssetBundle.of(context)
//         .loadString('assets/Medicament.json');
//     setState(() {
//       medicamentsData = json.decode(data);
//     });

//     //Rassembler tous les alias et les mettre en unique
//     //alias = medicamentsData.map((toElement)=>toElement['Classe Thérapeutique']).toList();
//     medNameList =
//         medicamentsData.map((item) => Med.fromSanpshot(item)).toList();
//     print(medNameList);
//     //print(alias);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body:
//             Column(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.1,
//                   color: Colors.blue,
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.medical_information,
//                         size: 40,
//                       ),
//                       Text(
//                         "MedicaPlus",
//                         style: TextStyle(
//fontFamily: 'TimesNewRoman',fontSize: 23),
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.89,
//                   child: StickyAzList(
//                       options: const StickyAzOptions(
//                           listOptions: ListOptions(showSectionHeader: false)),
//                       items: medNameList,
//                       builder: (context, index, items) {
//                         return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MedicamentDetailsScreen(
//                                       medicament: medNameList[index]),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                   border: BorderDirectional(
//                                       bottom: BorderSide(width: 0.5))),
//                               child: ListTile(
//                                   //shape: ShapeBorder.lerp(a, b, t),
//                                   //style: ListTileStyle.drawer,
//                                   title: Text(items.name)),
//                             ));
//                       }),
//                 )
//               ],
//             ));
//             // _bui;
//   }

//   // Widget _buildMedicamentsList() {
//   //   return ListView.builder(
//   //     itemCount: medicamentsData.length,
//   //     itemBuilder: (BuildContext context, int index) {
//   //       final medicament = medicamentsData[index];
//   //       return Hero(
//   //         tag: medicament['Médicament'],
//   //         child: MedicamentCard(medicament: medicament),
//   //       );
//   //     },
//   //   );
//   // }

//   Widget _buildAliasGrid() {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//       ),
//       itemCount: alias.length,
//       itemBuilder: (context, index) {
//         final aliasName = alias[index];

//         return GestureDetector(
//           onTap: () {
//             List<dynamic> meds = [];
//             //meds.contains(element)
//             medicamentsData.forEach((element) {
//               if (element['Classe Thérapeutique'].contains(alias[index])) {
//                 meds.add(element);
//               }
//             });
//             print(meds.length);
//           },
//           child: Card(
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.category, color: Colors.blue, size: 40),
//                   const SizedBox(height: 8),
//                   Text(
//                     aliasName,
//                     style: headerStyle,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // class MedicamentCard extends StatelessWidget {
// //   final dynamic medicament;

// //   const MedicamentCard({
// //     Key? key,
// //     required this.medicament,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) =>
// //                 MedicamentDetailsScreen(medicament: medicament),
// //           ),
// //         );
// //       },
// //       child: Card(
// //         margin: const EdgeInsets.all(2.0),
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(15.0),
// //         ),
// //         elevation: 5,
// //         child: Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [Colors.white, Colors.blue.withOpacity(0.2)],
// //             ),
// //             borderRadius: BorderRadius.circular(15.0),
// //           ),
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 children: [
// //                   Icon(Icons.medical_services, color: Colors.blue),
// //                   const SizedBox(width: 8),
// //                   Text(
// //                     medicament['Médicament'],
// //                     style: headerStyle,
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 '${medicament['Classe Thérapeutique'].join(', ')}',
// //                 style: subHeaderStyle,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// }

import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:moussa_project/Screens/categorieMedicamentView.dart';
import 'package:provider/provider.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moussa_project/Screens/medicamentdetailscreen.dart';
import 'dart:io';

// Styles personnalisés
const TextStyle headerStyle = TextStyle(
fontFamily: 'TimesNewRoman',
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const TextStyle subHeaderStyle = TextStyle(
fontFamily: 'TimesNewRoman',
  fontSize: 16.0,
  color: Colors.grey,
);

class MedicamentsScreen extends StatefulWidget {
  @override
  _MedicamentsScreenState createState() => _MedicamentsScreenState();
}

class _MedicamentsScreenState extends State<MedicamentsScreen> {
    //List<dynamic> medicamentsData = [];
 List<dynamic> classth = [];
  final tabs = <Tab>[
    Tab(
      icon: Image.asset("assets/images/az.png", height: 21,),
      text: "Nom",
    ),
    Tab(
      icon: Image.asset("assets/images/classe.png", height: 21,),
      text: "Classe",
    ),
    Tab(
      icon: Image.asset("assets/images/star.png", height: 21,),
      text: "Favoris",
    ),
    Tab(
      icon: Image.asset("assets/images/info.png", height: 21,),
      text: "Info",
    ),
  ];
  List<Med> medNameList = [];
  List<Med> favoris = [];
  List<Med> filteredMedNameList = [];
  bool isLoading = true;
    TextEditingController searchController = TextEditingController();
  TextEditingController searchController1 = TextEditingController();
  TextEditingController searchController2 = TextEditingController();
  List<Med> filtered = [];
  List<Med> filtered1 = [];
  List<Med> filtered2 = [];
  MyProvider provider = MyProvider();
  @override
  void initState() {
    super.initState();
    filtered = context.read<MyProvider>().medicament;
     filtered1 = context.read<MyProvider>().medicament;
     filtered2 = context.read<MyProvider>().favorisMedicaments;
    //_loadMedicamentsData();
  }

  // Future<void> _loadMedicamentsData() async {
  //   provider.loadMedicamentData();
  // }

  // void _filterMedicaments(String query) {
  //   final filtered = medNameList.where((med) {
      
  //     final medNameLower = med.name.toLowerCase();
  //     final queryLower = query.toLowerCase();
  //     return medNameLower.contains(queryLower);
  //   }).toList();

  //   setState(() {
  //     filteredMedNameList = filtered;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        body: 
            TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      color: Colors.blue,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Rechercher des médicaments...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (query){
                          filtered = context.read<MyProvider>().medicament.where((med) {
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.79,
                      child:filtered.isEmpty
                              ? Center(child: Text("No data available"))
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
                                              title: Text(items.name, style: TextStyle(fontWeight: FontWeight.w700),),
                                              subtitle: Text(items.nomCommercial.join('\n')),),
                                        ));
                                  }),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        color: Colors.blue,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Rechercher des médicaments...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onChanged: (query){
                          filtered1 = context.read<MyProvider>().medicament.where((med) {
                            final medNameLower = removeDiacritics(med.name.toLowerCase());
                            final queryLower = removeDiacritics(query.toLowerCase());
                            return medNameLower.contains(queryLower);
                          }).toList();

                          setState(() {
                            filtered1;
                          });
                  },
                        ),
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.69,
                      child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: context.watch<MyProvider>().classMedicament.length,
                            itemBuilder: (context, index) {
                              final aliasName = context.watch<MyProvider>().classMedicament[index];
                              final images = context.watch<MyProvider>().iconsMed;
                              final icons =  context.watch<MyProvider>().imagesMed;
                              print(images);
                              String image = "";
                              String icon = "";
                              for(final i in images){
                                if(i.split('icon/')[1].split('.')[0] == aliasName){
                                  image = i;
                                }
                              }
                              for(final i in icons){
                                if(i.split('images/')[1].split('.')[0] == aliasName){
                                  icon = i;
                                }
                              }

                              return GestureDetector(
                                onTap: () {
                                  List<dynamic> meds = [];
                                  //meds.contains(element)
                                  context.read<MyProvider>().medicament.forEach((element) {
                                    //for(final cl in classth[index]){
                                  if (element.classtherapique.contains(context.read<MyProvider>().classMedicament[index])) {
                                  meds.add(element);
                                    }
                                    //}
                                  });
                                  Navigator.push(
                                    context,MaterialPageRoute(builder: (context)=>CategorieMedicament(images: icon, meds: meds,name: context.watch<MyProvider>().classMedicament[index],))
                                    );
                                  print(meds.length);
                                },
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(image, height: 50,),
                                        const SizedBox(height: 8),
                                        Text(
                                          aliasName,
                                          style: headerStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      color: Colors.blue,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Rechercher des médicaments...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (query){
                            filtered2 = context.read<MyProvider>().favorisMedicaments.where((med) {
                              final medNameLower = removeDiacritics(med.name.toLowerCase());
                              final queryLower = removeDiacritics(query.toLowerCase());
                              return medNameLower.contains(queryLower);
                            }).toList();

                            setState(() {
                              filtered2;
                            });
                          },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.79,
                      child: filtered2.isEmpty
                              ? Center(child: Text("No data available"))
                              : StickyAzList(
                                  options: const StickyAzOptions(
                                      listOptions: ListOptions(showSectionHeader: false)),
                                  items: filtered2,
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
                                              title: Text(items.name, style: TextStyle(fontWeight: FontWeight.w700),),
                                              subtitle: Text(items.nomCommercial.join('\n')),),
                                        ));
                                  }),
                    )
                  ],
                ),
              ),
              Container(
                child: Text("Info"),
              )
            ],
          ),
        bottomNavigationBar: TabBar(
        //indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.blue)),
        tabs: tabs, 
        splashBorderRadius: BorderRadius.circular(20), 
        onTap: (i){
          setState(() {
          
          });
        },
        indicatorColor: Colors.blue,
        labelColor: Colors.blue,),
      ));
    
  }

//   Widget _buildAliasGrid() {
//     return 
// }
}