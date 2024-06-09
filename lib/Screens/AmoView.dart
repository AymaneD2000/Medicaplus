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
            AmoCard(subtitle: medicament.name, title: "Nom commercial"),
            AmoCard(
                subtitle: medicament.dci.join('\n -'),
                title: "D.C.I/Composition"),
            AmoCard(
                subtitle: medicament.classtherapique.join('\n'),
                title: "Classe Thérapeutique"),
            AmoCard(
                subtitle: medicament.formedosage.join('\n -'),
                title: "Forme et dosage"),
            AmoCard(
                subtitle: medicament.specialitepharmaco.join('\n -'),
                title: "Spécialité pharmaco-thérapeutique"),
            AmoCard(
                subtitle: medicament.presantation.join('\n -'),
                title: "Présentation"),
            AmoCard(
                subtitle: medicament.prix.join('\n -'), title: "Prix public"),
            Text(
                "Les prix indiqués dans cette application peuvent varier d'environ 10% selon les pharmacies")
          ],
        ),
      ),
    );
  }
}
