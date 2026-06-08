// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cartao_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Cartao {

 String get id; String get descricao; double get limite; String get bancoSigla; bool get ativo; int get diaFechamento;
/// Create a copy of Cartao
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartaoCopyWith<Cartao> get copyWith => _$CartaoCopyWithImpl<Cartao>(this as Cartao, _$identity);

  /// Serializes this Cartao to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cartao&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.limite, limite) || other.limite == limite)&&(identical(other.bancoSigla, bancoSigla) || other.bancoSigla == bancoSigla)&&(identical(other.ativo, ativo) || other.ativo == ativo)&&(identical(other.diaFechamento, diaFechamento) || other.diaFechamento == diaFechamento));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,descricao,limite,bancoSigla,ativo,diaFechamento);

@override
String toString() {
  return 'Cartao(id: $id, descricao: $descricao, limite: $limite, bancoSigla: $bancoSigla, ativo: $ativo, diaFechamento: $diaFechamento)';
}


}

/// @nodoc
abstract mixin class $CartaoCopyWith<$Res>  {
  factory $CartaoCopyWith(Cartao value, $Res Function(Cartao) _then) = _$CartaoCopyWithImpl;
@useResult
$Res call({
 String id, String descricao, double limite, String bancoSigla, bool ativo, int diaFechamento
});




}
/// @nodoc
class _$CartaoCopyWithImpl<$Res>
    implements $CartaoCopyWith<$Res> {
  _$CartaoCopyWithImpl(this._self, this._then);

  final Cartao _self;
  final $Res Function(Cartao) _then;

/// Create a copy of Cartao
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? descricao = null,Object? limite = null,Object? bancoSigla = null,Object? ativo = null,Object? diaFechamento = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,limite: null == limite ? _self.limite : limite // ignore: cast_nullable_to_non_nullable
as double,bancoSigla: null == bancoSigla ? _self.bancoSigla : bancoSigla // ignore: cast_nullable_to_non_nullable
as String,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,diaFechamento: null == diaFechamento ? _self.diaFechamento : diaFechamento // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Cartao].
extension CartaoPatterns on Cartao {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cartao value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cartao() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cartao value)  $default,){
final _that = this;
switch (_that) {
case _Cartao():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cartao value)?  $default,){
final _that = this;
switch (_that) {
case _Cartao() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String descricao,  double limite,  String bancoSigla,  bool ativo,  int diaFechamento)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cartao() when $default != null:
return $default(_that.id,_that.descricao,_that.limite,_that.bancoSigla,_that.ativo,_that.diaFechamento);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String descricao,  double limite,  String bancoSigla,  bool ativo,  int diaFechamento)  $default,) {final _that = this;
switch (_that) {
case _Cartao():
return $default(_that.id,_that.descricao,_that.limite,_that.bancoSigla,_that.ativo,_that.diaFechamento);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String descricao,  double limite,  String bancoSigla,  bool ativo,  int diaFechamento)?  $default,) {final _that = this;
switch (_that) {
case _Cartao() when $default != null:
return $default(_that.id,_that.descricao,_that.limite,_that.bancoSigla,_that.ativo,_that.diaFechamento);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cartao implements Cartao {
  const _Cartao({required this.id, required this.descricao, required this.limite, required this.bancoSigla, required this.ativo, required this.diaFechamento});
  factory _Cartao.fromJson(Map<String, dynamic> json) => _$CartaoFromJson(json);

@override final  String id;
@override final  String descricao;
@override final  double limite;
@override final  String bancoSigla;
@override final  bool ativo;
@override final  int diaFechamento;

/// Create a copy of Cartao
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartaoCopyWith<_Cartao> get copyWith => __$CartaoCopyWithImpl<_Cartao>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartaoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cartao&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.limite, limite) || other.limite == limite)&&(identical(other.bancoSigla, bancoSigla) || other.bancoSigla == bancoSigla)&&(identical(other.ativo, ativo) || other.ativo == ativo)&&(identical(other.diaFechamento, diaFechamento) || other.diaFechamento == diaFechamento));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,descricao,limite,bancoSigla,ativo,diaFechamento);

@override
String toString() {
  return 'Cartao(id: $id, descricao: $descricao, limite: $limite, bancoSigla: $bancoSigla, ativo: $ativo, diaFechamento: $diaFechamento)';
}


}

