import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moussa_project/DatabaseManagement/provider.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/materiels.dart';
import 'package:moussa_project/Screens/ventesCover.dart';
import 'package:provider/provider.dart';



class BooksHomePage extends StatefulWidget {
  const BooksHomePage({super.key});

  @override
  _BooksHomePageState createState() => _BooksHomePageState();
}

class _BooksHomePageState extends State<BooksHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Matériels en vente'),
        leading: GestureDetector(onTap: (){
          Navigator.pop(context);
        }, child: const Icon(Icons.arrow_back)),

      ),
      body: FutureBuilder<List<Materiel>>(
          future: context.read<MyProvider>().getMateriel(),
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>VenteCover(materiel: data[index],)));
                      },
                      child: buildBookCard(data[index]));
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child:
                      Column(
                        children: [
                        Image.asset('assets/images/wifi.png', color: Colors.red,scale: 2,),
                        const Text("Désolé, mais un problème de connexion s'est produit.",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                        ),
                        const Gap(30),
                        const Text("Appuyer sur Actualiser ou Redémarrer l'application",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12)),
                        const Gap(50),
                        TextButton.icon(
                onPressed: () {
                  setState(() {
                    //SupabaseManagement().getMateriel();
                  });
                },
                label: const Text("Actualiser"),
                icon: Image.asset(
                  "assets/images/refresh.png",
                  scale: 20,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                            ),
                        ],
                      ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget buildBookCard(Materiel book) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8), bottom: Radius.circular(8)),
              child: Image.network(
                book.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                book.title,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                "${book.price} XOF",
                style: const TextStyle(
                fontFamily: 'TimesNewRoman',color: Colors.orange),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Text(
          //     "${book.description}",
          //     style: TextStyle(
          //     fontFamily: 'TimesNewRoman',color: Colors.blue),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     "En vente au ${book.telephone}",
          //     style: TextStyle(
          //     fontFamily: 'TimesNewRoman',color: Colors.green),
          //   ),
          // ),
          // MaterialButton(
          //   onPressed: (){_launchWhatsApp(
          //     context,
          //     book.telephone,
          //     "Comment avoir ce produit Nom: ${book.title}, description: ${book.description} et prix:${book.price}?",
          //   );},child: Text("Acheter"),)
        ],
      ),
    );
  }

}
