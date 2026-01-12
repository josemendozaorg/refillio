import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/providers/network_provider.dart';
import '../domain/catalog_model.dart';

part 'catalog_repository.g.dart';

@riverpod
CatalogRepository catalogRepository(CatalogRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return CatalogRepository(dio);
}

class CatalogRepository {
  final Dio _dio;

  CatalogRepository(this._dio);

  Future<List<CanonicalProduct>> getProducts() async {
    final response = await _dio.get('/catalog/products');
    final List<dynamic> data = response.data;
    return data.map((e) => CanonicalProduct.fromJson(e)).toList();
  }
}

@riverpod
Future<List<CanonicalProduct>> allProducts(AllProductsRef ref) {
  return ref.watch(catalogRepositoryProvider).getProducts();
}
