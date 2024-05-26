// import 'dart:convert';
// import 'package:moussa_project/Models/amo.dart';
// import 'package:moussa_project/Models/med.dart';
// import 'package:moussa_project/Screens/AmoView.dart';
// import 'package:sticky_az_list/sticky_az_list.dart';
// import 'package:flutter/material.dart';
// import 'package:moussa_project/Screens/medicamentdetailscreen.dart';

// // // Styles personnalisés
// // const TextStyle headerStyle = TextStyle(
// //   fontSize: 20.0,
// //   fontWeight: FontWeight.bold,
// // );

// // const TextStyle subHeaderStyle = TextStyle(
// //   fontSize: 16.0,
// //   color: Colors.grey,
// // );

// class PharmacieScreen extends StatefulWidget {
//   @override
//   _PharmacieScreenState createState() => _PharmacieScreenState();
// }

// class _PharmacieScreenState extends State<PharmacieScreen> {
//   List<dynamic> medicamentsData = [];
//   @override
//   void initState() {
//     super.initState();
//     _loadMedicamentsData();
//   }

//   List<Amo> medNameList = [];

//   Future<void> _loadMedicamentsData() async {
//     String data =
//         await DefaultAssetBundle.of(context).loadString('assets/amo.json');
//     setState(() {
//       medicamentsData = json.decode(data);
//     });

//     medNameList =
//         medicamentsData.map((item) => Amo.fromSanpshot(item)).toList();
//     //print(medNameList);
//   }

//   @override
//   Widget build(BuildContext context) {
//     try {
//       return Scaffold(
//         body: Column(
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.1,
//               color: Colors.blue,
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.medical_information,
//                     size: 40,
//                   ),
//                   Text(
//                     "MedicaPlus",
//                     style: TextStyle(fontSize: 23),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.89,
//               child: StickyAzList(
//                   options: const StickyAzOptions(
//                       listOptions: ListOptions(showSectionHeader: false)),
//                   items: medNameList,
//                   builder: (context, index, items) {
//                     return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AmoDetailsScreen(
//                                   medicament: medNameList[index]),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           decoration: const BoxDecoration(
//                               border: BorderDirectional(
//                                   bottom: BorderSide(width: 0.5))),
//                           child: ListTile(
//                               //shape: ShapeBorder.lerp(a, b, t),
//                               //style: ListTileStyle.drawer,
//                               title: Text(items.name)),
//                         ));
//                   }),
//             )
//           ],
//         ),
//       );
//     } catch (e) {
//       return Center(
//         child: Text("$e"),
//       );
//     }
//   }

// //   Widget _buildMedicamentsList() {
// //     return ListView.builder(
// //       itemCount: medicamentsData.length,
// //       itemBuilder: (BuildContext context, int index) {
// //         final medicament = medicamentsData[index];
// //         return Hero(
// //           tag: medicament['Nom commercial'],
// //           child: MedicamentCard(medicament: medicament),
// //         );
// //       },
// //     );
// //   }

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
// //               if (element['D.C.I/Composition'].contains(alias[index])) {
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
// //                     medicament['Nom commercial'],
// //                     style: headerStyle,
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 '${medicament['D.C.I/Composition'].join(', ')}',
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
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Screens/AmoView.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'package:flutter/material.dart';
import 'package:moussa_project/Screens/medicamentdetailscreen.dart';

class PharmacieScreen extends StatefulWidget {
  @override
  _PharmacieScreenState createState() => _PharmacieScreenState();
}

class _PharmacieScreenState extends State<PharmacieScreen> {
  List<dynamic> medicamentsData = [];
  List<Amo> medNameList = [];

  @override
  void initState() {
    super.initState();
    _loadMedicamentsData();
  }

  Future<void> _loadMedicamentsData() async {
    try {
      String data =
          await DefaultAssetBundle.of(context).loadString('assets/amo.json');
      setState(() {
        medicamentsData = json.decode(data);
        medNameList =
            medicamentsData.map((item) => Amo.fromSanpshot(item)).toList();
      });
    } catch (e) {
      print("Error loading JSON data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      body: Column(
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
                  style: TextStyle(fontSize: 23),
                )
              ],
            ),
          ),
          Flexible(
            // Utilisation de Flexible au lieu de Expanded
            child: medNameList.isEmpty
                ? Center(child: Text("No data available"))
                : StickyAzList(
                    options: const StickyAzOptions(
                        listOptions: ListOptions(showSectionHeader: false)),
                    items: medNameList,
                    builder: (context, index, items) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AmoDetailsScreen(
                                    medicament: medNameList[index]),
                              ),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                border: BorderDirectional(
                                    bottom: BorderSide(width: 0.5))),
                            child: ListTile(
                              title: Text(
                                items.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              subtitle: Text(items.dci.join(',')),
                            ),
                          ));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
