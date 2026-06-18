// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fatura_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Fatura {

 String get id; String get cartaoId; int get ano; Mes get mes; DateTime get dataInicio; DateTime get dataFim; bool get fechada;
/// Create a copy of Fatura
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaturaCopyWith<Fatura> get copyWith => _$FaturaCopyWithImpl<Fatura>(this as Fatura, _$identity);

  /// Serializes this Fatura to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fatura&&(identical(other.id, id) || other.id == id)&&(identical(other.cartaoId, cartaoId) || other.cartaoId == cartaoId)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.fechada, fechada) || other.fechada == fechada));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cartaoId,ano,mes,dataInicio,dataFim,fechada);

@override
String toString() {
  return 'Fatura(id: $id, cartaoId: $cartaoId, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, fechada: $fechada)';
}


}

/// @nodoc
abstract mixin class $FaturaCopyWith<$Res>  {
  factory $FaturaCopyWith(Fatura value, $Res Function(Fatura) _then) = _$FaturaCopyWithImpl;
@useResult
$Res call({
 String id, String cartaoId, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, bool fechada
});




}
/// @nodoc
class _$FaturaCopyWithImpl<$Res>
    implements $FaturaCopyWith<$Res> {
  _$FaturaCopyWithImpl(this._self, this._then);

  final Fatura _self;
  final $Res Function(Fatura) _then;

/// Create a copy of Fatura
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cartaoId = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? fechada = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cartaoId: null == cartaoId ? _self.cartaoId : cartaoId // ignore: cast_nullable_to_non_nullable
as String,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,fechada: null == fechada ? _self.fechada : fechada // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Fatura].
extension FaturaPatterns on Fatura {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Fatura value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Fatura() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Fatura value)  $default,){
final _that = this;
switch (_that) {
case _Fatura():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Fatura value)?  $default,){
final _that = this;
switch (_that) {
case _Fatura() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String cartaoId,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechada)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Fatura() when $default != null:
return $default(_that.id,_that.cartaoId,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechada);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String cartaoId,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechada)  $default,) {final _that = this;
switch (_that) {
case _Fatura():
return $default(_that.id,_that.cartaoId,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechada);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String cartaoId,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechada)?  $default,) {final _that = this;
switch (_that) {
case _Fatura() when $default != null:
return $default(_that.id,_that.cartaoId,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechada);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Fatura implements Fatura {
  const _Fatura({required this.id, required this.cartaoId, required this.ano, required this.mes, required this.dataInicio, required this.dataFim, required this.fechada});
  factory _Fatura.fromJson(Map<String, dynamic> json) => _$FaturaFromJson(json);

@override final  String id;
@override final  String cartaoId;
@override final  int ano;
@override final  Mes mes;
@override final  DateTime dataInicio;
@override final  DateTime dataFim;
@override final  bool fechada;

/// Create a copy of Fatura
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaturaCopyWith<_Fatura> get copyWith => __$FaturaCopyWithImpl<_Fatura>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FaturaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fatura&&(identical(other.id, id) || other.id == id)&&(identical(other.cartaoId, cartaoId) || other.cartaoId == cartaoId)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.fechada, fechada) || other.fechada == fechada));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cartaoId,ano,mes,dataInicio,dataFim,fechada);

@override
String toString() {
  return 'Fatura(id: $id, cartaoId: $cartaoId, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, fechada: $fechada)';
}


}

