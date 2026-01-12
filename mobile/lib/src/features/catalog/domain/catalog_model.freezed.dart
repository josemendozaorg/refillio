// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Category {

 int get id; String get name; int? get parentId; String? get slug;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,parentId,slug);

@override
String toString() {
  return 'Category(id: $id, name: $name, parentId: $parentId, slug: $slug)';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 int id, String name, int? parentId, String? slug
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? parentId = freezed,Object? slug = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int? parentId,  String? slug)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.parentId,_that.slug);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int? parentId,  String? slug)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.id,_that.name,_that.parentId,_that.slug);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int? parentId,  String? slug)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.parentId,_that.slug);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Category implements Category {
  const _Category({required this.id, required this.name, this.parentId, this.slug});
  factory _Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

@override final  int id;
@override final  String name;
@override final  int? parentId;
@override final  String? slug;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,parentId,slug);

@override
String toString() {
  return 'Category(id: $id, name: $name, parentId: $parentId, slug: $slug)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int? parentId, String? slug
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? parentId = freezed,Object? slug = freezed,}) {
  return _then(_Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MeasurementUnit {

 int get id; String get symbol; String get type;
/// Create a copy of MeasurementUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementUnitCopyWith<MeasurementUnit> get copyWith => _$MeasurementUnitCopyWithImpl<MeasurementUnit>(this as MeasurementUnit, _$identity);

  /// Serializes this MeasurementUnit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasurementUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,symbol,type);

@override
String toString() {
  return 'MeasurementUnit(id: $id, symbol: $symbol, type: $type)';
}


}

/// @nodoc
abstract mixin class $MeasurementUnitCopyWith<$Res>  {
  factory $MeasurementUnitCopyWith(MeasurementUnit value, $Res Function(MeasurementUnit) _then) = _$MeasurementUnitCopyWithImpl;
@useResult
$Res call({
 int id, String symbol, String type
});




}
/// @nodoc
class _$MeasurementUnitCopyWithImpl<$Res>
    implements $MeasurementUnitCopyWith<$Res> {
  _$MeasurementUnitCopyWithImpl(this._self, this._then);

  final MeasurementUnit _self;
  final $Res Function(MeasurementUnit) _then;

/// Create a copy of MeasurementUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? symbol = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MeasurementUnit].
extension MeasurementUnitPatterns on MeasurementUnit {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasurementUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasurementUnit() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasurementUnit value)  $default,){
final _that = this;
switch (_that) {
case _MeasurementUnit():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasurementUnit value)?  $default,){
final _that = this;
switch (_that) {
case _MeasurementUnit() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String symbol,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasurementUnit() when $default != null:
return $default(_that.id,_that.symbol,_that.type);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String symbol,  String type)  $default,) {final _that = this;
switch (_that) {
case _MeasurementUnit():
return $default(_that.id,_that.symbol,_that.type);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String symbol,  String type)?  $default,) {final _that = this;
switch (_that) {
case _MeasurementUnit() when $default != null:
return $default(_that.id,_that.symbol,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeasurementUnit implements MeasurementUnit {
  const _MeasurementUnit({required this.id, required this.symbol, required this.type});
  factory _MeasurementUnit.fromJson(Map<String, dynamic> json) => _$MeasurementUnitFromJson(json);

@override final  int id;
@override final  String symbol;
@override final  String type;

/// Create a copy of MeasurementUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementUnitCopyWith<_MeasurementUnit> get copyWith => __$MeasurementUnitCopyWithImpl<_MeasurementUnit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeasurementUnitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasurementUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,symbol,type);

@override
String toString() {
  return 'MeasurementUnit(id: $id, symbol: $symbol, type: $type)';
}


}

/// @nodoc
abstract mixin class _$MeasurementUnitCopyWith<$Res> implements $MeasurementUnitCopyWith<$Res> {
  factory _$MeasurementUnitCopyWith(_MeasurementUnit value, $Res Function(_MeasurementUnit) _then) = __$MeasurementUnitCopyWithImpl;
@override @useResult
$Res call({
 int id, String symbol, String type
});




}
/// @nodoc
class __$MeasurementUnitCopyWithImpl<$Res>
    implements _$MeasurementUnitCopyWith<$Res> {
  __$MeasurementUnitCopyWithImpl(this._self, this._then);

  final _MeasurementUnit _self;
  final $Res Function(_MeasurementUnit) _then;

/// Create a copy of MeasurementUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? symbol = null,Object? type = null,}) {
  return _then(_MeasurementUnit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CanonicalProduct {

 String get id; String get name; String? get description; Category? get category; MeasurementUnit? get baseUnit;
/// Create a copy of CanonicalProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CanonicalProductCopyWith<CanonicalProduct> get copyWith => _$CanonicalProductCopyWithImpl<CanonicalProduct>(this as CanonicalProduct, _$identity);

  /// Serializes this CanonicalProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CanonicalProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.baseUnit, baseUnit) || other.baseUnit == baseUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,baseUnit);

@override
String toString() {
  return 'CanonicalProduct(id: $id, name: $name, description: $description, category: $category, baseUnit: $baseUnit)';
}


}

/// @nodoc
abstract mixin class $CanonicalProductCopyWith<$Res>  {
  factory $CanonicalProductCopyWith(CanonicalProduct value, $Res Function(CanonicalProduct) _then) = _$CanonicalProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, Category? category, MeasurementUnit? baseUnit
});


$CategoryCopyWith<$Res>? get category;$MeasurementUnitCopyWith<$Res>? get baseUnit;

}
/// @nodoc
class _$CanonicalProductCopyWithImpl<$Res>
    implements $CanonicalProductCopyWith<$Res> {
  _$CanonicalProductCopyWithImpl(this._self, this._then);

  final CanonicalProduct _self;
  final $Res Function(CanonicalProduct) _then;

/// Create a copy of CanonicalProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? category = freezed,Object? baseUnit = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,baseUnit: freezed == baseUnit ? _self.baseUnit : baseUnit // ignore: cast_nullable_to_non_nullable
as MeasurementUnit?,
  ));
}
/// Create a copy of CanonicalProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of CanonicalProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementUnitCopyWith<$Res>? get baseUnit {
    if (_self.baseUnit == null) {
    return null;
  }

  return $MeasurementUnitCopyWith<$Res>(_self.baseUnit!, (value) {
    return _then(_self.copyWith(baseUnit: value));
  });
}
}


/// Adds pattern-matching-related methods to [CanonicalProduct].
extension CanonicalProductPatterns on CanonicalProduct {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CanonicalProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CanonicalProduct() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CanonicalProduct value)  $default,){
final _that = this;
switch (_that) {
case _CanonicalProduct():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CanonicalProduct value)?  $default,){
final _that = this;
switch (_that) {
case _CanonicalProduct() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  Category? category,  MeasurementUnit? baseUnit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CanonicalProduct() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.baseUnit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  Category? category,  MeasurementUnit? baseUnit)  $default,) {final _that = this;
switch (_that) {
case _CanonicalProduct():
return $default(_that.id,_that.name,_that.description,_that.category,_that.baseUnit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  Category? category,  MeasurementUnit? baseUnit)?  $default,) {final _that = this;
switch (_that) {
case _CanonicalProduct() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.baseUnit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CanonicalProduct implements CanonicalProduct {
  const _CanonicalProduct({required this.id, required this.name, this.description, this.category, this.baseUnit});
  factory _CanonicalProduct.fromJson(Map<String, dynamic> json) => _$CanonicalProductFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  Category? category;
@override final  MeasurementUnit? baseUnit;

/// Create a copy of CanonicalProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CanonicalProductCopyWith<_CanonicalProduct> get copyWith => __$CanonicalProductCopyWithImpl<_CanonicalProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CanonicalProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CanonicalProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.baseUnit, baseUnit) || other.baseUnit == baseUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,baseUnit);

@override
String toString() {
  return 'CanonicalProduct(id: $id, name: $name, description: $description, category: $category, baseUnit: $baseUnit)';
}


}

/// @nodoc
abstract mixin class _$CanonicalProductCopyWith<$Res> implements $CanonicalProductCopyWith<$Res> {
  factory _$CanonicalProductCopyWith(_CanonicalProduct value, $Res Function(_CanonicalProduct) _then) = __$CanonicalProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, Category? category, MeasurementUnit? baseUnit
});


@override $CategoryCopyWith<$Res>? get category;@override $MeasurementUnitCopyWith<$Res>? get baseUnit;

}
/// @nodoc
class __$CanonicalProductCopyWithImpl<$Res>
    implements _$CanonicalProductCopyWith<$Res> {
  __$CanonicalProductCopyWithImpl(this._self, this._then);

  final _CanonicalProduct _self;
  final $Res Function(_CanonicalProduct) _then;

/// Create a copy of CanonicalProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? category = freezed,Object? baseUnit = freezed,}) {
  return _then(_CanonicalProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category?,baseUnit: freezed == baseUnit ? _self.baseUnit : baseUnit // ignore: cast_nullable_to_non_nullable
as MeasurementUnit?,
  ));
}

/// Create a copy of CanonicalProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of CanonicalProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeasurementUnitCopyWith<$Res>? get baseUnit {
    if (_self.baseUnit == null) {
    return null;
  }

  return $MeasurementUnitCopyWith<$Res>(_self.baseUnit!, (value) {
    return _then(_self.copyWith(baseUnit: value));
  });
}
}

// dart format on
