import 'package:flutter/material.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/classviewr.dart';
import 'package:moussa_project/Screens/medicamentscreen.dart';
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
        title: const Text('Dashboard'),
      ),
      body: Column(
        children: [
          _buildPublicationCard(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: _buildGridView(),
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
                    builder: (context) => ClassGridScreen(
                      classes: [
                        Classe(
                          nom: 'Mathématiques',
                          description:
                              'Cette classe enseigne des concepts mathématiques.',
                        ),
                        Classe(
                          nom: 'Histoire',
                          description:
                              'Cette classe couvre l\'histoire mondiale.',
                        ),
                        // Ajoutez d'autres classes ici selon vos besoins
                      ],
                    ),
                  ));
            }
          },
          child: CardE(title: 'Card $index')),
    );
  }
}
