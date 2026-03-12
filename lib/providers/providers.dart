import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_line_agency_banking/providers/pin_entry_provider.dart';
import 'package:three_line_agency_banking/providers/states/pin_entry_state.dart';
import 'package:three_line_agency_banking/providers/stats_notifier.dart';
import '../core/services/mock_api_service.dart';
import '../core/services/storage_service.dart';

import '../repositories/auth_repository.dart';
import '../repositories/customer_repository.dart';
import '../repositories/transaction_repository.dart';
import 'auth_notifier.dart';
import 'customer_notifier.dart';
import 'deposit_notifier.dart';

final storageServiceProvider = Provider<StorageService>((_) => StorageService());
final mockApiServiceProvider = Provider<MockApiService>((_) => MockApiService());

final authRepositoryProvider = Provider<AuthRepository>((ref) =>
    AuthRepository(ref.watch(mockApiServiceProvider), ref.watch(storageServiceProvider)));

final customerRepositoryProvider = Provider<CustomerRepository>((ref) =>
    CustomerRepository(ref.watch(mockApiServiceProvider)));

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) =>
    TransactionRepository(ref.watch(mockApiServiceProvider)));

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) =>
        AuthNotifier(ref.watch(authRepositoryProvider)));

final customerNotifierProvider =
    StateNotifierProvider.autoDispose<CustomerNotifier, CustomerState>((ref) =>
        CustomerNotifier(ref.watch(customerRepositoryProvider)));

final depositNotifierProvider =
    StateNotifierProvider.autoDispose<DepositNotifier, DepositState>((ref) =>
        DepositNotifier(ref.watch(transactionRepositoryProvider)));

final statsNotifierProvider =
StateNotifierProvider<StatsNotifier, AgentStats>((_) => StatsNotifier());

final pinEntryProvider =
StateNotifierProvider<PinEntryNotifier, PinEntryState>((ref) {
    return PinEntryNotifier();
});

