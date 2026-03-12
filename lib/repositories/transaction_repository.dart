import '../core/services/mock_api_service.dart';
import '../models/transaction_model.dart';
import '../models/app_error.dart';


class TransactionRepository {
  final MockApiService _api;

  TransactionRepository(this._api);

  Future<(DepositResponse?, AppError?)> deposit(
      String accountNumber, double amount, String transactionPin) async {
    try {
      final request = DepositRequest(accountNumber: accountNumber, amount: amount, transactionPin: transactionPin);
      final response = await _api.deposit(request);
      return (response, null);
    } on Exception catch (e) {
      return (null, e.toAppError());
    }
  }
}
