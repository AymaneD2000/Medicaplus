import 'package:flutter_test/flutter_test.dart';
import 'package:medpharm/Models/materiels.dart';
import 'package:medpharm/Models/classemodel.dart';
import 'package:medpharm/Models/filiere.dart';
import 'package:medpharm/Models/pdf.dart';
import 'package:medpharm/Models/semestre.dart';
import 'package:medpharm/Models/downloaded_pdf.dart';

void main() {
  group('Materiel Model', () {
    test('fromSnapshot creates valid object', () {
      final json = {
        'id': 1,
        'title': 'Stéthoscope',
        'description': 'Stéthoscope professionnel',
        'telephone': '+223 70 00 00 00',
        'image': 'https://example.com/image.png',
        'price': '25000 FCFA',
      };

      final materiel = Materiel.fromSnapshot(json);

      expect(materiel.id, 1);
      expect(materiel.title, 'Stéthoscope');
      expect(materiel.telephone, '+223 70 00 00 00');
      expect(materiel.price, '25000 FCFA');
    });

    test('toMap excludes null id', () {
      final materiel = Materiel(
        title: 'Test',
        price: '1000',
        image: 'img.png',
        telephone: '123',
      );

      final map = materiel.toMap();
      expect(map.containsKey('id'), false);
      expect(map['title'], 'Test');
    });

    test('toMap includes non-null id', () {
      final materiel = Materiel(
        id: 5,
        title: 'Test',
        price: '1000',
        image: 'img.png',
        telephone: '123',
      );

      final map = materiel.toMap();
      expect(map['id'], 5);
    });
  });

  group('Classe Model', () {
    test('fromSnapshot creates valid object', () {
      final json = {
        'nom': 'FMOS',
        'description': 'Faculté de Médecine',
        'faculter': 1,
        'image': 'fmos.png',
      };

      final classe = Classe.fromSnapshot(json);

      expect(classe.nom, 'FMOS');
      expect(classe.idfaculter, 1);
    });

    test('toMap returns correct structure', () {
      final classe = Classe(
        nom: 'Test',
        description: 'Desc',
        idfaculter: 2,
        image: 'img.png',
      );

      final map = classe.toMap();
      expect(map['nom'], 'Test');
      expect(map['faculter'], 2);
    });
  });

  group('Filiere Model', () {
    test('fromSnapshot creates valid object', () {
      final json = {
        'id': 'abc-123',
        'nom': 'Médecine Générale',
        'image': 'med.png',
        'semestre_id': 'sem-1',
      };

      final filiere = Filiere.fromSnapshot(json);

      expect(filiere.id, 'abc-123');
      expect(filiere.nom, 'Médecine Générale');
      expect(filiere.semestreId, 'sem-1');
    });

    test('toMap returns correct structure', () {
      final filiere = Filiere(
        id: 'id-1',
        nom: 'Test',
        image: 'img.png',
        semestreId: 'sem-1',
      );

      final map = filiere.toMap();
      expect(map['id'], 'id-1');
      expect(map['semestre_id'], 'sem-1');
    });
  });

  group('Pdf Model', () {
    test('fromSnapshot creates valid object', () {
      final json = {
        'id': 'pdf-1',
        'nom': 'Anatomie',
        'description': 'Cours anatomie',
        'pdf': 'https://example.com/file.pdf',
        'image': 'anat.png',
        'filiere_id': 'fil-1',
      };

      final pdf = Pdf.fromSnapshot(json);

      expect(pdf.id, 'pdf-1');
      expect(pdf.nom, 'Anatomie');
      expect(pdf.url, 'https://example.com/file.pdf');
      expect(pdf.idFiliere, 'fil-1');
    });
  });

  group('Semestre Model', () {
    test('fromJson creates valid object', () {
      final json = {
        'id': 'sem-1',
        'nomSemetre': 'Semestre 1',
        'image': 'sem1.png',
        'nomClasse': 'FMOS',
      };

      final semestre = Semestre.fromJson(json);

      expect(semestre.id, 'sem-1');
      expect(semestre.nomSemetre, 'Semestre 1');
      expect(semestre.nomClasse, 'FMOS');
    });

    test('toJson returns correct structure', () {
      final semestre = Semestre(
        id: 'id-1',
        nomSemetre: 'S1',
        image: 'img.png',
        nomClasse: 'Test',
      );

      final json = semestre.toJson();
      expect(json['id'], 'id-1');
      expect(json['nomSemetre'], 'S1');
      expect(json['nomClasse'], 'Test');
    });
  });

  group('DownloadedPdf Model', () {
    test('toMap and fromMap are symmetric', () {
      final original = DownloadedPdf(
        id: 'dl-1',
        originalId: 'pdf-1',
        name: 'Test PDF',
        description: 'A test',
        localPath: '/path/to/file.pdf',
        originalUrl: 'https://example.com/file.pdf',
        downloadDate: DateTime(2024, 3, 15),
        fileSize: 1024,
        hasLogo: true,
      );

      final map = original.toMap();
      final restored = DownloadedPdf.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.originalId, original.originalId);
      expect(restored.name, original.name);
      expect(restored.localPath, original.localPath);
      expect(restored.fileSize, original.fileSize);
      expect(restored.hasLogo, original.hasLogo);
    });
  });
}
