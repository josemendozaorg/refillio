import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_model.freezed.dart';
part 'catalog_model.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    int? parentId,
    String? slug,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
class MeasurementUnit with _$MeasurementUnit {
  const factory MeasurementUnit({
    required int id,
    required String symbol,
    required String type,
  }) = _MeasurementUnit;

  factory MeasurementUnit.fromJson(Map<String, dynamic> json) => _$MeasurementUnitFromJson(json);
}

@freezed
class CanonicalProduct with _$CanonicalProduct {
  const factory CanonicalProduct({
    required String id,
    required String name,
    String? description,
    Category? category,
    MeasurementUnit? baseUnit,
  }) = _CanonicalProduct;

  factory CanonicalProduct.fromJson(Map<String, dynamic> json) => _$CanonicalProductFromJson(json);
}
