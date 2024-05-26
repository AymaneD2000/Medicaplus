import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/ManageFiliere.dart';

class ManageClasse extends StatefulWidget {
  const ManageClasse({Key? key}) : super(key: key);

  @override
  State<ManageClasse> createState() => _ManageClasseState();
}

class _ManageClasseState extends State<ManageClasse> {
  TextEditingController _classeController = TextEditingController();
  List<Classe> _classes = [];

  @override
  void initState() {
    super.initState();
    getClasseList();
  }

  Future<void> getClasseList() async {
    try {
      List<Classe> classeList = await SupabaseManagement().getAllClasse();
      setState(() {
        _classes = classeList;
      });
    } catch (error) {
      print('Erreur lors de la récupération des classes : $error');
    }
  }

  Future<void> addClasse(int id) async {
    try {
      Classe newClasse =
          Classe(nom: _classeController.text, description: "", idfaculter: id);
      await SupabaseManagement().addClasse(newClasse);
      setState(() {
        _classeController.clear();
        getClasseList();
      });
    } catch (error) {
      print('Erreur lors de l\'ajout de la classe : $error');
    }
  }

  Future<void> deleteClasse(Classe classe) async {
    try {
      await SupabaseManagement().removeClasse(classe);
      setState(() {
        getClasseList();
      });
    } catch (error) {
      print('Erreur lors de la suppression de la classe : $error');
    }
  }

  String _selectedGroup = "fmos";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer les Classes'),
        backgroundColor:
            Colors.blue, // Changement de la couleur de la barre d'applications
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Liste des Classes',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListView.builder(
                  itemCount: _classes.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) => deleteClasse(_classes[index]),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(_classes[index].nom),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FiliereScreen(
                                      nomClasse: _classes[index].nom)));
                        },
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Ajouter une Classe'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _classeController,
                      decoration: InputDecoration(
                        labelText: 'Nom de la Classe',
                        border: OutlineInputBorder(), // Ajoute un contour
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text("Sélectionnez le type de classe:"),
                    ListTile(
                      title: Text("fmos"),
                      leading: Radio<String>(
                        value: "fmos",
                        groupValue: _selectedGroup,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGroup = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text("faph"),
                      leading: Radio<String>(
                        value: "faph",
                        groupValue: _selectedGroup,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGroup = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Ajoute la classe avec une valeur différente selon le choix
                        if (_selectedGroup == "fmos") {
                          addClasse(0); // fmos -> 0
                        } else {
                          addClasse(1); // faph -> 1
                        }
                      },
                      child: Text('Ajouter'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
