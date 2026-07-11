import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medpharm/DatabaseManagement/providers/cours_provider.dart';
import 'package:medpharm/DatabaseManagement/supabasemanagement.dart';
import 'package:medpharm/Models/semestre.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medpharm/Screens/ManageFiliere.dart';

class ManageSemestre extends StatefulWidget {
  final String classeName;

  const ManageSemestre({
    Key? key,
    required this.classeName,
  }) : super(key: key);

  @override
  State<ManageSemestre> createState() => _ManageSemestreState();
}

class _ManageSemestreState extends State<ManageSemestre> {
  late CoursProvider provider;
  bool isLoading = true;
  bool isOperationInProgress = false;
  List<Semestre> semestres = [];

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CoursProvider>(context, listen: false);
    _loadSemestres();
  }

  Future<void> _loadSemestres() async {
    setState(() => isLoading = true);
    try {
      final data = await provider.getSemestres(widget.classeName);
      if (mounted) {
        setState(() {
          semestres = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showErrorSnackBar('Erreur lors du chargement des semestres: $e');
      }
    }
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

  Future<bool> _showDeleteConfirmationDialog(String semestreName) async {
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
                  'Êtes-vous sûr de vouloir supprimer le semestre "$semestreName" ?'),
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

  Future<void> _deleteSemestre(String id, String nom) async {
    final confirmed = await _showDeleteConfirmationDialog(nom);
    if (!confirmed) return;

    setState(() => isOperationInProgress = true);
    try {
      // Find the semestre to get its image URL
      final semestre = semestres.firstWhere((s) => s.id == id);
      await provider.deleteSemestre(id, semestre.image);
      await _loadSemestres();
      _showSuccessSnackBar('Semestre supprimé avec succès');
    } catch (error, stackTrace) {
      debugPrint('Error deleting semestre: $error');
      debugPrint('Stack trace: $stackTrace');
      _showErrorSnackBar('Erreur: $error');
    } finally {
      setState(() => isOperationInProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Semestres de ${widget.classeName}',
          style:
              const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: isOperationInProgress ? null : _loadSemestres,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: isOperationInProgress
                ? null
                : () => _showAddSemestreDialog(context),
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
                    'Chargement des semestres...',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ],
              ),
            )
          else if (semestres.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 80,
                    color: Colors.blue[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun semestre trouvé',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyez sur + pour ajouter un semestre',
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
              onRefresh: _loadSemestres,
              color: Colors.blue,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: semestres.length,
                itemBuilder: (context, index) {
                  final semestre = semestres[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      elevation: 6,
                      color: Colors.white,
                      shadowColor: Colors.grey.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FiliereScreen(
                                      semestre: semestre,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.blue[100]!),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      semestre.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.blue[50],
                                          child: Icon(
                                            Icons.calendar_today,
                                            color: Colors.blue[300],
                                          ),
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
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
                                  )),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    semestre.nomSemetre,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.classeName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showEditSemestreDialog(
                                      context, semestre),
                                  color: Colors.blue,
                                  splashRadius: 20,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: isOperationInProgress
                                      ? null
                                      : () => _deleteSemestre(
                                          semestre.id, semestre.nomSemetre),
                                  color: Colors.red[400],
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                          ],
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

  Future<void> _showAddSemestreDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AddSemestreDialog(
        classeName: widget.classeName,
        onSemestreAdded: _loadSemestres,
      ),
    );
  }

  Future<void> _showEditSemestreDialog(
      BuildContext context, Semestre semestre) async {
    await showDialog(
      context: context,
      builder: (context) => AddSemestreDialog(
        classeName: widget.classeName,
        onSemestreAdded: _loadSemestres,
        semestreToEdit: semestre,
      ),
    );
  }
}

class AddSemestreDialog extends StatefulWidget {
  final String classeName;
  final VoidCallback onSemestreAdded;
  final Semestre? semestreToEdit;

  const AddSemestreDialog({
    Key? key,
    required this.classeName,
    required this.onSemestreAdded,
    this.semestreToEdit,
  }) : super(key: key);

  @override
  _AddSemestreDialogState createState() => _AddSemestreDialogState();
}

class _AddSemestreDialogState extends State<AddSemestreDialog> {
  final TextEditingController _semestreController = TextEditingController();
  String _imageUrl = '';
  bool _isUploading = false;
  bool _isSaving = false;
  File? _imageFile;
  late CoursProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CoursProvider>(context, listen: false);
    if (widget.semestreToEdit != null) {
      _semestreController.text = widget.semestreToEdit!.nomSemetre;
      _imageUrl = widget.semestreToEdit!.image;
    }
  }

  @override
  void dispose() {
    _semestreController.dispose();
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
      _isUploading = true;
      _imageFile = File(imageFile.path);
    });

    try {
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = 'semestres/$fileName';

      await Supabase.instance.client.storage.from('avatars').upload(
            filePath,
            File(imageFile.path),
            fileOptions: const FileOptions(contentType: 'image/*'),
          );

      _imageUrl = await Supabase.instance.client.storage
          .from('avatars')
          .createSignedUrl(
              filePath, SupabaseManagement.signedUrlExpiryInSeconds);

      setState(() => _isUploading = false);

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
    } catch (error) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors du téléchargement de l\'image'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  Future<void> _saveSemestre() async {
    if (_semestreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez entrer le nom du semestre'),
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
      if (widget.semestreToEdit != null) {
        await provider.updateSemestre(
          widget.semestreToEdit!.id,
          _semestreController.text.trim(),
          _imageUrl,
          widget.classeName,
        );
      } else {
        await provider.addSemestre(
          _semestreController.text.trim(),
          _imageUrl,
          widget.classeName,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        widget.onSemestreAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.semestreToEdit != null
                ? 'Semestre modifié avec succès'
                : 'Semestre ajouté avec succès'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (error, stackTrace) {
      debugPrint('Error saving semestre: $error');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxDialogHeight = screenHeight * 0.8;
    final imageHeight = screenHeight * 0.12;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxDialogHeight,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.semestreToEdit != null
                      ? 'Modifier le Semestre'
                      : 'Ajouter un Semestre',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _semestreController,
                      decoration: InputDecoration(
                        labelText: 'Nom du semestre *',
                        labelStyle: const TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        prefixIcon: Icon(Icons.edit, color: Colors.blue[400]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Image du semestre',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_imageFile != null || _imageUrl.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: imageHeight.clamp(80.0, 100.0),
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
                        height: imageHeight.clamp(80.0, 100.0),
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
                              size: 24,
                              color: Colors.blue[300],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Aucune image',
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isUploading ? null : _uploadImage,
                        icon: _isUploading
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.upload,
                                color: Colors.white, size: 18),
                        label: Text(
                          _isUploading ? 'Téléchargement...' : 'Choisir Image',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isSaving || _isUploading ? null : _saveSemestre,
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
              : Text(widget.semestreToEdit != null ? 'Modifier' : 'Ajouter'),
        ),
      ],
    );
  }
}
