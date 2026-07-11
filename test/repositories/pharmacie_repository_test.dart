import 'package:flutter_test/flutter_test.dart';
import 'package:medpharm/data/repositories/pharmacie_repository.dart';
import 'package:medpharm/Models/amo.dart';

void main() {
  group('LocalPharmacieRepository', () {
    test('repository can be instantiated', () {
      const repo = LocalPharmacieRepository();
      expect(repo, isNotNull);
    });

    test('Amo model fromSanpshot creates valid object', () {
      final json = {
        'Nom commercial': 'Doliprane 500mg',
        'AMO': true,
        'Favoris': false,
        'Icon': 'comprime',
        'Classe Thérapeutique': ['Antalgique'],
        'D.C.I/Composition': ['Paracetamol'],
        'Forme et dosage': ['Comprimé 500mg'],
        'Prix public': ['1500 FCFA'],
        'Présentation': ['Boîte de 16'],
        'Partenaire': true,
      };

      final amo = Amo.fromSanpshot(json);

      expect(amo.name, 'Doliprane 500mg');
      expect(amo.amo, true);
      expect(amo.favoris, false);
      expect(amo.partenaire, true);
      expect(amo.dci, ['Paracetamol']);
      expect(amo.prix, ['1500 FCFA']);
    });

    test('Amo model handles missing Partenaire field', () {
      final json = {
        'Nom commercial': 'Test Med',
        'AMO': false,
        'Favoris': true,
        'Icon': 'gelule',
        'Classe Thérapeutique': [],
        'D.C.I/Composition': [],
        'Forme et dosage': [],
        'Prix public': [],
        'Présentation': [],
      };

      final amo = Amo.fromSanpshot(json);
      expect(amo.partenaire, false);
    });

    test('ClassMed equality works correctly', () {
      final class1 = ClassMed(clname: 'Antalgique');
      final class2 = ClassMed(clname: 'Antalgique');
      final class3 = ClassMed(clname: 'Antibiotique');

      expect(class1 == class2, true);
      expect(class1 == class3, false);
      expect(class1.hashCode, class2.hashCode);
    });

    test('ClassMed sortName returns class name', () {
      final classMed = ClassMed(clname: 'Antalgique');
      expect(classMed.sortName(), 'Antalgique');
    });
  });
}
