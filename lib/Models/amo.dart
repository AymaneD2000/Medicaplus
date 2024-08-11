import 'package:sticky_az_list/sticky_az_list.dart';

class Amo extends TaggedItem {
  final String name;
  final bool amo;
  bool favoris;
  final String icon;
  final List<dynamic> classtherapique;
  final List<dynamic> dci;
  final List<dynamic> specialitepharmaco;
  final List<dynamic> formedosage;
  final List<dynamic> prix;
  final List<dynamic> presantation;
  Amo(
      {required this.name,
      required this.icon,
      required this.amo,
      required this.favoris,
      required this.classtherapique,
      required this.prix,
      required this.formedosage,
      required this.dci,
      required this.presantation,
      required this.specialitepharmaco});
  factory Amo.fromSanpshot(Map<String, dynamic> json) {
    return Amo(
        name: json['Nom commercial'],
        amo: json['AMO'],
        favoris: json['Favoris'],
        icon: json['Icon'],
        classtherapique: json['Classe Thérapeutique'],
        prix: json['Prix public'],
        formedosage: json['Forme et dosage'],
        dci: json['D.C.I/Composition'],
        presantation: json["Présentation"],
        specialitepharmaco: json['Spécialité médicale']);
  }
  @override
  String sortName() {
    try {
      return name;
    } catch (exp) {
      return "this is the execption $name";
    }
  }
}
