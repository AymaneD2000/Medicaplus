import 'package:flutter/material.dart';
import 'package:moussa_project/Screens/Appgar.dart';
import 'package:moussa_project/Screens/Bishop.dart';
import 'package:moussa_project/Screens/ChildUp.dart';
import 'package:moussa_project/Screens/IMC.dart';
import 'package:moussa_project/Screens/Malmart.dart';
import 'package:moussa_project/Screens/glascow.dart';
import 'package:moussa_project/Screens/hba.dart';
import 'package:moussa_project/Screens/secondCalcul.dart';
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
          title: const Text("Calcule"),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 5,
              crossAxisCount: 2,
            ),
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => IMCCalculator()));
                  },
                  child:
                      CardE(      
                        topStartTadius: 10,
                        topEndTadius: 10,
                        bottomStartRadius: 10,
                        bottomEndRadius: 10,
                        image: 'assets/images/Calcule.png',
                        backgroundColor: const Color(0xFF4A90E2),
                        title: "IMC")),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GlasgowHomePage()));
                  },
                  child: CardE(
                        topStartTadius: 10,
                        topEndTadius: 10,
                        bottomStartRadius: 10,
                        bottomEndRadius: 10,
                    image: 'assets/images/Calcule.png',
                    backgroundColor: Colors.white,
                    borderColor: const Color(0xFF4A90E2),
                    title: "Glascow")),
                  
                  GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HbA1cScreen()));
                  },
                  child: CardE(
                        topStartTadius: 10,
                        topEndTadius: 10,
                        bottomStartRadius: 10,
                        bottomEndRadius: 10,
                    image: 'assets/images/Calcule.png', title: "HBA1c")),
                  GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MallampatiScreen()));
                  },
                  child: CardE(
                        topStartTadius: 10,
                        topEndTadius: 10,
                        bottomStartRadius: 10,
                        bottomEndRadius: 10,
                    image: 'assets/images/Calcule.png', title: "Mallampati")),
                  GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BishopPage()));
                  },
                  child: CardE(
                        topStartTadius: 10,
                        topEndTadius: 10,
                        bottomStartRadius: 10,
                        bottomEndRadius: 10,
                    image: 'assets/images/Calcule.png', title: "Bishop")),
                    GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppgarHomePage()));
                  },
                  child: CardE(
                        topStartTadius: 10,
                        topEndTadius: 10,
                        bottomStartRadius: 10,
                        bottomEndRadius: 10,
                    image: 'assets/images/Calcule.png', title: "Apgar")),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChildupPage()));
                  },
                  child: CardE(
                        topStartTadius: 10,
                        topEndTadius: 10,
                        bottomStartRadius: 10,
                        bottomEndRadius: 10,
                    image: 'assets/images/Calcule.png', title: "Child Pugh")),

                    GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecondCalcule()));
                  },
                  child: CardE(
                        topStartTadius: 10,
                        topEndTadius: 10,
                        bottomStartRadius: 10,
                        bottomEndRadius: 10,
                    image: 'assets/images/Calcule.png', title: "Second calcul"))
            ],
          ),
        ));
  }
}
