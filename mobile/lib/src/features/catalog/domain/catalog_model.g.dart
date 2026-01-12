// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  parentId: (json['parentId'] as num?)?.toInt(),
  slug: json['slug'] as String?,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'parentId': instance.parentId,
  'slug': instance.slug,
};

_MeasurementUnit _$MeasurementUnitFromJson(Map<String, dynamic> json) =>
    _MeasurementUnit(
      id: (json['id'] as num).toInt(),
      symbol: json['symbol'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$MeasurementUnitToJson(_MeasurementUnit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'type': instance.type,
    };

_CanonicalProduct _$CanonicalProductFromJson(Map<String, dynamic> json) =>
    _CanonicalProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      baseUnit: json['baseUnit'] == null
          ? null
          : MeasurementUnit.fromJson(json['baseUnit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CanonicalProductToJson(_CanonicalProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'baseUnit': instance.baseUnit,
    };
