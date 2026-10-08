import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

ApiException mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const ApiException('Request timed out. Please try again.');
    case DioExceptionType.connectionError:
      return const ApiException(
          "Can't reach the server. Check your connection and that the backend is running.");
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      if (code == 404) return const ApiException('Not found', statusCode: 404);
      return ApiException('Server error ($code)', statusCode: code);
    default:
      return const ApiException('Something went wrong.');
  }
}

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'accept': 'application/json'},
  ));
});