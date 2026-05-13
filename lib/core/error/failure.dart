/// Base class for all failures in the application
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);
}

/// Failure occurring during network communication
class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.statusCode]);
}

/// Failure occurring when no internet connection is available
class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

/// Failure occurring during local storage operations
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Generic failure for unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
