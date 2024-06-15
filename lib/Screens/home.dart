import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/AddClasseScreen.dart';
import 'package:moussa_project/Screens/calculeScreen.dart';
import 'package:moussa_project/Screens/classviewr.dart';
import 'package:moussa_project/Screens/faculterScreenPage.dart';
import 'package:moussa_project/Screens/medicamentscreen.dart';
import 'package:moussa_project/Screens/pharmacie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:moussa_project/Screens/venteMaetiels.dart';
import 'package:moussa_project/Widgets/card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            _buildPublicationCard(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalculeScreen()));
                    },
                    child: CardE(
                      image: "assets/images/Calcule.png",
                      title: "Calcule",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BooksApp()));
                    },
                    child: CardE(
                      image: "assets/images/posow.png",
                      title: "Materiels",
                    ),
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
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.2,
      child: CarouselSlider(
          items: [
            Image.asset("assets/images/posow.png"),
            Image.asset("assets/images/pharmacy.png"),
            Image.asset("assets/images/Calcule.png"),
            Image.asset("assets/images/cours.png")
          ],
          options: CarouselOptions(
              autoPlay: true, autoPlayInterval: Duration(seconds: 1))),
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