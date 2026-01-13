import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/providers/http_client_provider.dart';
import '../domain/inventory_model.dart';

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
    final response = await _dio.get('inventory', queryParameters: {'userId': userId});
    final data = response.data as List<dynamic>;
    return data.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<InventoryItem> addToPantry(String userId, AddToPantryRequest request) async {
    final response = await _dio.post(
      'inventory',
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

@riverpod
Future<List<InventoryItem>> lowStockItems(Ref ref, String userId) async {
  final items = await ref.watch(pantryItemsProvider(userId).future);
  return items.where((item) => item.currentQty <= item.reorderPoint).toList();
}
