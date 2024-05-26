import 'package:flutter/material.dart';

class AmoCard extends StatelessWidget {
  String tile;
  String subtitile;
  AmoCard({super.key, required this.subtitile, required this.tile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          tile,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        Text(
          subtitile,
          style: TextStyle(color: Colors.blue),
        )
      ],
    );
  }
}
