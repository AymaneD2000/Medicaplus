import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/pdf.dart';
import 'package:moussa_project/Screens/pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfGridScreen extends StatefulWidget {
  String filiereId;

  PdfGridScreen({super.key, required this.filiereId});

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
    print(widget.filiereId);
    final pdfs = await supabaseManagement.getPDF(widget.filiereId);
    setState(() {
      _pdfs = pdfs;
    });
  }

  Future<void> _launchPDF(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardHeight = screenHeight * 0.14;
    return Scaffold(
            backgroundColor: const Color(0xFFFFF3CA),
      appBar: AppBar(
        title: const Text('Liste des PDF'),
      ),
      body: ListView.builder(
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 2,
        //   crossAxisSpacing: 10.0,
        //   mainAxisSpacing: 10.0,
        // ),
        itemCount: _pdfs.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFScreen(
                    path: _pdfs[index].url,
                  ),
                ),
              );
            },
            child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                            //margin: const EdgeInsets.only(left:  8, right: 8, bottom: ),
                            //shape: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              height: cardHeight,
                              child: Container(
                                //padding: EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  // image: DecorationImage(
                                  //   image: NetworkImage(fac.image),
                                  //   fit: BoxFit.cover,
                                  // ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //alignment: Alignment.bottomLeft,
                                  children: [
                                   SizedBox(width: MediaQuery.of(context).size.width*0.3, child: Image.network(_pdfs[index].image, fit: BoxFit.contain,)),
                                   const Spacer(),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _pdfs[index].nom,
                                          style: const TextStyle(
                                            fontFamily: 'TimesNewRoman',
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _pdfs[index].description,
                                          style: const TextStyle(
                                            fontFamily: 'TimesNewRoman',
                                            color: Colors.black,
                                            fontSize: 14,
                                            //fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    GestureDetector(onTap: (){
                                      _launchPDF(_pdfs[index].url);
                                    }, child: SizedBox(width: MediaQuery.of(context).size.width*0.1,child: Image.asset("assets/images/telecharger.png", scale: 20,)))
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
