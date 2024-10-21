import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/Screens/calculeScreen.dart';
import 'package:moussa_project/Screens/carlendriergrosesse.dart';
import 'package:moussa_project/Screens/faculterScreenPage.dart';
import 'package:moussa_project/Screens/medicamentscreen.dart';
import 'package:moussa_project/Screens/pharmacie.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
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
                      topStartTadius: 25,
                      topEndTadius: 10,
                      bottomStartRadius: 10,
                      bottomEndRadius: 25,
                      backgroundColor: Colors.white,
                      image: "assets/images/les-antibiotiques.png",
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
                      topStartTadius: 25,
                      topEndTadius: 10,
                      bottomStartRadius: 10,
                      bottomEndRadius: 25,
                      backgroundColor: Colors.white,
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
                      topStartTadius: 25,
                      topEndTadius: 10,
                      bottomStartRadius: 10,
                      bottomEndRadius: 25,
                      backgroundColor: Colors.white,
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
                      topStartTadius: 25,
                      topEndTadius: 10,
                      bottomStartRadius: 10,
                      bottomEndRadius: 25,
                      backgroundColor: Colors.white,
                      //textStyle: TextStyle(fontSize: 15),
                      image: "assets/images/Calcule.png",
                      title: "Matériels",
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
                      topStartTadius: 25,
                      topEndTadius: 10,
                      bottomStartRadius: 10,
                      bottomEndRadius: 25,
                      backgroundColor: Colors.white,
                      image: "assets/images/Calcule.png",
                      title: "Calcule",
                    ),
                  ),
                  GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PregnancyCalculatorScreen()));
                },
                child: CardE(
                      topStartTadius: 25,
                      topEndTadius: 10,
                      bottomStartRadius: 10,
                      bottomEndRadius: 25,
                  backgroundColor: Colors.white,
                  image: 'assets/images/Calcule.png',
                 title: "Grossesse")),
                ]
          ;

    //provider.loadMedicamentData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/Medicaplus.jpg",), opacity: 0.1, fit: BoxFit.fitHeight
      )),
      child: SingleChildScrollView(
          child: Column(
            children: [
              _buildPublicationCard(),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 25),
                height: MediaQuery.of(context).size.height * 0.7,
                child: GridView.builder(
                  itemCount: grid.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 15,
                    ///mainAxisExtent: 0,
                    mainAxisSpacing: 15,
                    crossAxisCount: 2),
                     itemBuilder: (context, index){
                  return grid[index];
                })
              ),
            ],
          ),
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
}