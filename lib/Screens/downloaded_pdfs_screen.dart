import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../DatabaseManagement/pdf_download_service.dart';
import '../Models/downloaded_pdf.dart';
import 'pdfview.dart';

class DownloadedPdfsScreen extends StatefulWidget {
  const DownloadedPdfsScreen({super.key});

  @override
  State<DownloadedPdfsScreen> createState() => _DownloadedPdfsScreenState();
}

class _DownloadedPdfsScreenState extends State<DownloadedPdfsScreen> {
  List<DownloadedPdf> _downloadedPdfs = [];
  bool _isLoading = true;
  bool _isDeleting = false;

  // Modern color scheme - consistent blue theme
  final Color _primaryColor = const Color(0xFF1E88E5);
  final Color _secondaryColor = const Color(0xFF42A5F5);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<DownloadedPdf> get _filteredPdfs {
    if (_searchQuery.isEmpty) return _downloadedPdfs;

    return _downloadedPdfs.where((pdf) {
      final nameMatch =
          pdf.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final descMatch =
          pdf.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return nameMatch || descMatch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadDownloadedPdfs();
  }

  Future<void> _loadDownloadedPdfs() async {
    setState(() => _isLoading = true);
    try {
      final pdfs = await PdfDownloadService.getAllDownloadedPdfs();
      setState(() {
        _downloadedPdfs = pdfs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Erreur lors du chargement des téléchargements');
    }
  }

  Future<void> _deletePdf(DownloadedPdf pdf) async {
    final confirmed = await _showDeleteConfirmationDialog(pdf.name);
    if (!confirmed) return;

    setState(() => _isDeleting = true);
    try {
      final success = await PdfDownloadService.deleteDownloadedPdf(pdf.id);
      if (success) {
        await _loadDownloadedPdfs();
        _showSuccessSnackBar('PDF supprimé avec succès');
      } else {
        _showErrorSnackBar('Erreur lors de la suppression');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la suppression');
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  Future<void> _clearAllDownloads() async {
    final confirmed = await _showClearAllConfirmationDialog();
    if (!confirmed) return;

    setState(() => _isDeleting = true);
    try {
      final success = await PdfDownloadService.clearAllDownloads();
      if (success) {
        await _loadDownloadedPdfs();
        _showSuccessSnackBar('Tous les téléchargements supprimés');
      } else {
        _showErrorSnackBar('Erreur lors de la suppression');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la suppression');
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  Future<bool> _showDeleteConfirmationDialog(String pdfName) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  const Gap(12),
                  const Text(
                    'Supprimer ce PDF ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ce document sera retiré de vos téléchargements hors ligne.',
                    style: TextStyle(
                      fontSize: 14,
                      color: _textColor.withValues(alpha: 0.75),
                      height: 1.4,
                    ),
                  ),
                  const Gap(12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.picture_as_pdf_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                        const Gap(10),
                        Expanded(
                          child: Text(
                            pdfName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  style: TextButton.styleFrom(
                    foregroundColor: _textColor.withValues(alpha: 0.75),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _textColor.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: const Text('Annuler'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Supprimer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<bool> _showClearAllConfirmationDialog() async {
    final totalCount = _downloadedPdfs.length;

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_sweep_rounded,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  const Gap(12),
                  const Text(
                    'Supprimer tous les PDF ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vous allez supprimer définitivement tous les téléchargements hors ligne.',
                    style: TextStyle(
                      fontSize: 14,
                      color: _textColor.withValues(alpha: 0.75),
                      height: 1.4,
                    ),
                  ),
                  const Gap(12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      '$totalCount PDF${totalCount > 1 ? 's' : ''} concerné${totalCount > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  style: TextButton.styleFrom(
                    foregroundColor: _textColor.withValues(alpha: 0.75),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _textColor.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: const Text('Annuler'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  icon: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text(
                    'Tout supprimer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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

  Future<void> _showExternalDownloadDialog(DownloadedPdf pdf) async {
    if (pdf.originalId.isEmpty) {
      _showErrorSnackBar('Impossible d\'exporter ce PDF');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.ios_share_rounded,
                  color: Colors.green.shade700,
                  size: 30,
                ),
              ),
              const Gap(12),
              const Text(
                'Exporter le PDF',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirmez l\'export de ce document vers le stockage du téléphone.',
                style: TextStyle(
                  fontSize: 14,
                  color: _textColor.withValues(alpha: 0.75),
                  height: 1.4,
                ),
              ),
              const Gap(12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.picture_as_pdf_rounded,
                      color: _primaryColor,
                      size: 20,
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        pdf.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      color: Colors.green.shade700,
                      size: 18,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        'Destination: Téléchargements/MedPharm',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _textColor.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: _textColor.withValues(alpha: 0.75),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _textColor.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _exportToExternal(pdf);
              },
              icon: const Icon(Icons.download_rounded,
                  color: Colors.white, size: 18),
              label: const Text(
                'Exporter',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportToExternal(DownloadedPdf pdf) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const Gap(12),
              const Expanded(
                child: Text('Export en cours...'),
              ),
            ],
          ),
          backgroundColor: _primaryColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      final exportedPdf = await PdfDownloadService.exportToExternalStorage(
        pdf.localPath,
        pdf.originalId,
        pdf.name,
        pdf.description,
        pdf.originalUrl,
        context: context,
      );

      if (exportedPdf != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.download_done, color: Colors.white, size: 20),
                Gap(12),
                Expanded(
                  child: Text('PDF exporté avec succès!'),
                ),
              ],
            ),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Ouvrir dossier',
              textColor: Colors.white,
              onPressed: () {
                _showExternalDownloadInfo(exportedPdf.localPath);
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'export: ${e.toString()}');
    }
  }

  void _showExternalDownloadInfo(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.folder_open_rounded,
                  color: _primaryColor,
                  size: 30,
                ),
              ),
              const Gap(12),
              const Text(
                'Fichier sauvegardé',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Votre document a été exporté avec succès dans le dossier dédié.',
                style: TextStyle(
                  fontSize: 14,
                  color: _textColor.withValues(alpha: 0.75),
                  height: 1.4,
                ),
              ),
              const Gap(12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.insert_drive_file_rounded,
                      color: _primaryColor,
                      size: 18,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        filePath,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: _textColor.withValues(alpha: 0.85),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Text(
                'Dossier: Téléchargements/MedPharm',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _textColor.withValues(alpha: 0.75),
                ),
              ),
              const Gap(8),
              Text(
                'Vous pouvez ouvrir ce fichier avec votre gestionnaire de fichiers ou une application PDF.',
                style: TextStyle(
                  fontSize: 13,
                  color: _textColor.withValues(alpha: 0.65),
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: _textColor.withValues(alpha: 0.75),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _textColor.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher des pdf...',
                hintStyle: TextStyle(
                  color: _textColor.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: _primaryColor,
                  size: 24,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: _textColor.withValues(alpha: 0.5),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              style: TextStyle(
                color: _textColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadStats() {
    final totalCount = _downloadedPdfs.length;
    final filteredCount = _filteredPdfs.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.download_done_rounded,
                color: _primaryColor,
                size: 22,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$totalCount PDF téléchargé${totalCount > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    Text(
                      '$filteredCount résultat${filteredCount > 1 ? 's' : ''} affiché${filteredCount > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 13,
                        color: _textColor.withValues(alpha: 0.65),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildModernAppBar(),
          SliverToBoxAdapter(child: _buildSearchAndFilters()),
          SliverToBoxAdapter(child: _buildDownloadStats()),
          SliverToBoxAdapter(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: _primaryColor, // Force la couleur de fond
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primaryColor, _secondaryColor],
            ),
          ),
        ),
        title: const Text(
          'Téléchargements',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (_downloadedPdfs.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.delete_sweep,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: _isDeleting ? null : _clearAllDownloads,
              tooltip: 'Supprimer tout',
            ),
          ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.refresh,
                size: 20,
                color: Colors.white,
              ),
            ),
            onPressed: _isLoading ? null : _loadDownloadedPdfs,
            tooltip: 'Actualiser',
          ),
        ),
      ],
    );
  }

  // Widget _buildContent() {
  //   if (_isLoading) {
  //     return _buildLoadingView();
  //   }

  //   if (_downloadedPdfs.isEmpty) {
  //     return _buildEmptyView();
  //   }

  //   return Column(
  //     children: [
  //       _buildStorageInfo(),
  //       _buildPdfList(),
  //     ],
  //   );
  // }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_downloadedPdfs.isEmpty) {
      return _buildEmptyView();
    }

    return Column(
      children: [
        _filteredPdfs.isEmpty ? _buildEmptySearchResults() : _buildPdfList(),
      ],
    );
  }

  // New widget for empty search results
  Widget _buildEmptySearchResults() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: _textColor.withValues(alpha: 0.3),
            ),
            const Gap(16),
            Text(
              'Aucun résultat trouvé',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: _textColor,
              ),
            ),
            const Gap(8),
            Text(
              'Aucun document ne correspond à "$_searchQuery"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: _primaryColor),
            const Gap(16),
            Text(
              'Chargement des téléchargements...',
              style: TextStyle(
                color: _textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: _primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 80,
                color: _primaryColor.withValues(alpha: 0.2),
              ),
            ),
            const Gap(32),
            Text(
              'Aucun téléchargement',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: _textColor,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Text(
              "Vous n'avez pas encore de documents\nenregistrés pour une lecture hors ligne.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: _textColor.withValues(alpha: 0.5),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPdfList() {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     itemCount: _downloadedPdfs.length,
  //     itemBuilder: (context, index) {
  //       final pdf = _downloadedPdfs[index];
  //       return _buildPdfCard(pdf);
  //     },
  //   );
  // }

  Widget _buildPdfList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredPdfs.length,
      itemBuilder: (context, index) {
        final pdf = _filteredPdfs[index];
        return _buildPdfCard(pdf);
      },
    );
  }

  Widget _buildPdfCard(DownloadedPdf pdf) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFScreen(
                  path: pdf.localPath,
                  pdfName: pdf.name,
                  isLocalFile: true,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // PDF Thumbnail style icon
                Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _primaryColor.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: _primaryColor,
                      size: 32,
                    ),
                  ),
                ),
                const Gap(16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pdf.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _textColor,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (pdf.hasLogo)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'PRO',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Gap(4),
                      Text(
                        pdf.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: _textColor.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(12),
                      Row(
                        children: [
                          _buildMetaData(Icons.access_time_rounded,
                              _formatDate(pdf.downloadDate)),
                          const Gap(12),
                          _buildMetaData(Icons.save_outlined,
                              _formatFileSize(pdf.fileSize)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Actions
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      icon: Icons.ios_share_rounded,
                      color: Colors.blue.shade600,
                      onPressed: () => _showExternalDownloadDialog(pdf),
                      tooltip: 'Exporter',
                    ),
                    const Gap(8),
                    _buildActionButton(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.red.shade400,
                      onPressed: () => _deletePdf(pdf),
                      tooltip: 'Supprimer',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaData(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: _textColor.withValues(alpha: 0.4)),
        const Gap(4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: _textColor.withValues(alpha: 0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: _isDeleting ? null : onPressed,
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(8),
        icon: Icon(icon, color: color, size: 18),
        tooltip: tooltip,
      ),
    );
  }
}
