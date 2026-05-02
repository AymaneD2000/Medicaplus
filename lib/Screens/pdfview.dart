import 'dart:async';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:medpharm/Models/pdf.dart';
import 'package:medpharm/DatabaseManagement/pdf_download_service.dart';
import 'package:medpharm/DatabaseManagement/supabasemanagement.dart';
import 'package:medpharm/Screens/downloaded_pdfs_screen.dart';
import 'package:medpharm/Utils/transitions.dart';
import 'package:gap/gap.dart';

class PDFScreen extends StatefulWidget {
  final String? path;
  final String? pdfName;
  final bool isLocalFile;
  final Pdf? pdf; // PDF object for download functionality

  const PDFScreen({
    Key? key,
    this.path,
    this.pdfName,
    this.isLocalFile = false,
    this.pdf,
  }) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  String errorMessage = '';
  bool _isDownloading = false;
  Set<String> _downloadingPdfs = {};
  bool _isPdfLoading = true;
  String? _resolvedPath;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _totalPages = 0;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _resolvePdfPath();
  }

  Future<void> _resolvePdfPath() async {
    final rawPath = widget.path;

    if (rawPath == null || rawPath.trim().isEmpty) {
      if (!mounted) return;
      setState(() {
        _resolvedPath = null;
        _isPdfLoading = false;
      });
      return;
    }

    if (widget.isLocalFile || rawPath.startsWith('http')) {
      if (!mounted) return;
      setState(() {
        _resolvedPath = rawPath;
      });
      return;
    }

    try {
      var storagePath = rawPath.trim();
      while (storagePath.startsWith('/')) {
        storagePath = storagePath.substring(1);
      }
      if (storagePath.startsWith('avatars/')) {
        storagePath = storagePath.substring('avatars/'.length);
      }

      final signedUrl = await SupabaseManagement.supabase.storage
          .from('avatars')
          .createSignedUrl(
            storagePath,
            SupabaseManagement.signedUrlExpiryInSeconds,
          );

      if (!mounted) return;
      setState(() {
        _resolvedPath = signedUrl;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Impossible d’ouvrir le PDF: $e';
        _isPdfLoading = false;
      });
    }
  }

  // Modern color scheme - consistent blue theme
  final Color _primaryColor = const Color(0xFF1E88E5);

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _primaryColor,
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
            border: Border.all(color: color.withOpacity(0.1), width: 1.5),
            color: color.withOpacity(0.03),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
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
                color: color.withOpacity(0.5),
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
                  color: Colors.green.withOpacity(0.1),
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
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
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
      _isDownloading = true;
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
                      'PDF sauvegardé dans Téléchargements/MedPharm!',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
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
              backgroundColor: Colors.green,
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
        _isDownloading = false;
      });
    }
  }

  void _handleDocumentLoaded(PdfDocumentLoadedDetails details) {
    if (!mounted) return;

    setState(() {
      _isPdfLoading = false;
      _totalPages = details.document.pages.count;
      _currentPage = 1;
    });
  }

  void _handleDocumentLoadFailed(PdfDocumentLoadFailedDetails details) {
    if (!mounted) return;

    setState(() {
      _isPdfLoading = false;
      _totalPages = 0;
      errorMessage = 'Erreur de chargement: ${details.error}';
    });
  }

  void _handlePageChanged(PdfPageChangedDetails details) {
    if (!mounted) return;

    setState(() {
      _currentPage = details.newPageNumber;
    });
  }

  Future<void> _showGoToPageDialog() async {
    if (_totalPages <= 0) return;

    var pageInput = _currentPage.toString();

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.find_in_page_rounded,
                  color: _primaryColor,
                  size: 22,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Aller à la page',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      'Pages disponibles: 1 - $_totalPages',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: TextFormField(
            initialValue: pageInput,
            autofocus: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Entrer le numéro de page',
              prefixIcon: Icon(
                Icons.numbers_rounded,
                color: _primaryColor,
              ),
              filled: true,
              fillColor: _primaryColor.withValues(alpha: 0.04),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: _primaryColor.withValues(alpha: 0.25),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: _primaryColor,
                  width: 1.8,
                ),
              ),
            ),
            onChanged: (value) => pageInput = value,
            onFieldSubmitted: (value) => _jumpToPage(value, dialogContext),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Annuler',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _jumpToPage(pageInput, dialogContext),
              icon: const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Colors.white,
              ),
              label: const Text(
                'Aller',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
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

  void _jumpToPage(String value, BuildContext dialogContext) {
    final page = int.tryParse(value.trim());
    if (page == null || page < 1 || page > _totalPages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer un numéro entre 1 et $_totalPages.'),
          backgroundColor: _primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    _pdfViewerController.jumpToPage(page);
    Navigator.of(dialogContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.pdfName ?? "Document",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          if (widget.path != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.28),
                ),
              ),
              child: Center(
                child: Text(
                  _totalPages > 0 ? '$_currentPage/$_totalPages' : '--/--',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (widget.path != null)
            IconButton(
              icon: const Icon(Icons.find_in_page_rounded, color: Colors.white),
              onPressed: (!_isPdfLoading && _totalPages > 0)
                  ? _showGoToPageDialog
                  : null,
              tooltip: 'Aller à la page',
            ),
          if (!widget.isLocalFile &&
              widget.pdf !=
                  null) // Only show download button for network PDFs with PDF object
            IconButton(
              icon: _isDownloading || _downloadingPdfs.contains(widget.pdf!.id)
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download, color: Colors.white),
              onPressed:
                  (_isDownloading || _downloadingPdfs.contains(widget.pdf!.id))
                      ? null
                      : () => _showDownloadDialog(widget.pdf!),
              tooltip: 'Télécharger le PDF',
            ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SfPdfViewerTheme(
          data: const SfPdfViewerThemeData(
            backgroundColor: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              // White background container
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
              ),
              // PDF Viewer wrapped in Material with white background
              Material(
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: _resolvedPath != null
                      ? widget.isLocalFile
                          ? SfPdfViewer.file(
                              File(_resolvedPath!),
                              controller: _pdfViewerController,
                              canShowPaginationDialog: false,
                              pageSpacing: 8,
                              onDocumentLoaded: _handleDocumentLoaded,
                              onDocumentLoadFailed: _handleDocumentLoadFailed,
                              onPageChanged: _handlePageChanged,
                            )
                          : SfPdfViewer.network(
                              _resolvedPath!,
                              controller: _pdfViewerController,
                              canShowPaginationDialog: false,
                              pageSpacing: 8,
                              onDocumentLoaded: _handleDocumentLoaded,
                              onDocumentLoadFailed: _handleDocumentLoadFailed,
                              onPageChanged: _handlePageChanged,
                            )
                      : const Center(
                          child: Text(
                            'Aucun PDF à afficher',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                ),
              ),
              // Loading overlay with white background
              if (_isPdfLoading && widget.path != null)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                    ),
                  ),
                ),
              if (errorMessage.isNotEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            errorMessage = '';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
