
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

class ApiClient {
  final http.Client client;
  final Duration timeout;

  const ApiClient({
    required this.client,
    this.timeout = const Duration(seconds: 15),
  });


  Future<dynamic> getJson(String url) async {
    try {
      final response = await client.get(Uri.parse(url)).timeout(timeout);

      if (response.statusCode != 200) {
        throw ServerException(
          'Server returned status code ${response.statusCode}.',
          statusCode: response.statusCode,
        );
      }
      return json.decode(response.body);
    } on SocketException {
      throw const NoInternetException();
    } on http.ClientException {
      throw const NoInternetException();
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on FormatException {
      throw const DataParsingException();
    }
  }
}
