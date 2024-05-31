
import 'dart:convert';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Screens/AmoView.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'package:flutter/material.dart';
// import 'package:moussa_project/Screens/medicamentdetailscreen.dart';

class PharmacieScreen extends StatefulWidget {
  @override
  _PharmacieScreenState createState() => _PharmacieScreenState();
}

class _PharmacieScreenState extends State<PharmacieScreen> {
  // List<dynamic> medicamentsData = [];
  // List<Amo> medNameList = [];
  Future<String>? data;

  @override
  void initState() {
    super.initState();
    _loadMedicamentsData();
  }

  Future<void> _loadMedicamentsData() async {
    try {
      data =
          DefaultAssetBundle.of(context).loadString('assets/amo.json');
      // setState(() async{
      //   medicamentsData = json.decode( await data);
      //   medNameList =
      //       medicamentsData.map((item) => Amo.fromSanpshot(item)).toList();
      // });
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
            child: FutureBuilder(future: data, builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              else if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              else if(snapshot.hasData){
                final medicamentData = json.decode(snapshot.data??"");
                List<Amo> medNameList = [];
            for (var item in medicamentData) {
              medNameList.add(Amo.fromSanpshot(item));
            }
             //medicamentData.map((item) => Amo.fromSanpshot(item)).toList();
             return StickyAzList(
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
                    );
              }
              else{
                return Text("No data available");
              }
            }),
          )
          // Flexible(
          //   // Utilisation de Flexible au lieu de Expanded
          //   child: medNameList.isEmpty
          //       ? Center(child: Text("No data available"))
          //       : 
          // ),
        ],
      ),
    );
  }
}
