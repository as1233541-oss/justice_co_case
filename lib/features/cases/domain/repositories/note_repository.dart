import '../entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getNotes(int caseId);
  Future<Note> addNote(int caseId, String text);
}
