import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgentStats {
  final double totalBalance;
  final int depositCount;
  final double totalCommission;

  const AgentStats({
    this.totalBalance = 0,
    this.depositCount = 0,
    this.totalCommission = 0,
  });

  static const double commissionRate = 0.005;

  AgentStats addDeposit(double amount) {
    final commission = amount * commissionRate;
    return AgentStats(
      totalBalance: totalBalance + amount,
      depositCount: depositCount + 1,
      totalCommission: totalCommission + commission,
    );
  }
}

class StatsNotifier extends StateNotifier<AgentStats> {
  StatsNotifier() : super(const AgentStats());

  void recordDeposit(double amount) {
    state = state.addDeposit(amount);
  }

  void reset() => state = const AgentStats();
}

final statsNotifierProvider =
    StateNotifierProvider<StatsNotifier, AgentStats>(
  (_) => StatsNotifier(),
);
