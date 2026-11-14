import '../../domain/entities/case.dart';

class CaseModel extends Case {
  const CaseModel({
    required super.id,
    required super.title,
    required super.status,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      // completed == true -> closed, otherwise active
      status: json['completed'] == true ? 'closed' : 'active',
    );
  }
}
