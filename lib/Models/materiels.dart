import 'dart:ffi';

class Materiel {
  int? id;
  final String title;
  final num price;
  final String image;
  Materiel(
      {required this.title,
      required this.price,
      required this.image,
      this.id});
  Map<String, dynamic> toMap() {
    return {'title': title, 'image': image, 'price': price};
  }

  factory Materiel.fromSnapshot(Map<String, dynamic> value) {
    return Materiel(
        id: value['id'],
        title: value['title'],
        image: value['image'],
        price: value['price']);
  }
}
