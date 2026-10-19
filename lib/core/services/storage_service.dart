import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Thin wrapper over GetStorage (local, offline-first persistence).
class StorageService extends GetxService {
  late final GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write(String key, dynamic value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);

  List<Map<String, dynamic>> readList(String key) =>
      (_box.read<List>(key) ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();
}
