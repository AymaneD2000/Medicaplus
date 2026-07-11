import 'package:flutter/material.dart';
import 'package:medpharm/Models/amo.dart';
import 'package:medpharm/data/repositories/pharmacie_repository.dart';

class PharmacieProvider extends ChangeNotifier {
  List<Amo> pharmacies = [];
  List<Amo> favorisPharmacies = [];
  bool _isPharmacieLoaded = false;

  final PharmacieRepository _pharmacieRepository =
      const LocalPharmacieRepository();

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

  Future<bool> changeFavorisPharmacie(String dcis) async {
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

  Future<void> reloadData() async {
    _isPharmacieLoaded = false;
    await loadPharmacieData();
  }
}
