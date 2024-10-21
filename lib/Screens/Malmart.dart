import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MallampatiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Medicalcul'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Score de Mallampati',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Icon(
                  Icons.medical_services, // Replace this with your custom image
                  size: 100,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Classe Définition',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              _buildClassRow(1, 'Toute la luette et les loges amygdaliennes sont visibles.'),
              _buildClassRow(2, 'La luette est partiellement visible.'),
              _buildClassRow(3, 'Le palais membraneux est visible.'),
              _buildClassRow(4, 'Seul le palais osseux est visible.'),
              const SizedBox(height: 20),
              Center(
                child: SvgPicture.asset(
                        'assets/images/Mallampati.svg',
                        height: MediaQuery.of(context).size.width*0.8,  // Spécifiez la taille que vous souhaitez
                        width: MediaQuery.of(context).size.width*0.8,
                      ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Interprétation:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'L\'examen doit être réalisé en position assise. Les classes 1 et 2 présagent d\'une intubation à priori facile, les classes 3 et 4 d\'une intubation difficile.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Text(
                'Références:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              const Text(
                'Mallampati S, Gatt S, Gugino L, Desai S, Waraksa B, Freiberg, Liu P. A clinical sign to predict difficult tracheal intubation: a prospective study.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassRow(int number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.red,
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
