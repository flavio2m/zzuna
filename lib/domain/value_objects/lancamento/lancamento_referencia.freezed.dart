// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lancamento_referencia.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
LancamentoReferencia _$LancamentoReferenciaFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'fatura':
          return ReferenciaFaturaLancamento.fromJson(
            json
          );
                case 'extrato':
          return ReferenciaExtratoLancamento.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'LancamentoReferencia',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$LancamentoReferencia {



  /// Serializes this LancamentoReferencia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoReferencia);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LancamentoReferencia()';
}


}

/// @nodoc
class $LancamentoReferenciaCopyWith<$Res>  {
$LancamentoReferenciaCopyWith(LancamentoReferencia _, $Res Function(LancamentoReferencia) __);
}


/// Adds pattern-matching-related methods to [LancamentoReferencia].
extension LancamentoReferenciaPatterns on LancamentoReferencia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReferenciaFaturaLancamento value)?  fatura,TResult Function( ReferenciaExtratoLancamento value)?  extrato,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReferenciaFaturaLancamento() when fatura != null:
return fatura(_that);case ReferenciaExtratoLancamento() when extrato != null:
return extrato(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReferenciaFaturaLancamento value)  fatura,required TResult Function( ReferenciaExtratoLancamento value)  extrato,}){
final _that = this;
switch (_that) {
case ReferenciaFaturaLancamento():
return fatura(_that);case ReferenciaExtratoLancamento():
return extrato(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReferenciaFaturaLancamento value)?  fatura,TResult? Function( ReferenciaExtratoLancamento value)?  extrato,}){
final _that = this;
switch (_that) {
case ReferenciaFaturaLancamento() when fatura != null:
return fatura(_that);case ReferenciaExtratoLancamento() when extrato != null:
return extrato(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String faturaId)?  fatura,TResult Function( String extratoId)?  extrato,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReferenciaFaturaLancamento() when fatura != null:
return fatura(_that.faturaId);case ReferenciaExtratoLancamento() when extrato != null:
return extrato(_that.extratoId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String faturaId)  fatura,required TResult Function( String extratoId)  extrato,}) {final _that = this;
switch (_that) {
case ReferenciaFaturaLancamento():
return fatura(_that.faturaId);case ReferenciaExtratoLancamento():
return extrato(_that.extratoId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String faturaId)?  fatura,TResult? Function( String extratoId)?  extrato,}) {final _that = this;
switch (_that) {
case ReferenciaFaturaLancamento() when fatura != null:
return fatura(_that.faturaId);case ReferenciaExtratoLancamento() when extrato != null:
return extrato(_that.extratoId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ReferenciaFaturaLancamento implements LancamentoReferencia {
  const ReferenciaFaturaLancamento({required this.faturaId, final  String? $type}): $type = $type ?? 'fatura';
  factory ReferenciaFaturaLancamento.fromJson(Map<String, dynamic> json) => _$ReferenciaFaturaLancamentoFromJson(json);

 final  String faturaId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LancamentoReferencia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferenciaFaturaLancamentoCopyWith<ReferenciaFaturaLancamento> get copyWith => _$ReferenciaFaturaLancamentoCopyWithImpl<ReferenciaFaturaLancamento>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferenciaFaturaLancamentoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenciaFaturaLancamento&&(identical(other.faturaId, faturaId) || other.faturaId == faturaId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,faturaId);

@override
String toString() {
  return 'LancamentoReferencia.fatura(faturaId: $faturaId)';
}


}

/// @nodoc
abstract mixin class $ReferenciaFaturaLancamentoCopyWith<$Res> implements $LancamentoReferenciaCopyWith<$Res> {
  factory $ReferenciaFaturaLancamentoCopyWith(ReferenciaFaturaLancamento value, $Res Function(ReferenciaFaturaLancamento) _then) = _$ReferenciaFaturaLancamentoCopyWithImpl;
@useResult
$Res call({
 String faturaId
});




}
/// @nodoc
class _$ReferenciaFaturaLancamentoCopyWithImpl<$Res>
    implements $ReferenciaFaturaLancamentoCopyWith<$Res> {
  _$ReferenciaFaturaLancamentoCopyWithImpl(this._self, this._then);

  final ReferenciaFaturaLancamento _self;
  final $Res Function(ReferenciaFaturaLancamento) _then;

/// Create a copy of LancamentoReferencia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? faturaId = null,}) {
  return _then(ReferenciaFaturaLancamento(
faturaId: null == faturaId ? _self.faturaId : faturaId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ReferenciaExtratoLancamento implements LancamentoReferencia {
  const ReferenciaExtratoLancamento({required this.extratoId, final  String? $type}): $type = $type ?? 'extrato';
  factory ReferenciaExtratoLancamento.fromJson(Map<String, dynamic> json) => _$ReferenciaExtratoLancamentoFromJson(json);

 final  String extratoId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LancamentoReferencia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferenciaExtratoLancamentoCopyWith<ReferenciaExtratoLancamento> get copyWith => _$ReferenciaExtratoLancamentoCopyWithImpl<ReferenciaExtratoLancamento>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferenciaExtratoLancamentoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenciaExtratoLancamento&&(identical(other.extratoId, extratoId) || other.extratoId == extratoId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,extratoId);

@override
String toString() {
  return 'LancamentoReferencia.extrato(extratoId: $extratoId)';
}


}

/// @nodoc
abstract mixin class $ReferenciaExtratoLancamentoCopyWith<$Res> implements $LancamentoReferenciaCopyWith<$Res> {
  factory $ReferenciaExtratoLancamentoCopyWith(ReferenciaExtratoLancamento value, $Res Function(ReferenciaExtratoLancamento) _then) = _$ReferenciaExtratoLancamentoCopyWithImpl;
@useResult
$Res call({
 String extratoId
});




}
/// @nodoc
class _$ReferenciaExtratoLancamentoCopyWithImpl<$Res>
    implements $ReferenciaExtratoLancamentoCopyWith<$Res> {
  _$ReferenciaExtratoLancamentoCopyWithImpl(this._self, this._then);

  final ReferenciaExtratoLancamento _self;
  final $Res Function(ReferenciaExtratoLancamento) _then;

/// Create a copy of LancamentoReferencia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? extratoId = null,}) {
  return _then(ReferenciaExtratoLancamento(
extratoId: null == extratoId ? _self.extratoId : extratoId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
