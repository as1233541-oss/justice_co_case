class Case {
  final int id;
  final String title;
  final String status; // 'active' or 'closed'

  const Case({
    required this.id,
    required this.title,
    required this.status,
  });
}
