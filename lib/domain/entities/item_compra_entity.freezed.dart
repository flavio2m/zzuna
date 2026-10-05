// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_compra_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupermercadoItem {

 String get nome; bool get ultimoUtilizado;
/// Create a copy of SupermercadoItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupermercadoItemCopyWith<SupermercadoItem> get copyWith => _$SupermercadoItemCopyWithImpl<SupermercadoItem>(this as SupermercadoItem, _$identity);

  /// Serializes this SupermercadoItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupermercadoItem&&(identical(other.nome, nome) || other.nome == nome)&&(identical(other.ultimoUtilizado, ultimoUtilizado) || other.ultimoUtilizado == ultimoUtilizado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nome,ultimoUtilizado);

@override
String toString() {
  return 'SupermercadoItem(nome: $nome, ultimoUtilizado: $ultimoUtilizado)';
}


}

/// @nodoc
abstract mixin class $SupermercadoItemCopyWith<$Res>  {
  factory $SupermercadoItemCopyWith(SupermercadoItem value, $Res Function(SupermercadoItem) _then) = _$SupermercadoItemCopyWithImpl;
@useResult
$Res call({
 String nome, bool ultimoUtilizado
});




}
/// @nodoc
class _$SupermercadoItemCopyWithImpl<$Res>
    implements $SupermercadoItemCopyWith<$Res> {
  _$SupermercadoItemCopyWithImpl(this._self, this._then);

  final SupermercadoItem _self;
  final $Res Function(SupermercadoItem) _then;

/// Create a copy of SupermercadoItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nome = null,Object? ultimoUtilizado = null,}) {
  return _then(_self.copyWith(
nome: null == nome ? _self.nome : nome // ignore: cast_nullable_to_non_nullable
as String,ultimoUtilizado: null == ultimoUtilizado ? _self.ultimoUtilizado : ultimoUtilizado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SupermercadoItem].
extension SupermercadoItemPatterns on SupermercadoItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupermercadoItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupermercadoItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupermercadoItem value)  $default,){
final _that = this;
switch (_that) {
case _SupermercadoItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupermercadoItem value)?  $default,){
final _that = this;
switch (_that) {
case _SupermercadoItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nome,  bool ultimoUtilizado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupermercadoItem() when $default != null:
return $default(_that.nome,_that.ultimoUtilizado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nome,  bool ultimoUtilizado)  $default,) {final _that = this;
switch (_that) {
case _SupermercadoItem():
return $default(_that.nome,_that.ultimoUtilizado);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nome,  bool ultimoUtilizado)?  $default,) {final _that = this;
switch (_that) {
case _SupermercadoItem() when $default != null:
return $default(_that.nome,_that.ultimoUtilizado);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupermercadoItem implements SupermercadoItem {
  const _SupermercadoItem({required this.nome, this.ultimoUtilizado = false});
  factory _SupermercadoItem.fromJson(Map<String, dynamic> json) => _$SupermercadoItemFromJson(json);

@override final  String nome;
@override@JsonKey() final  bool ultimoUtilizado;

/// Create a copy of SupermercadoItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupermercadoItemCopyWith<_SupermercadoItem> get copyWith => __$SupermercadoItemCopyWithImpl<_SupermercadoItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupermercadoItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupermercadoItem&&(identical(other.nome, nome) || other.nome == nome)&&(identical(other.ultimoUtilizado, ultimoUtilizado) || other.ultimoUtilizado == ultimoUtilizado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nome,ultimoUtilizado);

@override
String toString() {
  return 'SupermercadoItem(nome: $nome, ultimoUtilizado: $ultimoUtilizado)';
}


}

/// @nodoc
abstract mixin class _$SupermercadoItemCopyWith<$Res> implements $SupermercadoItemCopyWith<$Res> {
  factory _$SupermercadoItemCopyWith(_SupermercadoItem value, $Res Function(_SupermercadoItem) _then) = __$SupermercadoItemCopyWithImpl;
@override @useResult
$Res call({
 String nome, bool ultimoUtilizado
});




}
/// @nodoc
class __$SupermercadoItemCopyWithImpl<$Res>
    implements _$SupermercadoItemCopyWith<$Res> {
  __$SupermercadoItemCopyWithImpl(this._self, this._then);

  final _SupermercadoItem _self;
  final $Res Function(_SupermercadoItem) _then;

/// Create a copy of SupermercadoItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nome = null,Object? ultimoUtilizado = null,}) {
  return _then(_SupermercadoItem(
nome: null == nome ? _self.nome : nome // ignore: cast_nullable_to_non_nullable
as String,ultimoUtilizado: null == ultimoUtilizado ? _self.ultimoUtilizado : ultimoUtilizado // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ItemCompra {

 String get id; String get produto; double get quantidadePlanejada; List<RegistroCompra> get historicoCompras; double get precoEstimado; List<SupermercadoItem> get supermercados; ItemCompraSituacao get situacao; String get observacao;@JsonKey(name: 'quantidadeComprada') double get quantidadeCompradaLegada;
/// Create a copy of ItemCompra
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCompraCopyWith<ItemCompra> get copyWith => _$ItemCompraCopyWithImpl<ItemCompra>(this as ItemCompra, _$identity);

  /// Serializes this ItemCompra to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemCompra&&(identical(other.id, id) || other.id == id)&&(identical(other.produto, produto) || other.produto == produto)&&(identical(other.quantidadePlanejada, quantidadePlanejada) || other.quantidadePlanejada == quantidadePlanejada)&&const DeepCollectionEquality().equals(other.historicoCompras, historicoCompras)&&(identical(other.precoEstimado, precoEstimado) || other.precoEstimado == precoEstimado)&&const DeepCollectionEquality().equals(other.supermercados, supermercados)&&(identical(other.situacao, situacao) || other.situacao == situacao)&&(identical(other.observacao, observacao) || other.observacao == observacao)&&(identical(other.quantidadeCompradaLegada, quantidadeCompradaLegada) || other.quantidadeCompradaLegada == quantidadeCompradaLegada));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,produto,quantidadePlanejada,const DeepCollectionEquality().hash(historicoCompras),precoEstimado,const DeepCollectionEquality().hash(supermercados),situacao,observacao,quantidadeCompradaLegada);

@override
String toString() {
  return 'ItemCompra(id: $id, produto: $produto, quantidadePlanejada: $quantidadePlanejada, historicoCompras: $historicoCompras, precoEstimado: $precoEstimado, supermercados: $supermercados, situacao: $situacao, observacao: $observacao, quantidadeCompradaLegada: $quantidadeCompradaLegada)';
}


}

/// @nodoc
abstract mixin class $ItemCompraCopyWith<$Res>  {
  factory $ItemCompraCopyWith(ItemCompra value, $Res Function(ItemCompra) _then) = _$ItemCompraCopyWithImpl;
@useResult
$Res call({
 String id, String produto, double quantidadePlanejada, List<RegistroCompra> historicoCompras, double precoEstimado, List<SupermercadoItem> supermercados, ItemCompraSituacao situacao, String observacao,@JsonKey(name: 'quantidadeComprada') double quantidadeCompradaLegada
});




}
/// @nodoc
class _$ItemCompraCopyWithImpl<$Res>
    implements $ItemCompraCopyWith<$Res> {
  _$ItemCompraCopyWithImpl(this._self, this._then);

  final ItemCompra _self;
  final $Res Function(ItemCompra) _then;

/// Create a copy of ItemCompra
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? produto = null,Object? quantidadePlanejada = null,Object? historicoCompras = null,Object? precoEstimado = null,Object? supermercados = null,Object? situacao = null,Object? observacao = null,Object? quantidadeCompradaLegada = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,produto: null == produto ? _self.produto : produto // ignore: cast_nullable_to_non_nullable
as String,quantidadePlanejada: null == quantidadePlanejada ? _self.quantidadePlanejada : quantidadePlanejada // ignore: cast_nullable_to_non_nullable
as double,historicoCompras: null == historicoCompras ? _self.historicoCompras : historicoCompras // ignore: cast_nullable_to_non_nullable
as List<RegistroCompra>,precoEstimado: null == precoEstimado ? _self.precoEstimado : precoEstimado // ignore: cast_nullable_to_non_nullable
as double,supermercados: null == supermercados ? _self.supermercados : supermercados // ignore: cast_nullable_to_non_nullable
as List<SupermercadoItem>,situacao: null == situacao ? _self.situacao : situacao // ignore: cast_nullable_to_non_nullable
as ItemCompraSituacao,observacao: null == observacao ? _self.observacao : observacao // ignore: cast_nullable_to_non_nullable
as String,quantidadeCompradaLegada: null == quantidadeCompradaLegada ? _self.quantidadeCompradaLegada : quantidadeCompradaLegada // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemCompra].
extension ItemCompraPatterns on ItemCompra {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemCompra value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemCompra() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemCompra value)  $default,){
final _that = this;
switch (_that) {
case _ItemCompra():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemCompra value)?  $default,){
final _that = this;
switch (_that) {
case _ItemCompra() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String produto,  double quantidadePlanejada,  List<RegistroCompra> historicoCompras,  double precoEstimado,  List<SupermercadoItem> supermercados,  ItemCompraSituacao situacao,  String observacao, @JsonKey(name: 'quantidadeComprada')  double quantidadeCompradaLegada)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemCompra() when $default != null:
return $default(_that.id,_that.produto,_that.quantidadePlanejada,_that.historicoCompras,_that.precoEstimado,_that.supermercados,_that.situacao,_that.observacao,_that.quantidadeCompradaLegada);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String produto,  double quantidadePlanejada,  List<RegistroCompra> historicoCompras,  double precoEstimado,  List<SupermercadoItem> supermercados,  ItemCompraSituacao situacao,  String observacao, @JsonKey(name: 'quantidadeComprada')  double quantidadeCompradaLegada)  $default,) {final _that = this;
switch (_that) {
case _ItemCompra():
return $default(_that.id,_that.produto,_that.quantidadePlanejada,_that.historicoCompras,_that.precoEstimado,_that.supermercados,_that.situacao,_that.observacao,_that.quantidadeCompradaLegada);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String produto,  double quantidadePlanejada,  List<RegistroCompra> historicoCompras,  double precoEstimado,  List<SupermercadoItem> supermercados,  ItemCompraSituacao situacao,  String observacao, @JsonKey(name: 'quantidadeComprada')  double quantidadeCompradaLegada)?  $default,) {final _that = this;
switch (_that) {
case _ItemCompra() when $default != null:
return $default(_that.id,_that.produto,_that.quantidadePlanejada,_that.historicoCompras,_that.precoEstimado,_that.supermercados,_that.situacao,_that.observacao,_that.quantidadeCompradaLegada);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemCompra extends ItemCompra {
  const _ItemCompra({required this.id, required this.produto, this.quantidadePlanejada = 1.0, final  List<RegistroCompra> historicoCompras = const [], this.precoEstimado = 0.0, final  List<SupermercadoItem> supermercados = const [], this.situacao = ItemCompraSituacao.pendente, this.observacao = '', @JsonKey(name: 'quantidadeComprada') this.quantidadeCompradaLegada = 0.0}): _historicoCompras = historicoCompras,_supermercados = supermercados,super._();
  factory _ItemCompra.fromJson(Map<String, dynamic> json) => _$ItemCompraFromJson(json);

@override final  String id;
@override final  String produto;
@override@JsonKey() final  double quantidadePlanejada;
 final  List<RegistroCompra> _historicoCompras;
@override@JsonKey() List<RegistroCompra> get historicoCompras {
  if (_historicoCompras is EqualUnmodifiableListView) return _historicoCompras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_historicoCompras);
}

@override@JsonKey() final  double precoEstimado;
 final  List<SupermercadoItem> _supermercados;
@override@JsonKey() List<SupermercadoItem> get supermercados {
  if (_supermercados is EqualUnmodifiableListView) return _supermercados;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supermercados);
}

@override@JsonKey() final  ItemCompraSituacao situacao;
@override@JsonKey() final  String observacao;
@override@JsonKey(name: 'quantidadeComprada') final  double quantidadeCompradaLegada;

/// Create a copy of ItemCompra
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCompraCopyWith<_ItemCompra> get copyWith => __$ItemCompraCopyWithImpl<_ItemCompra>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemCompraToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemCompra&&(identical(other.id, id) || other.id == id)&&(identical(other.produto, produto) || other.produto == produto)&&(identical(other.quantidadePlanejada, quantidadePlanejada) || other.quantidadePlanejada == quantidadePlanejada)&&const DeepCollectionEquality().equals(other._historicoCompras, _historicoCompras)&&(identical(other.precoEstimado, precoEstimado) || other.precoEstimado == precoEstimado)&&const DeepCollectionEquality().equals(other._supermercados, _supermercados)&&(identical(other.situacao, situacao) || other.situacao == situacao)&&(identical(other.observacao, observacao) || other.observacao == observacao)&&(identical(other.quantidadeCompradaLegada, quantidadeCompradaLegada) || other.quantidadeCompradaLegada == quantidadeCompradaLegada));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,produto,quantidadePlanejada,const DeepCollectionEquality().hash(_historicoCompras),precoEstimado,const DeepCollectionEquality().hash(_supermercados),situacao,observacao,quantidadeCompradaLegada);

@override
String toString() {
  return 'ItemCompra(id: $id, produto: $produto, quantidadePlanejada: $quantidadePlanejada, historicoCompras: $historicoCompras, precoEstimado: $precoEstimado, supermercados: $supermercados, situacao: $situacao, observacao: $observacao, quantidadeCompradaLegada: $quantidadeCompradaLegada)';
}


}

/// @nodoc
abstract mixin class _$ItemCompraCopyWith<$Res> implements $ItemCompraCopyWith<$Res> {
  factory _$ItemCompraCopyWith(_ItemCompra value, $Res Function(_ItemCompra) _then) = __$ItemCompraCopyWithImpl;
@override @useResult
$Res call({
 String id, String produto, double quantidadePlanejada, List<RegistroCompra> historicoCompras, double precoEstimado, List<SupermercadoItem> supermercados, ItemCompraSituacao situacao, String observacao,@JsonKey(name: 'quantidadeComprada') double quantidadeCompradaLegada
});




}
/// @nodoc
class __$ItemCompraCopyWithImpl<$Res>
    implements _$ItemCompraCopyWith<$Res> {
  __$ItemCompraCopyWithImpl(this._self, this._then);

  final _ItemCompra _self;
  final $Res Function(_ItemCompra) _then;

/// Create a copy of ItemCompra
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? produto = null,Object? quantidadePlanejada = null,Object? historicoCompras = null,Object? precoEstimado = null,Object? supermercados = null,Object? situacao = null,Object? observacao = null,Object? quantidadeCompradaLegada = null,}) {
  return _then(_ItemCompra(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,produto: null == produto ? _self.produto : produto // ignore: cast_nullable_to_non_nullable
as String,quantidadePlanejada: null == quantidadePlanejada ? _self.quantidadePlanejada : quantidadePlanejada // ignore: cast_nullable_to_non_nullable
as double,historicoCompras: null == historicoCompras ? _self._historicoCompras : historicoCompras // ignore: cast_nullable_to_non_nullable
as List<RegistroCompra>,precoEstimado: null == precoEstimado ? _self.precoEstimado : precoEstimado // ignore: cast_nullable_to_non_nullable
as double,supermercados: null == supermercados ? _self._supermercados : supermercados // ignore: cast_nullable_to_non_nullable
as List<SupermercadoItem>,situacao: null == situacao ? _self.situacao : situacao // ignore: cast_nullable_to_non_nullable
as ItemCompraSituacao,observacao: null == observacao ? _self.observacao : observacao // ignore: cast_nullable_to_non_nullable
as String,quantidadeCompradaLegada: null == quantidadeCompradaLegada ? _self.quantidadeCompradaLegada : quantidadeCompradaLegada // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
