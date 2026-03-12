import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';

class DepositState {
  final DepositResponse? response;
  final bool isLoading;
  final String? error;
  const DepositState({this.response, this.isLoading = false, this.error});
}

class DepositNotifier extends StateNotifier<DepositState> {
  final TransactionRepository _repo;
  DepositNotifier(this._repo) : super(const DepositState());

  Future<bool> deposit(String accountNumber, double amount, String transactionPin) async {
    state = const DepositState(isLoading: true);
    final (response, error) = await _repo.deposit(accountNumber, amount, transactionPin);
    if (error != null) {
      state = DepositState(error: error.message);
      return false;
    }
    state = DepositState(response: response);
    return true;
  }

  void reset() => state = const DepositState();
}
