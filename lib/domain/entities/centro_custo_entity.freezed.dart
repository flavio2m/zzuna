// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'centro_custo_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CentroCusto {

 String get id; String get descricao; bool get ativo;
/// Create a copy of CentroCusto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CentroCustoCopyWith<CentroCusto> get copyWith => _$CentroCustoCopyWithImpl<CentroCusto>(this as CentroCusto, _$identity);

  /// Serializes this CentroCusto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CentroCusto&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.ativo, ativo) || other.ativo == ativo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,descricao,ativo);

@override
String toString() {
  return 'CentroCusto(id: $id, descricao: $descricao, ativo: $ativo)';
}


}

/// @nodoc
abstract mixin class $CentroCustoCopyWith<$Res>  {
  factory $CentroCustoCopyWith(CentroCusto value, $Res Function(CentroCusto) _then) = _$CentroCustoCopyWithImpl;
@useResult
$Res call({
 String id, String descricao, bool ativo
});




}
/// @nodoc
class _$CentroCustoCopyWithImpl<$Res>
    implements $CentroCustoCopyWith<$Res> {
  _$CentroCustoCopyWithImpl(this._self, this._then);

  final CentroCusto _self;
  final $Res Function(CentroCusto) _then;

/// Create a copy of CentroCusto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? descricao = null,Object? ativo = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CentroCusto].
extension CentroCustoPatterns on CentroCusto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CentroCusto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CentroCusto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CentroCusto value)  $default,){
final _that = this;
switch (_that) {
case _CentroCusto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CentroCusto value)?  $default,){
final _that = this;
switch (_that) {
case _CentroCusto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String descricao,  bool ativo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CentroCusto() when $default != null:
return $default(_that.id,_that.descricao,_that.ativo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String descricao,  bool ativo)  $default,) {final _that = this;
switch (_that) {
case _CentroCusto():
return $default(_that.id,_that.descricao,_that.ativo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String descricao,  bool ativo)?  $default,) {final _that = this;
switch (_that) {
case _CentroCusto() when $default != null:
return $default(_that.id,_that.descricao,_that.ativo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CentroCusto implements CentroCusto {
  const _CentroCusto({required this.id, required this.descricao, required this.ativo});
  factory _CentroCusto.fromJson(Map<String, dynamic> json) => _$CentroCustoFromJson(json);

@override final  String id;
@override final  String descricao;
@override final  bool ativo;

/// Create a copy of CentroCusto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CentroCustoCopyWith<_CentroCusto> get copyWith => __$CentroCustoCopyWithImpl<_CentroCusto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CentroCustoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CentroCusto&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.ativo, ativo) || other.ativo == ativo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,descricao,ativo);

@override
String toString() {
  return 'CentroCusto(id: $id, descricao: $descricao, ativo: $ativo)';
}


}

/// @nodoc
abstract mixin class _$CentroCustoCopyWith<$Res> implements $CentroCustoCopyWith<$Res> {
  factory _$CentroCustoCopyWith(_CentroCusto value, $Res Function(_CentroCusto) _then) = __$CentroCustoCopyWithImpl;
@override @useResult
$Res call({
 String id, String descricao, bool ativo
});




}
/// @nodoc
class __$CentroCustoCopyWithImpl<$Res>
    implements _$CentroCustoCopyWith<$Res> {
  __$CentroCustoCopyWithImpl(this._self, this._then);

  final _CentroCusto _self;
  final $Res Function(_CentroCusto) _then;

/// Create a copy of CentroCusto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? descricao = null,Object? ativo = null,}) {
  return _then(_CentroCusto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CentroCustoDetails {

 String get id; String get descricao; bool get ativo;
/// Create a copy of CentroCustoDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CentroCustoDetailsCopyWith<CentroCustoDetails> get copyWith => _$CentroCustoDetailsCopyWithImpl<CentroCustoDetails>(this as CentroCustoDetails, _$identity);

  /// Serializes this CentroCustoDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CentroCustoDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.ativo, ativo) || other.ativo == ativo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,descricao,ativo);

@override
String toString() {
  return 'CentroCustoDetails(id: $id, descricao: $descricao, ativo: $ativo)';
}


}

/// @nodoc
abstract mixin class $CentroCustoDetailsCopyWith<$Res>  {
  factory $CentroCustoDetailsCopyWith(CentroCustoDetails value, $Res Function(CentroCustoDetails) _then) = _$CentroCustoDetailsCopyWithImpl;
@useResult
$Res call({
 String id, String descricao, bool ativo
});




}
/// @nodoc
class _$CentroCustoDetailsCopyWithImpl<$Res>
    implements $CentroCustoDetailsCopyWith<$Res> {
  _$CentroCustoDetailsCopyWithImpl(this._self, this._then);

  final CentroCustoDetails _self;
  final $Res Function(CentroCustoDetails) _then;

/// Create a copy of CentroCustoDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? descricao = null,Object? ativo = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CentroCustoDetails].
extension CentroCustoDetailsPatterns on CentroCustoDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CentroCustoDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CentroCustoDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CentroCustoDetails value)  $default,){
final _that = this;
switch (_that) {
case _CentroCustoDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CentroCustoDetails value)?  $default,){
final _that = this;
switch (_that) {
case _CentroCustoDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String descricao,  bool ativo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CentroCustoDetails() when $default != null:
return $default(_that.id,_that.descricao,_that.ativo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String descricao,  bool ativo)  $default,) {final _that = this;
switch (_that) {
case _CentroCustoDetails():
return $default(_that.id,_that.descricao,_that.ativo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String descricao,  bool ativo)?  $default,) {final _that = this;
switch (_that) {
case _CentroCustoDetails() when $default != null:
return $default(_that.id,_that.descricao,_that.ativo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CentroCustoDetails implements CentroCustoDetails {
  const _CentroCustoDetails({required this.id, required this.descricao, required this.ativo});
  factory _CentroCustoDetails.fromJson(Map<String, dynamic> json) => _$CentroCustoDetailsFromJson(json);

@override final  String id;
@override final  String descricao;
@override final  bool ativo;

/// Create a copy of CentroCustoDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CentroCustoDetailsCopyWith<_CentroCustoDetails> get copyWith => __$CentroCustoDetailsCopyWithImpl<_CentroCustoDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CentroCustoDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CentroCustoDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.ativo, ativo) || other.ativo == ativo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,descricao,ativo);

@override
String toString() {
  return 'CentroCustoDetails(id: $id, descricao: $descricao, ativo: $ativo)';
}


}

/// @nodoc
abstract mixin class _$CentroCustoDetailsCopyWith<$Res> implements $CentroCustoDetailsCopyWith<$Res> {
  factory _$CentroCustoDetailsCopyWith(_CentroCustoDetails value, $Res Function(_CentroCustoDetails) _then) = __$CentroCustoDetailsCopyWithImpl;
@override @useResult
$Res call({
 String id, String descricao, bool ativo
});




}
/// @nodoc
class __$CentroCustoDetailsCopyWithImpl<$Res>
    implements _$CentroCustoDetailsCopyWith<$Res> {
  __$CentroCustoDetailsCopyWithImpl(this._self, this._then);

  final _CentroCustoDetails _self;
  final $Res Function(_CentroCustoDetails) _then;

/// Create a copy of CentroCustoDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? descricao = null,Object? ativo = null,}) {
  return _then(_CentroCustoDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
