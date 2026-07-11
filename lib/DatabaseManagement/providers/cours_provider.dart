import 'package:flutter/material.dart';
import 'package:medpharm/DatabaseManagement/supabasemanagement.dart';
import 'package:medpharm/Models/classemodel.dart';
import 'package:medpharm/Models/faculter.dart';
import 'package:medpharm/Models/filiere.dart';
import 'package:medpharm/Models/pdf.dart';
import 'package:medpharm/Models/semestre.dart';
import 'package:uuid/uuid.dart';

class CoursProvider extends ChangeNotifier {
  List<Classe> classes = [];
  List<Fac> faculter = [];
  List<Filiere> filiere = [];
  List<Pdf> pdf = [];

  final SupabaseManagement _sup = SupabaseManagement();

  Future<List<Filiere>> getClasseFilieres(String nomClasse) async {
    filiere = await _sup.getClasseFilieres(nomClasse);
    notifyListeners();
    return filiere;
  }

  Future<List<Pdf>> getDocument() async {
    pdf = await _sup.getDocuments();
    notifyListeners();
    return pdf;
  }

  Future<void> addPDF(Pdf p) async {
    await _sup.addPdf(p);
    await getDocument();
  }

  Future<void> removePdf(Pdf pdf) async {
    await _sup.removePdf(pdf);
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
      await _sup.addFiliere(filiereWithId);
      await getClasseFilieres(f.semestreId);
    } catch (e) {
      debugPrint('Error adding filiere: $e');
      rethrow;
    }
  }

  Future<void> updateFiliere(Filiere f) async {
    try {
      debugPrint('Updating filiere with data: ${f.toMap()}');
      await _sup.updateFiliere(f);
      await getClasseFilieres(f.semestreId);
    } catch (e) {
      debugPrint('Error updating filiere: $e');
      rethrow;
    }
  }

  Future<void> removeFiliere(Filiere f) async {
    await _sup.removeFiliere(f);
    await getClasseFilieres(f.semestreId);
  }

  Future<void> getAllClasses() async {
    classes = await _sup.getAllClasse();
    notifyListeners();
  }

  Future<void> getAllFaculty() async {
    faculter = await _sup.faculter();
    notifyListeners();
  }

  Future<void> addClasses(Classe c) async {
    await _sup.addClasse(c);
    await getAllClasses();
  }

  Future<void> getPDF(String id) async {
    pdf = await _sup.getPDF(id);
    notifyListeners();
  }

  Future<List<Semestre>> getSemestres(String classeName) async {
    try {
      final data = await _sup.getSemestres(classeName);
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
      await _sup.addSemestre(semestre);
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
      await _sup.updateSemestre(semestre);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating semestre: $e');
      rethrow;
    }
  }

  Future<void> deleteSemestre(String id, String? imageUrl) async {
    try {
      await _sup.deleteSemestre(id, imageUrl);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting semestre: $e');
      rethrow;
    }
  }
}
