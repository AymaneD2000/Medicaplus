import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:moussa_project/Models/prescription.dart';
import 'package:moussa_project/Screens/categorieMedicamentView.dart';
import 'package:moussa_project/Screens/pdfassetsviewer.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'package:moussa_project/Screens/medicamentdetailscreen.dart';

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
  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
    //List<dynamic> medicamentsData = [];
 List<dynamic> classth = [];
  final tabs = <Tab>[
    const Tab(
      icon: Icon(Icons.list, size: 30),
      text: "Par Nom",
    ),
    const Tab(
      icon: Icon(Icons.category, size: 30),
      text: "Par Classe",
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
      .where((String key) => key.startsWith('assets/prescription/') && key.endsWith('.pdf'))
      .toList();

  // Extract the file names from the paths
  final pdfFileNames = pdfFiles.map((filePath) => filePath.split('/').last).toList();
  print("$pdfFileNames");
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
  return DefaultTabController(
    length: 2,
    initialIndex: 0,
    child: Scaffold(
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
                          "MedicaPlus",
                          style: TextStyle(
                          fontFamily: 'TimesNewRoman',fontSize: 23),
                        )
                      ],
                    ),
                  ),
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: loadPdfFileNames(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No PDF files found.'));
                    } else {
                      final data = snapshot.data!.map((filePath) => filePath.split('/').last).toList();
                      final list = List.generate(growable: true, data.length, (index){
                        return Prescription(name: data[index]);
                      });
                      return StickyAzList(
                                options: const StickyAzOptions(
                                  startWithSpecialSymbol: true,
                                    listOptions: ListOptions(showSectionHeader: false)),
                                items: list,
                                builder: (context, index, items) {
                                  return GestureDetector(
                                      onTap: () {
                                        print("${items.name}");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFAssetScreen(path: "assets/prescription/${items.name}",),
                                        ));
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            border: BorderDirectional(
                                                bottom: BorderSide(width: 0.5))),
                                        child: ListTile(
                                            title: Text(items.name),),
                                      ));
                                });
                    }
                  },
                ),
              ),
            ],
          ),
          // Placeholder for the second tab content
          Center(child: Text('Second Tab')),
        ],
      ),
      bottomNavigationBar: TabBar(
        tabs: tabs,
      ),
    ),
  );
}

  Widget _buildAliasGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: classth.length,
      itemBuilder: (context, index) {
        final aliasName = classth[index];

        return GestureDetector(
          onTap: () {
            List<dynamic> meds = [];
            //meds.contains(element)
            medNameList.forEach((element) {
              //for(final cl in classth[index]){
                if (element.classtherapique.contains(classth[index])) {
                meds.add(element);
              }
              //}
            });
            Navigator.push(
              context,MaterialPageRoute(builder: (context)=>CategorieMedicament(images: "", meds: meds,name: classth[index],))
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
                  Icon(Icons.category, color: Colors.blue, size: 40),
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
    );
  }
}


