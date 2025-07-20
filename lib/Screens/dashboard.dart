import 'package:flutter/material.dart';
import 'package:medpharm/Screens/AddClasseScreen.dart';
import 'package:medpharm/Screens/home.dart';
import 'package:medpharm/Screens/manageMateriels.dart';
import 'package:medpharm/Screens/managePublication.dart';
import 'package:medpharm/Screens/downloaded_pdfs_screen.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // Modern color scheme
  final Color _primaryColor = const Color(0xFF02B1EC);
  final Color _secondaryColor = const Color(0xFF33CCCC);
  final Color _backgroundColor = const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_primaryColor, _secondaryColor],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: const Icon(
                        Icons.medical_services_outlined,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'MedicaPlus',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Administration',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                icon: Icons.home_outlined,
                title: 'Accueil',
                onTap: () => Navigator.pop(context),
              ),
              _buildDrawerItem(
                icon: Icons.school_outlined,
                title: 'Gérer les Classes',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategorySelectionScreen()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.medical_services_outlined,
                title: 'Gérer les Matériels',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MaterielHomePage()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.article_outlined,
                title: 'Gérer les Publications',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PublicationHomePage()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.download_done_outlined,
                title: 'Téléchargements PDF',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DownloadedPdfsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primaryColor, _secondaryColor],
            ),
          ),
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          _buildAppBarAction(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategorySelectionScreen()),
              );
            },
            icon: Icons.school_outlined,
            tooltip: 'Gérer les Classes',
          ),
          _buildAppBarAction(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MaterielHomePage()),
              );
            },
            icon: Icons.medical_services_outlined,
            tooltip: 'Gérer les Matériels',
          ),
          _buildAppBarAction(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PublicationHomePage()),
              );
            },
            icon: Icons.article_outlined,
            tooltip: 'Gérer les Publications',
          ),
          _buildAppBarAction(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DownloadedPdfsScreen()),
              );
            },
            icon: Icons.download_done_outlined,
            tooltip: 'Téléchargements PDF',
          ),
        ],
      ),
      body: const Home(),
    );
  }

  Widget _buildAppBarAction({
    required VoidCallback onPressed,
    required IconData icon,
    required String tooltip,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: _primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      dense: true,
      horizontalTitleGap: 12,
    );
  }
}
