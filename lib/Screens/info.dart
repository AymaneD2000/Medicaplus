import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome text
                    const Text(
                      "Bonjour et bienvenue sur mon application MemoIDE.",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Info text
                    const Text(
                      "Infirmier depuis 2013, j’ai pour but de vous apporter à travers ce support un outil pratique et accessible à tous et à tout moment.",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 12.0),

                    // General conditions text
                    const Text(
                      "Conditions générales d'utilisation:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Detailed conditions
                    const Text(
                      "Les informations fournies dans cette application sont destinées à un public averti ainsi qu’aux professionnels de santé. En aucun cas les informations éditées dans MemoIDE sont susceptibles de se substituer à une consultation, une visite ou un diagnostic formulé par un médecin.",
                      style: TextStyle(fontSize: 14.0, color: Colors.red),
                    ),
                    const SizedBox(height: 8.0),

                    const Text(
                      "L’utilisateur reconnaît que les informations qui sont mises à sa disposition ne sont ni complètes, ni exhaustives. Les professionnels de santé doivent respecter les protocoles et bonnes pratiques liées à leur profession.",
                      style: TextStyle(fontSize: 14.0, color: Colors.red),
                    ),
                    const SizedBox(height: 8.0),

                    // Encouragement text
                    const Text(
                      "Cette application étant en amélioration permanente, je vous encourage à me faire part de vos remarques afin de vous satisfaire au plus vite. Merci.",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 16.0),

                    // Error report icon
                    const Row(
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 40.0),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            "L'icône ci-joint permet de signaler toute incohérence concernant la page où vous vous trouvez, n’hésitez pas.",
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Website and contact
                    const Text(
                      "Site internet: www.rise-tech.fr/memoide",
                      style: TextStyle(fontSize: 14.0, color: Colors.blue),
                    ),
                    const SizedBox(height: 8.0),

                    const Text(
                      "Notre page Facebook: facebook.com/webmemoide",
                      style: TextStyle(fontSize: 14.0, color: Colors.blue),
                    ),
                    const SizedBox(height: 8.0),

                    const Text(
                      "Contact: webmemoide@gmail.com",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 8.0),

                    const Text(
                      "Version: MemoIDE© 1.8.1 - 2025 tous droits réservés.",
                      style: TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 8.0),

                    const Text(
                      "Sources: Voir la liste des sources",
                      style: TextStyle(fontSize: 14.0, color: Colors.blue),
                    ),
                    const SizedBox(height: 16.0),

                    // Terms acceptance checkbox
                    Row(
                      children: [
                        Checkbox(
                          value:
                              false, // Change this dynamically based on state
                          onChanged: (bool? value) {
                            // Handle the checkbox state
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "J’ai bien lu et accepte les conditions d'utilisation énoncées ci-dessus.",
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Validate button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle the button press
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text("Valider"),
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    // Thank you note
                    const Text(
                      "J’aimerais remercier spécialement Matori ainsi que tous ceux qui m’ont aidé à réaliser ce projet.",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
