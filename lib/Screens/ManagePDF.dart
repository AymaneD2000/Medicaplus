import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medpharm/DatabaseManagement/supabasemanagement.dart';
import 'package:medpharm/Models/pdf.dart';
import 'package:medpharm/Screens/pdfview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PdfScreen extends StatefulWidget {
  final String idFiliere;

  const PdfScreen({required this.idFiliere, Key? key}) : super(key: key);

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  List<Pdf> _pdfs = [];
  bool _isLoading = true;
  bool _isOperationInProgress = false;

  @override
  void initState() {
    super.initState();
    _loadPdfs();
  }

  Future<void> _loadPdfs() async {
    setState(() => _isLoading = true);
    try {
      final pdfs = await SupabaseManagement().getPDF(widget.idFiliere);
      setState(() {
        _pdfs = pdfs;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Erreur lors du chargement des PDFs');
    }
  }

  Future<void> _addPdf(
      String nom, String description, String url, String image) async {
    if (nom.trim().isEmpty ||
        description.trim().isEmpty ||
        url.isEmpty ||
        image.isEmpty) {
      _showErrorSnackBar(
          'Veuillez remplir tous les champs et sélectionner un PDF et une image');
      return;
    }

    setState(() => _isOperationInProgress = true);
    try {
      final pdf = Pdf(
        nom: nom.trim(),
        description: description.trim(),
        url: url,
        image: image,
        idFiliere: widget.idFiliere,
        id: const Uuid().v4(),
      );

      await SupabaseManagement().addPdf(pdf);
      await _loadPdfs();
      _showSuccessSnackBar('PDF ajouté avec succès');
    } catch (error) {
      _showErrorSnackBar('Erreur lors de l\'ajout du PDF');
    } finally {
      setState(() => _isOperationInProgress = false);
    }
  }

  Future<void> _removePdf(Pdf pdf) async {
    final confirmed = await _showDeleteConfirmationDialog(pdf.nom);
    if (!confirmed) return;

    setState(() => _isOperationInProgress = true);
    try {
      await SupabaseManagement().removePdf(pdf);
      await _loadPdfs();
      _showSuccessSnackBar('PDF supprimé avec succès');
    } catch (error) {
      _showErrorSnackBar('Erreur lors de la suppression du PDF');
    } finally {
      setState(() => _isOperationInProgress = false);
    }
  }

  Future<bool> _showDeleteConfirmationDialog(String pdfName) async {
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
              content: Text(
                  'Êtes-vous sûr de vouloir supprimer le PDF "$pdfName" ?'),
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
          'Gestion des PDF',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isOperationInProgress ? null : _loadPdfs,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _isOperationInProgress
                ? null
                : () => _showAddPdfDialog(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Chargement des PDFs...',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ],
              ),
            )
          else if (_pdfs.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 80,
                    color: Colors.blue[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun PDF trouvé',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyez sur + pour ajouter un PDF',
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
              onRefresh: _loadPdfs,
              color: Colors.blue,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _pdfs.length,
                itemBuilder: (context, index) {
                  final pdf = _pdfs[index];
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFScreen(
                                path: pdf.url,
                                pdfName: pdf.nom,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue[100]!),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    pdf.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.blue[50],
                                        child: Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.blue[300],
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
                                      pdf.nom,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      pdf.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PDFScreen(
                                            path: pdf.url,
                                            pdfName: pdf.nom,
                                          ),
                                        ),
                                      );
                                    },
                                    color: Colors.blue,
                                    splashRadius: 20,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: _isOperationInProgress
                                        ? null
                                        : () => _removePdf(pdf),
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
          if (_isOperationInProgress)
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

  Future<void> _showAddPdfDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AddPdfDialog(
        onPdfAdded: (nom, description, url, image) =>
            _addPdf(nom, description, url, image),
      ),
    );
  }
}

class AddPdfDialog extends StatefulWidget {
  final Function(String, String, String, String) onPdfAdded;

  const AddPdfDialog({
    Key? key,
    required this.onPdfAdded,
  }) : super(key: key);

