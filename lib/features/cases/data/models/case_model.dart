import '../../domain/entities/case.dart';

class CaseModel extends Case {
  const CaseModel({
    required super.id,
    required super.title,
    required super.status,
    required super.clientId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'completed': status == 'closed',
        'userId': clientId,
      };

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      //completed == true -> closed, otherwise active
      status: json['completed'] == true ? 'closed' : 'active',
      clientId: (json['userId'] as int?) ?? 0,
    );
  }
}
