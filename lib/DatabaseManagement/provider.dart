import 'package:flutter/material.dart';
import 'package:medpharm/DatabaseManagement/supabasemanagement.dart';
import 'package:medpharm/Models/amo.dart';
import 'package:medpharm/Models/classemodel.dart';
import 'package:medpharm/Models/faculter.dart';
import 'package:medpharm/Models/filiere.dart';
import 'package:medpharm/Models/materiels.dart';
import 'package:medpharm/Models/med.dart';
import 'package:medpharm/Models/pdf.dart';
import 'package:medpharm/Models/publication.dart';
import 'package:medpharm/Models/semestre.dart';
import 'package:medpharm/data/repositories/medicament_repository.dart';
import 'package:medpharm/data/repositories/pharmacie_repository.dart';
import 'package:uuid/uuid.dart';

/// Legacy provider kept for backward compatibility.
/// New code should use the domain-specific providers:
/// - MedicamentProvider
/// - PharmacieProvider
/// - CoursProvider
/// - MaterielProvider
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
  final MedicamentRepository _medicamentRepository =
      LocalMedicamentRepository();
  final PharmacieRepository _pharmacieRepository =
      const LocalPharmacieRepository();

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

  Future<void> addPDF(Pdf p) async {
    await sup.addPdf(p);
    await getDocument();
  }

  Future<void> addPublication(Publication p) async {
    await sup.addPublication(p);
    await getPublication();
  }

  Future<void> addMateriel(Materiel p) async {
    await sup.addMateriel(p);
    await getMateriel();
  }

  Future<void> removeMateriel(Materiel c) async {
    await sup.removeMateriel(c);
    await getMateriel();
  }

  Future<void> deletePublication(Publication c) async {
    await sup.deletePublication(c);
    await getPublication();
  }

  Future<void> removeFiliere(Filiere f) async {
    await sup.removeFiliere(f);
    await getClasseFilieres(f.semestreId);
  }

  Future<void> removePdf(Pdf pdf) async {
    await sup.removePdf(pdf);
  }

  Future<List<Materiel>> getMateriel() async {
    materiels = await sup.getMateriel();
    notifyListeners();
    return materiels;
  }

  Future<void> addFiliere(Filiere f) async {
    try {
      final String id = const Uuid().v4();
      final filiereWithId = Filiere(
        id: id,
        nom: f.nom,
        image: f.image,
        semestreId: f.semestreId,
      );

      debugPrint('Adding filiere with data: ${filiereWithId.toMap()}');
      await sup.addFiliere(filiereWithId);
      await getClasseFilieres(f.semestreId);
    } catch (e) {
      debugPrint('Error adding filiere: $e');
      rethrow;
    }
  }

  Future<void> updateFiliere(Filiere f) async {
    try {
      debugPrint('Updating filiere with data: ${f.toMap()}');
      await sup.updateFiliere(f);
      await getClasseFilieres(f.semestreId);
    } catch (e) {
      debugPrint('Error updating filiere: $e');
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

  Future<void> addClasses(Classe c) async {
    await sup.addClasse(c);
    await getAllClasses();
  }

  getPDF(id) async {
    pdf = await sup.getPDF(id);
    notifyListeners();
  }

  Future<bool> changeFavoris(dcis) async {
    try {
      final updated = await _medicamentRepository.toggleFavorite(dcis);
      if (!updated) return false;

      medicament = await _medicamentRepository.getAll();
      favorisMedicaments = medicament.where((i) => i.isFavoris).toList();
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Error changing medicament favorite: $e');
      return false;
    }
  }

  Future<bool> changeFavorisPharmacie(dcis) async {
    try {
      final updated = await _pharmacieRepository.toggleFavorite(dcis);
      if (!updated) return false;

      pharmacies = await _pharmacieRepository.getAll();
      favorisPharmacies = pharmacies.where((i) => i.favoris).toList();
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Error changing pharmacie favorite: $e');
      return false;
    }
  }

  Future<void> loadMedicamentData() async {
    if (_isMedicamentLoaded) return;

    try {
      medicament = await _medicamentRepository.getAll();
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
      pharmacies = await _pharmacieRepository.getAll();
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
      debugPrint('Error getting semestres: $e');
      rethrow;
    }
  }

  Future<void> addSemestre(
      String nomSemetre, String image, String classeName) async {
    try {
      final semestre = Semestre(
        id: const Uuid().v4(),
        nomSemetre: nomSemetre,
        image: image,
        nomClasse: classeName,
      );
      await sup.addSemestre(semestre);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding semestre: $e');
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
      debugPrint('Error updating semestre: $e');
      rethrow;
    }
  }

  Future<void> deleteSemestre(String id, String? imageUrl) async {
    try {
      await sup.deleteSemestre(id, imageUrl);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting semestre: $e');
      rethrow;
    }
  }
}
