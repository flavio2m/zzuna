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

 int get numero; String get centroCustoId; String get categoriaId; double get valor;
/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoItemCopyWith<LancamentoItem> get copyWith => _$LancamentoItemCopyWithImpl<LancamentoItem>(this as LancamentoItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoItem&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.centroCustoId, centroCustoId) || other.centroCustoId == centroCustoId)&&(identical(other.categoriaId, categoriaId) || other.categoriaId == categoriaId)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,numero,centroCustoId,categoriaId,valor);

@override
String toString() {
  return 'LancamentoItem(numero: $numero, centroCustoId: $centroCustoId, categoriaId: $categoriaId, valor: $valor)';
}


}

/// @nodoc
abstract mixin class $LancamentoItemCopyWith<$Res>  {
  factory $LancamentoItemCopyWith(LancamentoItem value, $Res Function(LancamentoItem) _then) = _$LancamentoItemCopyWithImpl;
@useResult
$Res call({
 int numero, String centroCustoId, String categoriaId, double valor
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
@pragma('vm:prefer-inline') @override $Res call({Object? numero = null,Object? centroCustoId = null,Object? categoriaId = null,Object? valor = null,}) {
  return _then(_self.copyWith(
numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,centroCustoId: null == centroCustoId ? _self.centroCustoId : centroCustoId // ignore: cast_nullable_to_non_nullable
as String,categoriaId: null == categoriaId ? _self.categoriaId : categoriaId // ignore: cast_nullable_to_non_nullable
as String,valor: null == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LancamentoItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LancamentoItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LancamentoItem value)  $default,){
final _that = this;
switch (_that) {
case _LancamentoItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LancamentoItem value)?  $default,){
final _that = this;
switch (_that) {
case _LancamentoItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int numero,  String centroCustoId,  String categoriaId,  double valor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LancamentoItem() when $default != null:
return $default(_that.numero,_that.centroCustoId,_that.categoriaId,_that.valor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int numero,  String centroCustoId,  String categoriaId,  double valor)  $default,) {final _that = this;
switch (_that) {
case _LancamentoItem():
return $default(_that.numero,_that.centroCustoId,_that.categoriaId,_that.valor);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int numero,  String centroCustoId,  String categoriaId,  double valor)?  $default,) {final _that = this;
switch (_that) {
case _LancamentoItem() when $default != null:
return $default(_that.numero,_that.centroCustoId,_that.categoriaId,_that.valor);case _:
  return null;

}
}

}

/// @nodoc


class _LancamentoItem extends LancamentoItem {
  const _LancamentoItem({required this.numero, required this.centroCustoId, required this.categoriaId, required this.valor}): super._();
  

@override final  int numero;
@override final  String centroCustoId;
@override final  String categoriaId;
@override final  double valor;

/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LancamentoItemCopyWith<_LancamentoItem> get copyWith => __$LancamentoItemCopyWithImpl<_LancamentoItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LancamentoItem&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.centroCustoId, centroCustoId) || other.centroCustoId == centroCustoId)&&(identical(other.categoriaId, categoriaId) || other.categoriaId == categoriaId)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,numero,centroCustoId,categoriaId,valor);

@override
String toString() {
  return 'LancamentoItem(numero: $numero, centroCustoId: $centroCustoId, categoriaId: $categoriaId, valor: $valor)';
}


}

/// @nodoc
abstract mixin class _$LancamentoItemCopyWith<$Res> implements $LancamentoItemCopyWith<$Res> {
  factory _$LancamentoItemCopyWith(_LancamentoItem value, $Res Function(_LancamentoItem) _then) = __$LancamentoItemCopyWithImpl;
@override @useResult
$Res call({
 int numero, String centroCustoId, String categoriaId, double valor
});




}
/// @nodoc
class __$LancamentoItemCopyWithImpl<$Res>
    implements _$LancamentoItemCopyWith<$Res> {
  __$LancamentoItemCopyWithImpl(this._self, this._then);

  final _LancamentoItem _self;
  final $Res Function(_LancamentoItem) _then;

/// Create a copy of LancamentoItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? numero = null,Object? centroCustoId = null,Object? categoriaId = null,Object? valor = null,}) {
  return _then(_LancamentoItem(
numero: null == numero ? _self.numero : numero // ignore: cast_nullable_to_non_nullable
as int,centroCustoId: null == centroCustoId ? _self.centroCustoId : centroCustoId // ignore: cast_nullable_to_non_nullable
as String,categoriaId: null == categoriaId ? _self.categoriaId : categoriaId // ignore: cast_nullable_to_non_nullable
as String,valor: null == valor ? _self.valor : valor // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$LancamentoItemDetails {

 int get numero; CentroCustoDetails get centroCusto; CategoriaDetails get categoria; double get valor;
/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoItemDetailsCopyWith<LancamentoItemDetails> get copyWith => _$LancamentoItemDetailsCopyWithImpl<LancamentoItemDetails>(this as LancamentoItemDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoItemDetails&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.centroCusto, centroCusto) || other.centroCusto == centroCusto)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,numero,centroCusto,categoria,valor);

@override
String toString() {
  return 'LancamentoItemDetails(numero: $numero, centroCusto: $centroCusto, categoria: $categoria, valor: $valor)';
}


}

/// @nodoc
abstract mixin class $LancamentoItemDetailsCopyWith<$Res>  {
  factory $LancamentoItemDetailsCopyWith(LancamentoItemDetails value, $Res Function(LancamentoItemDetails) _then) = _$LancamentoItemDetailsCopyWithImpl;
@useResult
$Res call({
 int numero, CentroCustoDetails centroCusto, CategoriaDetails categoria, double valor
});


$CentroCustoDetailsCopyWith<$Res> get centroCusto;$CategoriaDetailsCopyWith<$Res> get categoria;

}
/// @nodoc
class _$LancamentoItemDetailsCopyWithImpl<$Res>
    implements $LancamentoItemDetailsCopyWith<$Res> {
  _$LancamentoItemDetailsCopyWithImpl(this._self, this._then);

  final LancamentoItemDetails _self;
  final $Res Function(LancamentoItemDetails) _then;

/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? numero = null,Object? centroCusto = null,Object? categoria = null,Object? valor = null,}) {
  return _then(_self.copyWith(
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LancamentoItemDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LancamentoItemDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LancamentoItemDetails value)  $default,){
final _that = this;
switch (_that) {
case _LancamentoItemDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LancamentoItemDetails value)?  $default,){
final _that = this;
switch (_that) {
case _LancamentoItemDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int numero,  CentroCustoDetails centroCusto,  CategoriaDetails categoria,  double valor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LancamentoItemDetails() when $default != null:
return $default(_that.numero,_that.centroCusto,_that.categoria,_that.valor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int numero,  CentroCustoDetails centroCusto,  CategoriaDetails categoria,  double valor)  $default,) {final _that = this;
switch (_that) {
case _LancamentoItemDetails():
return $default(_that.numero,_that.centroCusto,_that.categoria,_that.valor);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int numero,  CentroCustoDetails centroCusto,  CategoriaDetails categoria,  double valor)?  $default,) {final _that = this;
switch (_that) {
case _LancamentoItemDetails() when $default != null:
return $default(_that.numero,_that.centroCusto,_that.categoria,_that.valor);case _:
  return null;

}
}

}

/// @nodoc


class _LancamentoItemDetails implements LancamentoItemDetails {
  const _LancamentoItemDetails({required this.numero, required this.centroCusto, required this.categoria, required this.valor});
  

@override final  int numero;
@override final  CentroCustoDetails centroCusto;
@override final  CategoriaDetails categoria;
@override final  double valor;

/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LancamentoItemDetailsCopyWith<_LancamentoItemDetails> get copyWith => __$LancamentoItemDetailsCopyWithImpl<_LancamentoItemDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LancamentoItemDetails&&(identical(other.numero, numero) || other.numero == numero)&&(identical(other.centroCusto, centroCusto) || other.centroCusto == centroCusto)&&(identical(other.categoria, categoria) || other.categoria == categoria)&&(identical(other.valor, valor) || other.valor == valor));
}


