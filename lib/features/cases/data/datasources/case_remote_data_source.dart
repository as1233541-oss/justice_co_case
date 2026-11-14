// Remote data source: asks the shared ApiClient for /todos and maps to models.
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/case_model.dart';

abstract class CaseRemoteDataSource {
  Future<List<CaseModel>> fetchCases();
}

class CaseRemoteDataSourceImpl implements CaseRemoteDataSource {
  final ApiClient apiClient;

  static const String _url = 'https://jsonplaceholder.typicode.com/todos';

  const CaseRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CaseModel>> fetchCases() async {
    final data = await apiClient.getJson(_url);

    if (data is! List) {
      throw const DataParsingException();
    }
    try {
      return data
          .map((e) => CaseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TypeError {
      throw const DataParsingException();
    }
  }
}
