import 'package:flutter/material.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:moussa_project/Widgets/amoattributescard.dart';
import 'package:moussa_project/Widgets/attributesCard.dart';

// Définition des styles de texte
const TextStyle sectionTitleStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.teal,
);

const TextStyle detailTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);

class AmoDetailsScreen extends StatelessWidget {
  final Amo medicament;
  const AmoDetailsScreen({Key? key, required this.medicament})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du médicament'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        margin: EdgeInsets.only(right: 10, left: 10, top: 10),
        child: ListView(
          children: [
            AmoCard(subtitile: medicament.name, tile: "Nom commercial"),
            AmoCard(
                subtitile: medicament.classtherapique.join('\n'),
                tile: "Classe Thérapeutique"),
            AmoCard(
                subtitile: medicament.formedosage.join('\n -'),
                tile: "Forme et dosage"),
            AmoCard(
                subtitile: medicament.dci.join('\n -'),
                tile: "D.C.I/Composition"),
            AmoCard(
                subtitile: medicament.specialitepharmaco.join('\n -'),
                tile: "Spécialité pharmaco-thérapeutique"),
            AmoCard(
                subtitile: medicament.presantation.join('\n -'),
                tile: "Présentation"),
            AmoCard(
                subtitile: medicament.prix.join('\n -'), tile: "Prix public"),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    bool showIfEmpty = true,
  }) {
    if (!showIfEmpty && value.isEmpty) {
      return SizedBox
          .shrink(); // N'affiche rien si vide et que l'option est désactivée
    }
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: title, style: sectionTitleStyle),
            TextSpan(text: value, style: detailTextStyle),
          ],
        ),
      ),
    );
  }
}

// Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             _buildListTile(
//               context,
//               icon: Icons.medical_services,
//               title: 'Médicament : ',
//               value: medicament['Médicament'],
//             ),
//             _buildListTile(
//               context,
//               icon: Icons.info,
//               title: 'Alias : ',
//               value: medicament['Alias'],
//               showIfEmpty: false,
//             ),
//             _buildListTile(
//               context,
//               icon: Icons.group,
//               title: 'Classe thérapeutique : ',
//               value: medicament['Classe Thérapeutique'].join(', '),
//             ),
//             Divider(),
//             _buildListTile(
//               context,
//               icon: Icons.star,
//               title: 'Propriété : ',
//               value: medicament['Propriété'].join(', '),
//             ),
//             _buildListTile(
//               context,
//               icon: Icons.healing,
//               title: 'Indications : ',
//               value: medicament['Indications'].join(', '),
//             ),
//             _buildListTile(
//               context,
//               icon: Icons.block,
//               title: 'Contre-indications : ',
//               value: medicament['Contre-indications'].join(', '),
//             ),
//             Divider(),
//             _buildListTile(
//               context,
//               icon: Icons.warning,
//               title: 'Effets indésirables : ',
//               value: medicament['Effets indésirables'].join(', '),
//             ),
//             _buildListTile(
//               context,
//               icon: Icons.security,
//               title: 'Précautions : ',
//               value: medicament["Précautions d'emploi"].join(', '),
//             ),
//             _buildListTile(
//               context,
//               icon: Icons.pregnant_woman,
//               title: 'Grossesse et Allaitement : ',
//               value: medicament['Grossesse et Allaitement'].join(', '),
//             ),
//           ],
//         ),
//       ),