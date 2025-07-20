class Filiere {
  String id;
  String nom;
  String image;
  String semestreId;
  Filiere(
      {required this.nom,
      required this.image,
      required this.semestreId,
      required this.id});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'image': image,
      'semestre_id': semestreId,
    };
  }

  factory Filiere.fromSnapshot(Map<String, dynamic> value) {
    return Filiere(
        nom: value['nom'],
        image: value['image'],
        semestreId: value['semestre_id'],
        id: value['id']);
  }
}
