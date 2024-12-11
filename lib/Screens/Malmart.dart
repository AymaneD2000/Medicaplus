import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MallampatiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
                'Mallampati',
              ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const Text(
              'Definition :',
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ), 
            const Text(
                "Le score de Bishop est une méthode globale d'évaluation du pronostic d'accouchement.",
                style:
                        TextStyle(
                          //fontFamily: 'TimesNewRoman',
                          fontSize: 17,
                          // fontFamily: 'TimesNewRoman',
                          color: Colors.black,
                        ),),
              const SizedBox(height: 10),
              Card(
      color: Colors.white, // White background
      margin: const EdgeInsets.all(8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Classe : Structure visible',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'TimesNewRoman',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildClassRow("I", 'Toute la luette et les loges amygdaliennes sont visibles.'),
              _buildClassRow("II", 'La luette est partiellement visible.'),
              _buildClassRow("III", 'Le palais membraneux est visible.'),
              _buildClassRow("IV", 'Seul le palais osseux est visible.'), 
          ],
        ),
      ),
    ),
              const SizedBox(height: 20),
              Center(
                child: SvgPicture.asset(
                        'assets/images/Mallampati.svg',
                        height: MediaQuery.of(context).size.width*0.8,  // Spécifiez la taille que vous souhaitez
                        width: MediaQuery.of(context).size.width*0.8,
                      ),
              ),
              const SizedBox(height: 20),
              Card(
      color: Colors.white, // White background
      margin: const EdgeInsets.all(8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Interprétation : ',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'TimesNewRoman',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _buildClassRowMalllampati("Grade I et Grade II", "Présomption d'intubation facile"),
              _buildClassRowMalllampati("Grade III et Grade IV", "Présomption d'intubation difficile"),
          ],
        ),
      ),
    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassRow(String number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number : ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff33CCCC),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildClassRowMalllampati(String number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number : ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff33CCCC),
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
