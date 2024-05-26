import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/faculter.dart';
import 'package:moussa_project/Screens/classviewr.dart';

class Faculter extends StatefulWidget {
  const Faculter({Key? key}) : super(key: key);

  @override
  _FaculterState createState() => _FaculterState();
}

class _FaculterState extends State<Faculter> {
  List<Fac>? faculties;
  final supabaseManagement = SupabaseManagement();

  Future<void> fetchFaculter() async {
    faculties = await supabaseManagement.faculter();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchFaculter();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardHeight = screenHeight * 0.4;

    return Scaffold(
        appBar: AppBar(
          title: const Text("List of Faculties"),
        ),
        body: faculties != null
            ? faculties!.isNotEmpty
                ? ListView.builder(
                    itemCount: faculties!.length,
                    itemBuilder: (context, index) {
                      final fac = faculties![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ClassGridScreen(id: index)));
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            height: cardHeight,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(fac.image),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.6),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      fac.nom,
                                      style: const TextStyle(
                                        color: Colors.white,
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
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator())
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Text(
                      "Connexion internet indisponible, verifier votre reseau",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ));
  }
}
