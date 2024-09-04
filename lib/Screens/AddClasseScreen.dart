// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
// import 'package:moussa_project/Models/classemodel.dart';
// import 'package:moussa_project/Screens/ManageFiliere.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ManageClasse extends StatefulWidget {
//   const ManageClasse({Key? key}) : super(key: key);

//   @override
//   State<ManageClasse> createState() => _ManageClasseState();
// }

// class _ManageClasseState extends State<ManageClasse> {
//   TextEditingController _classeController = TextEditingController();
//   List<Classe> _classes = [];
//   String _imageUrl = '';

//   @override
//   void initState() {
//     super.initState();
//     getClasseList();
//   }

//   Future<void> _uploadImage() async {
//     final picker = ImagePicker();
//     final imageFile = await picker.pickImage(source: ImageSource.gallery);

//     if (imageFile == null) {
//       return;
//     }

//     try {
//       final bytes = await File(imageFile.path).readAsBytes();
//       final fileExt = imageFile.path.split('.').last;
//       final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
//       final filePath = fileName;

//       await Supabase.instance.client.storage.from('avatars').upload(
//             filePath,
//             File(imageFile.path),
//             fileOptions: FileOptions(contentType: 'image/*'),
//           );

//       _imageUrl = await Supabase.instance.client.storage
//           .from('avatars')
//           .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
//           setState(() {});
//     } on StorageException catch (error) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(error.message),
//             backgroundColor: Theme.of(context).colorScheme.error,
//           ),
//         );
//       }
//     } catch (error) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Une erreur inattendue est survenue'),
//             backgroundColor: Theme.of(context).colorScheme.error,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> getClasseList() async {
//     try {
//       List<Classe> classeList = await SupabaseManagement().getAllClasse();
//       setState(() {
//         _classes = classeList;
//       });
//     } catch (error) {
//       print('Erreur lors de la récupération des classes : $error');
//     }
//   }

//   Future<void> addClasse(int id) async {
//     try {
//       Classe newClasse =
//           Classe(nom: _classeController.text, description: "", idfaculter: id, image: _imageUrl);
//           if (_classeController.text != "" || _imageUrl != ""){
//             await SupabaseManagement().addClasse(newClasse);
//             setState(() {
//         _classeController.clear();
//         getClasseList();
//         Navigator.pop(context);
//       });
//           }else{
            
//           }
    
//     } catch (error) {
//       print('Erreur lors de l\'ajout de la classe : $error');
//     }
//   }

//   Future<void> deleteClasse(Classe classe) async {
//     try {
//       await SupabaseManagement().removeClasse(classe);
//       setState(() {
//         getClasseList();
//       });
//     } catch (error) {
//       print('Erreur lors de la suppression de la classe : $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gérer les Classes'),
//         backgroundColor:
//             Colors.blue, // Changement de la couleur de la barre d'applications
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16.0),
//             const Text(
//               'Liste des Classes',
//               style: TextStyle(
// fontFamily: 'TimesNewRoman',
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue),
//             ),
//             const SizedBox(height: 8.0),
//             Expanded(
//               child: Card(
//                 elevation: 4.0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 child: ListView.builder(
//                   itemCount: _classes.length,
//                   itemBuilder: (context, index) {
//                     return Dismissible(
//                       key: UniqueKey(),
//                       direction: DismissDirection.endToStart,
//                       onDismissed: (direction) => deleteClasse(_classes[index]),
//                       background: Container(
//                         color: Colors.red,
//                         alignment: Alignment.centerRight,
//                         padding: const EdgeInsets.only(right: 16.0),
//                         child: const Icon(Icons.delete, color: Colors.white),
//                       ),
//                       child: ListTile(
//                         title: Text(_classes[index].nom),
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => FiliereScreen(
//                                       nomClasse: _classes[index].nom)));
//                         },
//                         trailing: const Icon(Icons.arrow_forward),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           String _selectedGroup = "fmos";
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('Ajouter une Classe'),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextField(
//                         controller: _classeController,
//                         decoration: InputDecoration(
//                           labelText: 'Nom de la Classe',
//                           border: OutlineInputBorder(), // Ajoute un contour
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                         _imageUrl.isNotEmpty
//                             ? Image.network(_imageUrl)
//                             : Text('Aucune image sélectionnée'),
//                         ElevatedButton(
//                           onPressed: _uploadImage,
//                           child: Text('Télécharger une Image'),
//                         ),
//                       const SizedBox(height: 16.0),
//                       Text("Sélectionnez le type de classe:"),
//                       ListTile(
//                         title: Text("FMOS"),
//                         leading: Radio<String>(
//                           value: "fmos",
//                           groupValue: _selectedGroup,
//                           onChanged: (String? value) {
//                             _selectedGroup = value!;
//                             setState(() {
                              
//                             });
//                           },
//                         ),
//                       ),
//                       ListTile(
//                         title: Text("FAPH"),
//                         leading: Radio<String>(
//                           value: "faph",
//                           groupValue: _selectedGroup,
//                           onChanged: (String? value) {
//                             _selectedGroup = value!;
//                             setState(() {
                              
//                             });
//                           },
//                         ),
//                       ),
//                       ListTile(
//                         title: Text("ODONTO"),
//                         leading: Radio<String>(
//                           value: "odonto",
//                           groupValue: _selectedGroup,
//                           onChanged: (String? value) {
//                             _selectedGroup = value!;
//                             setState(() {
                              
//                             });
//                           },
//                         ),
//                       ),
//                       ListTile(
//                         title: Text("LIVRE"),
//                         leading: Radio<String>(
//                           value: "livre",
//                           groupValue: _selectedGroup,
//                           onChanged: (String? value) {
//                             _selectedGroup = value!;
//                             setState(() {
                              
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 16.0),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Ajoute la classe avec une valeur différente selon le choix
//                           if (_selectedGroup == "fmos") {
//                             addClasse(0); // fmos -> 0
//                           } else if(_selectedGroup == "faph") {
//                             addClasse(1); // faph -> 1
//                           } else if(_selectedGroup == "odonto"){
//                             addClasse(3);
//                           }else{
//                             addClasse(2);
//                           }
//                         },
//                         child: Text('Ajouter'),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         backgroundColor: Colors.blue,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/ManageFiliere.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageClasse extends StatefulWidget {
  const ManageClasse({Key? key}) : super(key: key);

  @override
  State<ManageClasse> createState() => _ManageClasseState();
}

