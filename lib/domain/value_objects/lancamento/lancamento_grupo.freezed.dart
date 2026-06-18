// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lancamento_grupo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
LancamentoGrupo _$LancamentoGrupoFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'parcelamento':
          return LancamentoGrupoParcelamento.fromJson(
            json
          );
                case 'transferencia':
          return LancamentoGrupoTransferencia.fromJson(
            json
          );
                case 'replicacao':
          return LancamentoGrupoReplicacao.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'LancamentoGrupo',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$LancamentoGrupo {

 String get grupoId;
/// Create a copy of LancamentoGrupo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoGrupoCopyWith<LancamentoGrupo> get copyWith => _$LancamentoGrupoCopyWithImpl<LancamentoGrupo>(this as LancamentoGrupo, _$identity);

  /// Serializes this LancamentoGrupo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoGrupo&&(identical(other.grupoId, grupoId) || other.grupoId == grupoId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grupoId);

@override
String toString() {
  return 'LancamentoGrupo(grupoId: $grupoId)';
}


}

/// @nodoc
abstract mixin class $LancamentoGrupoCopyWith<$Res>  {
  factory $LancamentoGrupoCopyWith(LancamentoGrupo value, $Res Function(LancamentoGrupo) _then) = _$LancamentoGrupoCopyWithImpl;
@useResult
$Res call({
 String grupoId
});




}
/// @nodoc
class _$LancamentoGrupoCopyWithImpl<$Res>
    implements $LancamentoGrupoCopyWith<$Res> {
  _$LancamentoGrupoCopyWithImpl(this._self, this._then);

  final LancamentoGrupo _self;
  final $Res Function(LancamentoGrupo) _then;

/// Create a copy of LancamentoGrupo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? grupoId = null,}) {
  return _then(_self.copyWith(
grupoId: null == grupoId ? _self.grupoId : grupoId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LancamentoGrupo].
extension LancamentoGrupoPatterns on LancamentoGrupo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LancamentoGrupoParcelamento value)?  parcelamento,TResult Function( LancamentoGrupoTransferencia value)?  transferencia,TResult Function( LancamentoGrupoReplicacao value)?  replicacao,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LancamentoGrupoParcelamento() when parcelamento != null:
return parcelamento(_that);case LancamentoGrupoTransferencia() when transferencia != null:
return transferencia(_that);case LancamentoGrupoReplicacao() when replicacao != null:
return replicacao(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LancamentoGrupoParcelamento value)  parcelamento,required TResult Function( LancamentoGrupoTransferencia value)  transferencia,required TResult Function( LancamentoGrupoReplicacao value)  replicacao,}){
final _that = this;
switch (_that) {
case LancamentoGrupoParcelamento():
return parcelamento(_that);case LancamentoGrupoTransferencia():
return transferencia(_that);case LancamentoGrupoReplicacao():
return replicacao(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LancamentoGrupoParcelamento value)?  parcelamento,TResult? Function( LancamentoGrupoTransferencia value)?  transferencia,TResult? Function( LancamentoGrupoReplicacao value)?  replicacao,}){
final _that = this;
switch (_that) {
case LancamentoGrupoParcelamento() when parcelamento != null:
return parcelamento(_that);case LancamentoGrupoTransferencia() when transferencia != null:
return transferencia(_that);case LancamentoGrupoReplicacao() when replicacao != null:
return replicacao(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String grupoId,  int parcela,  int totalParcelas)?  parcelamento,TResult Function( String grupoId)?  transferencia,TResult Function( String grupoId)?  replicacao,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LancamentoGrupoParcelamento() when parcelamento != null:
return parcelamento(_that.grupoId,_that.parcela,_that.totalParcelas);case LancamentoGrupoTransferencia() when transferencia != null:
return transferencia(_that.grupoId);case LancamentoGrupoReplicacao() when replicacao != null:
return replicacao(_that.grupoId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String grupoId,  int parcela,  int totalParcelas)  parcelamento,required TResult Function( String grupoId)  transferencia,required TResult Function( String grupoId)  replicacao,}) {final _that = this;
switch (_that) {
case LancamentoGrupoParcelamento():
return parcelamento(_that.grupoId,_that.parcela,_that.totalParcelas);case LancamentoGrupoTransferencia():
return transferencia(_that.grupoId);case LancamentoGrupoReplicacao():
return replicacao(_that.grupoId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String grupoId,  int parcela,  int totalParcelas)?  parcelamento,TResult? Function( String grupoId)?  transferencia,TResult? Function( String grupoId)?  replicacao,}) {final _that = this;
switch (_that) {
case LancamentoGrupoParcelamento() when parcelamento != null:
return parcelamento(_that.grupoId,_that.parcela,_that.totalParcelas);case LancamentoGrupoTransferencia() when transferencia != null:
return transferencia(_that.grupoId);case LancamentoGrupoReplicacao() when replicacao != null:
return replicacao(_that.grupoId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class LancamentoGrupoParcelamento implements LancamentoGrupo {
  const LancamentoGrupoParcelamento({required this.grupoId, required this.parcela, required this.totalParcelas, final  String? $type}): $type = $type ?? 'parcelamento';
  factory LancamentoGrupoParcelamento.fromJson(Map<String, dynamic> json) => _$LancamentoGrupoParcelamentoFromJson(json);

@override final  String grupoId;
 final  int parcela;
 final  int totalParcelas;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LancamentoGrupo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoGrupoParcelamentoCopyWith<LancamentoGrupoParcelamento> get copyWith => _$LancamentoGrupoParcelamentoCopyWithImpl<LancamentoGrupoParcelamento>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LancamentoGrupoParcelamentoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoGrupoParcelamento&&(identical(other.grupoId, grupoId) || other.grupoId == grupoId)&&(identical(other.parcela, parcela) || other.parcela == parcela)&&(identical(other.totalParcelas, totalParcelas) || other.totalParcelas == totalParcelas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grupoId,parcela,totalParcelas);

@override
String toString() {
  return 'LancamentoGrupo.parcelamento(grupoId: $grupoId, parcela: $parcela, totalParcelas: $totalParcelas)';
}


}

/// @nodoc
abstract mixin class $LancamentoGrupoParcelamentoCopyWith<$Res> implements $LancamentoGrupoCopyWith<$Res> {
  factory $LancamentoGrupoParcelamentoCopyWith(LancamentoGrupoParcelamento value, $Res Function(LancamentoGrupoParcelamento) _then) = _$LancamentoGrupoParcelamentoCopyWithImpl;
@override @useResult
$Res call({
 String grupoId, int parcela, int totalParcelas
});




}
/// @nodoc
class _$LancamentoGrupoParcelamentoCopyWithImpl<$Res>
    implements $LancamentoGrupoParcelamentoCopyWith<$Res> {
  _$LancamentoGrupoParcelamentoCopyWithImpl(this._self, this._then);

  final LancamentoGrupoParcelamento _self;
  final $Res Function(LancamentoGrupoParcelamento) _then;

/// Create a copy of LancamentoGrupo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? grupoId = null,Object? parcela = null,Object? totalParcelas = null,}) {
  return _then(LancamentoGrupoParcelamento(
grupoId: null == grupoId ? _self.grupoId : grupoId // ignore: cast_nullable_to_non_nullable
as String,parcela: null == parcela ? _self.parcela : parcela // ignore: cast_nullable_to_non_nullable
as int,totalParcelas: null == totalParcelas ? _self.totalParcelas : totalParcelas // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LancamentoGrupoTransferencia implements LancamentoGrupo {
  const LancamentoGrupoTransferencia({required this.grupoId, final  String? $type}): $type = $type ?? 'transferencia';
  factory LancamentoGrupoTransferencia.fromJson(Map<String, dynamic> json) => _$LancamentoGrupoTransferenciaFromJson(json);

@override final  String grupoId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LancamentoGrupo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoGrupoTransferenciaCopyWith<LancamentoGrupoTransferencia> get copyWith => _$LancamentoGrupoTransferenciaCopyWithImpl<LancamentoGrupoTransferencia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LancamentoGrupoTransferenciaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoGrupoTransferencia&&(identical(other.grupoId, grupoId) || other.grupoId == grupoId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grupoId);

@override
String toString() {
  return 'LancamentoGrupo.transferencia(grupoId: $grupoId)';
}


}

/// @nodoc
abstract mixin class $LancamentoGrupoTransferenciaCopyWith<$Res> implements $LancamentoGrupoCopyWith<$Res> {
  factory $LancamentoGrupoTransferenciaCopyWith(LancamentoGrupoTransferencia value, $Res Function(LancamentoGrupoTransferencia) _then) = _$LancamentoGrupoTransferenciaCopyWithImpl;
@override @useResult
$Res call({
 String grupoId
});




}
/// @nodoc
class _$LancamentoGrupoTransferenciaCopyWithImpl<$Res>
    implements $LancamentoGrupoTransferenciaCopyWith<$Res> {
  _$LancamentoGrupoTransferenciaCopyWithImpl(this._self, this._then);

  final LancamentoGrupoTransferencia _self;
  final $Res Function(LancamentoGrupoTransferencia) _then;

/// Create a copy of LancamentoGrupo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? grupoId = null,}) {
  return _then(LancamentoGrupoTransferencia(
grupoId: null == grupoId ? _self.grupoId : grupoId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LancamentoGrupoReplicacao implements LancamentoGrupo {
  const LancamentoGrupoReplicacao({required this.grupoId, final  String? $type}): $type = $type ?? 'replicacao';
  factory LancamentoGrupoReplicacao.fromJson(Map<String, dynamic> json) => _$LancamentoGrupoReplicacaoFromJson(json);

@override final  String grupoId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LancamentoGrupo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoGrupoReplicacaoCopyWith<LancamentoGrupoReplicacao> get copyWith => _$LancamentoGrupoReplicacaoCopyWithImpl<LancamentoGrupoReplicacao>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LancamentoGrupoReplicacaoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoGrupoReplicacao&&(identical(other.grupoId, grupoId) || other.grupoId == grupoId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grupoId);

@override
String toString() {
  return 'LancamentoGrupo.replicacao(grupoId: $grupoId)';
}


}

/// @nodoc
abstract mixin class $LancamentoGrupoReplicacaoCopyWith<$Res> implements $LancamentoGrupoCopyWith<$Res> {
  factory $LancamentoGrupoReplicacaoCopyWith(LancamentoGrupoReplicacao value, $Res Function(LancamentoGrupoReplicacao) _then) = _$LancamentoGrupoReplicacaoCopyWithImpl;
@override @useResult
$Res call({
 String grupoId
});




}
/// @nodoc
class _$LancamentoGrupoReplicacaoCopyWithImpl<$Res>
    implements $LancamentoGrupoReplicacaoCopyWith<$Res> {
  _$LancamentoGrupoReplicacaoCopyWithImpl(this._self, this._then);

  final LancamentoGrupoReplicacao _self;
  final $Res Function(LancamentoGrupoReplicacao) _then;

/// Create a copy of LancamentoGrupo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? grupoId = null,}) {
  return _then(LancamentoGrupoReplicacao(
grupoId: null == grupoId ? _self.grupoId : grupoId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
