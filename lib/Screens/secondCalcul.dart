import 'package:flutter/material.dart';
import 'package:moussa_project/Screens/paracetamol.dart';
import 'package:moussa_project/Widgets/card.dart';

class SecondCalcule extends StatefulWidget {
  const SecondCalcule({super.key});

  @override
  State<SecondCalcule> createState() => _SecondCalculeState();
}

class _SecondCalculeState extends State<SecondCalcule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculer la dose'),
      ),
      body: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 5,
              crossAxisCount: 2,
            ),
      children: [
        GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ParacetamolScreen()));
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
      ],
    ),
    );
  }
}