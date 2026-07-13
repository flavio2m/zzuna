// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lancamento_origem_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LancamentoOrigemDetail {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoOrigemDetail);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LancamentoOrigemDetail()';
}


}

/// @nodoc
class $LancamentoOrigemDetailCopyWith<$Res>  {
$LancamentoOrigemDetailCopyWith(LancamentoOrigemDetail _, $Res Function(LancamentoOrigemDetail) __);
}


/// Adds pattern-matching-related methods to [LancamentoOrigemDetail].
extension LancamentoOrigemDetailPatterns on LancamentoOrigemDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LancamentoOrigemContaDetail value)?  conta,TResult Function( LancamentoOrigemCartaoDetail value)?  cartao,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LancamentoOrigemContaDetail() when conta != null:
return conta(_that);case LancamentoOrigemCartaoDetail() when cartao != null:
return cartao(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LancamentoOrigemContaDetail value)  conta,required TResult Function( LancamentoOrigemCartaoDetail value)  cartao,}){
final _that = this;
switch (_that) {
case LancamentoOrigemContaDetail():
return conta(_that);case LancamentoOrigemCartaoDetail():
return cartao(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LancamentoOrigemContaDetail value)?  conta,TResult? Function( LancamentoOrigemCartaoDetail value)?  cartao,}){
final _that = this;
switch (_that) {
case LancamentoOrigemContaDetail() when conta != null:
return conta(_that);case LancamentoOrigemCartaoDetail() when cartao != null:
return cartao(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ContaDetails conta)?  conta,TResult Function( CartaoDetails cartao)?  cartao,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LancamentoOrigemContaDetail() when conta != null:
return conta(_that.conta);case LancamentoOrigemCartaoDetail() when cartao != null:
return cartao(_that.cartao);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ContaDetails conta)  conta,required TResult Function( CartaoDetails cartao)  cartao,}) {final _that = this;
switch (_that) {
case LancamentoOrigemContaDetail():
return conta(_that.conta);case LancamentoOrigemCartaoDetail():
return cartao(_that.cartao);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ContaDetails conta)?  conta,TResult? Function( CartaoDetails cartao)?  cartao,}) {final _that = this;
switch (_that) {
case LancamentoOrigemContaDetail() when conta != null:
return conta(_that.conta);case LancamentoOrigemCartaoDetail() when cartao != null:
return cartao(_that.cartao);case _:
  return null;

}
}

}

/// @nodoc


class LancamentoOrigemContaDetail extends LancamentoOrigemDetail {
  const LancamentoOrigemContaDetail({required this.conta}): super._();
  

 final  ContaDetails conta;

/// Create a copy of LancamentoOrigemDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoOrigemContaDetailCopyWith<LancamentoOrigemContaDetail> get copyWith => _$LancamentoOrigemContaDetailCopyWithImpl<LancamentoOrigemContaDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoOrigemContaDetail&&(identical(other.conta, conta) || other.conta == conta));
}


@override
int get hashCode => Object.hash(runtimeType,conta);

@override
String toString() {
  return 'LancamentoOrigemDetail.conta(conta: $conta)';
}


}

/// @nodoc
abstract mixin class $LancamentoOrigemContaDetailCopyWith<$Res> implements $LancamentoOrigemDetailCopyWith<$Res> {
  factory $LancamentoOrigemContaDetailCopyWith(LancamentoOrigemContaDetail value, $Res Function(LancamentoOrigemContaDetail) _then) = _$LancamentoOrigemContaDetailCopyWithImpl;
@useResult
$Res call({
 ContaDetails conta
});


$ContaDetailsCopyWith<$Res> get conta;

}
/// @nodoc
class _$LancamentoOrigemContaDetailCopyWithImpl<$Res>
    implements $LancamentoOrigemContaDetailCopyWith<$Res> {
  _$LancamentoOrigemContaDetailCopyWithImpl(this._self, this._then);

  final LancamentoOrigemContaDetail _self;
  final $Res Function(LancamentoOrigemContaDetail) _then;

/// Create a copy of LancamentoOrigemDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? conta = null,}) {
  return _then(LancamentoOrigemContaDetail(
conta: null == conta ? _self.conta : conta // ignore: cast_nullable_to_non_nullable
as ContaDetails,
  ));
}

/// Create a copy of LancamentoOrigemDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContaDetailsCopyWith<$Res> get conta {
  
  return $ContaDetailsCopyWith<$Res>(_self.conta, (value) {
    return _then(_self.copyWith(conta: value));
  });
}
}

/// @nodoc


class LancamentoOrigemCartaoDetail extends LancamentoOrigemDetail {
  const LancamentoOrigemCartaoDetail({required this.cartao}): super._();
  

 final  CartaoDetails cartao;

/// Create a copy of LancamentoOrigemDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoOrigemCartaoDetailCopyWith<LancamentoOrigemCartaoDetail> get copyWith => _$LancamentoOrigemCartaoDetailCopyWithImpl<LancamentoOrigemCartaoDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoOrigemCartaoDetail&&(identical(other.cartao, cartao) || other.cartao == cartao));
}


@override
int get hashCode => Object.hash(runtimeType,cartao);

@override
String toString() {
  return 'LancamentoOrigemDetail.cartao(cartao: $cartao)';
}


}

/// @nodoc
abstract mixin class $LancamentoOrigemCartaoDetailCopyWith<$Res> implements $LancamentoOrigemDetailCopyWith<$Res> {
  factory $LancamentoOrigemCartaoDetailCopyWith(LancamentoOrigemCartaoDetail value, $Res Function(LancamentoOrigemCartaoDetail) _then) = _$LancamentoOrigemCartaoDetailCopyWithImpl;
@useResult
$Res call({
 CartaoDetails cartao
});


$CartaoDetailsCopyWith<$Res> get cartao;

}
/// @nodoc
class _$LancamentoOrigemCartaoDetailCopyWithImpl<$Res>
    implements $LancamentoOrigemCartaoDetailCopyWith<$Res> {
  _$LancamentoOrigemCartaoDetailCopyWithImpl(this._self, this._then);

  final LancamentoOrigemCartaoDetail _self;
  final $Res Function(LancamentoOrigemCartaoDetail) _then;

/// Create a copy of LancamentoOrigemDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cartao = null,}) {
  return _then(LancamentoOrigemCartaoDetail(
cartao: null == cartao ? _self.cartao : cartao // ignore: cast_nullable_to_non_nullable
as CartaoDetails,
  ));
}

/// Create a copy of LancamentoOrigemDetail
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
