import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/filiere.dart';
import 'package:moussa_project/Screens/pdfclientview.dart';

class FiliereGridScreen extends StatefulWidget {
  final String className;
  const FiliereGridScreen({super.key, required this.className});

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
        final double screenHeight = MediaQuery.of(context).size.height;
    final double cardHeight = screenHeight * 0.26;
    return Scaffold(
      backgroundColor: const Color(0xFFD4EEED),
      appBar: AppBar(
        title: const Text('Liste des modules'),
      ),
      body: ListView.builder(
        itemCount: _filieres.length,
        itemBuilder: (BuildContext context, int index) {
          return _filieres.isEmpty
              ? const Center()
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfGridScreen(
                                  filiereId: _filieres[index].id,
                                )));
                  },
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                            margin: const EdgeInsets.only(left:  55, right: 55, bottom: 12),
                            //shape: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              height: cardHeight,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  // image: DecorationImage(
                                  //   image: NetworkImage(fac.image),
                                  //   fit: BoxFit.cover,
                                  // ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Column(
                                  //alignment: Alignment.bottomLeft,
                                  children: [
                                    Expanded(child: Image.network(_filieres[index].image, fit: BoxFit.contain,)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _filieres[index].nom,
                                        style: const TextStyle(
                                          fontFamily: 'TimesNewRoman',
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                ),
                );
        },
      ),
    );
  }
}
