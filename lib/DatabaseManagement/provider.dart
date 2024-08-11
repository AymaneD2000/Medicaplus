import 'package:flutter/material.dart';
import 'package:moussa_project/DatabaseManagement/supabasemanagement.dart';
import 'package:moussa_project/Models/amo.dart';
import 'package:moussa_project/Models/classemodel.dart';
import 'package:moussa_project/Models/faculter.dart';
import 'package:moussa_project/Models/filiere.dart';
import 'package:moussa_project/Models/materiels.dart';
import 'package:moussa_project/Models/med.dart';
import 'package:flutter/services.dart';
import 'package:moussa_project/Models/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class MyProvider extends ChangeNotifier{
  List<Classe> classes = [];
  List<Fac> faculter = [];
  List<Filiere> filiere = [];
  List<Amo> pharmacies = [];
  List<Med> medicament = [];
  List<Amo> favorisPharmacies = [];
  List<Med> favorisMedicaments = [];
  List<String> dciPharmacie = [];
  List<String> classMedicament = [];
  List<Pdf> pdf = [];
  List<String> iconsMed = [];
  List<String> imagesMed = [];
  List<Materiel> materiels = [];
  //List<>
  
  SupabaseManagement sup = SupabaseManagement();

  Future<List<Filiere>> getClasseFilieres(nomClasse)async{
    filiere =await sup.getClasseFilieres(nomClasse);
    return filiere;
  }

  Future<List<Pdf>> getDocument()async{
    pdf = await sup.getDocuments();
    notifyListeners();
    return pdf;
  }

  addPDF(Pdf p)async{
    await sup.addPdf(p);
    pdf = await getDocument();
    notifyListeners();
  }

  addMateriel(Materiel p)async{
    sup.addMateriel(p);
    getMateriel();
    notifyListeners();
  }

  removeMateriel(Materiel c)async{
    await sup.removeMateriel(c);
    getMateriel();
    notifyListeners();
  }

  removeFiliere(Filiere f)async{
    await sup.removeFiliere(f);
    getClasseFilieres(f.nomClasse);
    notifyListeners();
  }

  removePdf(Pdf pdf)async{
    sup.removePdf(pdf);
    
  }

  Future<List<Materiel>> getMateriel()async{
    materiels = await sup.getMateriel();
    notifyListeners();
    return materiels;
  }

  addFiliere(Filiere f)async{
    await sup.addFiliere(f);
    filiere = await getClasseFilieres(f.nomClasse);
  }

  getAllClasses()async{
    classes = await sup.getAllClasse();
    notifyListeners();
  }

  getAllFaculty()async{
    faculter = await sup.faculter();
    notifyListeners();
  }

  addClasses(Classe c)async{
    sup.addClasse(c);
    getAllClasses();
    notifyListeners();
  }

  getPDF(id)async{
    pdf = await sup.getPDF(id);
    notifyListeners();
  }

  Future<bool> changeFavoris(dcis)async{
    try {
      // Obtenir le répertoire des documents
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/med3.json';

      // Copier le fichier depuis les assets vers le répertoire des documents si nécessaire
      final file = File(filePath);
      if (!await file.exists()) {
        final data = await rootBundle.load('assets/med3.json');
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
        if (medicaments[i]["Médicament/D.C.I (Alias)"] == dci) { // Modification du 5ème élément (index 4)
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
        medicament = (json.decode(updatedContents) as List).map((item) => Med.fromSanpshot(item)).toList();
        notifyListeners();
        favorisMedicaments.clear();
        for(final i in medicament){
        if(i.isFavoris){
          favorisMedicaments.add(i);
          notifyListeners();
        }
      }

        print("Le favori du médicament $dci a été mis à jour.");
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        print("Médicament $dci non trouvé comme 5ème élément dans la liste.");
        return false;
      }
    } catch (e) {
      notifyListeners();
      print("Erreur lors de la lecture ou de l'écriture du fichier : $e");
      return false;
    }
  }

    Future<bool> changeFavorisPharmacie(dcis)async{
    try {
      // Obtenir le répertoire des documents
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Pharmacies3.json';

      // Copier le fichier depuis les assets vers le répertoire des documents si nécessaire
      final file = File(filePath);
      if (!await file.exists()) {
        final data = await rootBundle.load('assets/Pharmacies3.json');
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
        if (medicaments[i]["Nom commercial"] == dci) { // Modification du 5ème élément (index 4)
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
        pharmacies = (json.decode(updatedContents) as List).map((item) => Amo.fromSanpshot(item)).toList();
        notifyListeners();
        favorisPharmacies.clear();
        for(final i in pharmacies){
        if(i.favoris){
          favorisPharmacies.add(i);
          notifyListeners();
        }
      }

        print("Le favori du médicament $dci a été mis à jour.");
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        print("Médicament $dci non trouvé comme 5ème élément dans la liste.");
        return false;
      }
    } catch (e) {
      notifyListeners();
      print("Erreur lors de la lecture ou de l'écriture du fichier : $e");
      return false;
    }
  }

  Future<List<Amo>> loadPharmacieData() async {
    //String data = await DefaultAssetBundle.of(context)
       // .loadString('assets/med.json');
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Pharmacies3.json';

      // Copier le fichier depuis les assets vers le répertoire des documents si nécessaire
      final file = File(filePath);
      if (!await file.exists()) {
        final data = await rootBundle.load('assets/Pharmacies3.json');
        final bytes = data.buffer.asUint8List();
        await file.writeAsBytes(bytes, flush: true);
      }

      // Lire le fichier JSON
      final contents = await file.readAsString();
      //final List<dynamic> medicaments = jsonDecode(contents);
      pharmacies =
          (json.decode(contents) as List).map((item) => Amo.fromSanpshot(item)).toList();
      //filteredMedNameList = medNameList;
      for(final i in pharmacies){
        if(i.favoris){
          favorisPharmacies.add(i);
        }
      }
      for(final med in pharmacies){
        for(final cl in med.classtherapique)
          dciPharmacie.add(cl);
        dciPharmacie = dciPharmacie.toSet().toList();
      }
      
      
    print("end");
    notifyListeners();
    return pharmacies ;
  }

  Future<void> loadMedicamentData() async {
    //String data = await DefaultAssetBundle.of(context)
       // .loadString('assets/med.json');
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/med3.json';

      // Copier le fichier depuis les assets vers le répertoire des documents si nécessaire
      final file = File(filePath);
      if (!await file.exists()) {
        final data = await rootBundle.load('assets/med3.json');
        final bytes = data.buffer.asUint8List();
        await file.writeAsBytes(bytes, flush: true);
      }

      // Lire le fichier JSON
      final contents = await file.readAsString();
      //final List<dynamic> medicaments = jsonDecode(contents);
      medicament =
          (json.decode(contents) as List).map((item) => Med.fromSanpshot(item)).toList();
      //filteredMedNameList = medNameList;
      for(final i in medicament){
        if(i.isFavoris){
          favorisMedicaments.add(i);
        }
      }
      print(medicament.length);
      for(final med in medicament){
        for(final cl in med.classtherapique)
          classMedicament.add(cl);
        classMedicament = classMedicament.toSet().toList();
      }

      for(final med in medicament){
        for(String cl in med.icons)
          iconsMed.add(cl);
        iconsMed = iconsMed.toSet().toList();
      }

      for(final med in medicament){
        for(String cl in med.images)
        imagesMed.add(cl);
        imagesMed = imagesMed.toSet().toList();
      }
      
    print("end");
    notifyListeners();
    //return medicament;
  }
}