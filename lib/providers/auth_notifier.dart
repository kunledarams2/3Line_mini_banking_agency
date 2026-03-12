import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';

class AuthState {
  final String? agentName;
  final bool isLoggedIn;
  const AuthState({this.agentName, this.isLoggedIn = false});
}

class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final AuthRepository _repo;
  AuthNotifier(this._repo) : super(const AsyncValue.data(AuthState())) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final loggedIn = await _repo.isLoggedIn();
    if (loggedIn) {
      final name = await _repo.getAgentName();
      state = AsyncValue.data(AuthState(agentName: name, isLoggedIn: true));
    }
  }

  Future<String?> login(String agentId, String password) async {
    state = const AsyncValue.loading();
    final (response, error) = await _repo.login(agentId, password);
    if (error != null) {
      state = const AsyncValue.data(AuthState(isLoggedIn: false));
      return error.message;
    }
    state = AsyncValue.data(
        AuthState(agentName: response!.agentName, isLoggedIn: true));
    return null;
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(AuthState(isLoggedIn: false));
  }
}
