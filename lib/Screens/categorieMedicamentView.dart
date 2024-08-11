import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:moussa_project/Screens/medicamentdetailscreen.dart';

class CategorieMedicament extends StatefulWidget {
  CategorieMedicament({super.key, required this.images, required this.meds, required this.name});
  List<dynamic> meds;
  String name;
  String images;
  @override
  State<CategorieMedicament> createState() => _CategorieMedicamentState();
}

class _CategorieMedicamentState extends State<CategorieMedicament> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name),),
      body: Column(
        children: [
          SizedBox(
            height:  MediaQuery.of(context).size.height* 0.15, 
            child: Image.asset(widget.images)),
          SizedBox(
            height: MediaQuery.of(context).size.height* 0.75,
            child: ListView.builder(itemCount: widget.meds.length, itemBuilder: (context,index){
              return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicamentDetailsScreen(
                              medicament: widget.meds[index]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          border: BorderDirectional(
                              bottom: BorderSide(width: 0.5))),
                      child: ListTile(
                          title: Text(widget.meds[index].name)),
                    ));
            }),
          ),
        ],
      ),
    );
  }
}