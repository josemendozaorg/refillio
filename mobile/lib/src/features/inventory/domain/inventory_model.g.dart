// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductSummary _$ProductSummaryFromJson(Map<String, dynamic> json) =>
    _ProductSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      unitSymbol: json['unitSymbol'] as String,
    );

Map<String, dynamic> _$ProductSummaryToJson(_ProductSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unitSymbol': instance.unitSymbol,
    };

_InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    _InventoryItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      product: json['product'] == null
          ? null
          : ProductSummary.fromJson(json['product'] as Map<String, dynamic>),
      currentQty: (json['currentQty'] as num).toDouble(),
      reorderPoint: (json['reorderPoint'] as num).toDouble(),
    );

Map<String, dynamic> _$InventoryItemToJson(_InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'product': instance.product,
      'currentQty': instance.currentQty,
      'reorderPoint': instance.reorderPoint,
    };

_AddToPantryRequest _$AddToPantryRequestFromJson(Map<String, dynamic> json) =>
    _AddToPantryRequest(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      reorderPoint: (json['reorderPoint'] as num).toDouble(),
    );

Map<String, dynamic> _$AddToPantryRequestToJson(_AddToPantryRequest instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'reorderPoint': instance.reorderPoint,
    };
