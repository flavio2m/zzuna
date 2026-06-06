// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conta_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Conta {

 String get id; String get descricao; String get bancoSigla; bool get ativo;
/// Create a copy of Conta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContaCopyWith<Conta> get copyWith => _$ContaCopyWithImpl<Conta>(this as Conta, _$identity);

  /// Serializes this Conta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conta&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.bancoSigla, bancoSigla) || other.bancoSigla == bancoSigla)&&(identical(other.ativo, ativo) || other.ativo == ativo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,descricao,bancoSigla,ativo);

@override
String toString() {
  return 'Conta(id: $id, descricao: $descricao, bancoSigla: $bancoSigla, ativo: $ativo)';
}


}

/// @nodoc
abstract mixin class $ContaCopyWith<$Res>  {
  factory $ContaCopyWith(Conta value, $Res Function(Conta) _then) = _$ContaCopyWithImpl;
@useResult
$Res call({
 String id, String descricao, String bancoSigla, bool ativo
});




}
/// @nodoc
class _$ContaCopyWithImpl<$Res>
    implements $ContaCopyWith<$Res> {
  _$ContaCopyWithImpl(this._self, this._then);

  final Conta _self;
  final $Res Function(Conta) _then;

/// Create a copy of Conta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? descricao = null,Object? bancoSigla = null,Object? ativo = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,bancoSigla: null == bancoSigla ? _self.bancoSigla : bancoSigla // ignore: cast_nullable_to_non_nullable
as String,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Conta].
extension ContaPatterns on Conta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conta value)  $default,){
final _that = this;
switch (_that) {
case _Conta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conta value)?  $default,){
final _that = this;
switch (_that) {
case _Conta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String descricao,  String bancoSigla,  bool ativo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conta() when $default != null:
return $default(_that.id,_that.descricao,_that.bancoSigla,_that.ativo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String descricao,  String bancoSigla,  bool ativo)  $default,) {final _that = this;
switch (_that) {
case _Conta():
return $default(_that.id,_that.descricao,_that.bancoSigla,_that.ativo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String descricao,  String bancoSigla,  bool ativo)?  $default,) {final _that = this;
switch (_that) {
case _Conta() when $default != null:
return $default(_that.id,_that.descricao,_that.bancoSigla,_that.ativo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Conta implements Conta {
  const _Conta({required this.id, required this.descricao, required this.bancoSigla, required this.ativo});
  factory _Conta.fromJson(Map<String, dynamic> json) => _$ContaFromJson(json);

@override final  String id;
@override final  String descricao;
@override final  String bancoSigla;
@override final  bool ativo;

/// Create a copy of Conta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContaCopyWith<_Conta> get copyWith => __$ContaCopyWithImpl<_Conta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conta&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.bancoSigla, bancoSigla) || other.bancoSigla == bancoSigla)&&(identical(other.ativo, ativo) || other.ativo == ativo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,descricao,bancoSigla,ativo);

@override
String toString() {
  return 'Conta(id: $id, descricao: $descricao, bancoSigla: $bancoSigla, ativo: $ativo)';
}


}

/// @nodoc
abstract mixin class _$ContaCopyWith<$Res> implements $ContaCopyWith<$Res> {
  factory _$ContaCopyWith(_Conta value, $Res Function(_Conta) _then) = __$ContaCopyWithImpl;
@override @useResult
$Res call({
 String id, String descricao, String bancoSigla, bool ativo
});




}
/// @nodoc
class __$ContaCopyWithImpl<$Res>
    implements _$ContaCopyWith<$Res> {
  __$ContaCopyWithImpl(this._self, this._then);

  final _Conta _self;
  final $Res Function(_Conta) _then;

/// Create a copy of Conta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? descricao = null,Object? bancoSigla = null,Object? ativo = null,}) {
  return _then(_Conta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,bancoSigla: null == bancoSigla ? _self.bancoSigla : bancoSigla // ignore: cast_nullable_to_non_nullable
as String,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ContaDetails {

 String get id; String get descricao; Banco get banco; bool get ativo;
/// Create a copy of ContaDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContaDetailsCopyWith<ContaDetails> get copyWith => _$ContaDetailsCopyWithImpl<ContaDetails>(this as ContaDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContaDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.banco, banco) || other.banco == banco)&&(identical(other.ativo, ativo) || other.ativo == ativo));
}


@override
int get hashCode => Object.hash(runtimeType,id,descricao,banco,ativo);

@override
String toString() {
  return 'ContaDetails(id: $id, descricao: $descricao, banco: $banco, ativo: $ativo)';
}


}

/// @nodoc
abstract mixin class $ContaDetailsCopyWith<$Res>  {
  factory $ContaDetailsCopyWith(ContaDetails value, $Res Function(ContaDetails) _then) = _$ContaDetailsCopyWithImpl;
@useResult
$Res call({
 String id, String descricao, Banco banco, bool ativo
});




}
/// @nodoc
class _$ContaDetailsCopyWithImpl<$Res>
    implements $ContaDetailsCopyWith<$Res> {
  _$ContaDetailsCopyWithImpl(this._self, this._then);

  final ContaDetails _self;
  final $Res Function(ContaDetails) _then;

/// Create a copy of ContaDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? descricao = null,Object? banco = null,Object? ativo = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,banco: null == banco ? _self.banco : banco // ignore: cast_nullable_to_non_nullable
as Banco,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContaDetails].
extension ContaDetailsPatterns on ContaDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContaDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContaDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContaDetails value)  $default,){
final _that = this;
switch (_that) {
case _ContaDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContaDetails value)?  $default,){
final _that = this;
switch (_that) {
case _ContaDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String descricao,  Banco banco,  bool ativo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContaDetails() when $default != null:
return $default(_that.id,_that.descricao,_that.banco,_that.ativo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String descricao,  Banco banco,  bool ativo)  $default,) {final _that = this;
switch (_that) {
case _ContaDetails():
return $default(_that.id,_that.descricao,_that.banco,_that.ativo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String descricao,  Banco banco,  bool ativo)?  $default,) {final _that = this;
switch (_that) {
case _ContaDetails() when $default != null:
return $default(_that.id,_that.descricao,_that.banco,_that.ativo);case _:
  return null;

}
}

}

/// @nodoc


class _ContaDetails implements ContaDetails {
  const _ContaDetails({required this.id, required this.descricao, required this.banco, required this.ativo});
  

@override final  String id;
@override final  String descricao;
@override final  Banco banco;
@override final  bool ativo;

/// Create a copy of ContaDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContaDetailsCopyWith<_ContaDetails> get copyWith => __$ContaDetailsCopyWithImpl<_ContaDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContaDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.banco, banco) || other.banco == banco)&&(identical(other.ativo, ativo) || other.ativo == ativo));
}


@override
int get hashCode => Object.hash(runtimeType,id,descricao,banco,ativo);

@override
String toString() {
  return 'ContaDetails(id: $id, descricao: $descricao, banco: $banco, ativo: $ativo)';
}


}

/// @nodoc
abstract mixin class _$ContaDetailsCopyWith<$Res> implements $ContaDetailsCopyWith<$Res> {
  factory _$ContaDetailsCopyWith(_ContaDetails value, $Res Function(_ContaDetails) _then) = __$ContaDetailsCopyWithImpl;
@override @useResult
$Res call({
 String id, String descricao, Banco banco, bool ativo
});




}
/// @nodoc
class __$ContaDetailsCopyWithImpl<$Res>
    implements _$ContaDetailsCopyWith<$Res> {
  __$ContaDetailsCopyWithImpl(this._self, this._then);

  final _ContaDetails _self;
  final $Res Function(_ContaDetails) _then;

/// Create a copy of ContaDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? descricao = null,Object? banco = null,Object? ativo = null,}) {
  return _then(_ContaDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,banco: null == banco ? _self.banco : banco // ignore: cast_nullable_to_non_nullable
as Banco,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
