class Validators {
  static String? validateAgentId(String? value) {
    if (value == null || value.trim().isEmpty) return 'Agent ID is required';
    if (value.trim().length < 4) return 'Agent ID is too short';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Account number is required';
    final digits = value.trim().replaceAll(' ', '');
    if (!RegExp(r'^\d+$').hasMatch(digits)) return 'Account number must contain only digits';
    if (digits.length != 10) return 'Account number must be exactly 10 digits';
    return null;
  }

  static String? validateDepositAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount is required';
    final cleaned = value.replaceAll(',', '').trim();
    final amount = double.tryParse(cleaned);
    if (amount == null) return 'Enter a valid amount';
    if (amount <= 0) return 'Amount must be greater than zero';
    if (amount < 100) return 'Minimum deposit is ₦100';
    if (amount > 5000000) return 'Maximum single deposit is ₦5,000,000';
    return null;
  }
}
