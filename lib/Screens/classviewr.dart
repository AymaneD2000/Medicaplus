import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/filieresviewer.dart';

class ClassGridScreen extends StatefulWidget {
  final int id;

  const ClassGridScreen({super.key, required this.id});

  @override
  State<ClassGridScreen> createState() => _ClassGridScreenState();
}

class _ClassGridScreenState extends State<ClassGridScreen> {
  List<Classe> _classes = [];

  @override
  void initState() {
    super.initState();
    getClasseList();
  }

  Future<void> getClasseList() async {
    try {
      List<Classe> classeList = await SupabaseManagement().getClasse(widget.id);
      setState(() {
        _classes = classeList;
      });
    } catch (error) {
      print('Erreur lors de la récupération des classes : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardHeight = screenHeight * 0.26;
    return Scaffold(
      backgroundColor: const Color(0xFFD4EEED),
      appBar: AppBar(
        title: const Text('Liste des Classes'),
      ),
      body: ListView.builder(
        itemCount: _classes.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FiliereGridScreen(className: _classes[index].nom)));
            },
            child: _classes.isEmpty
                ? const Center()
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                            margin: const EdgeInsets.only(left:  55, right: 55, bottom: 12),
                            //shape: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              height: cardHeight,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  // image: DecorationImage(
                                  //   image: NetworkImage(fac.image),
                                  //   fit: BoxFit.cover,
                                  // ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Column(
                                  //alignment: Alignment.bottomLeft,
                                  children: [
                                    Expanded(child: Image.network(_classes[index].image, fit: BoxFit.contain,)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _classes[index].nom,
                                        style: const TextStyle(
                                          fontFamily: 'TimesNewRoman',
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                ),
          );
        },
      ),
    );
  }
}
