import 'dart:ffi';

class Materiel {
  int? id;
  final String title;
  final num price;
  final int sales;
  final String image;
  Materiel(
      {required this.title,
      required this.price,
      required this.sales,
      required this.image,
      this.id});
  Map<String, dynamic> toMap() {
    return {'title': title, 'image': image, 'sales': sales, 'price': price};
  }

  factory Materiel.fromSnapshot(Map<String, dynamic> value) {
    return Materiel(
        id: value['id'],
        title: value['title'],
        sales: value['sales'],
        image: value['image'],
        price: value['price']);
  }
}
