import '../../../../core/error/exceptions.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class AddNote {
  final NoteRepository repository;

  const AddNote(this.repository);

  Future<Note> call(int caseId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw const ValidationException('Please write something before saving.');
    }
    return repository.addNote(caseId, trimmed);
  }
}
