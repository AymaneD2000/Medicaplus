import 'package:flutter/material.dart';
import 'package:medpharm/DatabaseManagement/supabasemanagement.dart';
import 'package:medpharm/Models/materiels.dart';
import 'package:medpharm/Models/publication.dart';

class MaterielProvider extends ChangeNotifier {
  List<Materiel> materiels = [];
  List<Publication> pub = [];

  final SupabaseManagement _sup = SupabaseManagement();

  Future<List<Materiel>> getMateriel() async {
    materiels = await _sup.getMateriel();
    notifyListeners();
    return materiels;
  }

  Future<void> addMateriel(Materiel p) async {
    await _sup.addMateriel(p);
    await getMateriel();
  }

  Future<void> removeMateriel(Materiel c) async {
    await _sup.removeMateriel(c);
    await getMateriel();
  }

  Future<List<Publication>> getPublication() async {
    pub = await _sup.getPublication();
    notifyListeners();
    return pub;
  }

  Future<void> addPublication(Publication p) async {
    await _sup.addPublication(p);
    await getPublication();
  }

  Future<void> deletePublication(Publication c) async {
    await _sup.deletePublication(c);
    await getPublication();
  }
}
