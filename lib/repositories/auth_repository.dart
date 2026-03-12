import '../core/services/mock_api_service.dart';
import '../core/services/storage_service.dart';
import '../models/auth_model.dart';
import '../models/app_error.dart';

class AuthRepository {
  final MockApiService _api;
  final StorageService _storage;

  AuthRepository(this._api, this._storage);

  Future<(LoginResponse?, AppError?)> login(String agentId, String password) async {
    try {
      final request = LoginRequest(agentId: agentId, password: password);
      final response = await _api.login(request);
      await _storage.saveAuthData(
        token: response.token,
        agentName: response.agentName,
        agentId: agentId,
      );
      return (response, null);
    } on Exception catch (e) {
      return (null, e.toAppError());
    }
  }

  Future<bool> isLoggedIn() => _storage.isLoggedIn();
  Future<String?> getAgentName() => _storage.getAgentName();

  Future<void> logout() => _storage.clearAll();
}
