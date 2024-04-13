import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moussa_project/Screens/medicamentdetailscreen.dart';

class MedicamentsScreen extends StatefulWidget {
  @override
  _MedicamentsScreenState createState() => _MedicamentsScreenState();
}

class _MedicamentsScreenState extends State<MedicamentsScreen> {
  List<dynamic> medicamentsData = [];

  @override
  void initState() {
    super.initState();
    _loadMedicamentsData();
  }

  Future<void> _loadMedicamentsData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/medicament.json');
    setState(() {
      medicamentsData = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des médicaments'),
      ),
      body: ListView.builder(
        itemCount: medicamentsData.length,
        itemBuilder: (BuildContext context, int index) {
          final medicament = medicamentsData[index];
          return MedicamentCard(medicament: medicament);
        },
      ),
    );
  }
}

class MedicamentCard extends StatelessWidget {
  final dynamic medicament;

  const MedicamentCard({
    Key? key,
    required this.medicament,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicament['Médicament'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              '${medicament['Action Thérapeutique']}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MedicamentDetailsScreen(medicament: medicament),
                  ),
                );
              },
              child: Text('Voir les détails'),
            ),
          ],
        ),
      ),
    );
  }
}
