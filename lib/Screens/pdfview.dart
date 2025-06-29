import 'dart:async';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PDFScreen extends StatefulWidget {
  final String? path;
  final String? pdfName;
  final bool isLocalFile;

  const PDFScreen({
    Key? key,
    this.path,
    this.pdfName,
    this.isLocalFile = false,
  }) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  String errorMessage = '';
  bool _isDownloading = false;

  Future<void> _downloadPdf() async {
    if (widget.path == null) return;

    setState(() => _isDownloading = true);

    try {
      // Show downloading snackbar with fixed behavior to avoid layout conflicts
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Ouverture du téléchargement...'),
            ],
          ),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 2),
        ),
      );

      // Launch the PDF URL using url_launcher (same approach as pdfclientview)
      if (await canLaunchUrl(Uri.parse(widget.path!))) {
        await launchUrl(
          Uri.parse(widget.path!),
          mode: LaunchMode.externalApplication,
        );

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'PDF ouvert pour téléchargement: ${widget.pdfName ?? "document"}'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.fixed,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        throw Exception("Impossible d'ouvrir le PDF pour téléchargement");
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du téléchargement: $error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          if (!widget.isLocalFile) // Only show download button for network PDFs
            IconButton(
              icon: _isDownloading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download, color: Colors.white),
              onPressed: _isDownloading ? null : _downloadPdf,
              tooltip: 'Télécharger le PDF',
            ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          widget.path != null
              ? widget.isLocalFile
                  ? SfPdfViewer.file(
                      File(widget.path!),
                      onDocumentLoadFailed:
                          (PdfDocumentLoadFailedDetails details) {
                        setState(() {
                          errorMessage =
                              'Erreur de chargement: ${details.error}';
                        });
                      },
                    )
                  : SfPdfViewer.network(
                      widget.path!,
                      onDocumentLoadFailed:
                          (PdfDocumentLoadFailedDetails details) {
                        setState(() {
                          errorMessage =
                              'Erreur de chargement: ${details.error}';
                        });
                      },
                    )
              : const Center(
                  child: Text(
                    'Aucun PDF à afficher',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
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
    );
  }
}
