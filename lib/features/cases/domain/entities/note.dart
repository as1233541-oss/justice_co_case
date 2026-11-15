class Note {
  final String id;
  final int caseId;
  final String text;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.caseId,
    required this.text,
    required this.createdAt,
  });
}
