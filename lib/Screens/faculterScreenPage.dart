import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/faculter.dart';
import 'package:moussa_project/Screens/classviewr.dart';

class Faculter extends StatefulWidget {
  const Faculter({Key? key}) : super(key: key);

  @override
  _FaculterState createState() => _FaculterState();
}

class _FaculterState extends State<Faculter> {
  //List<Fac>? faculties;
  final supabaseManagement = SupabaseManagement();

  // Future<void> fetchFaculter() async {
  //   faculties = await supabaseManagement.faculter();
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    //fetchFaculter();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardHeight = screenHeight * 0.4;

    return Scaffold(
      backgroundColor: Color(0xFFD4EEED),
        appBar: AppBar(
          title: const Text("Liste des cours"),
        ),
        body: 
        FutureBuilder(future: supabaseManagement.faculter(), builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              else if(snapshot.hasError){
                return Column(
                        children: [
                          Image.asset('assets/images/wifi.png', color: Colors.red,scale: 2,),
                          Text("Désolé, mais un problème de connexion s'est produit.",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.center,
                          ),
                          Gap(30),
                          Text("Appuyer sur Actualiser ou Redémarrer l'application",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12)),
                          Gap(50),
                          TextButton.icon(
                onPressed: () {
                  setState(() {
                    //SupabaseManagement().getMateriel();
                  });
                },
                label: Text("Actualiser"),
                icon: Image.asset(
                  "assets/images/refresh.png",
                  scale: 20,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
                            ),
                        ],
                      );
              }else if(snapshot.hasData){
                final faculties = snapshot.data;
                return ListView.builder(
                    itemCount: faculties!.length,
                    itemBuilder: (context, index) {
                      final fac = faculties[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ClassGridScreen(id: index)));
                          },
                          child: Card(
                            margin: const EdgeInsets.only(left:  15, right: 15, bottom: 12),
                            //shape: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              height: cardHeight,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
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
                                    Expanded(child: Image.network(fac.image, fit: BoxFit.contain,)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        fac.nom,
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
                  ); 
                }else{
                  return Column(
                        children: [
                          Image.asset('assets/images/wifi.png', color: Colors.red,scale: 2,),
                          Text("Désolé, mais un problème de connexion s'est produit.",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.center,
                          ),
                          Gap(30),
                          Text("Appuyer sur Actualiser ou Redémarrer l'application",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12)),
                          Gap(50),
                          TextButton.icon(
                onPressed: () {
                  setState(() {
                    //SupabaseManagement().getMateriel();
                  });
                },
                label: Text("Actualiser"),
                icon: Image.asset(
                  "assets/images/refresh.png",
                  scale: 20,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
                            ),
                        ],
                      );
                }
        })
        
        
        
        ,
                );
  }
}
