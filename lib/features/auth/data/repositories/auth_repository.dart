import 'package:fpdart/fpdart.dart';
import 'package:pokemon_explorer/core/error/failure.dart';
import 'package:pokemon_explorer/core/storage/secure_storage_service.dart';
import 'package:pokemon_explorer/core/constants/constants.dart';
import 'package:pokemon_explorer/core/constants/error_constants.dart';

/// Repository for handling authentication logic and secure credential storage
class AuthRepository {
  final SecureStorageService secureStorage;

  AuthRepository({required this.secureStorage});

  /// Saves user credentials securely
  Future<Either<Failure, void>> saveCredentials(
    String username,
    String password,
  ) async {
    try {
      await secureStorage.write(AppConstants.keyUserName, username);
      await secureStorage.write(AppConstants.keyPassword, password);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure(ErrorConstants.errorUnknown));
    }
  }

  /// Retrieves saved username securely
  Future<Either<Failure, String?>> getSavedUsername() async {
    try {
      final username = await secureStorage.read(AppConstants.keyUserName);
      return Right(username);
    } catch (e) {
      return const Left(CacheFailure(ErrorConstants.errorUnknown));
    }
  }

  /// Retrieves saved password securely
  Future<Either<Failure, String?>> getSavedPassword() async {
    try {
      final password = await secureStorage.read(AppConstants.keyPassword);
      return Right(password);
    } catch (e) {
      return const Left(CacheFailure(ErrorConstants.errorUnknown));
    }
  }

  /// Clears all session data
  Future<Either<Failure, void>> clearSession() async {
    try {
      await secureStorage.deleteAll();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure(ErrorConstants.errorUnknown));
    }
  }
}
