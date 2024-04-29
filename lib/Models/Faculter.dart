class Faculter {
  int id;
  String nom;
  String image;
  Faculter({required this.id, required this.image, required this.nom});

  factory Faculter.fromSnapshot(Map<String, dynamic> value) {
    return Faculter(id: value['id'], nom: value['name'], image: value['image']);
  }
}
