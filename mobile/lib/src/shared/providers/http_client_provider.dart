import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8081/api/v1/',
  );
  
  return Dio(BaseOptions(
    baseUrl: apiUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
}
