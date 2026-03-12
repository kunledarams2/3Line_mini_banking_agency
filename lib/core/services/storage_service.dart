import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _tokenKey = 'auth_token';
  static const _agentNameKey = 'agent_name';
  static const _agentIdKey = 'agent_id';

  Future<void> saveAuthData({
    required String token,
    required String agentName,
    required String agentId,
  }) async {
    await Future.wait([
      _storage.write(key: _tokenKey, value: token),
      _storage.write(key: _agentNameKey, value: agentName),
      _storage.write(key: _agentIdKey, value: agentId),
    ]);
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<String?> getAgentName() => _storage.read(key: _agentNameKey);
  Future<String?> getAgentId() => _storage.read(key: _agentIdKey);

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
