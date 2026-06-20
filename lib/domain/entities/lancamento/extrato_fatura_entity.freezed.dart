// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extrato_fatura_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtratoFatura {

 String get id; LancamentoOrigem get origem; int get ano; Mes get mes; DateTime get dataInicio; DateTime get dataFim; double get saldoInicial; double get saldoFinal; bool get fechado;
/// Create a copy of ExtratoFatura
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtratoFaturaCopyWith<ExtratoFatura> get copyWith => _$ExtratoFaturaCopyWithImpl<ExtratoFatura>(this as ExtratoFatura, _$identity);

  /// Serializes this ExtratoFatura to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtratoFatura&&(identical(other.id, id) || other.id == id)&&(identical(other.origem, origem) || other.origem == origem)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.saldoInicial, saldoInicial) || other.saldoInicial == saldoInicial)&&(identical(other.saldoFinal, saldoFinal) || other.saldoFinal == saldoFinal)&&(identical(other.fechado, fechado) || other.fechado == fechado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,origem,ano,mes,dataInicio,dataFim,saldoInicial,saldoFinal,fechado);

@override
String toString() {
  return 'ExtratoFatura(id: $id, origem: $origem, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, saldoInicial: $saldoInicial, saldoFinal: $saldoFinal, fechado: $fechado)';
}


}

