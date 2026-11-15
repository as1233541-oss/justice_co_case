
import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../models/case_model.dart';

class CachedCases {
  final List<CaseModel> cases;
  final DateTime savedAt;

  const CachedCases({required this.cases, required this.savedAt});
}

abstract class CaseLocalDataSource {
  Future<void> cacheCases(List<CaseModel> cases);

  /// Throws [CacheException] when nothing usable is stored.
  Future<CachedCases> getCachedCases();
}

class CaseLocalDataSourceImpl implements CaseLocalDataSource {
  final Box<String> box;

  static const String _casesKey = 'cases';
  static const String _syncedKey = 'synced_at';

  const CaseLocalDataSourceImpl(this.box);

  @override
  Future<void> cacheCases(List<CaseModel> cases) {
    return box.putAll({
      _casesKey: json.encode(cases.map((c) => c.toJson()).toList()),
      _syncedKey: DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<CachedCases> getCachedCases() async {
    final raw = box.get(_casesKey);
    final syncedRaw = box.get(_syncedKey);
    if (raw == null || syncedRaw == null) {
      throw const CacheException();
    }

    try {
      final list = json.decode(raw) as List<dynamic>;
      return CachedCases(
        cases: list
            .map((e) => CaseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        savedAt: DateTime.parse(syncedRaw),
      );
    } on FormatException {
      throw const CacheException('Saved data is damaged.');
    } on TypeError {
      throw const CacheException('Saved data is damaged.');
    }
  }
}
