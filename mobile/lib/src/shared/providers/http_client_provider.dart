import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  // For local development with Docker Compose, 
  // we use localhost if running in browser or 10.0.2.2 if on Android emulator.
  // Since we are focusing on Web Preview for now:
  return Dio(BaseOptions(
    baseUrl: 'http://localhost:8081',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
}
