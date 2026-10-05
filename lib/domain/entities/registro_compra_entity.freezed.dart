// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registro_compra_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegistroCompra {

 DateTime get data; double get quantidade; double get precoReal; String? get supermercadoId;
/// Create a copy of RegistroCompra
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistroCompraCopyWith<RegistroCompra> get copyWith => _$RegistroCompraCopyWithImpl<RegistroCompra>(this as RegistroCompra, _$identity);

  /// Serializes this RegistroCompra to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegistroCompra&&(identical(other.data, data) || other.data == data)&&(identical(other.quantidade, quantidade) || other.quantidade == quantidade)&&(identical(other.precoReal, precoReal) || other.precoReal == precoReal)&&(identical(other.supermercadoId, supermercadoId) || other.supermercadoId == supermercadoId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,quantidade,precoReal,supermercadoId);

@override
String toString() {
  return 'RegistroCompra(data: $data, quantidade: $quantidade, precoReal: $precoReal, supermercadoId: $supermercadoId)';
}


}

/// @nodoc
abstract mixin class $RegistroCompraCopyWith<$Res>  {
  factory $RegistroCompraCopyWith(RegistroCompra value, $Res Function(RegistroCompra) _then) = _$RegistroCompraCopyWithImpl;
@useResult
$Res call({
 DateTime data, double quantidade, double precoReal, String? supermercadoId
});




}
/// @nodoc
class _$RegistroCompraCopyWithImpl<$Res>
    implements $RegistroCompraCopyWith<$Res> {
  _$RegistroCompraCopyWithImpl(this._self, this._then);

  final RegistroCompra _self;
  final $Res Function(RegistroCompra) _then;

/// Create a copy of RegistroCompra
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? quantidade = null,Object? precoReal = null,Object? supermercadoId = freezed,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DateTime,quantidade: null == quantidade ? _self.quantidade : quantidade // ignore: cast_nullable_to_non_nullable
as double,precoReal: null == precoReal ? _self.precoReal : precoReal // ignore: cast_nullable_to_non_nullable
as double,supermercadoId: freezed == supermercadoId ? _self.supermercadoId : supermercadoId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegistroCompra].
extension RegistroCompraPatterns on RegistroCompra {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegistroCompra value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegistroCompra() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegistroCompra value)  $default,){
final _that = this;
switch (_that) {
case _RegistroCompra():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegistroCompra value)?  $default,){
final _that = this;
switch (_that) {
case _RegistroCompra() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime data,  double quantidade,  double precoReal,  String? supermercadoId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegistroCompra() when $default != null:
return $default(_that.data,_that.quantidade,_that.precoReal,_that.supermercadoId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime data,  double quantidade,  double precoReal,  String? supermercadoId)  $default,) {final _that = this;
switch (_that) {
case _RegistroCompra():
return $default(_that.data,_that.quantidade,_that.precoReal,_that.supermercadoId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime data,  double quantidade,  double precoReal,  String? supermercadoId)?  $default,) {final _that = this;
switch (_that) {
case _RegistroCompra() when $default != null:
return $default(_that.data,_that.quantidade,_that.precoReal,_that.supermercadoId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegistroCompra extends RegistroCompra {
  const _RegistroCompra({required this.data, required this.quantidade, this.precoReal = 0.0, this.supermercadoId}): super._();
  factory _RegistroCompra.fromJson(Map<String, dynamic> json) => _$RegistroCompraFromJson(json);

@override final  DateTime data;
@override final  double quantidade;
@override@JsonKey() final  double precoReal;
@override final  String? supermercadoId;

/// Create a copy of RegistroCompra
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistroCompraCopyWith<_RegistroCompra> get copyWith => __$RegistroCompraCopyWithImpl<_RegistroCompra>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegistroCompraToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegistroCompra&&(identical(other.data, data) || other.data == data)&&(identical(other.quantidade, quantidade) || other.quantidade == quantidade)&&(identical(other.precoReal, precoReal) || other.precoReal == precoReal)&&(identical(other.supermercadoId, supermercadoId) || other.supermercadoId == supermercadoId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data,quantidade,precoReal,supermercadoId);

@override
String toString() {
  return 'RegistroCompra(data: $data, quantidade: $quantidade, precoReal: $precoReal, supermercadoId: $supermercadoId)';
}


}

/// @nodoc
abstract mixin class _$RegistroCompraCopyWith<$Res> implements $RegistroCompraCopyWith<$Res> {
  factory _$RegistroCompraCopyWith(_RegistroCompra value, $Res Function(_RegistroCompra) _then) = __$RegistroCompraCopyWithImpl;
@override @useResult
$Res call({
 DateTime data, double quantidade, double precoReal, String? supermercadoId
});




}
/// @nodoc
class __$RegistroCompraCopyWithImpl<$Res>
    implements _$RegistroCompraCopyWith<$Res> {
  __$RegistroCompraCopyWithImpl(this._self, this._then);

  final _RegistroCompra _self;
  final $Res Function(_RegistroCompra) _then;

/// Create a copy of RegistroCompra
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? quantidade = null,Object? precoReal = null,Object? supermercadoId = freezed,}) {
  return _then(_RegistroCompra(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DateTime,quantidade: null == quantidade ? _self.quantidade : quantidade // ignore: cast_nullable_to_non_nullable
as double,precoReal: null == precoReal ? _self.precoReal : precoReal // ignore: cast_nullable_to_non_nullable
as double,supermercadoId: freezed == supermercadoId ? _self.supermercadoId : supermercadoId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
