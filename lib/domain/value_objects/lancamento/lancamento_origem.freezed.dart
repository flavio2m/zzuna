// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lancamento_origem.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
LancamentoOrigem _$LancamentoOrigemFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'conta':
          return LancamentoOrigemConta.fromJson(
            json
          );
                case 'cartao':
          return LancamentoOrigemCartao.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'LancamentoOrigem',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$LancamentoOrigem {



  /// Serializes this LancamentoOrigem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoOrigem);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LancamentoOrigem()';
}


}

/// @nodoc
class $LancamentoOrigemCopyWith<$Res>  {
$LancamentoOrigemCopyWith(LancamentoOrigem _, $Res Function(LancamentoOrigem) __);
}


/// Adds pattern-matching-related methods to [LancamentoOrigem].
extension LancamentoOrigemPatterns on LancamentoOrigem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LancamentoOrigemConta value)?  conta,TResult Function( LancamentoOrigemCartao value)?  cartao,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LancamentoOrigemConta() when conta != null:
return conta(_that);case LancamentoOrigemCartao() when cartao != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LancamentoOrigemConta value)  conta,required TResult Function( LancamentoOrigemCartao value)  cartao,}){
final _that = this;
switch (_that) {
case LancamentoOrigemConta():
return conta(_that);case LancamentoOrigemCartao():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LancamentoOrigemConta value)?  conta,TResult? Function( LancamentoOrigemCartao value)?  cartao,}){
final _that = this;
switch (_that) {
case LancamentoOrigemConta() when conta != null:
return conta(_that);case LancamentoOrigemCartao() when cartao != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String contaId)?  conta,TResult Function( String cartaoId)?  cartao,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LancamentoOrigemConta() when conta != null:
return conta(_that.contaId);case LancamentoOrigemCartao() when cartao != null:
return cartao(_that.cartaoId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String contaId)  conta,required TResult Function( String cartaoId)  cartao,}) {final _that = this;
switch (_that) {
case LancamentoOrigemConta():
return conta(_that.contaId);case LancamentoOrigemCartao():
return cartao(_that.cartaoId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String contaId)?  conta,TResult? Function( String cartaoId)?  cartao,}) {final _that = this;
switch (_that) {
case LancamentoOrigemConta() when conta != null:
return conta(_that.contaId);case LancamentoOrigemCartao() when cartao != null:
return cartao(_that.cartaoId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class LancamentoOrigemConta implements LancamentoOrigem {
  const LancamentoOrigemConta({required this.contaId, final  String? $type}): $type = $type ?? 'conta';
  factory LancamentoOrigemConta.fromJson(Map<String, dynamic> json) => _$LancamentoOrigemContaFromJson(json);

 final  String contaId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LancamentoOrigem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoOrigemContaCopyWith<LancamentoOrigemConta> get copyWith => _$LancamentoOrigemContaCopyWithImpl<LancamentoOrigemConta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LancamentoOrigemContaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoOrigemConta&&(identical(other.contaId, contaId) || other.contaId == contaId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contaId);

@override
String toString() {
  return 'LancamentoOrigem.conta(contaId: $contaId)';
}


}

/// @nodoc
abstract mixin class $LancamentoOrigemContaCopyWith<$Res> implements $LancamentoOrigemCopyWith<$Res> {
  factory $LancamentoOrigemContaCopyWith(LancamentoOrigemConta value, $Res Function(LancamentoOrigemConta) _then) = _$LancamentoOrigemContaCopyWithImpl;
@useResult
$Res call({
 String contaId
});




}
/// @nodoc
class _$LancamentoOrigemContaCopyWithImpl<$Res>
    implements $LancamentoOrigemContaCopyWith<$Res> {
  _$LancamentoOrigemContaCopyWithImpl(this._self, this._then);

  final LancamentoOrigemConta _self;
  final $Res Function(LancamentoOrigemConta) _then;

/// Create a copy of LancamentoOrigem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contaId = null,}) {
  return _then(LancamentoOrigemConta(
contaId: null == contaId ? _self.contaId : contaId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LancamentoOrigemCartao implements LancamentoOrigem {
  const LancamentoOrigemCartao({required this.cartaoId, final  String? $type}): $type = $type ?? 'cartao';
  factory LancamentoOrigemCartao.fromJson(Map<String, dynamic> json) => _$LancamentoOrigemCartaoFromJson(json);

 final  String cartaoId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of LancamentoOrigem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoOrigemCartaoCopyWith<LancamentoOrigemCartao> get copyWith => _$LancamentoOrigemCartaoCopyWithImpl<LancamentoOrigemCartao>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LancamentoOrigemCartaoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoOrigemCartao&&(identical(other.cartaoId, cartaoId) || other.cartaoId == cartaoId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cartaoId);

@override
String toString() {
  return 'LancamentoOrigem.cartao(cartaoId: $cartaoId)';
}


}

/// @nodoc
abstract mixin class $LancamentoOrigemCartaoCopyWith<$Res> implements $LancamentoOrigemCopyWith<$Res> {
  factory $LancamentoOrigemCartaoCopyWith(LancamentoOrigemCartao value, $Res Function(LancamentoOrigemCartao) _then) = _$LancamentoOrigemCartaoCopyWithImpl;
@useResult
$Res call({
 String cartaoId
});




}
/// @nodoc
class _$LancamentoOrigemCartaoCopyWithImpl<$Res>
    implements $LancamentoOrigemCartaoCopyWith<$Res> {
  _$LancamentoOrigemCartaoCopyWithImpl(this._self, this._then);

  final LancamentoOrigemCartao _self;
  final $Res Function(LancamentoOrigemCartao) _then;

/// Create a copy of LancamentoOrigem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cartaoId = null,}) {
  return _then(LancamentoOrigemCartao(
cartaoId: null == cartaoId ? _self.cartaoId : cartaoId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
