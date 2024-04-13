import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Models/filiere.dart';
import 'package:moussa_project/Models/pdf.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManagement {
  static final supabase = Supabase.instance.client;
  Future<List<Classe>> getClasse() async {
    final response = await supabase.from('classe').select("*");
    List<Classe> classes = response.map((e) => Classe.fromSnapshot(e)).toList();
    return classes;
  }

  addClasse(Classe c) async {
    await supabase.from('classe').insert(c.toMap()).then((value) {
      print(value);
      getClasse();
    });
  }

  Future<List<Filiere>> getClasseFilieres(String nomClasse) async {
    final response =
        await supabase.from('filiere').select("*").eq("nomClasse", nomClasse);
    List<Filiere> filieres =
        response.map((e) => Filiere.fromSnapshot(e)).toList();
    return filieres;
  }

  addFiliere(Filiere f) async {
    await supabase
        .from('filiere')
        .insert(f.toMap())
        .eq("nomClasse", f.nomClasse)
        .then((value) {
      print(value);
    });
  }

  addPdf(Pdf p) async {
    await supabase.from('pdf').insert(p.toMap()).then((value) {
      print(value);
    });
    getDocuments();
  }

  removeClasse(Classe c) async {
    await supabase.from('classe').delete().eq('nom', c.nom).then((value) {
      print(value);
    });
  }

  removeFiliere(Filiere f) async {
    await supabase.from('filiere').delete().eq('nom', f.nom).then((value) {
      print(value);
    });
  }

  removePdf(Pdf p) async {
    await supabase.from('pdf').delete().eq('nom', p.nom).then((value) {
      print(value);
    });
  }

  Future<List<Pdf>> getDocuments() async {
    final response = await supabase.from('pdf').select("*");
    List<Pdf> documents = response.map((e) => Pdf.fromSnapshot(e)).toList();
    return documents;
  }

  Future<List<Pdf>> getPDF(String id) async {
    final response = await supabase.from('pdf').select("*").eq("id", id);
    List<Pdf> documents = response.map((e) => Pdf.fromSnapshot(e)).toList();
    return documents;
  }

  Future<List<Filiere>> getFiliere() async {
    final response = await supabase.from('filiere').select("*");
    List<Filiere> filieres =
        response.map((e) => Filiere.fromSnapshot(e)).toList();
    return filieres;
  }
}
