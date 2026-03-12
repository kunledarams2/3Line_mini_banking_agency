import 'package:dio/dio.dart';

import '../../models/app_error.dart';
import 'storage_service.dart';

class ApiClient {
  static const _baseUrl = 'https://api.agencybank.mock';
  
  late final Dio _dio;
  final StorageService _storage;

  ApiClient(this._storage) {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(_AuthInterceptor(_storage));
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,

    ));
  }

  Dio get dio => _dio;

  static AppError handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const AppError(message: 'Connection timed out. Check your internet connection.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return const AppError(message: 'No internet connection. Please check your network.');
    }
    if (e.response != null) {
      return AppError.fromStatusCode(e.response!.statusCode ?? 0);
    }
    return const AppError(message: 'An unexpected error occurred.');
  }
}

class _AuthInterceptor extends Interceptor {
  final StorageService _storage;
  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    if (!options.path.contains('/login')) {
      final token = await _storage.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {

    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/login')) {
      _storage.clearAll();

    }
    handler.next(err);
  }
}
