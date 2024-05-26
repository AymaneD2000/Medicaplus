import 'package:sticky_az_list/sticky_az_list.dart';

class Med extends TaggedItem {
  final String name;
  final String alias;
  final List<dynamic> classtherapique;
  final List<dynamic> pharmacie;
  final List<dynamic> propriete;
  final List<dynamic> indication;
  final List<dynamic> contreindication;
  final List<dynamic> effetindesirable;
  final List<dynamic> precaution;
  final List<dynamic> grosseseallaitement;
  Med(
      {required this.name,
      required this.alias,
      required this.classtherapique,
      required this.contreindication,
      required this.effetindesirable,
      required this.grosseseallaitement,
      required this.indication,
      required this.pharmacie,
      required this.precaution,
      required this.propriete});
  factory Med.fromSanpshot(Map<String, dynamic> json) {
    return Med(
        name: json['Médicament'],
        alias: json['Alias'],
        classtherapique: json['Classe Thérapeutique'],
        contreindication: json['Contre-indications'],
        effetindesirable: json['Effets indésirables'],
        grosseseallaitement: json['Grossesse et Allaitement'],
        indication: json['Indications'],
        pharmacie: json['Pharmacies'],
        precaution: json["Précautions d'emploi"],
        propriete: json['Propriété']);
  }
  @override
  String sortName() => name;
}
