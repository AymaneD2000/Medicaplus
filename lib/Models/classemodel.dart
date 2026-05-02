class Classe {
  final int? id;
  final String nom;
  final String description;
  final int idfaculter;
  final String image;

  Classe({
    this.id,
    required this.nom,
    required this.description,
    required this.idfaculter,
    required this.image,
  });

  factory Classe.fromSnapshot(Map<String, dynamic> json) {
    return Classe(
      id: json['id'] as int?,
      nom: json['nom'] as String,
      description: json['description'] as String,
      idfaculter: json['faculter'] as int,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'description': description,
      'faculter': idfaculter,
      'image': image,
    };
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'faculter': idfaculter,
      'image': image,
    };
  }
}
