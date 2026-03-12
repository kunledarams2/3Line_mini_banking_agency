import '../core/services/mock_api_service.dart';
import '../models/customer_model.dart';
import '../models/app_error.dart';


class CustomerRepository {
  final MockApiService _api;

  CustomerRepository(this._api);

  Future<(Customer?, AppError?)> findCustomer(String accountNumber) async {
    try {
      final customer = await _api.getCustomer(accountNumber);
      return (customer, null);
    } on Exception catch (e) {
      return (null, e.toAppError());
    }
  }
}
