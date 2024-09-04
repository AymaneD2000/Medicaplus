
class Pdf {
  String id;
  String nom;
  String description;
  String url;
  String image;
  String idFiliere;
  Pdf(
      {required this.nom,
      required this.description,
      required this.image,
      required this.url,
      required this.idFiliere,
      required this.id});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'pdf': url,
      'description': description,
      'image': image,
      'filiere_id': idFiliere
    };
  }

  factory Pdf.fromSnapshot(Map<String, dynamic> value) {
    return Pdf(
      url: value['pdf'],
      id: value['id'],
      nom: value['nom'],
      description: value['description'],
      image: value['image'],
      idFiliere: value['filiere_id'],
    );
  }
}
