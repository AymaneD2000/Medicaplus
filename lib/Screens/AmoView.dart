import 'dart:convert';
import 'dart:io';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:moussa_project/Widgets/amoattributescard.dart';
import 'package:moussa_project/Widgets/attributesCard.dart';
import 'package:moussa_project/Widgets/attributtesCardPharmacie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
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

class AmoDetailsScreen extends StatefulWidget {
  final Amo medicament;
  const AmoDetailsScreen({Key? key, required this.medicament})
      : super(key: key);

  @override
  State<AmoDetailsScreen> createState() => _AmoDetailsScreenState();
}

class _AmoDetailsScreenState extends State<AmoDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du médicament'),
        actions: [GestureDetector(
          onTap: ()async{
            bool isTrue = await context.read<MyProvider>().changeFavorisPharmacie(widget.medicament.name);
            setState(() {
              if(isTrue){
                widget.medicament.favoris = !widget.medicament.favoris;
              }
            });
          },
          child:widget.medicament.favoris? Image.asset('assets/images/star.png', height: 30,):Image.asset('assets/images/etoile.png', height: 30,)),
           const SizedBox(width: 15,)],
        backgroundColor: Colors.green,
      ),
      body: Container(
        margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
        child: ListView(
          children: [
            AttributesCardPharmacie(couleurs: Color.fromARGB(206, 50, 204, 204),description: widget.medicament.name, title: "Nom commercial"),
            AttributesCardPharmacie(
                couleurs: Color.fromARGB(206, 50, 204, 204),description: widget.medicament.dci.join('\n -'),
                title: "D.C.I/Composition"),
            AttributesCardPharmacie(
                couleurs: Color.fromARGB(206, 50, 204, 204),description: widget.medicament.classtherapique.join('\n'),
                title: "Classe Thérapeutique"),
            AttributesCardPharmacie(
              couleurs: Color.fromARGB(206, 50, 204, 204),
                description: widget.medicament.specialitepharmaco.join('\n -'),
                title: "Spécialité médical"),
            AttributesCardPharmacie(
                couleurs: Color.fromARGB(206, 50, 204, 204),description: widget.medicament.formedosage.join('\n -'),
                title: "Forme et dosage"),
            AttributesCardPharmacie(
                couleurs: Color.fromARGB(206, 50, 204, 204),description: widget.medicament.presantation.join('\n -'),
                title: "Présentation"),
            AttributesCardPharmacie(
                couleurs: Color.fromARGB(206, 50, 204, 204),description: widget.medicament.prix.join('\n -'), title: "Prix public"),
            const Text(
                "Les prix indiqués dans cette application peuvent varier d'environ 10% selon les pharmacies")
          ],
        ),
      ),
    );
  }
}
