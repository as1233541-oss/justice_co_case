
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException(
      [super.message = 'Please check your Wi-Fi or mobile data and try again.']);
}

class RequestTimeoutException extends AppException {
  const RequestTimeoutException(
      [super.message = 'The request took too long. Please try again.']);
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode});
}

class DataParsingException extends AppException {
  const DataParsingException(
      [super.message = 'The server sent data in an unexpected format.']);
}

class UnknownException extends AppException {
  const UnknownException(super.message);
}

class CacheException extends AppException {
  const CacheException([super.message = 'No saved data available yet.']);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}
