import 'package:medpharm/Models/classemodel.dart';
import 'package:medpharm/Models/faculter.dart';
import 'package:medpharm/Models/filiere.dart';
import 'package:medpharm/Models/materiels.dart';
import 'package:medpharm/Models/pdf.dart';
import 'package:medpharm/Models/publication.dart';
import 'package:medpharm/Models/semestre.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseManagement {
  static final supabase = Supabase.instance.client;
  Future<List<Classe>> getClasse(int id) async {
    final response =
        await supabase.from('classe').select("*").eq("faculter", id);
    List<Classe> classes = response.map((e) => Classe.fromSnapshot(e)).toList();
    return classes;
  }

  Future<List<Classe>> getAllClasse() async {
    final response = await supabase.from('classe').select("*");
    List<Classe> classes = response.map((e) => Classe.fromSnapshot(e)).toList();
    return classes;
  }

  // Future<List<Materiel>> getAllMaterial() async {
  //   final response = await supabase.from('classe').select("*");
  //   List<Materiel> materiels =
  //       response.map((e) => Materiel.fromSnapshot(e)).toList();
  //   return materiels;
  // }

  Future<List<Fac>> faculter() async {
    final response = await supabase.from('faculter').select("*");
    List<Fac> classes = response.map((e) => Fac.fromSnapshot(e)).toList();
    return classes;
  }

  addClasse(Classe c) async {
    await supabase.from('classe').insert(c.toMap()).then((value) {
      getAllClasse();
    });
  }

  Future<List<Filiere>> getClasseFilieres(String id) async {
    final response =
        await supabase.from('filiere').select("*").eq("semestre_id", id);
    List<Filiere> filieres =
        response.map((e) => Filiere.fromSnapshot(e)).toList();
    return filieres;
  }

  Future<void> addFiliere(Filiere f) async {
    try {
      debugPrint('Attempting to insert filiere into Supabase: ${f.toMap()}');
      final response = await supabase.from('filiere').insert(f.toMap());
      debugPrint('Filiere inserted successfully: $response');
      await getClasseFilieres(f.semestreId);
    } catch (e) {
      debugPrint('Error in supabase addFiliere: $e');
      if (e is PostgrestException) {
        debugPrint('PostgrestException details:');
        debugPrint('Message: ${e.message}');
        debugPrint('Code: ${e.code}');
        debugPrint('Details: ${e.details}');
        debugPrint('Hint: ${e.hint}');
      }
      rethrow;
    }
  }

  addPdf(Pdf p) async {
    await supabase.from('pdf').insert(p.toMap()).then((value) {});
    getDocuments();
  }

  addMateriel(Materiel p) async {
    await supabase.from('materiel').insert(p.toMap()).then((value) {});

    ///getMateriel();
  }

  addPublication(Publication p) async {
    await supabase.from('publication').insert(p.toMap()).then((value) {});

    ///getMateriel();
  }

  removeClasse(Classe c) async {
    await supabase.from('classe').delete().eq('nom', c.nom).then((value) {});
  }

  removeMateriel(Materiel c) async {
    await supabase.from('materiel').delete().eq('id', c.id!).then((value) {});
  }

  updateMateriel(Materiel c) async {
    await supabase
        .from('materiel')
        .update(c.toMap())
        .eq('id', c.id!)
        .then((value) {});
  }

  removeFiliere(Filiere f) async {
    await supabase.from('filiere').delete().eq('nom', f.nom).then((value) {});
  }

  removePdf(Pdf p) async {
    await supabase.from('pdf').delete().eq('nom', p.nom).then((value) {});
  }

  updatePublication(Publication p) async {
    await supabase
        .from('publication')
        .update(p.toMap())
        .eq('id', p.idpublication!)
        .then((value) {});
  }

  deletePublication(Publication p) async {
    await supabase
        .from('publication')
        .delete()
        .eq('id', p.idpublication!)
        .then((value) {});
  }

  Future<List<Pdf>> getDocuments() async {
    final response = await supabase.from('pdf').select("*");
    List<Pdf> documents = response.map((e) => Pdf.fromSnapshot(e)).toList();
    return documents;
  }

  Future<List<Materiel>> getMateriel() async {
    final response = await supabase.from('materiel').select("*");
    List<Materiel> documents =
        response.map((e) => Materiel.fromSnapshot(e)).toList();
    return documents;
  }

  Future<List<Publication>> getPublication() async {
    final response = await supabase.from('publication').select("*");
    List<Publication> documents =
        response.map((e) => Publication.fromSnapshot(e)).toList();
    return documents;
  }

  Future<List<Pdf>> getPDF(String id) async {
    final response =
        await supabase.from('pdf').select("*").eq("filiere_id", id);
    List<Pdf> documents = response.map((e) => Pdf.fromSnapshot(e)).toList();
    return documents;
  }

  Future<List<Filiere>> getFiliere(String id) async {
    final response =
        await supabase.from('filiere').select("*").eq("semestre_id", id);
    List<Filiere> filieres =
        response.map((e) => Filiere.fromSnapshot(e)).toList();
    return filieres;
  }

  Future<List<Semestre>> getSemestres(String classeName) async {
    final response =
        await supabase.from('semestre').select().eq('nomClasse', classeName);
    List<Semestre> semestres =
        response.map((e) => Semestre.fromJson(e)).toList();
    return semestres;
  }

  Future<void> addSemestre(Semestre semestre) async {
    await supabase.from('semestre').insert(semestre.toJson());
  }

  Future<void> updateSemestre(Semestre semestre) async {
    await supabase
        .from('semestre')
        .update(semestre.toJson())
        .eq('id', semestre.id);
  }

  Future<void> deleteSemestre(String id) async {
    await supabase.from('semestre').delete().eq('id', id);
  }
}
