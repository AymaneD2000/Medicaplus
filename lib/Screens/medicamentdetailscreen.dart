import 'package:flutter/material.dart';
import 'package:moussa_project/Models/med.dart';
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

class MedicamentDetailsScreen extends StatelessWidget {
  final Med medicament;
  const MedicamentDetailsScreen({Key? key, required this.medicament})
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
            AttributesCard(
                alias: medicament.alias,
                couleurs: Color(0xFFB3CDE0),
                image: "assets/images/medocw.png",
                description: medicament.name,
                title: "Médicament (Alias)"),
            AttributesCard(
                //alias: medicament['Alias'],
                couleurs: Color(0xFFFFEB3B),
                image: "assets/images/CategorieMed.jpeg",
                description: medicament.classtherapique.join('\n'),
                title: "Classe Thérapeutique"),
            AttributesCard(
                //alias: medicament['Alias'],
                couleurs: Color(0xFFCFD8DC),
                image: "assets/images/remarquew.png",
                description: medicament.propriete.join('\n -'),
                title: "Propriété"),
            AttributesCard(
                //alias: medicament['Alias'],
                couleurs: Color(0xFFA5D6A7),
                image: "assets/images/indicw.png",
                description: medicament.indication.join('\n -'),
                title: "Indications"),
            AttributesCard(
                //alias: medicament['Alias'],
                couleurs: Color(0xFFFFE0B2),
                image: "assets/images/bewarew.png",
                description: medicament.effetindesirable.join('\n -'),
                title: "Effets indésirables"),
            AttributesCard(
                //alias: medicament['Alias'],
                couleurs: Color(0xFFFFCDD2),
                image: "assets/images/contreindicw.png",
                description: medicament.contreindication.join('\n -'),
                title: "Contre-indications"),
            AttributesCard(
                //alias: medicament['Alias'],
                couleurs: Color(0xFFF8BBD0),
                image: "assets/images/indicw.png",
                description: medicament.precaution.join('\n -'),
                title: "Précautions d'emploi"),
            AttributesCard(
                //alias: medicament['Alias'],
                couleurs: Color(0xFFF8BBD0),
                image: "assets/images/indicw.png",
                description: medicament.grosseseallaitement.join('\n -'),
                title: "Grossesse et Allaitement"),
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