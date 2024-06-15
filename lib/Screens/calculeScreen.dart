import 'package:flutter/material.dart';
import 'package:moussa_project/Screens/IMC.dart';
import 'package:moussa_project/Screens/carlendriergrosesse.dart';
import 'package:moussa_project/Screens/glascow.dart';
import 'package:moussa_project/Screens/hba.dart';
import 'package:moussa_project/Widgets/card.dart';

class CalculeScreen extends StatefulWidget {
  const CalculeScreen({super.key});

  @override
  State<CalculeScreen> createState() => _CalculeScreenState();
}

class _CalculeScreenState extends State<CalculeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calcule"),
        ),
        body: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => IMCCalculator()));
                },
                child:
                    CardE(image: 'assets/images/medecine.png', title: "IMC")),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GlasgowHomePage()));
                },
                child: CardE(image: 'assets/images/imc.png', title: "Glascow")),
                GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PregnancyCalculatorScreen()));
                },
                child: CardE(image: 'assets/images/Calcule.png', title: "Grossesse")),
                GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HbA1cScreen()));
                },
                child: CardE(image: 'assets/images/Calcule.png', title: "Carlendrier"))
          ],
        ));
  }
}
