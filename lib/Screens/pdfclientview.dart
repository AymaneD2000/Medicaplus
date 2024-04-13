import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfGridScreen extends StatefulWidget {
  String filiereId;

  PdfGridScreen({required this.filiereId});

  @override
  State<PdfGridScreen> createState() => _PdfGridScreenState();
}

class _PdfGridScreenState extends State<PdfGridScreen> {
List<Pdf> _pdfs = [];
  @override
  void initState() {
    super.initState();
    _fetchPdfs();
  }

  Future<void> _fetchPdfs() async {
    final supabaseManagement = SupabaseManagement();
    final pdfs = await supabaseManagement.getDocuments();
    setState(() {
      _pdfs = pdfs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des PDFs'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _pdfs.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Action à effectuer lorsque l'utilisateur appuie sur un PDF
              // Par exemple : ouvrir le PDF
            },
            child: Card(
              elevation: 5.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.network(
                    _pdfs[index].image,
                    fit: BoxFit.cover,
                  ),
                  // PDF Name Centered
                  Center(
                    child: Text(
                      _pdfs[index].nom,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        backgroundColor: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
