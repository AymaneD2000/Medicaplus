class Classe {
  String nom;
  String image;
  String description;
  int idfaculter;
  Classe(
      {required this.nom, required this.description,required this.image ,required this.idfaculter});
  Map<String, dynamic> toMap() {
    return {'nom': nom, 'description': description, "faculter":idfaculter, 'image':image};
  }

  factory Classe.fromSnapshot(Map<String, dynamic> value) {
    return Classe(
        image: value['image'],
        nom: value['nom'],
        description: value['description'],
        idfaculter: value['faculter']);
  }
}
