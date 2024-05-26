import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/filiere.dart';
import 'package:moussa_project/Screens/pdfclientview.dart';

class FiliereGridScreen extends StatefulWidget {
  final String className;
  FiliereGridScreen({required this.className});

  @override
  State<FiliereGridScreen> createState() => _FiliereGridScreenState();
}

class _FiliereGridScreenState extends State<FiliereGridScreen> {
  List<Filiere> _filieres = [];
  @override
  void initState() {
    super.initState();
    _fetchFilieres();
  }

  Future<void> _fetchFilieres() async {
    final supabaseManagement = SupabaseManagement();
    final filieres =
        await supabaseManagement.getClasseFilieres(widget.className);
    setState(() {
      _filieres = filieres;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Filières'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _filieres.length,
        itemBuilder: (BuildContext context, int index) {
          return _filieres.isEmpty
              ? Center()
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfGridScreen(
                                  filiereId: _filieres[index].id,
                                )));
                  },
                  child: Card(
                    elevation: 5.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background Image
                        Image.network(
                          _filieres[index].image,
                          fit: BoxFit.cover,
                        ),
                        // Filiere Name Centered
                        Center(
                          child: Text(
                            _filieres[index].nom,
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
