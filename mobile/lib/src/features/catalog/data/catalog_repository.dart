import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/providers/http_client_provider.dart';
import '../domain/product_dto.dart';

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
    final response = await _dio.get('products');
    final data = response.data as List<dynamic>;
    return data.map((e) => CanonicalProduct.fromJson(e as Map<String, dynamic>)).toList();
  }

    Future<CanonicalProduct> createProduct(CreateProductDto dto) async {
    final response = await _dio.post('products', data: dto.toJson());
    return CanonicalProduct.fromJson(response.data as Map<String, dynamic>);
    }

    Future<CanonicalProduct> updateProduct(String id, UpdateProductDto dto) async {
    final response = await _dio.put('products/$id', data: dto.toJson());
    return CanonicalProduct.fromJson(response.data as Map<String, dynamic>);
    }

    Future<void> deleteProduct(String id) async {
    await _dio.delete('products/$id');
    }
}

@riverpod
Future<List<CanonicalProduct>> allProducts(Ref ref) {
  return ref.watch(catalogRepositoryProvider).getProducts();
}
