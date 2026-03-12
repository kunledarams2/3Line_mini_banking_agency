class Customer {
  final String accountNumber;
  final String name;
  final double balance;

  const Customer({
    required this.accountNumber,
    required this.name,
    required this.balance,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        accountNumber: json['accountNumber'] as String,
        name: json['name'] as String,
        balance: (json['balance'] as num).toDouble(),
      );
}
