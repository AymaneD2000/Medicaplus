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
  int _totalStorageUsed = 0;

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
    _loadDownloadedPdfs();
  }

  Future<void> _loadDownloadedPdfs() async {
    setState(() => _isLoading = true);
    try {
      final pdfs = await PdfDownloadService.getAllDownloadedPdfs();
      final totalStorage = await PdfDownloadService.getTotalStorageUsed();
      setState(() {
        _downloadedPdfs = pdfs;
        _totalStorageUsed = totalStorage;
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
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Confirmer la suppression',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              content: Text('Êtes-vous sûr de vouloir supprimer "$pdfName" ?'),
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

  Future<bool> _showClearAllConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Supprimer tous les téléchargements',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              content: const Text(
                  'Êtes-vous sûr de vouloir supprimer tous les PDFs téléchargés ? Cette action est irréversible.'),
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
                  child: const Text('Tout supprimer'),
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
        title: const Text(
          'Téléchargements',
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
        if (_downloadedPdfs.isNotEmpty)
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
                color: Colors.white.withOpacity(0.2),
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

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_downloadedPdfs.isEmpty) {
      return _buildEmptyView();
    }

    return Column(
      children: [
        _buildStorageInfo(),
        _buildPdfList(),
      ],
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
                Icons.download_outlined,
                size: 64,
                color: _primaryColor,
              ),
            ),
            const Gap(32),
            Text(
              'Aucun téléchargement',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            Text(
              'Vous n\'avez pas encore téléchargé\nde documents PDF',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _textColor.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Icons.storage,
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
                  'Espace utilisé',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                const Gap(4),
                Text(
                  '${_formatFileSize(_totalStorageUsed)} • ${_downloadedPdfs.length} document${_downloadedPdfs.length > 1 ? 's' : ''}',
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

  Widget _buildPdfList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _downloadedPdfs.length,
      itemBuilder: (context, index) {
        final pdf = _downloadedPdfs[index];
        return _buildPdfCard(pdf);
      },
    );
  }

  Widget _buildPdfCard(DownloadedPdf pdf) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 6,
        color: _cardColor,
        shadowColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.picture_as_pdf,
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
                            pdf.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(4),
                          Text(
                            pdf.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: _textColor.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (pdf.hasLogo)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified,
                              size: 12,
                              color: Colors.green[700],
                            ),
                            const Gap(4),
                            Text(
                              'Logo',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const Gap(16),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: _textColor.withOpacity(0.5),
                    ),
                    const Gap(4),
                    Text(
                      _formatDate(pdf.downloadDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: _textColor.withOpacity(0.5),
                      ),
                    ),
                    const Gap(16),
                    Icon(
                      Icons.storage,
                      size: 14,
                      color: _textColor.withOpacity(0.5),
                    ),
                    const Gap(4),
                    Text(
                      _formatFileSize(pdf.fileSize),
                      style: TextStyle(
                        fontSize: 12,
                        color: _textColor.withOpacity(0.5),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _isDeleting ? null : () => _deletePdf(pdf),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red[400],
                        size: 20,
                      ),
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
}
