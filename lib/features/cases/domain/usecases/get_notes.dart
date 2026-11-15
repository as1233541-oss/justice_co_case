import '../entities/note.dart';
import '../repositories/note_repository.dart';

class GetNotes {
  final NoteRepository repository;

  const GetNotes(this.repository);

  Future<List<Note>> call(int caseId) => repository.getNotes(caseId);
}
