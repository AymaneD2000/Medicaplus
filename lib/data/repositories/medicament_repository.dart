import 'package:diacritic/diacritic.dart';
import 'package:medpharm/Models/med.dart';
import 'package:medpharm/data/datasources/local/local_json_datasource.dart';

abstract class MedicamentRepository {
  Future<List<Med>> getAll();

  Future<List<Med>> getFavorites();

  Future<List<Med>> searchByDci(String query);

  Future<List<Med>> searchByCommercialName(String query);

  Future<List<Med>> searchByTherapeuticClass(String query);

  Future<bool> toggleFavorite(String dci);

  Future<void> resetLocalData();
}

class LocalMedicamentRepository implements MedicamentRepository {
  LocalMedicamentRepository({
    LocalJsonDatasource datasource = const LocalJsonDatasource(),
    this.assetPath = 'assets/Medicament.json',
    this.localFileName = 'Medicament.json',
  }) : _datasource = datasource;

  final LocalJsonDatasource _datasource;
  final String assetPath;
  final String localFileName;

  static const String _favoriteKey = 'Favoris';
  static const String _dciKey = 'Médicament/D.C.I (Alias)';

  @override
  Future<List<Med>> getAll() async {
    final rows = await _readRows();
    return rows.map(Med.fromSanpshot).toList();
  }

  @override
  Future<List<Med>> getFavorites() async {
    final medicaments = await getAll();
    return medicaments.where((medicament) => medicament.isFavoris).toList();
  }

  @override
  Future<List<Med>> searchByDci(String query) async {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) return getAll();

    final medicaments = await getAll();

    return medicaments.where((medicament) {
      return _matchesText(medicament.name, normalizedQuery) ||
          _matchesList(medicament.dci, normalizedQuery);
    }).toList();
  }

  @override
  Future<List<Med>> searchByCommercialName(String query) async {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) return getAll();

    final medicaments = await getAll();

    return medicaments.where((medicament) {
      return _matchesList(medicament.nomCommercial, normalizedQuery);
    }).toList();
  }

  @override
  Future<List<Med>> searchByTherapeuticClass(String query) async {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) return getAll();

    final medicaments = await getAll();

    return medicaments.where((medicament) {
      return _matchesList(medicament.classtherapique, normalizedQuery);
    }).toList();
  }

  @override
  Future<bool> toggleFavorite(String dci) async {
    final normalizedDci = _normalize(dci);
    if (normalizedDci.isEmpty) return false;

    final rows = await _readRows();
    var found = false;

    for (final row in rows) {
      final rowDci = row[_dciKey];
      if (_normalize(rowDci?.toString() ?? '') == normalizedDci) {
        row[_favoriteKey] = !(row[_favoriteKey] == true);
        found = true;
        break;
      }
    }

    if (!found) return false;

    await _datasource.writeJsonList(
      assetPath: assetPath,
      localFileName: localFileName,
      data: rows,
    );

    return true;
  }

  @override
  Future<void> resetLocalData() {
    return _datasource.resetFromAsset(
      assetPath: assetPath,
      localFileName: localFileName,
    );
  }

  Future<List<Map<String, dynamic>>> _readRows() async {
    final rows = await _datasource.readJsonList(
      assetPath: assetPath,
      localFileName: localFileName,
    );

    return rows
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  bool _matchesList(List<dynamic> values, String normalizedQuery) {
    return values
        .any((value) => _matchesText(value?.toString() ?? '', normalizedQuery));
  }

  bool _matchesText(String value, String normalizedQuery) {
    return _normalize(value).contains(normalizedQuery);
  }

  String _normalize(String value) {
    return removeDiacritics(value).trim().toLowerCase();
  }
}
