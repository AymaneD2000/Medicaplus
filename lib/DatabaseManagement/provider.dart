import 'package:flutter/material.dart';
import 'package:medpharm/DatabaseManagement/supabasemanagement.dart';
import 'package:medpharm/Models/amo.dart';
import 'package:medpharm/Models/classemodel.dart';
import 'package:medpharm/Models/faculter.dart';
import 'package:medpharm/Models/filiere.dart';
import 'package:medpharm/Models/materiels.dart';
import 'package:medpharm/Models/med.dart';
import 'package:flutter/services.dart';
import 'package:medpharm/Models/pdf.dart';
import 'package:medpharm/Models/publication.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:medpharm/Models/semestre.dart';
import 'package:uuid/uuid.dart';

class MyProvider extends ChangeNotifier {
  List<Classe> classes = [];
  List<Fac> faculter = [];
  List<Filiere> filiere = [];
  List<Amo> pharmacies = [];
  List<Med> medicament = [];
  List<Amo> favorisPharmacies = [];
  List<Med> favorisMedicaments = [];
  List<String> dciPharmacie = [];
  List<ClassMed> classMedicament = [];
  List<Pdf> pdf = [];
  List<Publication> pub = [];
  List<String> iconsMed = [];
  List<String> imagesMed = [];
  List<Materiel> materiels = [];
  bool _isMedicamentLoaded = false;
  bool _isPharmacieLoaded = false;

  SupabaseManagement sup = SupabaseManagement();

  Future<List<Filiere>> getClasseFilieres(nomClasse) async {
    filiere = await sup.getClasseFilieres(nomClasse);
    notifyListeners();
    return filiere;
  }

  Future<List<Pdf>> getDocument() async {
    pdf = await sup.getDocuments();
    notifyListeners();
    return pdf;
  }

  Future<List<Publication>> getPublication() async {
    pub = await sup.getPublication();
    notifyListeners();
    return pub;
  }

  addPDF(Pdf p) async {
    await sup.addPdf(p);
    pdf = await getDocument();
    notifyListeners();
  }

  addPublication(Publication p) async {
    await sup.addPublication(p);
    pub = await getPublication();
    notifyListeners();
  }

  addMateriel(Materiel p) async {
    sup.addMateriel(p);
    getMateriel();
    notifyListeners();
  }

  removeMateriel(Materiel c) async {
    await sup.removeMateriel(c);
    getMateriel();
    notifyListeners();
  }

  deletePublication(Publication c) async {
    await sup.deletePublication(c);
    getPublication();
    notifyListeners();
  }

  removeFiliere(Filiere f) async {
    await sup.removeFiliere(f);
    getClasseFilieres(f.semestreId);
    notifyListeners();
  }

  removePdf(Pdf pdf) async {
    sup.removePdf(pdf);
  }

  Future<List<Materiel>> getMateriel() async {
    materiels = await sup.getMateriel();
    notifyListeners();
    return materiels;
  }

