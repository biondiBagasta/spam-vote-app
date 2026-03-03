import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    resetOnError: true
  );

  final _secureStorage = const FlutterSecureStorage();


  Future<String?> readSecureData(String key) async {
    final readData = await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  Future<void> writeSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value, aOptions: _getAndroidOptions());
  }

  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
  }

  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll();
  }

}