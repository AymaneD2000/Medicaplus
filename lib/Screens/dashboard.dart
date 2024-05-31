import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/AddClasseScreen.dart';
import 'package:moussa_project/Screens/classviewr.dart';
import 'package:moussa_project/Screens/faculterScreenPage.dart';
import 'package:moussa_project/Screens/medicamentscreen.dart';
import 'package:moussa_project/Screens/pharmacie.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
      body: SingleChildScrollView(
        child: Column(
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
                      image: "assets/images/medecine.png",
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
                      image: "assets/images/cours.png",
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
                      image: "assets/images/pharmacy.png",
                      title: "Pharmacie",
                    ),
                  ),
                  CardE(
                    image: "assets/images/Calcule.png",
                    title: "Calcule",
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
      ),
    );
  }

  Widget _buildPublicationCard() {
    return CarouselSlider(
        items: [
          Image.asset("assets/images/posow.png"),
          Image.asset("assets/images/pharmacy.png"),
          Image.asset("assets/images/Calcule.png"),
          Image.asset("assets/images/cours.png")
        ],
        options: CarouselOptions(
            autoPlay: true, autoPlayInterval: Duration(seconds: 1)));
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