  Future<void> addFiliere(Filiere f) async {
    try {
      // Generate a UUID for the new filiere
      final String id = const Uuid().v4();
      final filiereWithId = Filiere(
        id: id,
        nom: f.nom,
        image: f.image,
        semestreId: f.semestreId,
      );

      debugPrint('Adding filiere with data: ${filiereWithId.toMap()}');
      await sup.addFiliere(filiereWithId);
      filiere = await getClasseFilieres(f.semestreId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding filiere: $e');
      rethrow;
    }
  }

  getAllClasses() async {
    classes = await sup.getAllClasse();
    notifyListeners();
  }

  getAllFaculty() async {
    faculter = await sup.faculter();
    notifyListeners();
  }

  addClasses(Classe c) async {
    sup.addClasse(c);
    getAllClasses();
    notifyListeners();
  }

  getPDF(id) async {
    pdf = await sup.getPDF(id);
    notifyListeners();
  }

  Future<bool> changeFavoris(dcis) async {
    try {
      // Obtenir le répertoire des documents
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Medicament.json';

      // Copier le fichier depuis les assets vers le répertoire des documents si nécessaire
      final file = File(filePath);
      if (!await file.exists()) {
        final data = await rootBundle.load('assets/Medicament.json');
        final bytes = data.buffer.asUint8List();
        await file.writeAsBytes(bytes, flush: true);
      }

      // Lire le fichier JSON
      final contents = await file.readAsString();
      final List<dynamic> medicaments = jsonDecode(contents);

      // Vérifier si la liste contient au moins 5 éléments

      // D.C.I. du médicament à modifier (5ème élément)
      final String dci = dcis;

      // Rechercher et modifier le 5ème médicament
      bool found = false;
      for (var i = 0; i < medicaments.length; i++) {
        if (medicaments[i]["Médicament/D.C.I (Alias)"] == dci) {
          // Modification du 5ème élément (index 4)
          medicaments[i]["Favoris"] = !medicaments[i]["Favoris"];
          found = true;
          break;
        }
      }
      notifyListeners();

      if (found) {
        // Écrire les modifications dans le fichier JSON
        final updatedContents = jsonEncode(medicaments);
        await file.writeAsString(updatedContents, flush: true);
        medicament = (json.decode(updatedContents) as List)
            .map((item) => Med.fromSanpshot(item))
            .toList();
        notifyListeners();
        favorisMedicaments.clear();
        for (final i in medicament) {
          if (i.isFavoris) {
            favorisMedicaments.add(i);
            notifyListeners();
          }
        }

        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (e) {
      notifyListeners();
      return false;
    }
  }

  Future<bool> changeFavorisPharmacie(dcis) async {
    try {
      // Obtenir le répertoire des documents
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Pharmacie.json';

      // Copier le fichier depuis les assets vers le répertoire des documents si nécessaire
      final file = File(filePath);
      if (!await file.exists()) {
        final data = await rootBundle.load('assets/Pharmacie.json');
        final bytes = data.buffer.asUint8List();
        await file.writeAsBytes(bytes, flush: true);
      }

      // Lire le fichier JSON
      final contents = await file.readAsString();
      final List<dynamic> medicaments = jsonDecode(contents);

      // Vérifier si la liste contient au moins 5 éléments

      // D.C.I. du médicament à modifier (5ème élément)
      final String dci = dcis;

      // Rechercher et modifier le 5ème médicament
      bool found = false;
      for (var i = 0; i < medicaments.length; i++) {
        if (medicaments[i]["Nom commercial"] == dci) {
          // Modification du 5ème élément (index 4)
          medicaments[i]["Favoris"] = !medicaments[i]["Favoris"];
          found = true;
          break;
        }
      }
      notifyListeners();

      if (found) {
        // Écrire les modifications dans le fichier JSON
        final updatedContents = jsonEncode(medicaments);
        await file.writeAsString(updatedContents, flush: true);
        pharmacies = (json.decode(updatedContents) as List)
            .map((item) => Amo.fromSanpshot(item))
            .toList();
        notifyListeners();
        favorisPharmacies.clear();
        for (final i in pharmacies) {
          if (i.favoris) {
            favorisPharmacies.add(i);
            notifyListeners();
          }
        }

        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } catch (e) {
      notifyListeners();
      return false;
    }
  }

  Future<void> loadMedicamentData() async {
    if (_isMedicamentLoaded) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Medicament.json';
      final file = File(filePath);

      if (!await file.exists()) {
        final data = await rootBundle.load('assets/Medicament.json');
        final bytes = data.buffer.asUint8List();
        await file.writeAsBytes(bytes, flush: true);
      }

      final contents = await file.readAsString();
      medicament = (json.decode(contents) as List)
          .map((item) => Med.fromSanpshot(item))
          .toList();

      favorisMedicaments = medicament.where((med) => med.isFavoris).toList();
      _isMedicamentLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading medicament data: $e');
      rethrow;
    }
  }

  Future<void> loadPharmacieData() async {
    if (_isPharmacieLoaded) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Pharmacie.json';
      final file = File(filePath);

      if (!await file.exists()) {
        final data = await rootBundle.load('assets/Pharmacie.json');
        final bytes = data.buffer.asUint8List();
        await file.writeAsBytes(bytes, flush: true);
      }

      final contents = await file.readAsString();
      pharmacies = (json.decode(contents) as List)
          .map((item) => Amo.fromSanpshot(item))
          .toList();

      favorisPharmacies = pharmacies.where((pharm) => pharm.favoris).toList();
      _isPharmacieLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading pharmacie data: $e');
      rethrow;
    }
  }

  Future<void> reloadData() async {
    _isMedicamentLoaded = false;
    _isPharmacieLoaded = false;
    await Future.wait([
      loadMedicamentData(),
      loadPharmacieData(),
    ]);
  }

  Future<List<Semestre>> getSemestres(String classeName) async {
    try {
      final data = await sup.getSemestres(classeName);
      notifyListeners();
      return data;
    } catch (e) {
      print('Error getting semestres: $e');
      rethrow;
    }
  }

  Future<void> addSemestre(
      String nomSemetre, String image, String classeName) async {
    try {
      final semestre = Semestre(
        id: const Uuid().v4(), // Generate a new UUID
        nomSemetre: nomSemetre,
        image: image,
        nomClasse: classeName,
      );
      await sup.addSemestre(semestre);
      notifyListeners();
    } catch (e) {
      print('Error adding semestre: $e');
      rethrow;
    }
  }

  Future<void> updateSemestre(
      String id, String nomSemetre, String image, String classeName) async {
    try {
      final semestre = Semestre(
        id: id,
        nomSemetre: nomSemetre,
        image: image,
        nomClasse: classeName,
      );
      await sup.updateSemestre(semestre);
      notifyListeners();
    } catch (e) {
      print('Error updating semestre: $e');
      rethrow;
    }
  }

  Future<void> deleteSemestre(String id) async {
    try {
      await sup.deleteSemestre(id);
      notifyListeners();
    } catch (e) {
      print('Error deleting semestre: $e');
      rethrow;
    }
  }
}
