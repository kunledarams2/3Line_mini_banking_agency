import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/customer_model.dart';
import '../repositories/customer_repository.dart';

class CustomerState {
  final Customer? customer;
  final bool isLoading;
  final String? error;
  const CustomerState({this.customer, this.isLoading = false, this.error});
  CustomerState copyWith({Customer? customer, bool? isLoading, String? error}) =>
      CustomerState(customer: customer ?? this.customer, isLoading: isLoading ?? this.isLoading, error: error);
}

class CustomerNotifier extends StateNotifier<CustomerState> {
  final CustomerRepository _repo;
  CustomerNotifier(this._repo) : super(const CustomerState());

  Future<void> searchCustomer(String accountNumber) async {
    state = const CustomerState(isLoading: true);
    final (customer, error) = await _repo.findCustomer(accountNumber);
    if (error != null) {
      state = CustomerState(error: error.message);
    } else {
      state = CustomerState(customer: customer);
    }
  }

  void clear() => state = const CustomerState();
}
