import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Screens/AddClasseScreen.dart';
import 'package:moussa_project/Screens/home.dart';
import 'package:moussa_project/Screens/manageMateriels.dart';
import 'package:moussa_project/Screens/venteMaetiels.dart';


class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:86078232.
  // List<BottomNavigationBarItem> items = [
  //   BottomNavigationBarItem(icon: Image.asset("assets/images/home.png", height: 40,), label: "Home"),
  //   BottomNavigationBarItem(icon: Image.asset("assets/images/profile.png", height: 40,), label: 'Abreviation'), 
  //   BottomNavigationBarItem(icon: Image.asset("assets/images/3916582.png", height: 40,), label: 'Favoris')
  //   ];
  // List<Widget> Screens = [Home(),Center(child: Text(""),),Center(child: Text("Favoris"),)];
  // int index = 0;
  // void onTap(int index) {
  //   setState(() {
  //     this.index = index;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ManageClasse()));
            },
            icon: const Icon(Icons.manage_accounts),
            tooltip: 'Manage Classes',
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MaterielHomePage()));
              },
              icon: const Icon(Icons.abc))
        ],
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontFamily: 'TimesNewRoman',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        shadowColor: Colors.black54,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: const Home(),
      //bottomNavigationBar: BottomNavigationBar(items: items,onTap: onTap,currentIndex: index,),
    );
            }

}
