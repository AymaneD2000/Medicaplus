// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:medpharm/Screens/medicamentdetailscreen.dart';
import 'package:medpharm/Utils/transitions.dart';

class CategorieMedicament extends StatefulWidget {
  CategorieMedicament(
      {super.key,
      required this.images,
      required this.meds,
      required this.name});
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.name),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height,
              child: ClipRRect(
                child: Image.asset(
                  widget.images,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.71,
              child: ListView.builder(
                  itemCount: widget.meds.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PremiumPageRoute(
                              page: MedicamentDetailsScreen(
                                  medicament: widget.meds[index]),
                            ),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              border: BorderDirectional(
                                  bottom: BorderSide(width: 0.5))),
                          child: ListTile(title: Text(widget.meds[index].name)),
                        ));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
