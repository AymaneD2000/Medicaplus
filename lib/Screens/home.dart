import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/AddClasseScreen.dart';
import 'package:moussa_project/Screens/calculeScreen.dart';
import 'package:moussa_project/Screens/classviewr.dart';
import 'package:moussa_project/Screens/faculterScreenPage.dart';
import 'package:moussa_project/Screens/medicamentscreen.dart';
import 'package:moussa_project/Screens/pharmacie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:moussa_project/Screens/prescription.dart';
import 'package:moussa_project/Screens/venteMaetiels.dart';
import 'package:moussa_project/Widgets/card.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MyProvider provider;

  List<Widget> grid = [];
  @override
  void initState() {
    // TODO: implement initState
    //provider = Provider.of<MyProvider>(context, listen: false);
    super.initState();
    context.read<MyProvider>().loadMedicamentData();
    context.read<MyProvider>().loadPharmacieData();
    grid = [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MedicamentsScreen()));
                    },
                    child: CardE(
                      backgroundColor: const Color(0xff33CCCC),
                      imageColor: Colors.white,
                      image: "assets/images/medicine 1.png",
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BooksHomePage()));
                    },
                    child: CardE(
                      //textStyle: TextStyle(fontSize: 15),
                      image: "assets/images/Calcule.png",
                      title: "Matériels en vente",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CalculeScreen()));
                    },
                    child: CardE(
                      image: "assets/images/Calcule.png",
                      title: "Calcule",
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PrescriptionScreen()));
                    },
                    child: CardE(
                      image: "assets/images/Calcule.png",
                      title: "Prescription",
                    ),
                  )
                ]
          ;

    //provider.loadMedicamentData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            _buildPublicationCard(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: GridView.builder(
                itemCount: grid.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context, index){
                return grid[index];
              })
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
            Image.asset("assets/images/Calcule.png"),
            Image.asset("assets/images/pharmacy.png"),
            Image.asset("assets/images/Calcule.png"),
            Image.asset("assets/images/cours.png")
          ],
          options: CarouselOptions(
              autoPlay: true, autoPlayInterval: const Duration(seconds: 1))),
    );
  }

  // Widget _buildGridView() {
  //   return GridView.builder(
  //     itemCount: 6,
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //     ),
  //     itemBuilder: (context, index) => GestureDetector(
  //         onTap: () {
  //           if (index == 1) {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => MedicamentsScreen()));
  //           } else {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const Faculter(),
  //                 ));
  //           }
  //         },
  //         child: CardE(image: "assets/images/posow.png", title: 'Card $index')),
  //   );
  // }
}