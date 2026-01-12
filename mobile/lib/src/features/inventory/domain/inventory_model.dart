import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_model.freezed.dart';
part 'inventory_model.g.dart';

@freezed
abstract class ProductSummary with _$ProductSummary {
  const factory ProductSummary({
    required String id,
    required String name,
    required String unitSymbol,
  }) = _ProductSummary;

  factory ProductSummary.fromJson(Map<String, dynamic> json) => _$ProductSummaryFromJson(json);
}

@freezed
abstract class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    required String id,
    required String userId,
    ProductSummary? product,
    required double currentQty,
    required double reorderPoint,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);
}

@freezed
abstract class AddToPantryRequest with _$AddToPantryRequest {
  const factory AddToPantryRequest({
    required String productId,
    required double quantity,
    required double reorderPoint,
  }) = _AddToPantryRequest;

  factory AddToPantryRequest.fromJson(Map<String, dynamic> json) => _$AddToPantryRequestFromJson(json);
}
