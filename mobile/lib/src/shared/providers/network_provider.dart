import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  // Pointing to localhost:3000 (gateway) or 8081 (backend)
  // For Android emulator 10.0.2.2 usually.
  // For Linux desktop (which this seems to be), localhost is fine.
  // But hardcoding for now.
  return Dio(BaseOptions(
    baseUrl: 'http://localhost:8081/api/v1',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));
}
