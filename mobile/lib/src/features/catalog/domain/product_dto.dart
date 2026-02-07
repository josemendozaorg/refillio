import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

@freezed
abstract class CreateProductDto with _$CreateProductDto {
  const factory CreateProductDto({
    required String name,
    required int categoryId,
    required int baseUnitId,
    String? description,
  }) = _CreateProductDto;

  factory CreateProductDto.fromJson(Map<String, dynamic> json) => _$CreateProductDtoFromJson(json);
}

@freezed
abstract class UpdateProductDto with _$UpdateProductDto {
  const factory UpdateProductDto({
    required String id,
    String? name,
    int? categoryId,
    int? baseUnitId,
    String? description,
  }) = _UpdateProductDto;

  factory UpdateProductDto.fromJson(Map<String, dynamic> json) => _$UpdateProductDtoFromJson(json);
}
