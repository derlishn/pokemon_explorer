import 'package:get_storage/get_storage.dart';

/// Service for handling local persistence of non-sensitive data
class StorageService {
  final _box = GetStorage();

  /// Writes data to local storage
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  /// Reads data from local storage
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Removes data from local storage
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  /// Checks if a key exists in storage
  bool hasData(String key) {
    return _box.hasData(key);
  }
}
