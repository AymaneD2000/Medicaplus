class Classe {
  String nom;
  String description;
  int idfaculter;
  Classe(
      {required this.nom, required this.description, required this.idfaculter});
  Map<String, dynamic> toMap() {
    return {'nom': nom, 'description': description, "faculter":idfaculter};
  }

  factory Classe.fromSnapshot(Map<String, dynamic> value) {
    return Classe(
        nom: value['nom'],
        description: value['description'],
        idfaculter: value['faculter']);
  }
}
