import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/catalog_repository.dart';
import '../domain/product_dto.dart';
import '../domain/catalog_model.dart';

final productControllerProvider = Provider.autoDispose<
    ProductController>((ref) => ProductController(ref));

class ProductController {
  final Ref _ref;
  ProductController(this._ref);

  Future<List<CanonicalProduct>> fetchProducts() {
    return _ref.read(catalogRepositoryProvider).getProducts();
  }

  Future<CanonicalProduct> createProduct(CreateProductDto dto) {
    return _ref.read(catalogRepositoryProvider).createProduct(dto);
  }

  Future<CanonicalProduct> updateProduct(String id, UpdateProductDto dto) {
    return _ref.read(catalogRepositoryProvider).updateProduct(id, dto);
  }

  Future<void> deleteProduct(String id) {
    return _ref.read(catalogRepositoryProvider).deleteProduct(id);
  }
}
