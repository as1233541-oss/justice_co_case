import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes(int caseId);

  Future<void> addNote(NoteModel note);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Box<String> box;

  const NoteLocalDataSourceImpl(this.box);

  String _key(int caseId) => 'case_$caseId';

  @override
  Future<List<NoteModel>> getNotes(int caseId) async {
    final raw = box.get(_key(caseId));
    if (raw == null) return <NoteModel>[]; // no notes written yet

    try {
      final list = json.decode(raw) as List<dynamic>;
      return list
          .map((e) => NoteModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw const CacheException('Saved notes are damaged.');
    } on TypeError {
      throw const CacheException('Saved notes are damaged.');
    }
  }

  @override
  Future<void> addNote(NoteModel note) async {
    final notes = await getNotes(note.caseId);
    notes.add(note);
    await box.put(
      _key(note.caseId),
      json.encode(notes.map((n) => n.toJson()).toList()),
    );
  }
}
