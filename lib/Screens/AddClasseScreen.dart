import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/ManageFiliere.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> categories = const [
    {
      'id': 0,
      'name': 'FMOS',
      'title': 'Faculté de Médecine',
      'icon': Icons.local_hospital,
      'color': Colors.red,
    },
    {
      'id': 1,
      'name': 'FAPH',
      'title': 'Faculté de Pharmacie',
      'icon': Icons.medication,
      'color': Colors.green,
    },
    {
      'id': 3,
      'name': 'ODONTO',
      'title': 'Faculté d\'Odontologie',
      'icon': Icons.emoji_emotions,
      'color': Colors.orange,
    },
    {
      'id': 2,
      'name': 'LIVRE',
      'title': 'Bibliothèque',
      'icon': Icons.library_books,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Sélectionner une Catégorie',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choisissez une catégorie',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sélectionnez la faculté pour gérer ses classes',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    elevation: 8,
                    color: Colors.white,
                    shadowColor: Colors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageClasse(
                              categoryId: category['id'],
                              categoryName: category['name'],
                              categoryTitle: category['title'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: category['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                category['icon'],
                                size: 32,
                                color: category['color'],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              category['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageClasse extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String categoryTitle;

  const ManageClasse({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  State<ManageClasse> createState() => _ManageClasseState();
}

class _ManageClasseState extends State<ManageClasse> {
  List<Classe> _classes = [];
  bool _isLoading = true;
  bool _isOperationInProgress = false;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() => _isLoading = true);
    try {
      List<Classe> allClasses = await SupabaseManagement().getAllClasse();
      List<Classe> filteredClasses = allClasses
          .where((classe) => classe.idfaculter == widget.categoryId)
          .toList();
      setState(() {
        _classes = filteredClasses;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Erreur lors du chargement des classes');
    }
  }

  Future<void> _deleteClasse(Classe classe) async {
    final confirmed = await _showDeleteConfirmationDialog(classe.nom);
    if (!confirmed) return;

    setState(() => _isOperationInProgress = true);
    try {
      await SupabaseManagement().removeClasse(classe);
      await _loadClasses();
      _showSuccessSnackBar('Classe supprimée avec succès');
    } catch (error) {
      _showErrorSnackBar('Erreur lors de la suppression de la classe');
    } finally {
      setState(() => _isOperationInProgress = false);
    }
  }

  Future<bool> _showDeleteConfirmationDialog(String className) async {
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
                  'Êtes-vous sûr de vouloir supprimer la classe "$className" ?'),
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
        title: Text(
          'Classes ${widget.categoryName}',
          style:
              const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isOperationInProgress ? null : _loadClasses,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _isOperationInProgress
                ? null
                : () => _showAddClassDialog(context),
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
                    'Chargement des classes...',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ],
              ),
            )
          else if (_classes.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 80,
                    color: Colors.blue[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune classe trouvée',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyez sur + pour ajouter une classe',
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
              onRefresh: _loadClasses,
              color: Colors.blue,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _classes.length,
                itemBuilder: (context, index) {
                  final classe = _classes[index];
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
                              builder: (context) => FiliereScreen(
                                nomClasse: classe.nom,
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
                                    classe.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.blue[50],
                                        child: Icon(
                                          Icons.school,
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
                                      classe.nom,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.categoryTitle,
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
                                    icon: const Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FiliereScreen(
                                            nomClasse: classe.nom,
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
                                        : () => _deleteClasse(classe),
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

  Future<void> _showAddClassDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AddClasseDialog(
        categoryId: widget.categoryId,
        onClassAdded: _loadClasses,
      ),
    );
  }
}

class AddClasseDialog extends StatefulWidget {
  final int categoryId;
  final VoidCallback onClassAdded;

  const AddClasseDialog({
    Key? key,
    required this.categoryId,
    required this.onClassAdded,
  }) : super(key: key);

  @override
  _AddClasseDialogState createState() => _AddClasseDialogState();
}

class _AddClasseDialogState extends State<AddClasseDialog> {
  final TextEditingController _classeController = TextEditingController();
  String _imageUrl = '';
  bool _isUploading = false;
  bool _isSaving = false;
  File? _imageFile;

  @override
  void dispose() {
    _classeController.dispose();
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
      final filePath = 'classes/$fileName';

      await Supabase.instance.client.storage.from('avatars').upload(
            filePath,
            File(imageFile.path),
            fileOptions: const FileOptions(contentType: 'image/*'),
          );

      _imageUrl = await Supabase.instance.client.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

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

  Future<void> _addClass() async {
    if (_classeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez entrer le nom de la classe'),
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
      Classe newClasse = Classe(
        nom: _classeController.text.trim(),
        description: '',
        idfaculter: widget.categoryId,
        image: _imageUrl,
      );

      await SupabaseManagement().addClasse(newClasse);

      if (mounted) {
        Navigator.pop(context);
        widget.onClassAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Classe ajoutée avec succès'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Erreur lors de l\'ajout de la classe'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
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
    final maxDialogHeight = screenHeight * 0.8; // 80% of screen height
    final imageHeight = screenHeight * 0.12; // 12% of screen height

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
            // Title inside content
            Row(
              children: [
                Icon(Icons.school, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Ajouter une Classe',
                  style: TextStyle(
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
                      controller: _classeController,
                      decoration: InputDecoration(
                        labelText: 'Nom de la classe *',
                        labelStyle: const TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        prefixIcon: Icon(Icons.class_, color: Colors.blue[400]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Image de la classe',
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
          onPressed: _isSaving || _isUploading ? null : _addClass,
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
