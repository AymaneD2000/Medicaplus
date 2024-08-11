import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/pdf.dart';
import 'package:moussa_project/Screens/pdfview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PdfScreen extends StatefulWidget {
  final String idFiliere;

  PdfScreen({required this.idFiliere, Key? key}) : super(key: key);

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedPdf;
  List<Pdf> _pdfs = [];
  String _pdfUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchPdfs();
  }

  File? _selectedImage;
  String _imageUrl = ''; // Ajout de la variable pour stocker l'URL de l'image

  // ... (le reste du code reste inchangé)

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) {
      return;
    }

    try {
      final bytes = await File(imageFile.path).readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${imageFile.name}';
      final filePath = fileName;

      await SupabaseManagement.supabase.storage.from('avatars').upload(
            filePath,
            File(imageFile.path),
            fileOptions: FileOptions(contentType: 'image/*'),
          );

      _imageUrl = await SupabaseManagement.supabase.storage
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

  Future<void> _fetchPdfs() async {
    final supabaseManagement = SupabaseManagement();
    final pdfs = await supabaseManagement.getPDF(widget.idFiliere);
    setState(() {
      _pdfs = pdfs;
    });
  }

  Future<void> _addPdf(
      String nom, String description, String url, String image) async {
    final supabaseManagement = SupabaseManagement();

    if (nom.isNotEmpty && description.isNotEmpty && url.isNotEmpty && _imageUrl.isNotEmpty) {
      final pdf = Pdf(
        nom: nom,
        description: description,
        url: _pdfUrl,
        image:
            _imageUrl, // Ajoutez votre logique pour gérer l'image associée au PDF
        idFiliere: widget.idFiliere,
        id: const Uuid().v4(),
      );

      await supabaseManagement.addPdf(pdf);
      _fetchPdfs();
      setState(() {
        //_selectedPdf = null;
      });
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Veuillez choisir une image ou pdf ou ajouter un nom et description s\'il vous plait!'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    }
  }

  Future<void> _removePdf(Pdf pdf) async {
    final supabaseManagement = SupabaseManagement();
    await supabaseManagement.removePdf(pdf);
    _fetchPdfs();
  }

  Future<void> _uploadPdf() async {
    final picker = FilePicker.platform;
    final pdfFile = await picker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pdfFile == null) {
      return;
    }

    try {
      final bytes = await pdfFile.files.first.bytes;
      final fileExt = pdfFile.files.first.path!.split('.').last;
      final fileName = '${pdfFile.names.first}.$fileExt';
      final f = File(pdfFile.files.first.path!);
      final filePath = fileName;
      await SupabaseManagement.supabase.storage.from('avatars').upload(
            filePath,
            f,
            fileOptions: FileOptions(contentType: 'application/pdf'),
          );
      _pdfUrl = await SupabaseManagement.supabase.storage
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

  Future<void> _showAddPdfDialog(BuildContext context) async {
    String nom = '';
    String description = '';

    return showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Ajouter un PDF'),
            content: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    nom = value;
                  },
                  decoration: const InputDecoration(labelText: 'Nom du PDF'),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    description = value;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Description du PDF'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      
                    });
                    setState(() {
                      _uploadPdf();  
                    });
                  },
                  child: const Text('Télécharger PDF'),
                ),
                Text(_pdfUrl.isEmpty?"Aucun Pdf choisie":"pdf selectionner avec success"),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _uploadImage(); // Appeler la fonction pour télécharger l'image
                    });
                  },
                  child: const Text('Télécharger Image'),
                ),
                Text(_imageUrl.isEmpty?"Aucune image choisie":"image selectionner avec success"),
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
                  _addPdf(nom, description, _pdfUrl,
                      _imageUrl); // Passer l'URL de l'image
                  Navigator.of(context).pop();
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer les PDFs'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _pdfs.length,
              itemBuilder: (context, index) {
                final pdf = _pdfs[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFScreen(
                                  path: pdf.url,
                                )));
                  },
                  title: Text(pdf.nom),
                  subtitle: Text(pdf.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removePdf(pdf),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddPdfDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
