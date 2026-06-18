// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lancamento_referencia_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LancamentoReferenciaDetail {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoReferenciaDetail);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LancamentoReferenciaDetail()';
}


}

/// @nodoc
class $LancamentoReferenciaDetailCopyWith<$Res>  {
$LancamentoReferenciaDetailCopyWith(LancamentoReferenciaDetail _, $Res Function(LancamentoReferenciaDetail) __);
}


/// Adds pattern-matching-related methods to [LancamentoReferenciaDetail].
extension LancamentoReferenciaDetailPatterns on LancamentoReferenciaDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReferenciaFaturaLancamentoDetail value)?  fatura,TResult Function( ReferenciaExtratoLancamentoDetail value)?  extrato,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReferenciaFaturaLancamentoDetail() when fatura != null:
return fatura(_that);case ReferenciaExtratoLancamentoDetail() when extrato != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReferenciaFaturaLancamentoDetail value)  fatura,required TResult Function( ReferenciaExtratoLancamentoDetail value)  extrato,}){
final _that = this;
switch (_that) {
case ReferenciaFaturaLancamentoDetail():
return fatura(_that);case ReferenciaExtratoLancamentoDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReferenciaFaturaLancamentoDetail value)?  fatura,TResult? Function( ReferenciaExtratoLancamentoDetail value)?  extrato,}){
final _that = this;
switch (_that) {
case ReferenciaFaturaLancamentoDetail() when fatura != null:
return fatura(_that);case ReferenciaExtratoLancamentoDetail() when extrato != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( FaturaDetails fatura)?  fatura,TResult Function( ExtratoDetails extrato)?  extrato,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReferenciaFaturaLancamentoDetail() when fatura != null:
return fatura(_that.fatura);case ReferenciaExtratoLancamentoDetail() when extrato != null:
return extrato(_that.extrato);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( FaturaDetails fatura)  fatura,required TResult Function( ExtratoDetails extrato)  extrato,}) {final _that = this;
switch (_that) {
case ReferenciaFaturaLancamentoDetail():
return fatura(_that.fatura);case ReferenciaExtratoLancamentoDetail():
return extrato(_that.extrato);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( FaturaDetails fatura)?  fatura,TResult? Function( ExtratoDetails extrato)?  extrato,}) {final _that = this;
switch (_that) {
case ReferenciaFaturaLancamentoDetail() when fatura != null:
return fatura(_that.fatura);case ReferenciaExtratoLancamentoDetail() when extrato != null:
return extrato(_that.extrato);case _:
  return null;

}
}

}

/// @nodoc


class ReferenciaFaturaLancamentoDetail implements LancamentoReferenciaDetail {
  const ReferenciaFaturaLancamentoDetail({required this.fatura});
  

 final  FaturaDetails fatura;

/// Create a copy of LancamentoReferenciaDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferenciaFaturaLancamentoDetailCopyWith<ReferenciaFaturaLancamentoDetail> get copyWith => _$ReferenciaFaturaLancamentoDetailCopyWithImpl<ReferenciaFaturaLancamentoDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenciaFaturaLancamentoDetail&&(identical(other.fatura, fatura) || other.fatura == fatura));
}


@override
int get hashCode => Object.hash(runtimeType,fatura);

@override
String toString() {
  return 'LancamentoReferenciaDetail.fatura(fatura: $fatura)';
}


}

/// @nodoc
abstract mixin class $ReferenciaFaturaLancamentoDetailCopyWith<$Res> implements $LancamentoReferenciaDetailCopyWith<$Res> {
  factory $ReferenciaFaturaLancamentoDetailCopyWith(ReferenciaFaturaLancamentoDetail value, $Res Function(ReferenciaFaturaLancamentoDetail) _then) = _$ReferenciaFaturaLancamentoDetailCopyWithImpl;
@useResult
$Res call({
 FaturaDetails fatura
});


$FaturaDetailsCopyWith<$Res> get fatura;

}
/// @nodoc
class _$ReferenciaFaturaLancamentoDetailCopyWithImpl<$Res>
    implements $ReferenciaFaturaLancamentoDetailCopyWith<$Res> {
  _$ReferenciaFaturaLancamentoDetailCopyWithImpl(this._self, this._then);

  final ReferenciaFaturaLancamentoDetail _self;
  final $Res Function(ReferenciaFaturaLancamentoDetail) _then;

/// Create a copy of LancamentoReferenciaDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fatura = null,}) {
  return _then(ReferenciaFaturaLancamentoDetail(
fatura: null == fatura ? _self.fatura : fatura // ignore: cast_nullable_to_non_nullable
as FaturaDetails,
  ));
}

/// Create a copy of LancamentoReferenciaDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FaturaDetailsCopyWith<$Res> get fatura {
  
  return $FaturaDetailsCopyWith<$Res>(_self.fatura, (value) {
    return _then(_self.copyWith(fatura: value));
  });
}
}

/// @nodoc


class ReferenciaExtratoLancamentoDetail implements LancamentoReferenciaDetail {
  const ReferenciaExtratoLancamentoDetail({required this.extrato});
  

 final  ExtratoDetails extrato;

/// Create a copy of LancamentoReferenciaDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferenciaExtratoLancamentoDetailCopyWith<ReferenciaExtratoLancamentoDetail> get copyWith => _$ReferenciaExtratoLancamentoDetailCopyWithImpl<ReferenciaExtratoLancamentoDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferenciaExtratoLancamentoDetail&&(identical(other.extrato, extrato) || other.extrato == extrato));
}


@override
int get hashCode => Object.hash(runtimeType,extrato);

@override
String toString() {
  return 'LancamentoReferenciaDetail.extrato(extrato: $extrato)';
}


}

/// @nodoc
abstract mixin class $ReferenciaExtratoLancamentoDetailCopyWith<$Res> implements $LancamentoReferenciaDetailCopyWith<$Res> {
  factory $ReferenciaExtratoLancamentoDetailCopyWith(ReferenciaExtratoLancamentoDetail value, $Res Function(ReferenciaExtratoLancamentoDetail) _then) = _$ReferenciaExtratoLancamentoDetailCopyWithImpl;
@useResult
$Res call({
 ExtratoDetails extrato
});


$ExtratoDetailsCopyWith<$Res> get extrato;

}
/// @nodoc
class _$ReferenciaExtratoLancamentoDetailCopyWithImpl<$Res>
    implements $ReferenciaExtratoLancamentoDetailCopyWith<$Res> {
  _$ReferenciaExtratoLancamentoDetailCopyWithImpl(this._self, this._then);

  final ReferenciaExtratoLancamentoDetail _self;
  final $Res Function(ReferenciaExtratoLancamentoDetail) _then;

/// Create a copy of LancamentoReferenciaDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? extrato = null,}) {
  return _then(ReferenciaExtratoLancamentoDetail(
extrato: null == extrato ? _self.extrato : extrato // ignore: cast_nullable_to_non_nullable
as ExtratoDetails,
  ));
}

/// Create a copy of LancamentoReferenciaDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExtratoDetailsCopyWith<$Res> get extrato {
  
  return $ExtratoDetailsCopyWith<$Res>(_self.extrato, (value) {
    return _then(_self.copyWith(extrato: value));
  });
}
}

// dart format on
