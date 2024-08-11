import 'package:sticky_az_list/sticky_az_list.dart';

class Med extends TaggedItem {
  final String name;
  bool isFavoris;
  final List<dynamic> nomCommercial;
  final List<dynamic> posologie;
  final List<dynamic> classtherapique;
  List<dynamic>? activiteantibacterienne;
  List<dynamic> icons;
  List<dynamic> images;
  //final List<dynamic> pharmacie;
  final List<dynamic> propriete;
  final List<dynamic> indication;
  final List<dynamic> contreindication;
  final List<dynamic> effetindesirable;
  final List<dynamic> precaution;
  final List<dynamic> grosseseallaitement;
  Med(
      {required this.name,
      required this.images,
      required this.icons,
      this.activiteantibacterienne,
      required this.isFavoris,
      required this.nomCommercial,
      required this.posologie,
      required this.classtherapique,
      required this.contreindication,
      required this.effetindesirable,
      required this.grosseseallaitement,
      required this.indication,
      //required this.pharmacie,
      required this.precaution,
      required this.propriete});
  // Other properties and methods...

  Map<String, dynamic> toJson() {
    return {
      'Favoris': isFavoris,
    };
  }

  factory Med.fromSanpshot(Map<String, dynamic> json) {
    
    json['Favoris'] != null?print(json['Favoris']):print(json['Médicament/D.C.I (Alias)']);
    return Med(
      posologie: json['Posologie et durée'],
      isFavoris: json['Favoris'],
      icons: json['Icon'],
      images: json['Images'],
      activiteantibacterienne: json['Activité antibactérienne'],
        name: json['Médicament/D.C.I (Alias)'],
        nomCommercial: json['Nom commercial'],
        classtherapique: json['Classe Thérapeutique'],
        contreindication: json['Contre-indications'],
        effetindesirable: json['Effets indésirables'],
        grosseseallaitement: json['Grossesse et Allaitement'],
        indication: json['Indications'],
        //pharmacie: json['Pharmacies'],
        precaution: json["Précautions d'emploi"],
        propriete: json['Propriété']);
  }
  @override
  String sortName() => name;
}
