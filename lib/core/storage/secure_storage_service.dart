import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for handling encrypted persistence of sensitive data
class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  /// Encrypts and saves sensitive data
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads and decrypts sensitive data
  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  /// Deletes sensitive data
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Clears all encrypted data
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
