import 'package:flutter/material.dart';

// Define custom text styles
const TextStyle sectionTitleStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: Colors.teal,
);

const TextStyle detailTextStyle = TextStyle(
  fontSize: 16.0,
);

class MedicamentDetailsScreen extends StatelessWidget {
  final dynamic medicament;

  const MedicamentDetailsScreen({Key? key, required this.medicament})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du médicament'),
        backgroundColor: Colors.teal, // Maintain color consistency
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading:
                  Icon(Icons.medical_services, color: Colors.teal), // Add icon
              title: RichText(
                text: TextSpan(
                  style: detailTextStyle,
                  children: [
                    const TextSpan(
                      text: 'Médicament : ',
                      style: sectionTitleStyle,
                    ),
                    TextSpan(text: medicament['Médicament']),
                  ],
                ),
              ),
            ),
            if (medicament['Alias'] != "")
              ListTile(
                leading: Icon(Icons.info, color: Colors.teal), // Add icon
                title: RichText(
                  text: TextSpan(
                    style: detailTextStyle,
                    children: [
                      const TextSpan(
                        text: 'Alias : ',
                        style: sectionTitleStyle,
                      ),
                      TextSpan(text: medicament['Alias']),
                    ],
                  ),
                ),
              ),
            ListTile(
              leading: Icon(Icons.group, color: Colors.teal),
              title: RichText(
                text: TextSpan(
                  style: detailTextStyle,
                  children: [
                    const TextSpan(
                      text: 'Classe thérapeutique : ',
                      style: sectionTitleStyle,
                    ),
                    TextSpan(
                      text: '${medicament['Classe Thérapeutique'].join(', ')}',
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.healing, color: Colors.teal),
              title: Text(
                'Indications : ${medicament['Indications'].join(', ')}',
                style: detailTextStyle,
              ),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.teal),
              title: Text(
                'Propriété : ${medicament['Propriété'].join(', ')}',
                style: detailTextStyle,
              ),
            ),
            ListTile(
              leading: Icon(Icons.block, color: Colors.teal),
              title: Text(
                'Contre-indications : ${medicament['Contre-indications'].join(', ')}',
                style: detailTextStyle,
              ),
            ),
            ListTile(
              leading: Icon(Icons.warning, color: Colors.teal),
              title: Text(
                'Effets indésirables : ${medicament['Effets indésirables'].join(', ')}',
                style: detailTextStyle,
              ),
            ),
            ListTile(
              leading: Icon(Icons.pregnant_woman, color: Colors.teal),
              title: Text(
                'Grossesse et Allaitement : ${medicament['Grossesse et Allaitement'].join(', ')}',
                style: detailTextStyle,
              ),
            ),
            ListTile(
              leading: Icon(Icons.security, color: Colors.teal),
              title: Text(
                'Précautions : ${medicament["Précautions d'emploi"].join(', ')}',
                style: detailTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
