import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/http_client_provider.dart';
import '../domain/inventory_model.dart';
import '../domain/catalog_model.dart';

part 'inventory_repository.g.dart';

@riverpod
InventoryRepository inventoryRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return InventoryRepository(dio);
}

class InventoryRepository {
  final Dio _dio;

  InventoryRepository(this._dio);

  Future<List<InventoryItem>> getPantry(String userId) async {
    final response = await _dio.get('/inventory', queryParameters: {'userId': userId});
    final List<dynamic> data = response.data;
    return data.map((e) => InventoryItem.fromJson(e)).toList();
  }

  Future<InventoryItem> addToPantry(String userId, AddToPantryRequest request) async {
    final response = await _dio.post(
      '/inventory',
      queryParameters: {'userId': userId},
      data: request.toJson(),
    );
    return InventoryItem.fromJson(response.data);
  }
}

@riverpod
Future<List<InventoryItem>> pantryItems(Ref ref, String userId) {
  return ref.watch(inventoryRepositoryProvider).getPantry(userId);
}
