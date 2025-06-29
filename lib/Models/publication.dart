class Publication {
  String image;
  int? idpublication;
  Publication({required this.image, this.idpublication});
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'image': image};
    if (idpublication != null) {
      map['id'] = idpublication;
    }
    return map;
  }

  factory Publication.fromSnapshot(Map<String, dynamic> value) {
    return Publication(image: value['image'], idpublication: value['id']);
  }
}
