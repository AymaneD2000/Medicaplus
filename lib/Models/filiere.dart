import 'package:uuid/v4.dart';

class Filiere {
  String id;
  String nom;
  String image;
  String nomClasse;
  Filiere(
      {required this.nom,
      required this.image,
      required this.nomClasse,
      required this.id});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'image': image,
      'nomClasse': nomClasse,
    };
  }

  factory Filiere.fromSnapshot(Map<String, dynamic> value) {
    return Filiere(
        nom: value['nom'],
        image: value['image'],
        nomClasse: value['nomClasse'],
        id: value['id']);
  }
}
