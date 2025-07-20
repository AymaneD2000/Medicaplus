class Semestre {
  final String id;
  final String nomSemetre;
  final String image;
  final String nomClasse;

  Semestre({
    required this.id,
    required this.nomSemetre,
    required this.image,
    required this.nomClasse,
  });

  factory Semestre.fromJson(Map<String, dynamic> json) {
    return Semestre(
      id: json['id'] as String,
      nomSemetre: json['nomSemetre'] as String,
      image: json['image'] as String,
      nomClasse: json['nomClasse'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomSemetre': nomSemetre,
      'image': image,
      'nomClasse': nomClasse,
    };
  }
}
