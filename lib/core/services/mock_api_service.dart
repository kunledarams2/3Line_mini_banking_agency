
import 'dart:math';
import '../../models/app_error.dart';
import '../../models/auth_model.dart';
import '../../models/customer_model.dart';
import '../../models/transaction_model.dart';


class MockApiService {
  static const _delay = Duration(milliseconds: 1200);

  static final _customers = <String, Customer>{
    '0123456789': const Customer(accountNumber: '0123456789', name: 'Jane Doe', balance: 25000),
    '9876543210': const Customer(accountNumber: '9876543210', name: 'John Smith', balance: 150000),
    '1111111111': const Customer(accountNumber: '1111111111', name: 'Amaka Obi', balance: 5000, ),
  };

  Future<LoginResponse> login(LoginRequest request) async {
    await Future.delayed(_delay);
    if (request.agentId == 'AGT123' && request.password == 'password') {
      return const LoginResponse(token: 'jwt_token', agentName: 'John Agent');
    }
    throw _AppException('Invalid agent ID or password.', statusCode: 401);
  }

  Future<Customer> getCustomer(String accountNumber) async {
    await Future.delayed(_delay);
    final customer = _customers[accountNumber];
    if (customer == null) {
      throw _AppException('Customer account not found.', statusCode: 404);
    }
    return customer;
  }

  Future<DepositResponse> deposit(DepositRequest request) async {
    await Future.delayed(_delay);
    if (request.amount <= 0) {
      throw _AppException('Amount must be greater than zero.', statusCode: 422);
    }
    if (request.transactionPin !="1234"){
      throw _AppException('Incorrect transaction pin.', statusCode: 422);
    }
    final txnId = 'TXN${Random().nextInt(99999).toString().padLeft(5, '0')}';
    final customer = _customers[request.accountNumber];
    if (customer != null) {
      _customers[request.accountNumber] = Customer(
        accountNumber: customer.accountNumber,
        name: customer.name,
        balance: customer.balance + request.amount,
      );
    }
    return DepositResponse(transactionId: txnId, status: 'SUCCESS');
  }
}

class _AppException implements Exception {
  final String message;
  final int statusCode;
  _AppException(this.message, {required this.statusCode});
  AppError toAppError() => AppError(message: message, statusCode: statusCode);
}

extension AppExceptionExt on Exception {
  AppError toAppError() {
    if (this is _AppException) return (this as _AppException).toAppError();
    return const AppError(message: 'An unexpected error occurred.');
  }
}
