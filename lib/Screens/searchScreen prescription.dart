// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medpharm/Models/prescription.dart';
import 'package:medpharm/Screens/pdfassetsviewer.dart';

class SearchPrescriptionScreen extends StatefulWidget {
  List<Prescription> listes;
  String hintText;

  SearchPrescriptionScreen(
      {super.key, required this.listes, required this.hintText});

  @override
  State<SearchPrescriptionScreen> createState() =>
      _SearchPrescriptionScreenState();
}

class _SearchPrescriptionScreenState extends State<SearchPrescriptionScreen> {
  TextEditingController searchController = TextEditingController();
  List<Prescription> filtered = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filtered = widget.listes;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.15,
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/back.png',
                    scale: 13,
                  )),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  autofocus: true,
                  controller: searchController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Color(0xfffc6e6ff))),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          searchController.clear();
                          filtered = widget.listes;
                          setState(() {});
                        },
                        child: Image.asset(
                          'assets/images/fermer noir.png',
                          scale: 20,
                        )),
                    labelText: widget.hintText,
                    labelStyle: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onChanged: (query) {
                    filtered = widget.listes.where((med) {
                      final medNameLower =
                          removeDiacritics(med.name.toLowerCase());
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
            ? const Center(
                child: Text("Aucun résultat trouvé",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)))
            : Column(children: [
                Expanded(
                    child:
                        // StickyAzList(
                        //     options: const StickyAzOptions(
                        //         startWithSpecialSymbol: true,
                        //         listOptions: ListOptions(
                        //             headerColor: Color(0xfffc6e6ff),
                        //             showSectionHeader: true)),
                        //     items: filtered,
                        //     builder: (context, index, items) {
                        //       return GestureDetector(
                        //           onTap: () {
                        //             Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                   builder: (context) => PDFAssetScreen(
                        //                     path:
                        //                         "assets/prescription/${items.name}",
                        //                   ),
                        //                 ));
                        //           },
                        //           child: Container(
                        //             decoration: const BoxDecoration(
                        //                 border: BorderDirectional(
                        //                     bottom: BorderSide(width: 0.5))),
                        //             child: ListTile(
                        //               title: Text(items.name.split(".")[0]),
                        //             ),
                        //           ));
                        //     })
                        Center())
              ]));
  }
}