  @override
  _AddPdfDialogState createState() => _AddPdfDialogState();
}

class _AddPdfDialogState extends State<AddPdfDialog> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _pdfUrl = '';
  String _imageUrl = '';
  bool _isUploadingPdf = false;
  bool _isUploadingImage = false;
  bool _isSaving = false;
  File? _imageFile;

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (imageFile == null) return;

    setState(() {
      _isUploadingImage = true;
      _imageFile = File(imageFile.path);
    });

    try {
      final fileName = imageFile.name;
      final filePath = 'pdf_images/$fileName';

      await SupabaseManagement.supabase.storage.from('avatars').upload(
            filePath,
            File(imageFile.path),
            fileOptions: const FileOptions(contentType: 'image/*'),
          );

      _imageUrl = await SupabaseManagement.supabase.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

      setState(() => _isUploadingImage = false);

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
      setState(() => _isUploadingImage = false);
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
      setState(() => _isUploadingImage = false);
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

  Future<void> _uploadPdf() async {
    final picker = FilePicker.platform;
    final pdfFile = await picker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pdfFile == null) return;

    setState(() => _isUploadingPdf = true);

    try {
      final fileName = pdfFile.names.first!;
      final file = File(pdfFile.files.first.path!);
      final filePath = 'pdfs/$fileName';

      await SupabaseManagement.supabase.storage.from('avatars').upload(
            filePath,
            file,
            fileOptions: const FileOptions(
                contentType: 'application/pdf', cacheControl: '3600'),
          );

      _pdfUrl = await SupabaseManagement.supabase.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

      setState(() => _isUploadingPdf = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PDF téléchargé avec succès'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } on StorageException catch (error) {
      setState(() => _isUploadingPdf = false);
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
      setState(() => _isUploadingPdf = false);
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

  Future<void> _addPdf() async {
    if (_nomController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez entrer le nom du PDF'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez entrer une description'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    if (_pdfUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez sélectionner un fichier PDF'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    if (_imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez sélectionner une image'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      widget.onPdfAdded(
        _nomController.text.trim(),
        _descriptionController.text.trim(),
        _pdfUrl,
        _imageUrl,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.picture_as_pdf, color: Colors.blue, size: 24),
          const SizedBox(width: 8),
          const Text(
            'Ajouter un PDF',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nomController,
              decoration: InputDecoration(
                labelText: 'Nom du PDF *',
                labelStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                prefixIcon: Icon(Icons.title, color: Colors.blue[400]),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description *',
                labelStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                prefixIcon: Icon(Icons.description, color: Colors.blue[400]),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'Fichier PDF',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    size: 40,
                    color: _pdfUrl.isNotEmpty ? Colors.blue : Colors.blue[300],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _pdfUrl.isNotEmpty
                        ? 'PDF sélectionné avec succès'
                        : 'Aucun PDF sélectionné',
                    style: TextStyle(
                      color: _pdfUrl.isNotEmpty
                          ? Colors.blue[700]
                          : Colors.blue[400],
                      fontWeight: _pdfUrl.isNotEmpty
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isUploadingPdf ? null : _uploadPdf,
                icon: _isUploadingPdf
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.upload_file, color: Colors.white),
                label: Text(
                  _isUploadingPdf ? 'Téléchargement...' : 'Sélectionner un PDF',
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
            const SizedBox(height: 20),
            const Text(
              'Image du PDF',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            if (_imageFile != null || _imageUrl.isNotEmpty)
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : Image.network(_imageUrl, fit: BoxFit.cover),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: Colors.blue[300],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aucune image sélectionnée',
                      style: TextStyle(color: Colors.blue[400]),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isUploadingImage ? null : _uploadImage,
                icon: _isUploadingImage
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.upload, color: Colors.white),
                label: Text(
                  _isUploadingImage
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
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isSaving || _isUploadingPdf || _isUploadingImage
              ? null
              : _addPdf,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Ajouter'),
        ),
      ],
    );
  }
}