@override
int get hashCode => Object.hash(runtimeType,numero,centroCusto,categoria,valor);

@override
String toString() {
  return 'LancamentoItemDetails(numero: $numero, centroCusto: $centroCusto, categoria: $categoria, valor: $valor)';
}


}

/// @nodoc
abstract mixin class _$LancamentoItemDetailsCopyWith<$Res> implements $LancamentoItemDetailsCopyWith<$Res> {
  factory _$LancamentoItemDetailsCopyWith(_LancamentoItemDetails value, $Res Function(_LancamentoItemDetails) _then) = __$LancamentoItemDetailsCopyWithImpl;
@override @useResult
$Res call({
 int numero, CentroCustoDetails centroCusto, CategoriaDetails categoria, double valor
});


@override $CentroCustoDetailsCopyWith<$Res> get centroCusto;@override $CategoriaDetailsCopyWith<$Res> get categoria;

}
/// @nodoc
class __$LancamentoItemDetailsCopyWithImpl<$Res>
    implements _$LancamentoItemDetailsCopyWith<$Res> {
  __$LancamentoItemDetailsCopyWithImpl(this._self, this._then);

  final _LancamentoItemDetails _self;
  final $Res Function(_LancamentoItemDetails) _then;

/// Create a copy of LancamentoItemDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? numero = null,Object? centroCusto = null,Object? categoria = null,Object? valor = null,}) {
  return _then(_LancamentoItemDetails(
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

// dart format on