class _ManageClasseState extends State<ManageClasse> {
  final TextEditingController _classeController = TextEditingController();
  List<Classe> _classes = [];
  final String _imageUrl = '';

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
                fontFamily: 'TimesNewRoman',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
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
              return AddClasseDialog(
                //onAddClasse: addClasse,
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddClasseDialog extends StatefulWidget {
  //Function(int) onAddClasse;

  const AddClasseDialog({Key? key}) : super(key: key);

  @override
  _AddClasseDialogState createState() => _AddClasseDialogState();
}

class _AddClasseDialogState extends State<AddClasseDialog> {
  final TextEditingController _classeController = TextEditingController();
  String _imageUrl = '';
  String _selectedGroup = "fmos";

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) {
      return;
    }

    try {
      //inal bytes = await File(imageFile.path).readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;

      await Supabase.instance.client.storage.from('avatars').upload(
            filePath,
            File(imageFile.path),
            fileOptions: const FileOptions(contentType: 'image/*'),
          );

      _imageUrl = await Supabase.instance.client.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      setState(() {});
    } on StorageException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Une erreur inattendue est survenue'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> addClasse(int id) async {
    try {
      Classe newClasse =
          Classe(nom: _classeController.text, description: "", idfaculter: id, image: _imageUrl);
      if (_classeController.text != "" || _imageUrl != "") {
        await SupabaseManagement().addClasse(newClasse);
        print("");
        setState(() {
          _classeController.clear();
          _imageUrl = '';
        });
      }
    } catch (error) {
      print('Erreur lors de l\'ajout de la classe : $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter une Classe'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _classeController,
              decoration: const InputDecoration(
                labelText: 'Nom de la Classe',
                border: OutlineInputBorder(), // Ajoute un contour
              ),
            ),
            const SizedBox(height: 16),
            _imageUrl.isNotEmpty
                ? Image.network(_imageUrl)
                : const Text('Aucune image sélectionnée'),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Télécharger une Image'),
            ),
            const SizedBox(height: 16.0),
            const Text("Sélectionnez le type de classe:"),
            ListTile(
              title: const Text("FMOS"),
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
              title: const Text("FAPH"),
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
            ListTile(
              title: const Text("ODONTO"),
              leading: Radio<String>(
                value: "odonto",
                groupValue: _selectedGroup,
                onChanged: (String? value) {
                  setState(() {
                    _selectedGroup = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("LIVRE"),
              leading: Radio<String>(
                value: "livre",
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
                  Navigator.pop(context);
                } else if (_selectedGroup == "faph") {
                  addClasse(1); // faph -> 1
                  Navigator.pop(context);
                } else if (_selectedGroup == "odonto") {
                  addClasse(3);
                  Navigator.pop(context);
                } else {
                  addClasse(2);
                  Navigator.pop(context);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
