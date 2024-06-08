import 'package:darttonconnect/storage/interface.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TonConnectStorage implements IStorage {
  TonConnectStorage();
  final String storagePrefix = 'darttonconnect_';

  final storage = const FlutterSecureStorage();

  @override
  Future<void> setItem({
    required String key,
    required String value,
  }) async {
    final storageKey = _getStorageKey(key);
    return storage.write(
      key: storageKey,
      value: value,
    );
  }

  @override
  Future<String?> getItem({
    required String key,
    String? defaultValue,
  }) async {
    final storageKey = _getStorageKey(key);
    final result = await storage.read(key: storageKey);
    return result ?? defaultValue;
  }

  @override
  Future<void> removeItem({required String key}) async {
    final storageKey = _getStorageKey(key);
    await storage.delete(key: storageKey);
  }

  String _getStorageKey(String key) => storagePrefix + key;
}
