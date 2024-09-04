
class Materiel {
  int? id;
  final String title;
  final String? description;
  final String telephone;
  final String price;
  final String image;
  Materiel(
      {required this.title,
      required this.price,
      required this.image,
      this.description,
      required this.telephone,
      this.id});
  Map<String, dynamic> toMap() {
    return {'title': title, 'image': image, 'price': price, 'description':description,'telephone':telephone};
  }

  factory Materiel.fromSnapshot(Map<String, dynamic> value) {
    return Materiel(
        id: value['id'],
        title: value['title'],
        description: value['description']??"",
        telephone: value['telephone'],
        image: value['image'],
        price: value['price']);
  }
}
