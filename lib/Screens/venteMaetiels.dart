import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/materiels.dart';

class BooksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books For Sale',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headlineMedium:
              TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
      ),
      home: BooksHomePage(),
    );
  }
}

class BooksHomePage extends StatefulWidget {
  @override
  _BooksHomePageState createState() => _BooksHomePageState();
}

class _BooksHomePageState extends State<BooksHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materieles En Vente'),
        leading: Icon(Icons.arrow_back),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Mes Achats')),
          ),
        ],
      ),
      body: FutureBuilder(
          future: SupabaseManagement().getMateriel(),
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return buildBookCard(data[index]);
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child:
                    Text("Nous avons rencontrer une erreur lors du chargement"),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget buildBookCard(Materiel book) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                book.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              book.title,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${book.price} XOF",
              style: TextStyle(color: Colors.yellow),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${book.sales} Ventes",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
