class Publication {
  String image;
  int? idpublication;
  Publication(
      {required this.image ,this.idpublication});
  Map<String, dynamic> toMap() {
    return {'image':image};
  }

  factory Publication.fromSnapshot(Map<String, dynamic> value) {
    return Publication(
        image: value['image'],
        idpublication: value['id']);
  }
}
