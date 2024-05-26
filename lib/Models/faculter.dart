class Fac {
  int id;
  String nom;
  String image;
  Fac({required this.id, required this.image, required this.nom});
  factory Fac.fromSnapshot(Map<String, dynamic> value) {
    return Fac(id: value['id'], nom: value['name'], image: value['image']);
  }
}
