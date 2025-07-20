import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medpharm/DatabaseManagement/supabasemanagement.dart';
import 'package:medpharm/Models/publication.dart';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class PublicationHomePage extends StatefulWidget {
  const PublicationHomePage({super.key});

  @override
  _PublicationHomePageState createState() => _PublicationHomePageState();
}

class _PublicationHomePageState extends State<PublicationHomePage> {
  List<Publication> publications = [];
  bool isLoading = true;
  bool isOperationInProgress = false;

  @override
  void initState() {
    super.initState();
    _loadPublications();
  }

  Future<void> _loadPublications() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedPublications = await SupabaseManagement().getPublication();
      setState(() {
        publications = loadedPublications;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Erreur lors du chargement des publications');
    }
  }

  Future<void> _addPublication() async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => PublicationFormPage(
          onSave: (publication) async {
            setState(() {
              isOperationInProgress = true;
            });

            try {
              await SupabaseManagement().addPublication(publication);
              await _loadPublications();
              _showSuccessSnackBar('Publication ajoutée avec succès');
              return true;
            } catch (e) {
              _showErrorSnackBar('Erreur lors de l\'ajout de la publication');
              return false;
            } finally {
              setState(() {
                isOperationInProgress = false;
              });
            }
          },
        ),
      ),
    );
  }

  Future<void> _editPublication(Publication publication) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => PublicationFormPage(
          publication: publication,
          onSave: (updatedPublication) async {
            setState(() {
              isOperationInProgress = true;
            });

            try {
              await SupabaseManagement().updatePublication(updatedPublication);
              await _loadPublications();
              _showSuccessSnackBar('Publication modifiée avec succès');
              return true;
            } catch (e) {
              _showErrorSnackBar(
                  'Erreur lors de la modification de la publication');
              return false;
            } finally {
              setState(() {
                isOperationInProgress = false;
              });
            }
          },
        ),
      ),
    );
  }

  Future<void> _deletePublication(Publication publication) async {
    final confirmed = await _showDeleteConfirmationDialog('cette publication');
    if (!confirmed) return;

    setState(() {
      isOperationInProgress = true;
    });

    try {
      await SupabaseManagement().deletePublication(publication);
      await _loadPublications();
      _showSuccessSnackBar('Publication supprimée avec succès');
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la suppression de la publication');
    } finally {
      setState(() {
        isOperationInProgress = false;
      });
    }
  }

  Future<bool> _showDeleteConfirmationDialog(String title) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Confirmer la suppression',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              content: Text('Êtes-vous sûr de vouloir supprimer $title ?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Supprimer'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Gestion des Publications',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: isOperationInProgress ? null : _loadPublications,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: isOperationInProgress ? null : _addPublication,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Chargement des publications...',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ],
              ),
            )
          else if (publications.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 80,
                    color: Colors.blue[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune publication trouvée',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyez sur + pour ajouter une publication',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[500],
                    ),
                  ),
                ],
              ),
            )
          else
            RefreshIndicator(
              onRefresh: _loadPublications,
              color: Colors.blue,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: publications.length,
                itemBuilder: (context, index) {
                  final publication = publications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      elevation: 6,
                      color: Colors.white,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _editPublication(publication),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue[100]!),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    publication.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.blue[50],
                                        child: Icon(
                                          Icons.article,
                                          color: Colors.blue[300],
                                          size: 32,
                                        ),
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.blue[50],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Publication ${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'ID: ${publication.idpublication ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 14,
                                          color: Colors.black54,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Image ajoutée',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: isOperationInProgress
                                        ? null
                                        : () => _editPublication(publication),
                                    color: Colors.blue,
                                    splashRadius: 20,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: isOperationInProgress
                                        ? null
                                        : () => _deletePublication(publication),
                                    color: Colors.red[400],
                                    splashRadius: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (isOperationInProgress)
            Container(
              color: Colors.black38,
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.blue),
                        const SizedBox(height: 16),
                        Text(
                          'Opération en cours...',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PublicationFormPage extends StatefulWidget {
  final Publication? publication;
  final Future<bool> Function(Publication) onSave;

  const PublicationFormPage(
      {super.key, this.publication, required this.onSave});

  @override
  _PublicationFormPageState createState() => _PublicationFormPageState();
}

class _PublicationFormPageState extends State<PublicationFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _imageUrl = '';
  File? imageFile;
  bool isLoading = false;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.publication?.image ?? '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      await _uploadImageToSupabase();
    }
  }

  Future<void> _uploadImageToSupabase() async {
    if (imageFile == null) return;

    setState(() {
      isUploading = true;
    });

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final filePath = 'publications/$fileName';

      await Supabase.instance.client.storage
          .from('avatars')
          .upload(filePath, imageFile!);

      final imageUrl = await Supabase.instance.client.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

      setState(() {
        _imageUrl = imageUrl;
        isUploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Image téléchargée avec succès'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } on StorageException catch (error) {
      setState(() {
        isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de téléchargement: ${error.message}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (error) {
      setState(() {
        isUploading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Une erreur inattendue est survenue'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageUrl.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Veuillez sélectionner une image'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
      return;
    }

    setState(() {
      isLoading = true;
    });

    final newPublication = Publication(
      idpublication: widget.publication?.idpublication,
      image: _imageUrl,
    );

    try {
      final success = await widget.onSave(newPublication);
      if (success && mounted) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.publication == null
              ? 'Ajouter une Publication'
              : 'Modifier la Publication',
          style:
              const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.save, color: Colors.white),
            onPressed: isLoading || isUploading ? null : _saveForm,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 10,
              color: Colors.white,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.article, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Publication',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Sélectionnez une image pour votre publication',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 10,
              color: Colors.white,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.image, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Image de la publication',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (imageFile != null || _imageUrl.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageFile != null
                              ? Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  _imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.blue[50],
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.blue[300],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.blue[200]!,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: Colors.blue[300],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Aucune image sélectionnée',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isUploading ? null : _pickImage,
                        icon: isUploading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.camera_alt, color: Colors.white),
                        label: Text(
                          isUploading
                              ? 'Téléchargement...'
                              : 'Sélectionner une Image',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading || isUploading ? null : _saveForm,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save, color: Colors.white),
                label: Text(
                  isLoading
                      ? 'Enregistrement...'
                      : widget.publication == null
                          ? 'Ajouter la Publication'
                          : 'Modifier la Publication',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
