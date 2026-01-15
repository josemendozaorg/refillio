import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  // For local development, pointing directly to the backend.
  return Dio(BaseOptions(
    baseUrl: 'http://localhost:8081/api/v1/', 
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
}
