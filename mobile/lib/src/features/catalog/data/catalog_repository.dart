import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/providers/http_client_provider.dart';
import '../domain/catalog_model.dart';

part 'catalog_repository.g.dart';

@riverpod
CatalogRepository catalogRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return CatalogRepository(dio);
}

class CatalogRepository {
  final Dio _dio;

  CatalogRepository(this._dio);

  Future<List<CanonicalProduct>> getProducts() async {
    final response = await _dio.get('catalog/products');
    final data = response.data as List<dynamic>;
    return data.map((e) => CanonicalProduct.fromJson(e as Map<String, dynamic>)).toList();
  }
}

@riverpod
Future<List<CanonicalProduct>> allProducts(Ref ref) {
  return ref.watch(catalogRepositoryProvider).getProducts();
}
