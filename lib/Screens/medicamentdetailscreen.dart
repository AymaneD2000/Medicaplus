import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moussa_project/Widgets/attributesCard.dart';
import 'package:provider/provider.dart';

// Définition des styles de texte
const TextStyle sectionTitleStyle = TextStyle(
fontFamily: 'TimesNewRoman',
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.teal,
);

const TextStyle detailTextStyle = TextStyle(
fontFamily: 'TimesNewRoman',
  fontSize: 16.0,
  color: Colors.black,
);

class MedicamentDetailsScreen extends StatefulWidget {
  final Med medicament;
  const MedicamentDetailsScreen({Key? key, required this.medicament})
      : super(key: key);

  @override
  State<MedicamentDetailsScreen> createState() => _MedicamentDetailsScreenState();
}

class _MedicamentDetailsScreenState extends State<MedicamentDetailsScreen> {
  //late MyProvider chatModel;
  @override
  void initState() {
    // TODO: implement initState
    //chatModel = Provider.of<MyProvider>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du médicament'),
        backgroundColor: Colors.blue,
        actions: [GestureDetector(
          onTap: ()async{
            //bool isTrue = await chatModel.changeFavoris(widget.medicament.name);
            bool isTrue = await context.read<MyProvider>().changeFavoris(widget.medicament.name);
            setState(() {
              if(isTrue){
                widget.medicament.isFavoris = !widget.medicament.isFavoris;
              }
            });
          },
          child: widget.medicament.isFavoris? Image.asset("assets/images/star.png", height: 30,):Image.asset("assets/images/etoile.png",height: 30,)), const Gap(15)],
      ),
      body: Container(
        margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
        child: ListView(
          children: [
            AttributesCard(
                alias: "",
                couleurs: const Color.fromARGB(206, 50, 204, 204),
                image: "assets/images/dci.png",
                description: widget.medicament.name,
                title: "Médicament/D.C.I (Alias)"),
                AttributesCard(
                alias: "",
                couleurs: const Color.fromARGB(179, 48, 184, 229),
                image: "assets/images/nom commercial.png",
                description: widget.medicament.nomCommercial.join('\n'),
                title: "Nom Commercial"),
                AttributesCard(
                //alias: medicament['Alias'],
                couleurs: const Color.fromARGB(207, 236, 232, 105),
                image: "assets/images/classe.png",
                description: widget.medicament.classtherapique.join('\n'),
                title: "Classe Thérapeutique"),
                AttributesCard(
                //alias: medicament['Alias'],
                couleurs: const Color(0xffC7CFDC),
                image: "assets/images/propriété.png",
                description: widget.medicament.propriete.join('\n -'),
                title: "Propriété"),
                    widget.medicament.activiteantibacterienne != null? AttributesCard(
                //alias: medicament['Alias'],
                couleurs: const Color.fromARGB(207, 236, 232, 105),
                image: "assets/images/les-bacteries.png",
                description: widget.medicament.activiteantibacterienne!.join('\n'),
                title: "Activité antibactérienne"):const Center(),
                AttributesCard(
                //alias: medicament['Alias'],
                couleurs: const Color.fromARGB(171, 82, 216, 153),
                image: "assets/images/indication.png",
                description: widget.medicament.indication.join('\n -'),
                title: "Indications"),
                AttributesCard(
                //alias: medicament['Alias'],
                couleurs: const Color(0xffffdd1b6),
                image: "assets/images/effet secondaire.png",
                description: widget.medicament.effetindesirable.join('\n -'),
                title: "Effets indésirables"),
                AttributesCard(
                //alias: medicament['Alias'],
                couleurs: const Color.fromARGB(143, 240, 73, 90),
                image: "assets/images/contre-indication.png",
                description: widget.medicament.contreindication.join('\n -'),
                title: "Contre-indications"),
                AttributesCard(
                // alias: medicament.alias,`
                couleurs: const Color(0xfffc6e6ff),
                image: "assets/images/posologie.png",
                description: widget.medicament.posologie.join('\n'),
                title: "Posologie et durée"),
                AttributesCard(
                //alias: medicament['Alias'],
                couleurs: const Color.fromRGBO(198, 132, 228, 0.644),
                image: "assets/images/bouclier (1).png",

                description: widget.medicament.precaution.join('\n -'),
                title: "Précautions d'emploi"),
                AttributesCard(
                //alias: medicament['Alias'],
                couleurs: const Color.fromARGB(148, 255, 139, 228),
                image: "assets/images/grossesse.png",
                description: widget.medicament.grosseseallaitement.join('\n -'),
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
      return const SizedBox
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