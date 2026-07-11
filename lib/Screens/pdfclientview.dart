import 'package:flutter/material.dart';
import 'package:medpharm/DatabaseManagement/supabasemanagement.dart';
import 'package:medpharm/DatabaseManagement/pdf_download_service.dart';
import 'package:medpharm/Models/pdf.dart';

import 'package:medpharm/Utils/transitions.dart';
import 'package:medpharm/Screens/pdfview.dart';
import 'package:medpharm/Screens/downloaded_pdfs_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';

class PdfGridScreen extends StatefulWidget {
  final String filiereId;

  const PdfGridScreen({super.key, required this.filiereId});

  @override
  State<PdfGridScreen> createState() => _PdfGridScreenState();
}

class _PdfGridScreenState extends State<PdfGridScreen> {
  List<Pdf> _pdfs = [];
  List<Pdf> _filteredPdfs = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  Set<String> _downloadingPdfs = {};

  // Modern color scheme - consistent blue theme
  final Color _primaryColor = const Color(0xFF1E88E5);
  final Color _secondaryColor = const Color(0xFF42A5F5);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF1D1B20);
  final Color _accentColor = const Color(0xFF1976D2);

  @override
  void initState() {
    super.initState();
    _loadPdfs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPdfs(String query) {
    setState(() {
      _filteredPdfs = _pdfs.where((pdf) {
        final titleLower = pdf.nom.toLowerCase();
        final descriptionLower = pdf.description.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();
      // Maintain sorting order after filtering
      _filteredPdfs.sort(_comparePdfNames);
    });
  }

  Future<void> _loadPdfs() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final supabaseManagement = SupabaseManagement();
      final pdfs = await supabaseManagement.getPDF(widget.filiereId);
      // Sort PDFs: non-numbered names first (A-Z), then numbered names (1 -> N)
      pdfs.sort(_comparePdfNames);
      setState(() {
        _pdfs = pdfs;
        _filteredPdfs = pdfs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Erreur lors du chargement des documents';
      });
      _showErrorSnackBar("Erreur lors du chargement des PDF: $e");
    }
  }

  /// Extracts leading number from a string, returns null if no leading number
  int? _extractLeadingNumber(String name) {
    final match = RegExp(r'^(\d+)').firstMatch(name.trim());
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  /// Compares two PDF names for sorting:
  /// - Names without leading numbers come first, sorted alphabetically (A-Z)
  /// - Names starting with numbers come after, sorted numerically (small to large)
  int _comparePdfNames(Pdf a, Pdf b) {
    final numA = _extractLeadingNumber(a.nom);
    final numB = _extractLeadingNumber(b.nom);

    // Neither has a leading number - sort alphabetically
    if (numA == null && numB == null) {
      return a.nom.toLowerCase().compareTo(b.nom.toLowerCase());
    }
    // Only A has no leading number - A comes first
    if (numA == null) {
      return -1;
    }
    // Only B has no leading number - B comes first
    if (numB == null) {
      return 1;
    }
    // Both have leading numbers - sort numerically
    return numA.compareTo(numB);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _showDownloadDialog(Pdf pdf) async {
    // Check if already downloaded
    final isDownloaded = await PdfDownloadService.isPdfDownloaded(pdf.id);

    if (isDownloaded) {
      final downloadedPdf = await PdfDownloadService.getDownloadedPdf(pdf.id);
      if (downloadedPdf != null) {
        _showAlreadyDownloadedDialog(downloadedPdf);
        return;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.download, color: _primaryColor, size: 24),
              const Gap(8),
              const Text(
                'Télécharger le PDF',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
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
                'Selectionnez une option :',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              const Gap(16),
              // Option: Internal download
              _buildDownloadOptionCard(
                title: "Dans l'application",
                subtitle: "Lecture hors ligne sécurisée",
                icon: Icons.smartphone_rounded,
                color: _primaryColor,
                onTap: () {
                  Navigator.of(context).pop();
                  _downloadPdf(pdf, false);
                },
              ),
              const Gap(12),
              // Option: External download
              _buildDownloadOptionCard(
                title: "Dans le téléphone",
                subtitle: "Partage et gestion externe",
                icon: Icons.file_download_outlined,
                color: Colors.green.shade600,
                onTap: () {
                  Navigator.of(context).pop();
                  _downloadPdf(pdf, true);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ANNULER',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDownloadOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
            color: color.withValues(alpha: 0.03),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: color.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlreadyDownloadedDialog(dynamic downloadedPdf) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.green.shade600,
                  size: 48,
                ),
              ),
              const Gap(16),
              const Text(
                'Déjà présent',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          content: Text(
            'Ce document est déjà disponible sur votre appareil. Souhaitez-vous le consulter maintenant ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      PremiumPageRoute(page: const DownloadedPdfsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Voir mes téléchargements',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Gap(8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Plus tard',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
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

  Future<void> _downloadPdf(Pdf pdf, bool addLogo) async {
    setState(() {
      _downloadingPdfs.add(pdf.id);
    });

    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
              Expanded(
                child: Text(
                  addLogo
                      ? 'Téléchargement en cours...'
                      : 'Téléchargement en cours...',
                ),
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

      final downloadedPdf = await PdfDownloadService.downloadPdf(
        originalId: pdf.id,
        name: pdf.nom,
        description: pdf.description,
        url: pdf.url,
        addLogo: addLogo,
      );

      if (downloadedPdf != null) {
        if (addLogo) {
          // Show different message for external download
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.download_done, color: Colors.white, size: 20),
                  Gap(12),
                  Expanded(
                    child: Text(
                      'PDF sauvegardé dans Téléchargements/MedPharm !',
                    ),
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
                  // Try to open file manager or show path info
                  _showExternalDownloadInfo(downloadedPdf.localPath);
                },
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else {
          // Show message for internal app download
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  Gap(12),
                  Expanded(
                    child: Text('PDF téléchargé dans l\'application!'),
                  ),
                ],
              ),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Voir',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DownloadedPdfsScreen(),
                    ),
                  );
                },
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors du téléchargement: ${e.toString()}');
    } finally {
      setState(() {
        _downloadingPdfs.remove(pdf.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildModernAppBar(),
          SliverToBoxAdapter(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar() {
    final showResultCount = _isSearching && _searchController.text.isNotEmpty;

    return SliverAppBar(
      expandedHeight: _isSearching ? (showResultCount ? 178 : 158) : 140,
      pinned: true,
      backgroundColor: _primaryColor,
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
        title: Text(
          _isSearching ? 'Recherche' : 'Documents PDF',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      bottom: _isSearching
          ? PreferredSize(
              preferredSize: Size.fromHeight(showResultCount ? 104 : 84),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        cursorColor: Colors.blue,
                        textInputAction: TextInputAction.search,
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Rechercher un document...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.blue,
                            size: 24,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterPdfs('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.blue.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.blue.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: _cardColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        onChanged: _filterPdfs,
                      ),
                    ),
                    if (showResultCount) ...[
                      const Gap(12),
                      Text(
                        '${_filteredPdfs.length} document${_filteredPdfs.length > 1 ? 's' : ''} trouvé${_filteredPdfs.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )
          : null,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                _filteredPdfs = _pdfs;
              }
            });
          },
        ),
        if (!_isSearching) ...[
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
                  Icons.download_done,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadedPdfsScreen(),
                  ),
                );
              },
              tooltip: 'Téléchargements',
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
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: _loadPdfs,
              tooltip: 'Actualiser',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_hasError) {
      return _buildErrorView();
    }

    if (_filteredPdfs.isEmpty) {
      return _buildEmptyView();
    }

    return _buildPdfGrid();
  }

  Widget _buildLoadingView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                strokeWidth: 3,
              ),
            ),
            const Gap(24),
            Text(
              'Chargement des documents...',
              style: TextStyle(
                color: _textColor.withValues(alpha: 0.7),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfGrid() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          const Gap(20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredPdfs.length,
            itemBuilder: (context, index) {
              final pdf = _filteredPdfs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildPdfCard(pdf, index),
              );
            },
          ),
          const Gap(20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.picture_as_pdf_outlined,
              color: _primaryColor,
              size: 24,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Documents PDF',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const Gap(4),
                Text(
                  '${_filteredPdfs.length} document${_filteredPdfs.length > 1 ? 's' : ''} disponible${_filteredPdfs.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: _textColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfCard(Pdf pdf, int index) {
    final colors = [
      _primaryColor,
      _secondaryColor,
      _accentColor,
      const Color(0xFF2196F3),
      const Color(0xFF1565C0),
      const Color(0xFF0D47A1),
    ];
    final cardColor = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PDFScreen(path: pdf.url, pdfName: pdf.nom, pdf: pdf),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // PDF Thumbnail
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    // color: cardColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: pdf.image,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: cardColor.withValues(alpha: 0.1),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(cardColor),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: cardColor.withValues(alpha: 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf_outlined,
                              color: cardColor,
                              size: 32,
                            ),
                            const Gap(4),
                            Text(
                              'PDF',
                              style: TextStyle(
                                color: cardColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                // PDF Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pdf.nom,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (pdf.description.isNotEmpty) ...[
                        const Gap(8),
                        Text(
                          pdf.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: _textColor.withValues(alpha: 0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const Gap(12),
                      // Row(
                      //   children: [
                      //     Container(
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 8, vertical: 4),
                      //       decoration: BoxDecoration(
                      //         color: cardColor.withValues(alpha: 0.1),
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //       child: Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Icon(
                      //             Icons.picture_as_pdf_outlined,
                      //             color: cardColor,
                      //             size: 14,
                      //           ),
                      //           const Gap(4),
                      //           Text(
                      //             'PDF',
                      //             style: TextStyle(
                      //               color: cardColor,
                      //               fontSize: 12,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                const Gap(16),
                // Action Buttons
                Column(
                  children: [
                    // View Button
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PDFScreen(path: pdf.url, pdfName: pdf.nom),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.visibility_outlined,
                          color: cardColor,
                          size: 20,
                        ),
                        tooltip: 'Voir le PDF',
                      ),
                    ),
                    const Gap(8),
                    // Download Button
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _downloadingPdfs.contains(pdf.id)
                          ? Container(
                              padding: const EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: cardColor,
                                ),
                              ),
                            )
                          : IconButton(
                              onPressed: () => _showDownloadDialog(pdf),
                              icon: Icon(
                                Icons.download_outlined,
                                color: cardColor,
                                size: 20,
                              ),
                              tooltip: 'Télécharger dans l\'app',
                            ),
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

  Widget _buildErrorView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: _accentColor,
              ),
            ),
            const Gap(32),
            Text(
              _errorMessage,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            Text(
              "Veuillez vérifier votre connexion\net réessayer",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _textColor.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            const Gap(32),
            ElevatedButton.icon(
              onPressed: _loadPdfs,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                "Réessayer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.picture_as_pdf_outlined,
                size: 64,
                color: _primaryColor,
              ),
            ),
            const Gap(32),
            Text(
              _isSearching
                  ? "Aucun résultat trouvé"
                  : "Aucun document disponible",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            Text(
              _isSearching
                  ? "Essayez d'autres termes de recherche"
                  : "Aucun document PDF n'est disponible\npour ce module",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _textColor.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            const Gap(32),
            ElevatedButton.icon(
              onPressed: _loadPdfs,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                "Actualiser",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
