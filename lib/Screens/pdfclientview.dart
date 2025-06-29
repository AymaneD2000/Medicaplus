import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/DatabaseManagement/pdf_download_service.dart';
import 'package:moussa_project/Models/pdf.dart';
import 'package:moussa_project/Screens/pdfview.dart';
import 'package:moussa_project/Screens/downloaded_pdfs_screen.dart';
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
  bool _isDownloading = false;
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

  Future<void> _launchPDF(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        _showErrorSnackBar("Impossible d'ouvrir le PDF.");
      }
    } catch (e) {
      _showErrorSnackBar("Erreur lors de l'ouverture du PDF.");
    }
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
                'Comment souhaitez-vous télécharger "${pdf.nom}" ?',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.smartphone, color: _primaryColor, size: 16),
                        const Gap(8),
                        const Text(
                          'Téléchargement Simple',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Gap(4),
                    const Text(
                      'Sauvegarde dans l\'application pour lecture hors ligne',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.share, color: Colors.green[600], size: 16),
                        const Gap(8),
                        const Text(
                          'Avec Logo MedicaPlus',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Gap(4),
                    const Text(
                      'Ajoute le logo et sauvegarde dans Téléchargements pour partage',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _downloadPdf(pdf, false);
              },
              icon: const Icon(Icons.download, color: Colors.white, size: 18),
              label: const Text(
                'Simple',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _downloadPdf(pdf, true);
              },
              icon: const Icon(Icons.verified, color: Colors.white, size: 18),
              label: const Text(
                'Avec Logo',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAlreadyDownloadedDialog(dynamic downloadedPdf) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 24),
              const Gap(8),
              const Text(
                'Déjà téléchargé',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: Text(
            'Ce PDF est déjà téléchargé dans votre appareil. Vous pouvez le consulter dans la section "Téléchargements".',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadedPdfsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.folder, color: Colors.white, size: 18),
              label: const Text(
                'Voir téléchargements',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showExternalDownloadInfo(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.folder_open, color: Colors.blue[600], size: 24),
              const Gap(8),
              const Text(
                'Fichier sauvegardé',
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
              const Text(
                'Le PDF avec logo a été sauvegardé dans:',
                style: TextStyle(fontSize: 16),
              ),
              const Gap(12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  filePath,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: Colors.black87,
                  ),
                ),
              ),
              const Gap(12),
              const Text(
                'Vous pouvez ouvrir ce fichier avec votre gestionnaire de fichiers ou une application PDF.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
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
                      ? 'Téléchargement avec logo en cours...'
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
          // Show different message for external download with logo
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.download_done, color: Colors.white, size: 20),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      'PDF avec logo sauvegardé dans Téléchargements!',
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const Gap(12),
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
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
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
        title: _isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Rechercher un document...',
                    hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.white70, size: 20),
                  ),
                  onChanged: _filterPdfs,
                ),
              )
            : const Text(
                'Documents PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        centerTitle: true,
      ),
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
                  color: Colors.white.withOpacity(0.2),
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
                  color: Colors.white.withOpacity(0.2),
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
                    color: Colors.black.withOpacity(0.1),
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
                color: _textColor.withOpacity(0.7),
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
            color: Colors.black.withOpacity(0.05),
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
              color: _primaryColor.withOpacity(0.1),
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
                    color: _textColor.withOpacity(0.7),
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
            color: cardColor.withOpacity(0.15),
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
                    PDFScreen(path: pdf.url, pdfName: pdf.nom),
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
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: pdf.image,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: cardColor.withOpacity(0.1),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(cardColor),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: cardColor.withOpacity(0.1),
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
                            color: _textColor.withOpacity(0.7),
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
                      //         color: cardColor.withOpacity(0.1),
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
                        color: cardColor.withOpacity(0.1),
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
                        color: cardColor.withOpacity(0.1),
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
                    color: Colors.black.withOpacity(0.1),
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
                color: _textColor.withOpacity(0.7),
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
                    color: Colors.black.withOpacity(0.1),
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
                color: _textColor.withOpacity(0.7),
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
