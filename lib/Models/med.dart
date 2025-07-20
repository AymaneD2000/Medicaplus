class Med {
  final String name;
  bool isFavoris;
  final List<dynamic> nomCommercial;
  final List<dynamic> posologie;
  final List<dynamic> dci;
  final List<dynamic> classtherapique;

  final List<dynamic> interactions;
  final List<dynamic> activiteantibacterienne;
  //final List<dynamic> pharmacie;
  final List<dynamic> propriete;
  final List<dynamic> indication;
  final List<dynamic> contreindication;
  final List<dynamic> effetindesirable;
  final List<dynamic> precaution;
  final List<dynamic> grosseseallaitement;
  Med(
      {required this.name,
      required this.interactions,
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
      required this.activiteantibacterienne,
      required this.propriete,
      required this.dci});
  // Other properties and methods...

  Map<String, dynamic> toJson() {
    return {
      'Favoris': isFavoris,
    };
  }

  factory Med.fromSanpshot(Map<String, dynamic> json) {
    return Med(
        activiteantibacterienne: json['Activité antibactérienne'] ?? [],
        posologie: json['Posologie et durée'],
        isFavoris: json['Favoris'],
        interactions: json['Interactions médicamenteuses'],
        name: json['Médicament/D.C.I (Alias)'],
        nomCommercial: json['Nom commercial'],
        classtherapique: json['Classe Thérapeutique'],
        contreindication: json['Contre-indications'],
        effetindesirable: json['Effets indésirables'],
        grosseseallaitement: json['Grossesse et Allaitement'],
        indication: json['Indications'],
        dci: [json['Médicament/D.C.I (Alias)']],
        //pharmacie: json['Pharmacies'],
        precaution: json["Précautions d’emploi"],
        propriete: json['Propriété']);
  }
  @override
  String sortName() => name;
}
