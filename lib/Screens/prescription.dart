import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medpharm/Models/med.dart';
import 'package:medpharm/Models/prescription.dart';
import 'package:medpharm/Screens/searchScreen%20prescription.dart';

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

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  //List<dynamic> medicamentsData = [];
  List<dynamic> classth = [];
  final tabs = <Tab>[
    const Tab(
      icon: Icon(Icons.sort_by_alpha, size: 21),
      text: "Nom",
    ),
    const Tab(
      icon: Icon(Icons.info_outline, size: 21),
      text: "Info",
    ),
  ];
  List<Med> medNameList = [];
  List<Med> filteredMedNameList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_loadMedicamentsData();
  }

  Future<List<String>> loadPdfFileNames() async {
    // Load the asset manifest
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter the asset files to get only the PDF files
    final pdfFiles = manifestMap.keys
        .where((String key) =>
            key.startsWith('assets/prescription/') && key.endsWith('.pdf'))
        .toList();

    // Extract the file names from the paths
    pdfFiles.map((filePath) => filePath.split('/').last).toList();
    return pdfFiles;
  }

//   Future<void> _loadMedicamentsData() async {
//     List<String> data = await loadPdfFileNames();
//     setState(() {
//       medNameList =
//           (json.decode(data) as List).map((item) => Med.fromSanpshot(item)).toList();
//       filteredMedNameList = medNameList;
//       for(final med in medNameList){
//         for(final cl in med.classtherapique)
//           classth.add(cl);
//         classth = classth.toSet().toList();
//       }
// //     medNameList =
// //         medicamentsData.map((item) => Med.fromSanpshot(item)).toList();
//       isLoading = false;
//     });
//     print(medNameList);
//     print("end");
//   }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            Column(
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
                        "MedPharm",
                        style: TextStyle(
                            fontFamily: 'TimesNewRoman', fontSize: 23),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final list = await loadPdfFileNames();
                    final data = list
                        .map((filePath) => filePath.split('/').last)
                        .toList();
                    final listes =
                        List.generate(growable: true, data.length, (index) {
                      return Prescription(name: data[index]);
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchPrescriptionScreen(
                                listes: listes,
                                hintText: 'Rechercher des Noms...')));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
                    child: TextField(
                      enabled: false,
                      autofocus: false,
                      //controller: searchController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(color: Colors.green)),
                        suffixIcon: const Icon(
                          Icons.search,
                          size: 20,
                        ),
                        hintText: 'Rechercher des Noms...',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<String>>(
                    future: loadPdfFileNames(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No PDF files found.'));
                      } else {
                        return const Center();
                        // return StickyAzList(
                        //     options: const StickyAzOptions(
                        //         startWithSpecialSymbol: true,
                        //         listOptions: ListOptions(
                        //             headerColor: const Color(0xfffc6e6ff),
                        //             showSectionHeader: true)),
                        //     items: list,
                        //     builder: (context, index, items) {
                        //       return GestureDetector(
                        //           onTap: () {
                        //             Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                   builder: (context) => PDFAssetScreen(
                        //                       path:
                        //                           "assets/prescription/${items.name}",
                        //                       name: items.name.split(".")[0]),
                        //                 ));
                        //           },
                        //           child: Container(
                        //             decoration: const BoxDecoration(
                        //                 border: BorderDirectional(
                        //                     bottom: BorderSide(width: 0.5))),
                        //             child: ListTile(
                        //               title: Text(
                        //                 items.name.split(".")[0],
                        //                 style: const TextStyle(
                        //                     fontWeight: FontWeight.bold),
                        //               ),
                        //             ),
                        //           ));
                        //     });
                      }
                    },
                  ),
                ),
              ],
            ),
            // Placeholder for the second tab content
            const Center(child: Text('Second Tab')),
          ],
        ),
        bottomNavigationBar: TabBar(
          //indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.blue)),
          tabs: tabs,
          splashBorderRadius: BorderRadius.circular(20),
          onTap: (i) {
            setState(() {});
          },
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
        ),
      ),
    );
  }
}
