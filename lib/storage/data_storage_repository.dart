import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../models/user.dart';
import '../models/vendor.dart';

/// 🧠 Central storage handler for user and vendor data.
/// Similar to DataStoreRepository in Kotlin apps.
class DataStorageRepository {
  // Singleton instance
  static final DataStorageRepository _instance = DataStorageRepository._internal();
  factory DataStorageRepository() => _instance;
  DataStorageRepository._internal();

  final GetStorage _storage = GetStorage();

  /// Keys
  static const String _keyCheckFirst = 'checkFirst';
  static const String _keyCheckVFirst = 'checkVFirst';
  static const String _keyIsLogin = 'isLogin';
  static const String _keyIsVendorLogin = 'isVendorLogin';
  static const String _keyUser = 'user';
  static const String _keyVendor = 'vendor';
  static const String _keyToken = 'token';

  // ==========================
  // ✅ SAVE METHODS
  // ==========================
  Future<void> saveCheckFirstTime(bool value) async =>
      _storage.write(_keyCheckFirst, value);

  Future<void> saveCheckVFirstTime(bool value) async =>
      _storage.write(_keyCheckVFirst, value);

  Future<void> saveIsLogin(bool value) async =>
      _storage.write(_keyIsLogin, value);

  Future<void> saveIsVendorLogin(bool value) async =>
      _storage.write(_keyIsVendorLogin, value);

  Future<void> saveUser(User user) async =>
      _storage.write(_keyUser, jsonEncode(user.toJson()));

  Future<void> saveVendor(Vendor vendor) async =>
      _storage.write(_keyVendor, jsonEncode(vendor.toJson()));

  // 👇 alias for clarity
  Future<void> saveVendorUser(Vendor vendor) async => saveVendor(vendor);

  Future<void> saveToken(String token) async =>
      _storage.write(_keyToken, token);

  // ==========================
  // ✅ GET METHODS
  // ==========================
  bool getCheckFirstTime() => _storage.read(_keyCheckFirst) ?? false;

  bool getCheckVFirstTime() => _storage.read(_keyCheckVFirst) ?? false;

  bool getIsLogin() => _storage.read(_keyIsLogin) ?? false;

  bool getIsVendorLogin() => _storage.read(_keyIsVendorLogin) ?? false;

  User? getUser() {
    final jsonStr = _storage.read(_keyUser);
    if (jsonStr != null && jsonStr.toString().isNotEmpty) {
      try {
        return User.fromJson(jsonDecode(jsonStr));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Vendor? getVendor() {
    final jsonStr = _storage.read(_keyVendor);
    if (jsonStr != null && jsonStr.toString().isNotEmpty) {
      try {
        return Vendor.fromJson(jsonDecode(jsonStr));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // 👇 alias for clarity
  Vendor? getVendorUser() => getVendor();

  String? getToken() => _storage.read(_keyToken);

  // ==========================
  // ✅ CLEAR / RESET METHODS
  // ==========================
  Future<void> clearUserData() async {
    await _storage.remove(_keyUser);
    await _storage.remove(_keyToken);
    await _storage.write(_keyIsLogin, false);
  }

  Future<void> clearVendorData() async {
    await _storage.remove(_keyVendor);
    await _storage.remove(_keyToken);
    await _storage.write(_keyIsVendorLogin, false);
  }

  Future<void> clearAll() async => _storage.erase();
}
