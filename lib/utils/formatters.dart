

import 'package:intl/intl.dart';

class Formatters {
  static final _currency = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 2);
  static final _shortCurrency = NumberFormat('#,##0.00');

  static String formatCurrency(double amount) => _currency.format(amount);
  static String formatAmount(double amount) => _shortCurrency.format(amount);

  static String maskAccountNumber(String accountNumber) {
    if (accountNumber.length < 4) return accountNumber;
    final visible = accountNumber.substring(accountNumber.length - 4);
    return '•••• •••• $visible';
  }
}
