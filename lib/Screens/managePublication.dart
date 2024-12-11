import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/publication.dart';
import 'package:supabase/supabase.dart';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';


class PublicationHomePage extends StatefulWidget {
  const PublicationHomePage({super.key});

  @override
  _PublicationHomePageState createState() => _PublicationHomePageState();
}

class _PublicationHomePageState extends State<PublicationHomePage> {
  List<Publication> publications = [];
  getPublication() async {
    publications = await SupabaseManagement().getPublication();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPublication();
  }

  void _addPublication() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PublicationFormPage(
          onSave: (publication) {
            setState(() {
              SupabaseManagement().addPublication(publication);
              //materiels.add(materiel);
            });
          },
        ),
      ),
    );
  }

  // void _editPublication(Publication publication) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => PublicationFormPage(
  //         publication: publication,
  //         onSave: (updatedPublication) {
  //           setState(() {
  //             final index = publications.indexOf(publication);
  //             publications[index] = updatedPublication;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  void _deletePublication(Publication publication) {
    setState(() {
      SupabaseManagement().deletePublication(publication);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publication Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addPublication,
          ),
        ],
      ),
      body: FutureBuilder(
          future: SupabaseManagement().getPublication(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  final publication = data[index];
                  return ListTile(
                    leading: Image.network(publication.image),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // IconButton(
                        //   icon: const Icon(Icons.edit),
                        //   onPressed: () => _editMateriel(materiel),
                        // ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deletePublication(publication),
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

class PublicationFormPage extends StatefulWidget {
  final Publication? publication;
  final Function(Publication) onSave;

  const PublicationFormPage({super.key, this.publication, required this.onSave});

  @override
  _PublicationFormPageState createState() => _PublicationFormPageState();
}

class _PublicationFormPageState extends State<PublicationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _imageUrl = '';
  File? imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.publication != null) {
      _imageUrl = widget.publication!.image;
    } else {
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
      final filePath = imageFiles.path;
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
      final newPublication = Publication(
        image: _imageUrl,
      );
      widget.onSave(newPublication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.publication == null ? 'Ajouter Publication' : 'Modifier Publication'),
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
