import 'package:flutter/material.dart';
import 'package:medpharm/Models/med.dart';
import 'package:medpharm/data/repositories/medicament_repository.dart';

class MedicamentProvider extends ChangeNotifier {
  List<Med> medicament = [];
  List<Med> favorisMedicaments = [];
  bool _isMedicamentLoaded = false;

  final MedicamentRepository _medicamentRepository =
      LocalMedicamentRepository();

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

  Future<bool> changeFavoris(String dcis) async {
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

  Future<void> reloadData() async {
    _isMedicamentLoaded = false;
    await loadMedicamentData();
  }
}
