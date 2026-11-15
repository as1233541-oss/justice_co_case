import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_data_source.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  const NoteRepositoryImpl(this.localDataSource);

  @override
  Future<List<Note>> getNotes(int caseId) async {
    final notes = await localDataSource.getNotes(caseId);
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt)); 
    return notes;
  }

  @override
  Future<Note> addNote(int caseId, String text) async {
    final now = DateTime.now();
    final note = NoteModel(
      id: now.microsecondsSinceEpoch.toString(),
      caseId: caseId,
      text: text,
      createdAt: now,
    );
    await localDataSource.addNote(note);
    return note;
  }
}