/// @nodoc
abstract mixin class $ExtratoFaturaCopyWith<$Res>  {
  factory $ExtratoFaturaCopyWith(ExtratoFatura value, $Res Function(ExtratoFatura) _then) = _$ExtratoFaturaCopyWithImpl;
@useResult
$Res call({
 String id, LancamentoOrigem origem, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, double saldoInicial, double saldoFinal, bool fechado
});


$LancamentoOrigemCopyWith<$Res> get origem;

}
/// @nodoc
class _$ExtratoFaturaCopyWithImpl<$Res>
    implements $ExtratoFaturaCopyWith<$Res> {
  _$ExtratoFaturaCopyWithImpl(this._self, this._then);

  final ExtratoFatura _self;
  final $Res Function(ExtratoFatura) _then;

/// Create a copy of ExtratoFatura
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? origem = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? saldoInicial = null,Object? saldoFinal = null,Object? fechado = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,origem: null == origem ? _self.origem : origem // ignore: cast_nullable_to_non_nullable
as LancamentoOrigem,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,saldoInicial: null == saldoInicial ? _self.saldoInicial : saldoInicial // ignore: cast_nullable_to_non_nullable
as double,saldoFinal: null == saldoFinal ? _self.saldoFinal : saldoFinal // ignore: cast_nullable_to_non_nullable
as double,fechado: null == fechado ? _self.fechado : fechado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ExtratoFatura
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoOrigemCopyWith<$Res> get origem {
  
  return $LancamentoOrigemCopyWith<$Res>(_self.origem, (value) {
    return _then(_self.copyWith(origem: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExtratoFatura].
extension ExtratoFaturaPatterns on ExtratoFatura {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtratoFatura value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtratoFatura() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtratoFatura value)  $default,){
final _that = this;
switch (_that) {
case _ExtratoFatura():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtratoFatura value)?  $default,){
final _that = this;
switch (_that) {
case _ExtratoFatura() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LancamentoOrigem origem,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  double saldoInicial,  double saldoFinal,  bool fechado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtratoFatura() when $default != null:
return $default(_that.id,_that.origem,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.saldoInicial,_that.saldoFinal,_that.fechado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LancamentoOrigem origem,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  double saldoInicial,  double saldoFinal,  bool fechado)  $default,) {final _that = this;
switch (_that) {
case _ExtratoFatura():
return $default(_that.id,_that.origem,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.saldoInicial,_that.saldoFinal,_that.fechado);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LancamentoOrigem origem,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  double saldoInicial,  double saldoFinal,  bool fechado)?  $default,) {final _that = this;
switch (_that) {
case _ExtratoFatura() when $default != null:
return $default(_that.id,_that.origem,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.saldoInicial,_that.saldoFinal,_that.fechado);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExtratoFatura implements ExtratoFatura {
  const _ExtratoFatura({required this.id, required this.origem, required this.ano, required this.mes, required this.dataInicio, required this.dataFim, required this.saldoInicial, required this.saldoFinal, required this.fechado});
  factory _ExtratoFatura.fromJson(Map<String, dynamic> json) => _$ExtratoFaturaFromJson(json);

@override final  String id;
@override final  LancamentoOrigem origem;
@override final  int ano;
@override final  Mes mes;
@override final  DateTime dataInicio;
@override final  DateTime dataFim;
@override final  double saldoInicial;
@override final  double saldoFinal;
@override final  bool fechado;

/// Create a copy of ExtratoFatura
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtratoFaturaCopyWith<_ExtratoFatura> get copyWith => __$ExtratoFaturaCopyWithImpl<_ExtratoFatura>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtratoFaturaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtratoFatura&&(identical(other.id, id) || other.id == id)&&(identical(other.origem, origem) || other.origem == origem)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.saldoInicial, saldoInicial) || other.saldoInicial == saldoInicial)&&(identical(other.saldoFinal, saldoFinal) || other.saldoFinal == saldoFinal)&&(identical(other.fechado, fechado) || other.fechado == fechado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,origem,ano,mes,dataInicio,dataFim,saldoInicial,saldoFinal,fechado);

@override
String toString() {
  return 'ExtratoFatura(id: $id, origem: $origem, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, saldoInicial: $saldoInicial, saldoFinal: $saldoFinal, fechado: $fechado)';
}


}

/// @nodoc
abstract mixin class _$ExtratoFaturaCopyWith<$Res> implements $ExtratoFaturaCopyWith<$Res> {
  factory _$ExtratoFaturaCopyWith(_ExtratoFatura value, $Res Function(_ExtratoFatura) _then) = __$ExtratoFaturaCopyWithImpl;
@override @useResult
$Res call({
 String id, LancamentoOrigem origem, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, double saldoInicial, double saldoFinal, bool fechado
});


@override $LancamentoOrigemCopyWith<$Res> get origem;

}
/// @nodoc
class __$ExtratoFaturaCopyWithImpl<$Res>
    implements _$ExtratoFaturaCopyWith<$Res> {
  __$ExtratoFaturaCopyWithImpl(this._self, this._then);

  final _ExtratoFatura _self;
  final $Res Function(_ExtratoFatura) _then;

/// Create a copy of ExtratoFatura
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? origem = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? saldoInicial = null,Object? saldoFinal = null,Object? fechado = null,}) {
  return _then(_ExtratoFatura(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,origem: null == origem ? _self.origem : origem // ignore: cast_nullable_to_non_nullable
as LancamentoOrigem,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,saldoInicial: null == saldoInicial ? _self.saldoInicial : saldoInicial // ignore: cast_nullable_to_non_nullable
as double,saldoFinal: null == saldoFinal ? _self.saldoFinal : saldoFinal // ignore: cast_nullable_to_non_nullable
as double,fechado: null == fechado ? _self.fechado : fechado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ExtratoFatura
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoOrigemCopyWith<$Res> get origem {
  
  return $LancamentoOrigemCopyWith<$Res>(_self.origem, (value) {
    return _then(_self.copyWith(origem: value));
  });
}
}

/// @nodoc
mixin _$ExtratoFaturaDetails {

 String get id; LancamentoOrigemDetail get origem; int get ano; Mes get mes; DateTime get dataInicio; DateTime get dataFim; double get saldoInicial; double get saldoFinal; bool get fechado;
/// Create a copy of ExtratoFaturaDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtratoFaturaDetailsCopyWith<ExtratoFaturaDetails> get copyWith => _$ExtratoFaturaDetailsCopyWithImpl<ExtratoFaturaDetails>(this as ExtratoFaturaDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtratoFaturaDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.origem, origem) || other.origem == origem)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.saldoInicial, saldoInicial) || other.saldoInicial == saldoInicial)&&(identical(other.saldoFinal, saldoFinal) || other.saldoFinal == saldoFinal)&&(identical(other.fechado, fechado) || other.fechado == fechado));
}


@override
int get hashCode => Object.hash(runtimeType,id,origem,ano,mes,dataInicio,dataFim,saldoInicial,saldoFinal,fechado);

@override
String toString() {
  return 'ExtratoFaturaDetails(id: $id, origem: $origem, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, saldoInicial: $saldoInicial, saldoFinal: $saldoFinal, fechado: $fechado)';
}


}

/// @nodoc
abstract mixin class $ExtratoFaturaDetailsCopyWith<$Res>  {
  factory $ExtratoFaturaDetailsCopyWith(ExtratoFaturaDetails value, $Res Function(ExtratoFaturaDetails) _then) = _$ExtratoFaturaDetailsCopyWithImpl;
@useResult
$Res call({
 String id, LancamentoOrigemDetail origem, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, double saldoInicial, double saldoFinal, bool fechado
});


$LancamentoOrigemDetailCopyWith<$Res> get origem;

}
/// @nodoc
class _$ExtratoFaturaDetailsCopyWithImpl<$Res>
    implements $ExtratoFaturaDetailsCopyWith<$Res> {
  _$ExtratoFaturaDetailsCopyWithImpl(this._self, this._then);

  final ExtratoFaturaDetails _self;
  final $Res Function(ExtratoFaturaDetails) _then;

/// Create a copy of ExtratoFaturaDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? origem = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? saldoInicial = null,Object? saldoFinal = null,Object? fechado = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,origem: null == origem ? _self.origem : origem // ignore: cast_nullable_to_non_nullable
as LancamentoOrigemDetail,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,saldoInicial: null == saldoInicial ? _self.saldoInicial : saldoInicial // ignore: cast_nullable_to_non_nullable
as double,saldoFinal: null == saldoFinal ? _self.saldoFinal : saldoFinal // ignore: cast_nullable_to_non_nullable
as double,fechado: null == fechado ? _self.fechado : fechado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ExtratoFaturaDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoOrigemDetailCopyWith<$Res> get origem {
  
  return $LancamentoOrigemDetailCopyWith<$Res>(_self.origem, (value) {
    return _then(_self.copyWith(origem: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExtratoFaturaDetails].
extension ExtratoFaturaDetailsPatterns on ExtratoFaturaDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtratoFaturaDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtratoFaturaDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtratoFaturaDetails value)  $default,){
final _that = this;
switch (_that) {
case _ExtratoFaturaDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtratoFaturaDetails value)?  $default,){
final _that = this;
switch (_that) {
case _ExtratoFaturaDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LancamentoOrigemDetail origem,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  double saldoInicial,  double saldoFinal,  bool fechado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtratoFaturaDetails() when $default != null:
return $default(_that.id,_that.origem,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.saldoInicial,_that.saldoFinal,_that.fechado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LancamentoOrigemDetail origem,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  double saldoInicial,  double saldoFinal,  bool fechado)  $default,) {final _that = this;
switch (_that) {
case _ExtratoFaturaDetails():
return $default(_that.id,_that.origem,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.saldoInicial,_that.saldoFinal,_that.fechado);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LancamentoOrigemDetail origem,  int ano,  Mes mes,  DateTime dataInicio,  DateTime dataFim,  double saldoInicial,  double saldoFinal,  bool fechado)?  $default,) {final _that = this;
switch (_that) {
case _ExtratoFaturaDetails() when $default != null:
return $default(_that.id,_that.origem,_that.ano,_that.mes,_that.dataInicio,_that.dataFim,_that.saldoInicial,_that.saldoFinal,_that.fechado);case _:
  return null;

}
}

}

/// @nodoc


class _ExtratoFaturaDetails implements ExtratoFaturaDetails {
  const _ExtratoFaturaDetails({required this.id, required this.origem, required this.ano, required this.mes, required this.dataInicio, required this.dataFim, required this.saldoInicial, required this.saldoFinal, required this.fechado});
  

@override final  String id;
@override final  LancamentoOrigemDetail origem;
@override final  int ano;
@override final  Mes mes;
@override final  DateTime dataInicio;
@override final  DateTime dataFim;
@override final  double saldoInicial;
@override final  double saldoFinal;
@override final  bool fechado;

/// Create a copy of ExtratoFaturaDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtratoFaturaDetailsCopyWith<_ExtratoFaturaDetails> get copyWith => __$ExtratoFaturaDetailsCopyWithImpl<_ExtratoFaturaDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtratoFaturaDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.origem, origem) || other.origem == origem)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.dataInicio, dataInicio) || other.dataInicio == dataInicio)&&(identical(other.dataFim, dataFim) || other.dataFim == dataFim)&&(identical(other.saldoInicial, saldoInicial) || other.saldoInicial == saldoInicial)&&(identical(other.saldoFinal, saldoFinal) || other.saldoFinal == saldoFinal)&&(identical(other.fechado, fechado) || other.fechado == fechado));
}


@override
int get hashCode => Object.hash(runtimeType,id,origem,ano,mes,dataInicio,dataFim,saldoInicial,saldoFinal,fechado);

@override
String toString() {
  return 'ExtratoFaturaDetails(id: $id, origem: $origem, ano: $ano, mes: $mes, dataInicio: $dataInicio, dataFim: $dataFim, saldoInicial: $saldoInicial, saldoFinal: $saldoFinal, fechado: $fechado)';
}


}

/// @nodoc
abstract mixin class _$ExtratoFaturaDetailsCopyWith<$Res> implements $ExtratoFaturaDetailsCopyWith<$Res> {
  factory _$ExtratoFaturaDetailsCopyWith(_ExtratoFaturaDetails value, $Res Function(_ExtratoFaturaDetails) _then) = __$ExtratoFaturaDetailsCopyWithImpl;
@override @useResult
$Res call({
 String id, LancamentoOrigemDetail origem, int ano, Mes mes, DateTime dataInicio, DateTime dataFim, double saldoInicial, double saldoFinal, bool fechado
});


@override $LancamentoOrigemDetailCopyWith<$Res> get origem;

}
/// @nodoc
class __$ExtratoFaturaDetailsCopyWithImpl<$Res>
    implements _$ExtratoFaturaDetailsCopyWith<$Res> {
  __$ExtratoFaturaDetailsCopyWithImpl(this._self, this._then);

  final _ExtratoFaturaDetails _self;
  final $Res Function(_ExtratoFaturaDetails) _then;

/// Create a copy of ExtratoFaturaDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? origem = null,Object? ano = null,Object? mes = null,Object? dataInicio = null,Object? dataFim = null,Object? saldoInicial = null,Object? saldoFinal = null,Object? fechado = null,}) {
  return _then(_ExtratoFaturaDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,origem: null == origem ? _self.origem : origem // ignore: cast_nullable_to_non_nullable
as LancamentoOrigemDetail,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,dataInicio: null == dataInicio ? _self.dataInicio : dataInicio // ignore: cast_nullable_to_non_nullable
as DateTime,dataFim: null == dataFim ? _self.dataFim : dataFim // ignore: cast_nullable_to_non_nullable
as DateTime,saldoInicial: null == saldoInicial ? _self.saldoInicial : saldoInicial // ignore: cast_nullable_to_non_nullable
as double,saldoFinal: null == saldoFinal ? _self.saldoFinal : saldoFinal // ignore: cast_nullable_to_non_nullable
as double,fechado: null == fechado ? _self.fechado : fechado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ExtratoFaturaDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoOrigemDetailCopyWith<$Res> get origem {
  
  return $LancamentoOrigemDetailCopyWith<$Res>(_self.origem, (value) {
    return _then(_self.copyWith(origem: value));
  });
}
}

// dart format on
