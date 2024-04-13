import 'package:flutter/material.dart';

class MedicamentDetailsScreen extends StatelessWidget {
  final dynamic medicament;

  const MedicamentDetailsScreen({Key? key, required this.medicament})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du médicament'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Row(
                children: [
                  const Text(
                    'Médicament : ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  Text(medicament['Médicament']),
                ],
              ),
            ),
            medicament['Alias'] == ""
                ? Container()
                : ListTile(
                    title: Text('Alias : ${medicament['Alias']}'),
                  ),
            // ListTile(
            //   title: Text('Prescription : ${medicament['prescription']}'),
            // ),
            ListTile(
              title: Text(
                  'Action thérapeutique : ${medicament['Action Thérapeutique']}'),
            ),
            ListTile(
              title:
                  Text('Indications : ${medicament['Indications'].join(', ')}'),
            ),
            ListTile(
              title: Text(
                  'Forme et Présentation : ${medicament['Forme et Présentation'].join(', ')}'),
            ),
            ListTile(
              title: Text(
                  'Posologie et Durée : ${medicament['Posologie et Durée'].join(', ')}'),
            ),
            ListTile(
              title: Text(
                  'Contre indications : ${medicament['Contre-indications'].join(', ')}'),
            ),
            ListTile(
              title: Text(
                  'Effets indésirables : ${medicament['Effets indésirables'].join(', ')}'),
            ),
            ListTile(
              title: Text(
                  'Grossesse et Allaitement : ${medicament['Grossesse et Allaitement']}'),
            ),
            ListTile(
              title:
                  Text('Précautions : ${medicament['Précautions'].join(', ')}'),
            ),
            ListTile(
              title: Text(
                  'Grossesse et Allaitement : ${medicament['Grossesse et Allaitement'].join(', ')}'),
            ),
          ],
        ),
      ),
    );
  }
}
