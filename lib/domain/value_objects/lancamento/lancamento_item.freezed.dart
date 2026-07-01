// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lancamento_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LancamentoItem {

 int get numero; double get valor;
/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoItemCopyWith<LancamentoItem> get copyWith => _$LancamentoItemCopyWithImpl<LancamentoItem>(this as LancamentoItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoItem&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,numero,valor);

@override
String toString() {
  return 'LancamentoItem(numero: $numero, valor: $valor)';
}


}

/// @nodoc
abstract mixin class $LancamentoItemCopyWith<$Res>  {
  factory $LancamentoItemCopyWith(LancamentoItem value, $Res Function(LancamentoItem) _then) = _$LancamentoItemCopyWithImpl;
@useResult
$Res call({
 int numero, double valor
});




}
/// @nodoc
class _$LancamentoItemCopyWithImpl<$Res>
    implements $LancamentoItemCopyWith<$Res> {
  _$LancamentoItemCopyWithImpl(this._self, this._then);

  final LancamentoItem _self;
  final $Res Function(LancamentoItem) _then;

/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? numero = null,Object? valor = null,}) {
  return _then(_self.copyWith(
numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,valor: null == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LancamentoItem].
extension LancamentoItemPatterns on LancamentoItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( LancamentoItemStandard value)?  $default,{TResult Function( LancamentoItemTransferencia value)?  transferencia,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LancamentoItemStandard() when $default != null:
return $default(_that);case LancamentoItemTransferencia() when transferencia != null:
return transferencia(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( LancamentoItemStandard value)  $default,{required TResult Function( LancamentoItemTransferencia value)  transferencia,}){
final _that = this;
switch (_that) {
case LancamentoItemStandard():
return $default(_that);case LancamentoItemTransferencia():
return transferencia(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( LancamentoItemStandard value)?  $default,{TResult? Function( LancamentoItemTransferencia value)?  transferencia,}){
final _that = this;
switch (_that) {
case LancamentoItemStandard() when $default != null:
return $default(_that);case LancamentoItemTransferencia() when transferencia != null:
return transferencia(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int numero,  String centroCustoId,  String categoriaId,  double valor)?  $default,{TResult Function( int numero,  LancamentoOrigem origemEntrada,  LancamentoOrigem origemSaida,  double valor)?  transferencia,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LancamentoItemStandard() when $default != null:
return $default(_that.numero,_that.centroCustoId,_that.categoriaId,_that.valor);case LancamentoItemTransferencia() when transferencia != null:
return transferencia(_that.numero,_that.origemEntrada,_that.origemSaida,_that.valor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int numero,  String centroCustoId,  String categoriaId,  double valor)  $default,{required TResult Function( int numero,  LancamentoOrigem origemEntrada,  LancamentoOrigem origemSaida,  double valor)  transferencia,}) {final _that = this;
switch (_that) {
case LancamentoItemStandard():
return $default(_that.numero,_that.centroCustoId,_that.categoriaId,_that.valor);case LancamentoItemTransferencia():
return transferencia(_that.numero,_that.origemEntrada,_that.origemSaida,_that.valor);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int numero,  String centroCustoId,  String categoriaId,  double valor)?  $default,{TResult? Function( int numero,  LancamentoOrigem origemEntrada,  LancamentoOrigem origemSaida,  double valor)?  transferencia,}) {final _that = this;
switch (_that) {
case LancamentoItemStandard() when $default != null:
return $default(_that.numero,_that.centroCustoId,_that.categoriaId,_that.valor);case LancamentoItemTransferencia() when transferencia != null:
return transferencia(_that.numero,_that.origemEntrada,_that.origemSaida,_that.valor);case _:
  return null;

}
}

}

/// @nodoc


class LancamentoItemStandard extends LancamentoItem {
  const LancamentoItemStandard({required this.numero, required this.centroCustoId, required this.categoriaId, required this.valor}): super._();
  

@override final  int numero;
 final  String centroCustoId;
 final  String categoriaId;
@override final  double valor;

/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoItemStandardCopyWith<LancamentoItemStandard> get copyWith => _$LancamentoItemStandardCopyWithImpl<LancamentoItemStandard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoItemStandard&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.centroCustoId, centroCustoId) || other.centroCustoId == centroCustoId)&&(identical(other.categoriaId, categoriaId) || other.categoriaId == categoriaId)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,numero,centroCustoId,categoriaId,valor);

@override
String toString() {
  return 'LancamentoItem(numero: $numero, centroCustoId: $centroCustoId, categoriaId: $categoriaId, valor: $valor)';
}


}

/// @nodoc
abstract mixin class $LancamentoItemStandardCopyWith<$Res> implements $LancamentoItemCopyWith<$Res> {
  factory $LancamentoItemStandardCopyWith(LancamentoItemStandard value, $Res Function(LancamentoItemStandard) _then) = _$LancamentoItemStandardCopyWithImpl;
@override @useResult
$Res call({
 int numero, String centroCustoId, String categoriaId, double valor
});




}
/// @nodoc
class _$LancamentoItemStandardCopyWithImpl<$Res>
    implements $LancamentoItemStandardCopyWith<$Res> {
  _$LancamentoItemStandardCopyWithImpl(this._self, this._then);

  final LancamentoItemStandard _self;
  final $Res Function(LancamentoItemStandard) _then;

/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? numero = null,Object? centroCustoId = null,Object? categoriaId = null,Object? valor = null,}) {
  return _then(LancamentoItemStandard(
numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,centroCustoId: null == centroCustoId ? _self.centroCustoId : centroCustoId // ignore: cast_nullable_to_non_nullable
as String,categoriaId: null == categoriaId ? _self.categoriaId : categoriaId // ignore: cast_nullable_to_non_nullable
as String,valor: null == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class LancamentoItemTransferencia extends LancamentoItem {
  const LancamentoItemTransferencia({required this.numero, required this.origemEntrada, required this.origemSaida, required this.valor}): super._();
  

@override final  int numero;
 final  LancamentoOrigem origemEntrada;
 final  LancamentoOrigem origemSaida;
@override final  double valor;

/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoItemTransferenciaCopyWith<LancamentoItemTransferencia> get copyWith => _$LancamentoItemTransferenciaCopyWithImpl<LancamentoItemTransferencia>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoItemTransferencia&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.origemEntrada, origemEntrada) || other.origemEntrada == origemEntrada)&&(identical(other.origemSaida, origemSaida) || other.origemSaida == origemSaida)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,numero,origemEntrada,origemSaida,valor);

@override
String toString() {
  return 'LancamentoItem.transferencia(numero: $numero, origemEntrada: $origemEntrada, origemSaida: $origemSaida, valor: $valor)';
}


}

/// @nodoc
abstract mixin class $LancamentoItemTransferenciaCopyWith<$Res> implements $LancamentoItemCopyWith<$Res> {
  factory $LancamentoItemTransferenciaCopyWith(LancamentoItemTransferencia value, $Res Function(LancamentoItemTransferencia) _then) = _$LancamentoItemTransferenciaCopyWithImpl;
@override @useResult
$Res call({
 int numero, LancamentoOrigem origemEntrada, LancamentoOrigem origemSaida, double valor
});


$LancamentoOrigemCopyWith<$Res> get origemEntrada;$LancamentoOrigemCopyWith<$Res> get origemSaida;

}
/// @nodoc
class _$LancamentoItemTransferenciaCopyWithImpl<$Res>
    implements $LancamentoItemTransferenciaCopyWith<$Res> {
  _$LancamentoItemTransferenciaCopyWithImpl(this._self, this._then);

  final LancamentoItemTransferencia _self;
  final $Res Function(LancamentoItemTransferencia) _then;

/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? numero = null,Object? origemEntrada = null,Object? origemSaida = null,Object? valor = null,}) {
  return _then(LancamentoItemTransferencia(
numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,origemEntrada: null == origemEntrada ? _self.origemEntrada : origemEntrada // ignore: cast_nullable_to_non_nullable
as LancamentoOrigem,origemSaida: null == origemSaida ? _self.origemSaida : origemSaida // ignore: cast_nullable_to_non_nullable
as LancamentoOrigem,valor: null == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoOrigemCopyWith<$Res> get origemEntrada {
  
  return $LancamentoOrigemCopyWith<$Res>(_self.origemEntrada, (value) {
    return _then(_self.copyWith(origemEntrada: value));
  });
}/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoOrigemCopyWith<$Res> get origemSaida {
  
  return $LancamentoOrigemCopyWith<$Res>(_self.origemSaida, (value) {
    return _then(_self.copyWith(origemSaida: value));
  });
}
}

/// @nodoc
mixin _$LancamentoItemDetails {

 int get numero; double get valor;
/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoItemDetailsCopyWith<LancamentoItemDetails> get copyWith => _$LancamentoItemDetailsCopyWithImpl<LancamentoItemDetails>(this as LancamentoItemDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoItemDetails&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,numero,valor);

@override
String toString() {
  return 'LancamentoItemDetails(numero: $numero, valor: $valor)';
}


}

/// @nodoc
abstract mixin class $LancamentoItemDetailsCopyWith<$Res>  {
  factory $LancamentoItemDetailsCopyWith(LancamentoItemDetails value, $Res Function(LancamentoItemDetails) _then) = _$LancamentoItemDetailsCopyWithImpl;
@useResult
$Res call({
 int numero, double valor
});




}
/// @nodoc
class _$LancamentoItemDetailsCopyWithImpl<$Res>
    implements $LancamentoItemDetailsCopyWith<$Res> {
  _$LancamentoItemDetailsCopyWithImpl(this._self, this._then);

  final LancamentoItemDetails _self;
  final $Res Function(LancamentoItemDetails) _then;

/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? numero = null,Object? valor = null,}) {
  return _then(_self.copyWith(
numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,valor: null == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LancamentoItemDetails].
extension LancamentoItemDetailsPatterns on LancamentoItemDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( LancamentoItemDetailsStandard value)?  $default,{TResult Function( LancamentoItemDetailsTransferencia value)?  transferencia,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LancamentoItemDetailsStandard() when $default != null:
return $default(_that);case LancamentoItemDetailsTransferencia() when transferencia != null:
return transferencia(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( LancamentoItemDetailsStandard value)  $default,{required TResult Function( LancamentoItemDetailsTransferencia value)  transferencia,}){
final _that = this;
switch (_that) {
case LancamentoItemDetailsStandard():
return $default(_that);case LancamentoItemDetailsTransferencia():
return transferencia(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( LancamentoItemDetailsStandard value)?  $default,{TResult? Function( LancamentoItemDetailsTransferencia value)?  transferencia,}){
final _that = this;
switch (_that) {
case LancamentoItemDetailsStandard() when $default != null:
return $default(_that);case LancamentoItemDetailsTransferencia() when transferencia != null:
return transferencia(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int numero,  CentroCustoDetails centroCusto,  CategoriaDetails categoria,  double valor)?  $default,{TResult Function( int numero,  LancamentoOrigemDetail origemEntrada,  LancamentoOrigemDetail origemSaida,  double valor)?  transferencia,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LancamentoItemDetailsStandard() when $default != null:
return $default(_that.numero,_that.centroCusto,_that.categoria,_that.valor);case LancamentoItemDetailsTransferencia() when transferencia != null:
return transferencia(_that.numero,_that.origemEntrada,_that.origemSaida,_that.valor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int numero,  CentroCustoDetails centroCusto,  CategoriaDetails categoria,  double valor)  $default,{required TResult Function( int numero,  LancamentoOrigemDetail origemEntrada,  LancamentoOrigemDetail origemSaida,  double valor)  transferencia,}) {final _that = this;
switch (_that) {
case LancamentoItemDetailsStandard():
return $default(_that.numero,_that.centroCusto,_that.categoria,_that.valor);case LancamentoItemDetailsTransferencia():
return transferencia(_that.numero,_that.origemEntrada,_that.origemSaida,_that.valor);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int numero,  CentroCustoDetails centroCusto,  CategoriaDetails categoria,  double valor)?  $default,{TResult? Function( int numero,  LancamentoOrigemDetail origemEntrada,  LancamentoOrigemDetail origemSaida,  double valor)?  transferencia,}) {final _that = this;
switch (_that) {
case LancamentoItemDetailsStandard() when $default != null:
return $default(_that.numero,_that.centroCusto,_that.categoria,_that.valor);case LancamentoItemDetailsTransferencia() when transferencia != null:
return transferencia(_that.numero,_that.origemEntrada,_that.origemSaida,_that.valor);case _:
  return null;

}
}

}

/// @nodoc


class LancamentoItemDetailsStandard extends LancamentoItemDetails {
  const LancamentoItemDetailsStandard({required this.numero, required this.centroCusto, required this.categoria, required this.valor}): super._();
  

@override final  int numero;
 final  CentroCustoDetails centroCusto;
 final  CategoriaDetails categoria;
@override final  double valor;

/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoItemDetailsStandardCopyWith<LancamentoItemDetailsStandard> get copyWith => _$LancamentoItemDetailsStandardCopyWithImpl<LancamentoItemDetailsStandard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoItemDetailsStandard&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.centroCusto, centroCusto) || other.centroCusto == centroCusto)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,numero,centroCusto,categoria,valor);

@override
String toString() {
  return 'LancamentoItemDetails(numero: $numero, centroCusto: $centroCusto, categoria: $categoria, valor: $valor)';
}


}

/// @nodoc
abstract mixin class $LancamentoItemDetailsStandardCopyWith<$Res> implements $LancamentoItemDetailsCopyWith<$Res> {
  factory $LancamentoItemDetailsStandardCopyWith(LancamentoItemDetailsStandard value, $Res Function(LancamentoItemDetailsStandard) _then) = _$LancamentoItemDetailsStandardCopyWithImpl;
@override @useResult
$Res call({
 int numero, CentroCustoDetails centroCusto, CategoriaDetails categoria, double valor
});


$CentroCustoDetailsCopyWith<$Res> get centroCusto;$CategoriaDetailsCopyWith<$Res> get categoria;

}
/// @nodoc
class _$LancamentoItemDetailsStandardCopyWithImpl<$Res>
    implements $LancamentoItemDetailsStandardCopyWith<$Res> {
  _$LancamentoItemDetailsStandardCopyWithImpl(this._self, this._then);

  final LancamentoItemDetailsStandard _self;
  final $Res Function(LancamentoItemDetailsStandard) _then;

/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? numero = null,Object? centroCusto = null,Object? categoria = null,Object? valor = null,}) {
  return _then(LancamentoItemDetailsStandard(
numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,centroCusto: null == centroCusto ? _self.centroCusto : centroCusto // ignore: cast_nullable_to_non_nullable
as CentroCustoDetails,categoria: null == categoria ? _self.categoria : categoria // ignore: cast_nullable_to_non_nullable
as CategoriaDetails,valor: null == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CentroCustoDetailsCopyWith<$Res> get centroCusto {
  
  return $CentroCustoDetailsCopyWith<$Res>(_self.centroCusto, (value) {
    return _then(_self.copyWith(centroCusto: value));
  });
}/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoriaDetailsCopyWith<$Res> get categoria {
  
  return $CategoriaDetailsCopyWith<$Res>(_self.categoria, (value) {
    return _then(_self.copyWith(categoria: value));
  });
}
}

/// @nodoc


class LancamentoItemDetailsTransferencia extends LancamentoItemDetails {
  const LancamentoItemDetailsTransferencia({required this.numero, required this.origemEntrada, required this.origemSaida, required this.valor}): super._();
  

@override final  int numero;
 final  LancamentoOrigemDetail origemEntrada;
 final  LancamentoOrigemDetail origemSaida;
@override final  double valor;

/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoItemDetailsTransferenciaCopyWith<LancamentoItemDetailsTransferencia> get copyWith => _$LancamentoItemDetailsTransferenciaCopyWithImpl<LancamentoItemDetailsTransferencia>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoItemDetailsTransferencia&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.origemEntrada, origemEntrada) || other.origemEntrada == origemEntrada)&&(identical(other.origemSaida, origemSaida) || other.origemSaida == origemSaida)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,numero,origemEntrada,origemSaida,valor);

@override
String toString() {
  return 'LancamentoItemDetails.transferencia(numero: $numero, origemEntrada: $origemEntrada, origemSaida: $origemSaida, valor: $valor)';
}


}

/// @nodoc
abstract mixin class $LancamentoItemDetailsTransferenciaCopyWith<$Res> implements $LancamentoItemDetailsCopyWith<$Res> {
  factory $LancamentoItemDetailsTransferenciaCopyWith(LancamentoItemDetailsTransferencia value, $Res Function(LancamentoItemDetailsTransferencia) _then) = _$LancamentoItemDetailsTransferenciaCopyWithImpl;
@override @useResult
$Res call({
 int numero, LancamentoOrigemDetail origemEntrada, LancamentoOrigemDetail origemSaida, double valor
});


$LancamentoOrigemDetailCopyWith<$Res> get origemEntrada;$LancamentoOrigemDetailCopyWith<$Res> get origemSaida;

}
/// @nodoc
class _$LancamentoItemDetailsTransferenciaCopyWithImpl<$Res>
    implements $LancamentoItemDetailsTransferenciaCopyWith<$Res> {
  _$LancamentoItemDetailsTransferenciaCopyWithImpl(this._self, this._then);

  final LancamentoItemDetailsTransferencia _self;
  final $Res Function(LancamentoItemDetailsTransferencia) _then;

/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? numero = null,Object? origemEntrada = null,Object? origemSaida = null,Object? valor = null,}) {
  return _then(LancamentoItemDetailsTransferencia(
numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,origemEntrada: null == origemEntrada ? _self.origemEntrada : origemEntrada // ignore: cast_nullable_to_non_nullable
as LancamentoOrigemDetail,origemSaida: null == origemSaida ? _self.origemSaida : origemSaida // ignore: cast_nullable_to_non_nullable
as LancamentoOrigemDetail,valor: null == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoOrigemDetailCopyWith<$Res> get origemEntrada {
  
  return $LancamentoOrigemDetailCopyWith<$Res>(_self.origemEntrada, (value) {
    return _then(_self.copyWith(origemEntrada: value));
  });
}/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoOrigemDetailCopyWith<$Res> get origemSaida {
  
  return $LancamentoOrigemDetailCopyWith<$Res>(_self.origemSaida, (value) {
    return _then(_self.copyWith(origemSaida: value));
  });
}
}

// dart format on
