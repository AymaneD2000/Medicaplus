class DownloadedPdf {
  final String id;
  final String originalId;
  final String name;
  final String description;
  final String localPath;
  final String originalUrl;
  final DateTime downloadDate;
  final int fileSize;
  final bool hasLogo;

  DownloadedPdf({
    required this.id,
    required this.originalId,
    required this.name,
    required this.description,
    required this.localPath,
    required this.originalUrl,
    required this.downloadDate,
    required this.fileSize,
    this.hasLogo = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalId': originalId,
      'name': name,
      'description': description,
      'localPath': localPath,
      'originalUrl': originalUrl,
      'downloadDate': downloadDate.toIso8601String(),
      'fileSize': fileSize,
      'hasLogo': hasLogo ? 1 : 0,
    };
  }

  factory DownloadedPdf.fromMap(Map<String, dynamic> map) {
    return DownloadedPdf(
      id: map['id'],
      originalId: map['originalId'],
      name: map['name'],
      description: map['description'],
      localPath: map['localPath'],
      originalUrl: map['originalUrl'],
      downloadDate: DateTime.parse(map['downloadDate']),
      fileSize: map['fileSize'],
      hasLogo: map['hasLogo'] == 1,
    );
  }
}
