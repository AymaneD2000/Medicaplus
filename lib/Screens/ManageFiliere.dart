import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/filiere.dart';
import 'package:moussa_project/Screens/ManagePDF.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class FiliereScreen extends StatefulWidget {
  FiliereScreen({required this.nomClasse, Key? key}) : super(key: key);
  final String nomClasse;

  @override
  _FiliereScreenState createState() => _FiliereScreenState();
}

class _FiliereScreenState extends State<FiliereScreen> {
  final TextEditingController _filiereController = TextEditingController();
  File? _selectedImage;
  List<Filiere> _filieres = [];
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchFilieres();
  }

  @override
  void dispose() {
    _filiereController.dispose();
    super.dispose();
  }

  Future<void> _fetchFilieres() async {
    final supabaseManagement = SupabaseManagement();
    final filieres =
        await supabaseManagement.getClasseFilieres(widget.nomClasse);
    setState(() {
      _filieres = filieres;
    });
  }

  Future<void> _addFiliere(String nom, String image) async {
    final supabaseManagement = SupabaseManagement();

    if (nom.isNotEmpty && image.isNotEmpty) {
      final filiere = Filiere(
        nom: nom,
        image: image,
        nomClasse: widget.nomClasse,
        id: const Uuid().v4(),
      );

      await supabaseManagement.addFiliere(filiere);
      _fetchFilieres();
      setState(() {
        _selectedImage = null;
      });
    } else {
      print('Veuillez remplir tous les champs');
    }
  }

  Future<void> _removeFiliere(Filiere filiere) async {
    final supabaseManagement = SupabaseManagement();
    await supabaseManagement.removeFiliere(filiere);
    _fetchFilieres();
  }

  Future<void> _chargerImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imageFile == null) {
      return;
    }

    try {
      //final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await SupabaseManagement.supabase.storage.from('avatars').upload(
            filePath,
            File(imageFile.path),
            fileOptions: FileOptions(contentType: 'image/*'),
          );
      _avatarUrl = await Supabase.instance.client.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
          setState(() {
          });
    } on StorageException catch (error) {
      if (mounted) {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
         setState(() {});
        return;
      }
       setState(() {});
      return;
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Une erreur inattendue est survenue'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
         setState(() {});
        return;
      }
       setState(() {});
      return;
    }

  }

  Future<void> _showAddFiliereDialog(BuildContext context) async {
    String nom = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter une Filière'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  nom = value;
                },
                decoration:
                    const InputDecoration(labelText: 'Nom de la Filière'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _chargerImage,
                child: const Text('Choisir Image'),
              ),
            _avatarUrl.isNotEmpty? Image.network(_avatarUrl):Center(child: Text("Choisisez une image"),)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                _addFiliere(nom, _avatarUrl);
                _avatarUrl = '';
                Navigator.of(context).pop();
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer les Filieres'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filieres.length,
              itemBuilder: (context, index) {
                final filiere = _filieres[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfScreen(
                                  idFiliere: filiere.id,
                                )));
                  },
                  leading: Image.network(
                    filiere.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(filiere.nom),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeFiliere(filiere),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddFiliereDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