/// @nodoc
abstract mixin class _$FaturaCopyWith<$Res> implements $FaturaCopyWith<$Res> {
  factory _$FaturaCopyWith(_Fatura value, $Res Function(_Fatura) _then) = __$FaturaCopyWithImpl;
@override @useResult
$Res call({
 String id, String cartaoId, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, bool fechada
});




}
/// @nodoc
class __$FaturaCopyWithImpl<$Res>
    implements _$FaturaCopyWith<$Res> {
  __$FaturaCopyWithImpl(this._self, this._then);

  final _Fatura _self;
  final $Res Function(_Fatura) _then;

/// Create a copy of Fatura
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cartaoId = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? fechada = null,}) {
  return _then(_Fatura(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cartaoId: null == cartaoId ? _self.cartaoId : cartaoId // ignore: cast_nullable_to_non_nullable
as String,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,fechada: null == fechada ? _self.fechada : fechada // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$FaturaDetails {

 String get id; CartaoDetails get cartao; int get ano; Mes get mes; DateTime get dataInicio; DateTime get dataFim; bool get fechada;
/// Create a copy of FaturaDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaturaDetailsCopyWith<FaturaDetails> get copyWith => _$FaturaDetailsCopyWithImpl<FaturaDetails>(this as FaturaDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaturaDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.cartao, cartao) || other.cartao == cartao)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.fechada, fechada) || other.fechada == fechada));
}


@override
int get hashCode => Object.hash(runtimeType,id,cartao,ano,mes,dataInicio,dataFim,fechada);

@override
String toString() {
  return 'FaturaDetails(id: $id, cartao: $cartao, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, fechada: $fechada)';
}


}

/// @nodoc
abstract mixin class $FaturaDetailsCopyWith<$Res>  {
  factory $FaturaDetailsCopyWith(FaturaDetails value, $Res Function(FaturaDetails) _then) = _$FaturaDetailsCopyWithImpl;
@useResult
$Res call({
 String id, CartaoDetails cartao, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, bool fechada
});


$CartaoDetailsCopyWith<$Res> get cartao;

}
/// @nodoc
class _$FaturaDetailsCopyWithImpl<$Res>
    implements $FaturaDetailsCopyWith<$Res> {
  _$FaturaDetailsCopyWithImpl(this._self, this._then);

  final FaturaDetails _self;
  final $Res Function(FaturaDetails) _then;

/// Create a copy of FaturaDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cartao = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? fechada = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cartao: null == cartao ? _self.cartao : cartao // ignore: cast_nullable_to_non_nullable
as CartaoDetails,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,fechada: null == fechada ? _self.fechada : fechada // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FaturaDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CartaoDetailsCopyWith<$Res> get cartao {
  
  return $CartaoDetailsCopyWith<$Res>(_self.cartao, (value) {
    return _then(_self.copyWith(cartao: value));
  });
}
}


/// Adds pattern-matching-related methods to [FaturaDetails].
extension FaturaDetailsPatterns on FaturaDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaturaDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaturaDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaturaDetails value)  $default,){
final _that = this;
switch (_that) {
case _FaturaDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaturaDetails value)?  $default,){
final _that = this;
switch (_that) {
case _FaturaDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  CartaoDetails cartao,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechada)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaturaDetails() when $default != null:
return $default(_that.id,_that.cartao,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechada);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  CartaoDetails cartao,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechada)  $default,) {final _that = this;
switch (_that) {
case _FaturaDetails():
return $default(_that.id,_that.cartao,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechada);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  CartaoDetails cartao,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechada)?  $default,) {final _that = this;
switch (_that) {
case _FaturaDetails() when $default != null:
return $default(_that.id,_that.cartao,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechada);case _:
  return null;

}
}

}

/// @nodoc


class _FaturaDetails implements FaturaDetails {
  const _FaturaDetails({required this.id, required this.cartao, required this.ano, required this.mes, required this.dataInicio, required this.dataFim, required this.fechada});
  

@override final  String id;
@override final  CartaoDetails cartao;
@override final  int ano;
@override final  Mes mes;
@override final  DateTime dataInicio;
@override final  DateTime dataFim;
@override final  bool fechada;

/// Create a copy of FaturaDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaturaDetailsCopyWith<_FaturaDetails> get copyWith => __$FaturaDetailsCopyWithImpl<_FaturaDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaturaDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.cartao, cartao) || other.cartao == cartao)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.fechada, fechada) || other.fechada == fechada));
}


@override
int get hashCode => Object.hash(runtimeType,id,cartao,ano,mes,dataInicio,dataFim,fechada);

@override
String toString() {
  return 'FaturaDetails(id: $id, cartao: $cartao, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, fechada: $fechada)';
}


}

/// @nodoc
abstract mixin class _$FaturaDetailsCopyWith<$Res> implements $FaturaDetailsCopyWith<$Res> {
  factory _$FaturaDetailsCopyWith(_FaturaDetails value, $Res Function(_FaturaDetails) _then) = __$FaturaDetailsCopyWithImpl;
@override @useResult
$Res call({
 String id, CartaoDetails cartao, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, bool fechada
});


@override $CartaoDetailsCopyWith<$Res> get cartao;

}
/// @nodoc
class __$FaturaDetailsCopyWithImpl<$Res>
    implements _$FaturaDetailsCopyWith<$Res> {
  __$FaturaDetailsCopyWithImpl(this._self, this._then);

  final _FaturaDetails _self;
  final $Res Function(_FaturaDetails) _then;

/// Create a copy of FaturaDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cartao = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? fechada = null,}) {
  return _then(_FaturaDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cartao: null == cartao ? _self.cartao : cartao // ignore: cast_nullable_to_non_nullable
as CartaoDetails,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,fechada: null == fechada ? _self.fechada : fechada // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FaturaDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CartaoDetailsCopyWith<$Res> get cartao {
  
  return $CartaoDetailsCopyWith<$Res>(_self.cartao, (value) {
    return _then(_self.copyWith(cartao: value));
  });
}
}

// dart format on
