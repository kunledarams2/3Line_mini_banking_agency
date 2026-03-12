class DepositRequest {
  final String accountNumber;
  final double amount;
  final String transactionPin;

  const DepositRequest({required this.accountNumber, required this.amount, required this.transactionPin});

  Map<String, dynamic> toJson() => {
        'accountNumber': accountNumber,
        'amount': amount,
      };
}

class DepositResponse {
  final String transactionId;
  final String status;

  const DepositResponse({required this.transactionId, required this.status});

  factory DepositResponse.fromJson(Map<String, dynamic> json) =>
      DepositResponse(
        transactionId: json['transactionId'] as String,
        status: json['status'] as String,
      );

  bool get isSuccess => status == 'SUCCESS';
}
