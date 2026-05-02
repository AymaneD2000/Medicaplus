import 'package:diacritic/diacritic.dart';
import 'package:medpharm/Models/amo.dart';
import 'package:medpharm/data/datasources/local/local_json_datasource.dart';

abstract class PharmacieRepository {
  Future<List<Amo>> getAll();
  Future<List<Amo>> getFavorites();
  Future<bool> toggleFavorite(String nomCommercial);
  Future<List<Amo>> searchByName(String query);
  Future<List<Amo>> searchByDci(String query);
  Future<List<Amo>> searchByAmoStatus({required bool isAmo});
  Future<void> resetLocalData();
}

class LocalPharmacieRepository implements PharmacieRepository {
  static const String pharmacieAssetPath = 'assets/Pharmacie.json';
  static const String pharmacieLocalFileName = 'Pharmacie.json';

  final LocalJsonDatasource _datasource;

  const LocalPharmacieRepository({
    LocalJsonDatasource datasource = const LocalJsonDatasource(),
  }) : _datasource = datasource;

  @override
  Future<List<Amo>> getAll() async {
    final rows = await _datasource.readJsonList(
      assetPath: pharmacieAssetPath,
      localFileName: pharmacieLocalFileName,
    );

    return rows
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .map(Amo.fromSanpshot)
        .toList();
  }

  @override
  Future<List<Amo>> getFavorites() async {
    final pharmacies = await getAll();
    return pharmacies.where((pharmacie) => pharmacie.favoris).toList();
  }

  @override
  Future<bool> toggleFavorite(String nomCommercial) async {
    final rows = await _datasource.readJsonList(
      assetPath: pharmacieAssetPath,
      localFileName: pharmacieLocalFileName,
    );

    var found = false;

    final normalizedName = _normalize(nomCommercial);

    final updatedRows = rows.map((row) {
      if (row is! Map) {
        return row;
      }

      final mappedRow = Map<String, dynamic>.from(row);
      final currentName = mappedRow['Nom commercial']?.toString() ?? '';

      if (_normalize(currentName) == normalizedName) {
        found = true;
        return {
          ...mappedRow,
          'Favoris': !(mappedRow['Favoris'] == true),
        };
      }

      return mappedRow;
    }).toList();

    if (!found) {
      return false;
    }

    await _datasource.writeJsonList(
      assetPath: pharmacieAssetPath,
      localFileName: pharmacieLocalFileName,
      data: updatedRows,
    );

    return true;
  }

  @override
  Future<List<Amo>> searchByName(String query) async {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return getAll();
    }

    final pharmacies = await getAll();

    return pharmacies.where((pharmacie) {
      return _normalize(pharmacie.name).contains(normalizedQuery);
    }).toList();
  }

  @override
  Future<List<Amo>> searchByDci(String query) async {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return getAll();
    }

    final pharmacies = await getAll();

    return pharmacies.where((pharmacie) {
      return pharmacie.dci.any((value) {
        return _normalize(value.toString()).contains(normalizedQuery);
      });
    }).toList();
  }

  @override
  Future<List<Amo>> searchByAmoStatus({required bool isAmo}) async {
    final pharmacies = await getAll();
    return pharmacies.where((pharmacie) => pharmacie.amo == isAmo).toList();
  }

  @override
  Future<void> resetLocalData() {
    return _datasource.resetFromAsset(
      assetPath: pharmacieAssetPath,
      localFileName: pharmacieLocalFileName,
    );
  }

  String _normalize(String value) {
    return removeDiacritics(value).trim().toLowerCase();
  }
}
