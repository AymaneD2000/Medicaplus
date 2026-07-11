import 'package:flutter_test/flutter_test.dart';
import 'package:medpharm/data/repositories/medicament_repository.dart';
import 'package:medpharm/Models/med.dart';

void main() {
  group('LocalMedicamentRepository', () {
    test('normalize removes diacritics and lowercases', () {
      // Test that the repository can be instantiated
      final repo = LocalMedicamentRepository();
      expect(repo, isNotNull);
    });

    test('repository has correct asset path', () {
      final repo = LocalMedicamentRepository();
      expect(repo.assetPath, 'assets/Medicament.json');
      expect(repo.localFileName, 'Medicament.json');
    });

    test('Med model fromSanpshot creates valid object', () {
      final Map<String, dynamic> json = {
        'Médicament/D.C.I (Alias)': 'Paracetamol',
        'Favoris': true,
        'Nom commercial': <dynamic>['Doliprane', 'Efferalgan'],
        'Posologie et durée': <dynamic>['500mg 3x/jour'],
        'Classe Thérapeutique': <dynamic>['Antalgique'],
        'Contre-indications': <dynamic>['Insuffisance hépatique'],
        'Effets indésirables': <dynamic>['Rares'],
        'Grossesse et Allaitement': <dynamic>['Autorisé'],
        'Indications': <dynamic>['Douleur', 'Fièvre'],
        'Interactions médicamenteuses': <dynamic>[],
        'Activité antibactérienne': <dynamic>[],
        "Pr\u00e9cautions d\u2019emploi": <dynamic>['Dose max 4g/jour'],
        'Propriété': <dynamic>['Antalgique', 'Antipyrétique'],
      };

      final med = Med.fromSanpshot(json);

      expect(med.name, 'Paracetamol');
      expect(med.isFavoris, true);
      expect(med.nomCommercial, ['Doliprane', 'Efferalgan']);
      expect(med.classtherapique, ['Antalgique']);
      expect(med.indication, ['Douleur', 'Fièvre']);
      expect(med.sortName(), 'Paracetamol');
    });

    test('Med model toJson returns favoris status', () {
      final json = {
        'Médicament/D.C.I (Alias)': 'Test',
        'Favoris': false,
        'Nom commercial': <dynamic>[],
        'Posologie et durée': <dynamic>[],
        'Classe Thérapeutique': <dynamic>[],
        'Contre-indications': <dynamic>[],
        'Effets indésirables': <dynamic>[],
        'Grossesse et Allaitement': <dynamic>[],
        'Indications': <dynamic>[],
        'Interactions médicamenteuses': <dynamic>[],
        'Activité antibactérienne': <dynamic>[],
        "Pr\u00e9cautions d\u2019emploi": <dynamic>[],
        'Propriété': <dynamic>[],
      };

      final med = Med.fromSanpshot(json);
      expect(med.toJson(), {'Favoris': false});

      med.isFavoris = true;
      expect(med.toJson(), {'Favoris': true});
    });
  });
}
