import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  // For Flutter Web, using an empty baseUrl allows the browser 
  // to resolve requests like '/api/...' against the current origin.
  return Dio(BaseOptions(
    baseUrl: '/api/v1', 
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
}
