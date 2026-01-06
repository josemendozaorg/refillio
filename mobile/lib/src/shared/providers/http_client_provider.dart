import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  // For Flutter Web, using an empty baseUrl or a relative path 
  // allows the browser to resolve the request against the same origin.
  // This works perfectly with our Nginx Reverse Proxy strategy.
  return Dio(BaseOptions(
    baseUrl: '/', 
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
}
