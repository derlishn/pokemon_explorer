import 'package:get_storage/get_storage.dart';

/// Professional wrapper for GetStorage to allow easier testing and 
/// infrastructure swapping in the future.
class StorageService {
  final _box = GetStorage();

  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  bool hasData(String key) {
    return _box.hasData(key);
  }

  /// Exposes keys for maintenance tasks like cache clearing
  Iterable<dynamic> getKeys() {
    return _box.getKeys();
  }

  Future<void> clearAll() async {
    await _box.erase();
  }
}
