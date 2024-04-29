import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moussa_project/Screens/medicamentdetailscreen.dart';

// Custom text styles for headers and subheaders
const TextStyle headerStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const TextStyle subHeaderStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.grey,
);

class MedicamentsScreen extends StatefulWidget {
  @override
  _MedicamentsScreenState createState() => _MedicamentsScreenState();
}

class _MedicamentsScreenState extends State<MedicamentsScreen> {
  List<dynamic> medicamentsData = [];
  final Tabs = <Tab>[
    const Tab(
      icon: Icon(
        Icons.list, // Changed icon
        size: 30,
      ),
      text: "By Name",
    ),
    const Tab(
      icon: Icon(
        Icons.category, // Changed icon
        size: 30,
      ),
      text: "By Class",
    )
  ];

  @override
  void initState() {
    super.initState();
    _loadMedicamentsData();
  }

  Future<void> _loadMedicamentsData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/medicament.json');
    setState(() {
      medicamentsData = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Medicaments"),
          backgroundColor: Colors.teal, // Primary color
          bottom: TabBar(
            tabs: Tabs,
            indicatorColor: Colors.white, // Tab indicator color
          ),
        ),
        body: TabBarView(
          children: [
            // First tab: List of medicaments
            ListView.builder(
              itemCount: medicamentsData.length,
              itemBuilder: (BuildContext context, int index) {
                final medicament = medicamentsData[index];
                return Hero(
                  tag: medicament['Médicament'],
                  child: MedicamentCard(medicament: medicament),
                );
              },
            ),
            // Second tab: Placeholder content or additional functionality
            Center(
              child: Text(
                "Medicaments by Class - Coming Soon",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicamentCard extends StatelessWidget {
  final dynamic medicament;

  const MedicamentCard({
    Key? key,
    required this.medicament,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.teal.withOpacity(0.2)], // Gradient
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services, color: Colors.teal), // Icon
                const SizedBox(width: 8.0),
                Text(
                  medicament['Médicament'],
                  style: headerStyle,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              '${medicament['Classe Thérapeutique'].join(', ')}',
              style: subHeaderStyle,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.teal, // Button background color
                backgroundColor: Colors.white, // Button text color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MedicamentDetailsScreen(medicament: medicament),
                  ),
                );
              },
              child: const Text("See Details"),
            ),
          ],
        ),
      ),
    );
  }
}
