class AppError {
  final String message;
  final int? statusCode;

  const AppError({required this.message, this.statusCode});

  factory AppError.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 401:
        return const AppError(message: 'Invalid credentials. Please try again.', statusCode: 401);
      case 404:
        return const AppError(message: 'Customer account not found.', statusCode: 404);
      case 422:
        return const AppError(message: 'Invalid request. Please check your input.', statusCode: 422);
      case 500:
        return const AppError(message: 'Server error. Please try again later.', statusCode: 500);
      default:
        return AppError(message: 'An error occurred (code: $statusCode).', statusCode: statusCode);
    }
  }

  @override
  String toString() => message;
}
