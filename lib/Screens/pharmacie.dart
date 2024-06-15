import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'package:moussa_project/Screens/AmoView.dart';

class PharmacieScreen extends StatefulWidget {
  @override
  _PharmacieScreenState createState() => _PharmacieScreenState();
}

class _PharmacieScreenState extends State<PharmacieScreen> {
  Future<String>? data;
  List<Amo> medNameList = [];
  List<Amo> filteredMedNameList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMedicamentsData();
  }

  Future<void> _loadMedicamentsData() async {
    try {
      String jsonData =
          await DefaultAssetBundle.of(context).loadString('assets/amo.json');
      setState(() {
        medNameList = (json.decode(jsonData) as List)
            .map((item) => Amo.fromSanpshot(item))
            .toList();
        filteredMedNameList = medNameList;
      });
    } catch (e) {
      print("Error loading JSON data: $e");
    }
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
          Flexible(
            child: filteredMedNameList.isEmpty
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
                                builder: (context) => AmoDetailsScreen(
                                    medicament: filteredMedNameList[index]),
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
                    }),
          )
        ],
      ),
    );
  }
}
