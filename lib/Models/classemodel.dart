class Classe {
  String nom;
  String description;
  Classe({required this.nom, required this.description});
  Map<String, dynamic> toMap() {
    return {'nom': nom, 'description': description};
  }

  factory Classe.fromSnapshot(Map<String, dynamic> value) {
    return Classe(nom: value['nom'], description: value['description']);
  }
}
