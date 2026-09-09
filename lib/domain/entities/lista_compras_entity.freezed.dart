// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lista_compras_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListaCompras {

 String get id; int get ano; Mes get mes; int get periodo; List<ItemCompra> get itens;
/// Create a copy of ListaCompras
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListaComprasCopyWith<ListaCompras> get copyWith => _$ListaComprasCopyWithImpl<ListaCompras>(this as ListaCompras, _$identity);

  /// Serializes this ListaCompras to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListaCompras&&(identical(other.id, id) || other.id == id)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.periodo, periodo) || other.periodo == periodo)&&const DeepCollectionEquality().equals(other.itens, itens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ano,mes,periodo,const DeepCollectionEquality().hash(itens));

@override
String toString() {
  return 'ListaCompras(id: $id, ano: $ano, mes: $mes, periodo: $periodo, itens: $itens)';
}


}

/// @nodoc
abstract mixin class $ListaComprasCopyWith<$Res>  {
  factory $ListaComprasCopyWith(ListaCompras value, $Res Function(ListaCompras) _then) = _$ListaComprasCopyWithImpl;
@useResult
$Res call({
 String id, int ano, Mes mes, int periodo, List<ItemCompra> itens
});




}
/// @nodoc
class _$ListaComprasCopyWithImpl<$Res>
    implements $ListaComprasCopyWith<$Res> {
  _$ListaComprasCopyWithImpl(this._self, this._then);

  final ListaCompras _self;
  final $Res Function(ListaCompras) _then;

/// Create a copy of ListaCompras
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ano = null,Object? mes = null,Object? periodo = null,Object? itens = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,periodo: null == periodo ? _self.periodo : periodo // ignore: cast_nullable_to_non_nullable
as int,itens: null == itens ? _self.itens : itens // ignore: cast_nullable_to_non_nullable
as List<ItemCompra>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListaCompras].
extension ListaComprasPatterns on ListaCompras {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListaCompras value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListaCompras() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListaCompras value)  $default,){
final _that = this;
switch (_that) {
case _ListaCompras():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListaCompras value)?  $default,){
final _that = this;
switch (_that) {
case _ListaCompras() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int ano,  Mes mes,  int periodo,  List<ItemCompra> itens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListaCompras() when $default != null:
return $default(_that.id,_that.ano,_that.mes,_that.periodo,_that.itens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int ano,  Mes mes,  int periodo,  List<ItemCompra> itens)  $default,) {final _that = this;
switch (_that) {
case _ListaCompras():
return $default(_that.id,_that.ano,_that.mes,_that.periodo,_that.itens);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int ano,  Mes mes,  int periodo,  List<ItemCompra> itens)?  $default,) {final _that = this;
switch (_that) {
case _ListaCompras() when $default != null:
return $default(_that.id,_that.ano,_that.mes,_that.periodo,_that.itens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListaCompras extends ListaCompras {
  const _ListaCompras({required this.id, required this.ano, required this.mes, required this.periodo, final  List<ItemCompra> itens = const []}): _itens = itens,super._();
  factory _ListaCompras.fromJson(Map<String, dynamic> json) => _$ListaComprasFromJson(json);

@override final  String id;
@override final  int ano;
@override final  Mes mes;
@override final  int periodo;
 final  List<ItemCompra> _itens;
@override@JsonKey() List<ItemCompra> get itens {
  if (_itens is EqualUnmodifiableListView) return _itens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itens);
}


/// Create a copy of ListaCompras
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListaComprasCopyWith<_ListaCompras> get copyWith => __$ListaComprasCopyWithImpl<_ListaCompras>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListaComprasToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListaCompras&&(identical(other.id, id) || other.id == id)&&(identical(other.ano, ano) || other.ano == ano)&&(identical(other.mes, mes) || other.mes == mes)&&(identical(other.periodo, periodo) || other.periodo == periodo)&&const DeepCollectionEquality().equals(other._itens, _itens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ano,mes,periodo,const DeepCollectionEquality().hash(_itens));

@override
String toString() {
  return 'ListaCompras(id: $id, ano: $ano, mes: $mes, periodo: $periodo, itens: $itens)';
}


}

/// @nodoc
abstract mixin class _$ListaComprasCopyWith<$Res> implements $ListaComprasCopyWith<$Res> {
  factory _$ListaComprasCopyWith(_ListaCompras value, $Res Function(_ListaCompras) _then) = __$ListaComprasCopyWithImpl;
@override @useResult
$Res call({
 String id, int ano, Mes mes, int periodo, List<ItemCompra> itens
});




}
/// @nodoc
class __$ListaComprasCopyWithImpl<$Res>
    implements _$ListaComprasCopyWith<$Res> {
  __$ListaComprasCopyWithImpl(this._self, this._then);

  final _ListaCompras _self;
  final $Res Function(_ListaCompras) _then;

/// Create a copy of ListaCompras
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ano = null,Object? mes = null,Object? periodo = null,Object? itens = null,}) {
  return _then(_ListaCompras(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ano: null == ano ? _self.ano : ano // ignore: cast_nullable_to_non_nullable
as int,mes: null == mes ? _self.mes : mes // ignore: cast_nullable_to_non_nullable
as Mes,periodo: null == periodo ? _self.periodo : periodo // ignore: cast_nullable_to_non_nullable
as int,itens: null == itens ? _self._itens : itens // ignore: cast_nullable_to_non_nullable
as List<ItemCompra>,
  ));
}


}

// dart format on
