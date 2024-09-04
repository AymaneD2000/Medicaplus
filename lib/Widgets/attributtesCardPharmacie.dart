import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AttributesCardPharmacie extends StatelessWidget {
  String description;
  String title;
  Color couleurs;
  AttributesCardPharmacie(
      {super.key, required this.couleurs,
      required this.description,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(30), // Rayon général du bord du Card
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            // Utilisation de BorderRadius.only pour spécifier les rayons des coins individuels
            topLeft: Radius.circular(6 *
                MediaQuery.devicePixelRatioOf(
                    context)), // Rayon réduit pour le coin supérieur gauche
            topRight: Radius.circular(6 *
                MediaQuery.devicePixelRatioOf(
                    context)), // Rayon réduit pour le coin supérieur droit
            bottomLeft: Radius.circular(6 *
                MediaQuery.devicePixelRatioOf(
                    context)), // Rayon complet pour le coin inférieur gauche
            bottomRight: Radius.circular(6 *
                MediaQuery.devicePixelRatioOf(
                    context)), // Rayon complet pour le coin inférieur droit
          ),
          color: Colors.white, // Couleur d'arrière-plan
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.045,
              padding: EdgeInsets.symmetric(
                  horizontal: 4 * MediaQuery.devicePixelRatioOf(context)),
              decoration: BoxDecoration(
                color: couleurs, // Couleur d'arrière-plan du haut
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6 *
                      MediaQuery.devicePixelRatioOf(
                          context)), // Rayon réduit pour le coin supérieur gauche
                  topRight: Radius.circular(6 *
                      MediaQuery.devicePixelRatioOf(
                          context)), // Rayon réduit pour le coin supérieur droit
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 4 * MediaQuery.devicePixelRatioOf(context),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'TimesNewRoman',
                      fontWeight: FontWeight.bold,
                      fontSize: 6.5 * MediaQuery.devicePixelRatioOf(context),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin:
                  EdgeInsets.all(4 * MediaQuery.devicePixelRatioOf(context)),
              child: Text("$description ", style: TextStyle(fontSize: 5.5 * MediaQuery.devicePixelRatioOf(context),),)
            ),
          ],
        ),
      ),
    );
  }
}
