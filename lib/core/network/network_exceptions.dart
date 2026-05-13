/// Base class for all network-related exceptions
class NetworkException implements Exception {
  final String errorCode;
  final int? statusCode;

  NetworkException(this.errorCode, [this.statusCode]);

  @override
  String toString() => '$runtimeType: $errorCode ($statusCode)';
}

/// Thrown when there is a server-side error (500s)
class FetchDataException extends NetworkException {
  FetchDataException(super.errorCode, [super.statusCode]);
}

/// Thrown for invalid requests (400)
class BadRequestException extends NetworkException {
  BadRequestException(super.errorCode, [super.statusCode]);
}

/// Thrown for authentication issues (401, 403)
class UnauthorizedException extends NetworkException {
  UnauthorizedException(super.errorCode, [super.statusCode]);
}

/// Thrown when a resource is not found (404)
class NotFoundException extends NetworkException {
  NotFoundException(super.errorCode, [super.statusCode]);
}

/// Thrown when no internet connection is detected
class NoInternetException extends NetworkException {
  NoInternetException(super.errorCode);
}

/// Thrown when a request times out
class ApiTimeoutException extends NetworkException {
  ApiTimeoutException(super.errorCode);
}
