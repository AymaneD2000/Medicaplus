import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/AddClasseScreen.dart';
import 'package:moussa_project/Screens/classviewr.dart';
import 'package:moussa_project/Screens/faculterScreenPage.dart';
import 'package:moussa_project/Screens/medicamentscreen.dart';
import 'package:moussa_project/Screens/pharmacie.dart';
import 'package:moussa_project/Widgets/card.dart';

class DashBoard extends StatefulWidget {
  const DashBoard();

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ManageClasse()));
              },
              icon: Icon(Icons.manage_accounts))
        ],
        title: const Text('Dashboard'),
      ),
      body: Column(
        children: [
          _buildPublicationCard(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MedicamentsScreen()));
                  },
                  child: CardE(
                    image: "assets/images/posow.png",
                    title: "Medicament",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Faculter(),
                        ));
                  },
                  child: CardE(
                    image: "assets/images/posow.png",
                    title: "Cours",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PharmacieScreen()));
                  },
                  child: CardE(
                    image: "assets/images/posow.png",
                    title: "Pharmacie",
                  ),
                ),
                CardE(
                  image: "assets/images/posow.png",
                  title: "Calcul",
                ),
                CardE(
                  image: "assets/images/posow.png",
                  title: "",
                ),
                CardE(
                  image: "assets/images/posow.png",
                  title: "",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationCard() {
    return Card(
      child: Container(
        color: Colors.red,
        height: 100,
        width: 100,
        child: const Center(
          child: Text("Publications"),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MedicamentsScreen()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Faculter(),
                  ));
            }
          },
          child: CardE(image: "assets/images/posow.png", title: 'Card $index')),
    );
  }
}
