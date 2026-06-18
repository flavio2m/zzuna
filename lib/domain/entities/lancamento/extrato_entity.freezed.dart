// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extrato_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Extrato {

 String get id; String get contaId; int get ano; Mes get mes; DateTime get dataInicio; DateTime get dataFim; bool get fechado;
/// Create a copy of Extrato
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtratoCopyWith<Extrato> get copyWith => _$ExtratoCopyWithImpl<Extrato>(this as Extrato, _$identity);

  /// Serializes this Extrato to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Extrato&&(identical(other.id, id) || other.id == id)&&(identical(other.contaId, contaId) || other.contaId == contaId)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.fechado, fechado) || other.fechado == fechado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,contaId,ano,mes,dataInicio,dataFim,fechado);

@override
String toString() {
  return 'Extrato(id: $id, contaId: $contaId, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, fechado: $fechado)';
}


}

/// @nodoc
abstract mixin class $ExtratoCopyWith<$Res>  {
  factory $ExtratoCopyWith(Extrato value, $Res Function(Extrato) _then) = _$ExtratoCopyWithImpl;
@useResult
$Res call({
 String id, String contaId, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, bool fechado
});




}
/// @nodoc
class _$ExtratoCopyWithImpl<$Res>
    implements $ExtratoCopyWith<$Res> {
  _$ExtratoCopyWithImpl(this._self, this._then);

  final Extrato _self;
  final $Res Function(Extrato) _then;

/// Create a copy of Extrato
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contaId = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? fechado = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contaId: null == contaId ? _self.contaId : contaId // ignore: cast_nullable_to_non_nullable
as String,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,fechado: null == fechado ? _self.fechado : fechado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Extrato].
extension ExtratoPatterns on Extrato {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Extrato value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Extrato() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Extrato value)  $default,){
final _that = this;
switch (_that) {
case _Extrato():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Extrato value)?  $default,){
final _that = this;
switch (_that) {
case _Extrato() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String contaId,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Extrato() when $default != null:
return $default(_that.id,_that.contaId,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String contaId,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechado)  $default,) {final _that = this;
switch (_that) {
case _Extrato():
return $default(_that.id,_that.contaId,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechado);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String contaId,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechado)?  $default,) {final _that = this;
switch (_that) {
case _Extrato() when $default != null:
return $default(_that.id,_that.contaId,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechado);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Extrato implements Extrato {
  const _Extrato({required this.id, required this.contaId, required this.ano, required this.mes, required this.dataInicio, required this.dataFim, required this.fechado});
  factory _Extrato.fromJson(Map<String, dynamic> json) => _$ExtratoFromJson(json);

@override final  String id;
@override final  String contaId;
@override final  int ano;
@override final  Mes mes;
@override final  DateTime dataInicio;
@override final  DateTime dataFim;
@override final  bool fechado;

/// Create a copy of Extrato
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtratoCopyWith<_Extrato> get copyWith => __$ExtratoCopyWithImpl<_Extrato>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtratoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Extrato&&(identical(other.id, id) || other.id == id)&&(identical(other.contaId, contaId) || other.contaId == contaId)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.fechado, fechado) || other.fechado == fechado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,contaId,ano,mes,dataInicio,dataFim,fechado);

@override
String toString() {
  return 'Extrato(id: $id, contaId: $contaId, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, fechado: $fechado)';
}


}

/// @nodoc
abstract mixin class _$ExtratoCopyWith<$Res> implements $ExtratoCopyWith<$Res> {
  factory _$ExtratoCopyWith(_Extrato value, $Res Function(_Extrato) _then) = __$ExtratoCopyWithImpl;
@override @useResult
$Res call({
 String id, String contaId, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, bool fechado
});




}
/// @nodoc
class __$ExtratoCopyWithImpl<$Res>
    implements _$ExtratoCopyWith<$Res> {
  __$ExtratoCopyWithImpl(this._self, this._then);

  final _Extrato _self;
  final $Res Function(_Extrato) _then;

/// Create a copy of Extrato
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contaId = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? fechado = null,}) {
  return _then(_Extrato(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contaId: null == contaId ? _self.contaId : contaId // ignore: cast_nullable_to_non_nullable
as String,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,fechado: null == fechado ? _self.fechado : fechado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ExtratoDetails {

 String get id; ContaDetails get conta; int get ano; Mes get mes; DateTime get dataInicio; DateTime get dataFim; bool get fechado;
/// Create a copy of ExtratoDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtratoDetailsCopyWith<ExtratoDetails> get copyWith => _$ExtratoDetailsCopyWithImpl<ExtratoDetails>(this as ExtratoDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtratoDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.conta, conta) || other.conta == conta)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.fechado, fechado) || other.fechado == fechado));
}


@override
int get hashCode => Object.hash(runtimeType,id,conta,ano,mes,dataInicio,dataFim,fechado);

@override
String toString() {
  return 'ExtratoDetails(id: $id, conta: $conta, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, fechado: $fechado)';
}


}

/// @nodoc
abstract mixin class $ExtratoDetailsCopyWith<$Res>  {
  factory $ExtratoDetailsCopyWith(ExtratoDetails value, $Res Function(ExtratoDetails) _then) = _$ExtratoDetailsCopyWithImpl;
@useResult
$Res call({
 String id, ContaDetails conta, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, bool fechado
});


$ContaDetailsCopyWith<$Res> get conta;

}
/// @nodoc
class _$ExtratoDetailsCopyWithImpl<$Res>
    implements $ExtratoDetailsCopyWith<$Res> {
  _$ExtratoDetailsCopyWithImpl(this._self, this._then);

  final ExtratoDetails _self;
  final $Res Function(ExtratoDetails) _then;

/// Create a copy of ExtratoDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conta = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? fechado = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conta: null == conta ? _self.conta : conta // ignore: cast_nullable_to_non_nullable
as ContaDetails,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,fechado: null == fechado ? _self.fechado : fechado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ExtratoDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContaDetailsCopyWith<$Res> get conta {
  
  return $ContaDetailsCopyWith<$Res>(_self.conta, (value) {
    return _then(_self.copyWith(conta: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExtratoDetails].
extension ExtratoDetailsPatterns on ExtratoDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtratoDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtratoDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtratoDetails value)  $default,){
final _that = this;
switch (_that) {
case _ExtratoDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtratoDetails value)?  $default,){
final _that = this;
switch (_that) {
case _ExtratoDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ContaDetails conta,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtratoDetails() when $default != null:
return $default(_that.id,_that.conta,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ContaDetails conta,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechado)  $default,) {final _that = this;
switch (_that) {
case _ExtratoDetails():
return $default(_that.id,_that.conta,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechado);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ContaDetails conta,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  bool fechado)?  $default,) {final _that = this;
switch (_that) {
case _ExtratoDetails() when $default != null:
return $default(_that.id,_that.conta,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.fechado);case _:
  return null;

}
}

}

/// @nodoc


class _ExtratoDetails implements ExtratoDetails {
  const _ExtratoDetails({required this.id, required this.conta, required this.ano, required this.mes, required this.dataInicio, required this.dataFim, required this.fechado});
  

@override final  String id;
@override final  ContaDetails conta;
@override final  int ano;
@override final  Mes mes;
@override final  DateTime dataInicio;
@override final  DateTime dataFim;
@override final  bool fechado;

/// Create a copy of ExtratoDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtratoDetailsCopyWith<_ExtratoDetails> get copyWith => __$ExtratoDetailsCopyWithImpl<_ExtratoDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtratoDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.conta, conta) || other.conta == conta)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.fechado, fechado) || other.fechado == fechado));
}


@override
int get hashCode => Object.hash(runtimeType,id,conta,ano,mes,dataInicio,dataFim,fechado);

@override
String toString() {
  return 'ExtratoDetails(id: $id, conta: $conta, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, fechado: $fechado)';
}


}

/// @nodoc
abstract mixin class _$ExtratoDetailsCopyWith<$Res> implements $ExtratoDetailsCopyWith<$Res> {
  factory _$ExtratoDetailsCopyWith(_ExtratoDetails value, $Res Function(_ExtratoDetails) _then) = __$ExtratoDetailsCopyWithImpl;
@override @useResult
$Res call({
 String id, ContaDetails conta, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, bool fechado
});


@override $ContaDetailsCopyWith<$Res> get conta;

}
/// @nodoc
class __$ExtratoDetailsCopyWithImpl<$Res>
    implements _$ExtratoDetailsCopyWith<$Res> {
  __$ExtratoDetailsCopyWithImpl(this._self, this._then);

  final _ExtratoDetails _self;
  final $Res Function(_ExtratoDetails) _then;

/// Create a copy of ExtratoDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conta = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? fechado = null,}) {
  return _then(_ExtratoDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conta: null == conta ? _self.conta : conta // ignore: cast_nullable_to_non_nullable
as ContaDetails,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,fechado: null == fechado ? _self.fechado : fechado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ExtratoDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContaDetailsCopyWith<$Res> get conta {
  
  return $ContaDetailsCopyWith<$Res>(_self.conta, (value) {
    return _then(_self.copyWith(conta: value));
  });
}
}

// dart format on
