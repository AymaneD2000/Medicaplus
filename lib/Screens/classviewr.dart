import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/filieresviewer.dart';

class ClassGridScreen extends StatefulWidget {
  final int id;

  ClassGridScreen({required this.id});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Classes'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
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
                : Card(
                    elevation: 5.0,
                    child: Center(
                      child: Text(
                        _classes[index].nom,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
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
