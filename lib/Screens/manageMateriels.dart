import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/materiels.dart';
import 'package:supabase/supabase.dart';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class MaterielApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Materiel Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // /brightness: Brightness.dark,
      ),
      home: MaterielHomePage(),
    );
  }
}

class MaterielHomePage extends StatefulWidget {
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
      materiels.remove(materiel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materiel Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
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
                    subtitle: Text('${materiel.price} - ${materiel.sales}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editMateriel(materiel),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteMateriel(materiel),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child:
                    Text("Nous avons rencontrer une erreur lors du chargement"),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

class MaterielFormPage extends StatefulWidget {
  final Materiel? materiel;
  final Function(Materiel) onSave;

  MaterielFormPage({this.materiel, required this.onSave});

  @override
  _MaterielFormPageState createState() => _MaterielFormPageState();
}

class _MaterielFormPageState extends State<MaterielFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late num _price;
  late int _sales;
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    if (widget.materiel != null) {
      _title = widget.materiel!.title;
      _price = widget.materiel!.price;
      _sales = widget.materiel!.sales;
      _imageUrl = widget.materiel!.image;
    } else {
      _title = '';
      _price = 0.0;
      _sales = 0;
      _imageUrl = '';
    }
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) {
      return;
    }

    try {
      final bytes = await File(imageFile.path).readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;

      await Supabase.instance.client.storage.from('avatars').upload(
            filePath,
            File(imageFile.path),
            fileOptions: FileOptions(contentType: 'image/*'),
          );

      _imageUrl = await Supabase.instance.client.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
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

    setState(() {});
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newMateriel = Materiel(
        title: _title,
        price: _price,
        sales: _sales,
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
            icon: Icon(Icons.save),
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
                decoration: InputDecoration(labelText: 'Titre'),
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
                decoration: InputDecoration(labelText: 'Prix'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = num.parse(value!);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: _sales.toString(),
                decoration: InputDecoration(labelText: 'Ventes'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de ventes';
                  }
                  return null;
                },
                onSaved: (value) {
                  _sales = int.parse(value!);
                },
              ),
              SizedBox(height: 16),
              _imageUrl.isNotEmpty
                  ? Image.network(_imageUrl)
                  : Text('Aucune image sélectionnée'),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Télécharger une Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
