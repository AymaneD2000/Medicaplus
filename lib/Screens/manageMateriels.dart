import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/materiels.dart';
import 'package:supabase/supabase.dart';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';


class MaterielHomePage extends StatefulWidget {
  const MaterielHomePage({super.key});

  @override
  _MaterielHomePageState createState() => _MaterielHomePageState();
}

class _MaterielHomePageState extends State<MaterielHomePage> {
  List<Materiel> materiels = [];
  getMateriel() async {
    materiels = await SupabaseManagement().getMateriel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMateriel();
  }

  void _addMateriel() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MaterielFormPage(
          onSave: (materiel) {
            setState(() {
              SupabaseManagement().addMateriel(materiel);
              //materiels.add(materiel);
            });
          },
        ),
      ),
    );
  }

  void _editMateriel(Materiel materiel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MaterielFormPage(
          materiel: materiel,
          onSave: (updatedMateriel) {
            setState(() {
              final index = materiels.indexOf(materiel);
              materiels[index] = updatedMateriel;
            });
          },
        ),
      ),
    );
  }

  void _deleteMateriel(Materiel materiel) {
    setState(() {
      SupabaseManagement().removeMateriel(materiel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materiel Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMateriel,
          ),
        ],
      ),
      body: FutureBuilder(
          future: SupabaseManagement().getMateriel(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  final materiel = data[index];
                  return ListTile(
                    leading: Image.network(materiel.image),
                    title: Text(materiel.title),
                    subtitle: Text(materiel.price),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editMateriel(materiel),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteMateriel(materiel),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child:
                    Text("Nous avons rencontrer une erreur lors du chargement"),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}

class MaterielFormPage extends StatefulWidget {
  final Materiel? materiel;
  final Function(Materiel) onSave;

  const MaterielFormPage({super.key, this.materiel, required this.onSave});

  @override
  _MaterielFormPageState createState() => _MaterielFormPageState();
}

class _MaterielFormPageState extends State<MaterielFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _price;
  late String _description;
  late String _telephone;
  String _imageUrl = '';
  File? imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.materiel != null) {
      _title = widget.materiel!.title;
      _price = widget.materiel!.price;
      _imageUrl = widget.materiel!.image;
      _description = widget.materiel!.description??"";
      _telephone = widget.materiel!.telephone;
    } else {
      _title = '';
      _description = "";
      _telephone = "";
      _price = "";
      _imageUrl = '';
    }
  }

  Future<File?> UploadeFile()async{
    final picker = ImagePicker();
    final imageFiles = await picker.pickImage(source: ImageSource.gallery);

    if (imageFiles == null)
      {
        return null;
      }

    //final bytes = await File(imageFile.path).readAsBytes();
      final fileExt = imageFiles.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      imageFile = File(filePath);
      setState(() {
        
      });
    return File(filePath);
  }

  Future<void> _uploadImageToSuppabse() async {
    final imageFiles = await UploadeFile();

    try {
      await Supabase.instance.client.storage.from('avatars').upload(
            imageFiles!.path,
            imageFiles,
            fileOptions: const FileOptions(contentType: 'image/*'),
          );

      _imageUrl = await Supabase.instance.client.storage
          .from('avatars')
          .createSignedUrl(imageFiles.path, 60 * 60 * 24 * 365 * 10);
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

  void _saveForm() {
    _uploadImageToSuppabse();
    if (_formKey.currentState!.validate() && _imageUrl !="") {
      _formKey.currentState!.save();
      final newMateriel = Materiel(
        description:  _description,
        title: _title,
        telephone: _telephone,
        price: _price,
        image: _imageUrl,
        id: widget.materiel?.id,
      );
      widget.onSave(newMateriel);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.materiel == null ? 'Ajouter Materiel' : 'Modifier Materiel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Prix'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'description'),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: _telephone,
                decoration: const InputDecoration(labelText: 'Telephone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numero de telephone';
                  }
                  return null;
                },
                onSaved: (value) {
                  _telephone = value!;
                },
              ),
              const SizedBox(height: 16),
              imageFile != null
                  ? Image.file(imageFile!)
                  : const Text('Aucune image sélectionnée'),
              ElevatedButton(
                onPressed: UploadeFile,
                child: const Text('Télécharger une Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