/// @nodoc
abstract mixin class _$CartaoCopyWith<$Res> implements $CartaoCopyWith<$Res> {
  factory _$CartaoCopyWith(_Cartao value, $Res Function(_Cartao) _then) = __$CartaoCopyWithImpl;
@override @useResult
$Res call({
 String id, String descricao, double limite, String bancoSigla, bool ativo, int diaFechamento
});




}
/// @nodoc
class __$CartaoCopyWithImpl<$Res>
    implements _$CartaoCopyWith<$Res> {
  __$CartaoCopyWithImpl(this._self, this._then);

  final _Cartao _self;
  final $Res Function(_Cartao) _then;

/// Create a copy of Cartao
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? descricao = null,Object? limite = null,Object? bancoSigla = null,Object? ativo = null,Object? diaFechamento = null,}) {
  return _then(_Cartao(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,limite: null == limite ? _self.limite : limite // ignore: cast_nullable_to_non_nullable
as double,bancoSigla: null == bancoSigla ? _self.bancoSigla : bancoSigla // ignore: cast_nullable_to_non_nullable
as String,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,diaFechamento: null == diaFechamento ? _self.diaFechamento : diaFechamento // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$CartaoDetails {

 String get id; String get descricao; double get limite; Banco get banco; bool get ativo; int get diaFechamento;
/// Create a copy of CartaoDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartaoDetailsCopyWith<CartaoDetails> get copyWith => _$CartaoDetailsCopyWithImpl<CartaoDetails>(this as CartaoDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartaoDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.limite, limite) || other.limite == limite)&&const DeepCollectionEquality().equals(other.banco, banco)&&(identical(other.ativo, ativo) || other.ativo == ativo)&&(identical(other.diaFechamento, diaFechamento) || other.diaFechamento == diaFechamento));
}


@override
int get hashCode => Object.hash(runtimeType,id,descricao,limite,const DeepCollectionEquality().hash(banco),ativo,diaFechamento);

@override
String toString() {
  return 'CartaoDetails(id: $id, descricao: $descricao, limite: $limite, banco: $banco, ativo: $ativo, diaFechamento: $diaFechamento)';
}


}

/// @nodoc
abstract mixin class $CartaoDetailsCopyWith<$Res>  {
  factory $CartaoDetailsCopyWith(CartaoDetails value, $Res Function(CartaoDetails) _then) = _$CartaoDetailsCopyWithImpl;
@useResult
$Res call({
 String id, String descricao, double limite, Banco banco, bool ativo, int diaFechamento
});




}
/// @nodoc
class _$CartaoDetailsCopyWithImpl<$Res>
    implements $CartaoDetailsCopyWith<$Res> {
  _$CartaoDetailsCopyWithImpl(this._self, this._then);

  final CartaoDetails _self;
  final $Res Function(CartaoDetails) _then;

/// Create a copy of CartaoDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? descricao = null,Object? limite = null,Object? banco = freezed,Object? ativo = null,Object? diaFechamento = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,limite: null == limite ? _self.limite : limite // ignore: cast_nullable_to_non_nullable
as double,banco: freezed == banco ? _self.banco : banco // ignore: cast_nullable_to_non_nullable
as Banco,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,diaFechamento: null == diaFechamento ? _self.diaFechamento : diaFechamento // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CartaoDetails].
extension CartaoDetailsPatterns on CartaoDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartaoDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartaoDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartaoDetails value)  $default,){
final _that = this;
switch (_that) {
case _CartaoDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartaoDetails value)?  $default,){
final _that = this;
switch (_that) {
case _CartaoDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String descricao,  double limite,  Banco banco,  bool ativo,  int diaFechamento)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartaoDetails() when $default != null:
return $default(_that.id,_that.descricao,_that.limite,_that.banco,_that.ativo,_that.diaFechamento);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String descricao,  double limite,  Banco banco,  bool ativo,  int diaFechamento)  $default,) {final _that = this;
switch (_that) {
case _CartaoDetails():
return $default(_that.id,_that.descricao,_that.limite,_that.banco,_that.ativo,_that.diaFechamento);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String descricao,  double limite,  Banco banco,  bool ativo,  int diaFechamento)?  $default,) {final _that = this;
switch (_that) {
case _CartaoDetails() when $default != null:
return $default(_that.id,_that.descricao,_that.limite,_that.banco,_that.ativo,_that.diaFechamento);case _:
  return null;

}
}

}

/// @nodoc


class _CartaoDetails implements CartaoDetails {
  const _CartaoDetails({required this.id, required this.descricao, required this.limite, required this.banco, required this.ativo, required this.diaFechamento});
  

@override final  String id;
@override final  String descricao;
@override final  double limite;
@override final  Banco banco;
@override final  bool ativo;
@override final  int diaFechamento;

/// Create a copy of CartaoDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartaoDetailsCopyWith<_CartaoDetails> get copyWith => __$CartaoDetailsCopyWithImpl<_CartaoDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartaoDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.limite, limite) || other.limite == limite)&&const DeepCollectionEquality().equals(other.banco, banco)&&(identical(other.ativo, ativo) || other.ativo == ativo)&&(identical(other.diaFechamento, diaFechamento) || other.diaFechamento == diaFechamento));
}


@override
int get hashCode => Object.hash(runtimeType,id,descricao,limite,const DeepCollectionEquality().hash(banco),ativo,diaFechamento);

@override
String toString() {
  return 'CartaoDetails(id: $id, descricao: $descricao, limite: $limite, banco: $banco, ativo: $ativo, diaFechamento: $diaFechamento)';
}


}

/// @nodoc
abstract mixin class _$CartaoDetailsCopyWith<$Res> implements $CartaoDetailsCopyWith<$Res> {
  factory _$CartaoDetailsCopyWith(_CartaoDetails value, $Res Function(_CartaoDetails) _then) = __$CartaoDetailsCopyWithImpl;
@override @useResult
$Res call({
 String id, String descricao, double limite, Banco banco, bool ativo, int diaFechamento
});




}
/// @nodoc
class __$CartaoDetailsCopyWithImpl<$Res>
    implements _$CartaoDetailsCopyWith<$Res> {
  __$CartaoDetailsCopyWithImpl(this._self, this._then);

  final _CartaoDetails _self;
  final $Res Function(_CartaoDetails) _then;

/// Create a copy of CartaoDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? descricao = null,Object? limite = null,Object? banco = freezed,Object? ativo = null,Object? diaFechamento = null,}) {
  return _then(_CartaoDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,limite: null == limite ? _self.limite : limite // ignore: cast_nullable_to_non_nullable
as double,banco: freezed == banco ? _self.banco : banco // ignore: cast_nullable_to_non_nullable
as Banco,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,diaFechamento: null == diaFechamento ? _self.diaFechamento : diaFechamento // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
