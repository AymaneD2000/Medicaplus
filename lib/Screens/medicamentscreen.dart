// import 'dart:convert';
// import 'package:moussa_project/Models/med.dart';
// import 'package:sticky_az_list/sticky_az_list.dart';
// import 'package:flutter/material.dart';
// import 'package:moussa_project/Screens/medicamentdetailscreen.dart';

// // Styles personnalisés
// const TextStyle headerStyle = TextStyle(
//   fontSize: 20.0,
//   fontWeight: FontWeight.bold,
// );

// const TextStyle subHeaderStyle = TextStyle(
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
//                         style: TextStyle(fontSize: 23),
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

// //   Widget _buildAliasGrid() {
// //     return GridView.builder(
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 2,
// //         crossAxisSpacing: 10,
// //         mainAxisSpacing: 10,
// //       ),
// //       itemCount: alias.length,
// //       itemBuilder: (context, index) {
// //         final aliasName = alias[index];

// //         return GestureDetector(
// //           onTap: () {
// //             List<dynamic> meds = [];
// //             //meds.contains(element)
// //             medicamentsData.forEach((element) {
// //               if (element['Classe Thérapeutique'].contains(alias[index])) {
// //                 meds.add(element);
// //               }
// //             });
// //             print(meds.length);
// //           },
// //           child: Card(
// //             elevation: 5,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(15.0),
// //             ),
// //             child: Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.category, color: Colors.blue, size: 40),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     aliasName,
// //                     style: headerStyle,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

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
import 'package:flutter/material.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'package:moussa_project/Screens/medicamentdetailscreen.dart';

// Styles personnalisés
const TextStyle headerStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const TextStyle subHeaderStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.grey,
);

class MedicamentsScreen extends StatefulWidget {
  @override
  _MedicamentsScreenState createState() => _MedicamentsScreenState();
}

class _MedicamentsScreenState extends State<MedicamentsScreen> {
  List<Med> medNameList = [];
  List<Med> filteredMedNameList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMedicamentsData();
  }

  Future<void> _loadMedicamentsData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/Medicament.json');
    setState(() {
      medNameList =
          (json.decode(data) as List).map((item) => Med.fromSanpshot(item)).toList();
      filteredMedNameList = medNameList;
      isLoading = false;
    });
    print(medNameList);
    print("end");
  }

  void _filterMedicaments(String query) {
    final filtered = medNameList.where((med) {
      final medNameLower = med.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return medNameLower.contains(queryLower);
    }).toList();

    setState(() {
      filteredMedNameList = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    style: TextStyle(fontSize: 23),
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
                onChanged: _filterMedicaments,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.79,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredMedNameList.isEmpty
                      ? Center(child: Text("No data available"))
                      : StickyAzList(
                          options: const StickyAzOptions(
                              listOptions: ListOptions(showSectionHeader: false)),
                          items: filteredMedNameList,
                          builder: (context, index, items) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MedicamentDetailsScreen(
                                          medicament: filteredMedNameList[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: BorderDirectional(
                                          bottom: BorderSide(width: 0.5))),
                                  child: ListTile(
                                      title: Text(items.name)),
                                ));
                          }),
            )
          ],
        ),
      ),
    );
  }
}
