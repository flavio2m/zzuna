// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lancamento_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lancamento {

 String get id; LancamentoTipo get tipo; DateTime get data; String get descricao; LancamentoReferencia get referencia; LancamentoOrigem get origem; List<LancamentoItem> get itens; bool get conciliado; String? get observacao;
/// Create a copy of Lancamento
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoCopyWith<Lancamento> get copyWith => _$LancamentoCopyWithImpl<Lancamento>(this as Lancamento, _$identity);

  /// Serializes this Lancamento to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lancamento&&(identical(other.id, id) || other.id == id)&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.data, data) || other.data == data)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.referencia, referencia) || other.referencia == referencia)&&(identical(other.origem, origem) || other.origem == origem)&&const DeepCollectionEquality().equals(other.itens, itens)&&(identical(other.conciliado, conciliado) || other.conciliado == conciliado)&&(identical(other.observacao, observacao) || other.observacao == observacao));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tipo,data,descricao,referencia,origem,const DeepCollectionEquality().hash(itens),conciliado,observacao);

@override
String toString() {
  return 'Lancamento(id: $id, tipo: $tipo, data: $data, descricao: $descricao, referencia: $referencia, origem: $origem, itens: $itens, conciliado: $conciliado, observacao: $observacao)';
}


}

/// @nodoc
abstract mixin class $LancamentoCopyWith<$Res>  {
  factory $LancamentoCopyWith(Lancamento value, $Res Function(Lancamento) _then) = _$LancamentoCopyWithImpl;
@useResult
$Res call({
 String id, LancamentoTipo tipo, DateTime data, String descricao, LancamentoReferencia referencia, LancamentoOrigem origem, List<LancamentoItem> itens, bool conciliado, String? observacao
});


$LancamentoReferenciaCopyWith<$Res> get referencia;$LancamentoOrigemCopyWith<$Res> get origem;

}
/// @nodoc
class _$LancamentoCopyWithImpl<$Res>
    implements $LancamentoCopyWith<$Res> {
  _$LancamentoCopyWithImpl(this._self, this._then);

  final Lancamento _self;
  final $Res Function(Lancamento) _then;

/// Create a copy of Lancamento
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tipo = null,Object? data = null,Object? descricao = null,Object? referencia = null,Object? origem = null,Object? itens = null,Object? conciliado = null,Object? observacao = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as LancamentoTipo,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DateTime,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,referencia: null == referencia ? _self.referencia : referencia // ignore: cast_nullable_to_non_nullable
as LancamentoReferencia,origem: null == origem ? _self.origem : origem // ignore: cast_nullable_to_non_nullable
as LancamentoOrigem,itens: null == itens ? _self.itens : itens // ignore: cast_nullable_to_non_nullable
as List<LancamentoItem>,conciliado: null == conciliado ? _self.conciliado : conciliado // ignore: cast_nullable_to_non_nullable
as bool,observacao: freezed == observacao ? _self.observacao : observacao // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Lancamento
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoReferenciaCopyWith<$Res> get referencia {
  
  return $LancamentoReferenciaCopyWith<$Res>(_self.referencia, (value) {
    return _then(_self.copyWith(referencia: value));
  });
}/// Create a copy of Lancamento
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoOrigemCopyWith<$Res> get origem {
  
  return $LancamentoOrigemCopyWith<$Res>(_self.origem, (value) {
    return _then(_self.copyWith(origem: value));
  });
}
}


/// Adds pattern-matching-related methods to [Lancamento].
extension LancamentoPatterns on Lancamento {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lancamento value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lancamento() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lancamento value)  $default,){
final _that = this;
switch (_that) {
case _Lancamento():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lancamento value)?  $default,){
final _that = this;
switch (_that) {
case _Lancamento() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LancamentoTipo tipo,  DateTime data,  String descricao,  LancamentoReferencia referencia,  LancamentoOrigem origem,  List<LancamentoItem> itens,  bool conciliado,  String? observacao)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lancamento() when $default != null:
return $default(_that.id,_that.tipo,_that.data,_that.descricao,_that.referencia,_that.origem,_that.itens,_that.conciliado,_that.observacao);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LancamentoTipo tipo,  DateTime data,  String descricao,  LancamentoReferencia referencia,  LancamentoOrigem origem,  List<LancamentoItem> itens,  bool conciliado,  String? observacao)  $default,) {final _that = this;
switch (_that) {
case _Lancamento():
return $default(_that.id,_that.tipo,_that.data,_that.descricao,_that.referencia,_that.origem,_that.itens,_that.conciliado,_that.observacao);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LancamentoTipo tipo,  DateTime data,  String descricao,  LancamentoReferencia referencia,  LancamentoOrigem origem,  List<LancamentoItem> itens,  bool conciliado,  String? observacao)?  $default,) {final _that = this;
switch (_that) {
case _Lancamento() when $default != null:
return $default(_that.id,_that.tipo,_that.data,_that.descricao,_that.referencia,_that.origem,_that.itens,_that.conciliado,_that.observacao);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lancamento implements Lancamento {
  const _Lancamento({required this.id, required this.tipo, required this.data, required this.descricao, required this.referencia, required this.origem, required final  List<LancamentoItem> itens, required this.conciliado, this.observacao}): _itens = itens;
  factory _Lancamento.fromJson(Map<String, dynamic> json) => _$LancamentoFromJson(json);

@override final  String id;
@override final  LancamentoTipo tipo;
@override final  DateTime data;
@override final  String descricao;
@override final  LancamentoReferencia referencia;
@override final  LancamentoOrigem origem;
 final  List<LancamentoItem> _itens;
@override List<LancamentoItem> get itens {
  if (_itens is EqualUnmodifiableListView) return _itens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itens);
}

@override final  bool conciliado;
@override final  String? observacao;

/// Create a copy of Lancamento
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LancamentoCopyWith<_Lancamento> get copyWith => __$LancamentoCopyWithImpl<_Lancamento>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LancamentoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lancamento&&(identical(other.id, id) || other.id == id)&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.data, data) || other.data == data)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.referencia, referencia) || other.referencia == referencia)&&(identical(other.origem, origem) || other.origem == origem)&&const DeepCollectionEquality().equals(other._itens, _itens)&&(identical(other.conciliado, conciliado) || other.conciliado == conciliado)&&(identical(other.observacao, observacao) || other.observacao == observacao));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tipo,data,descricao,referencia,origem,const DeepCollectionEquality().hash(_itens),conciliado,observacao);

@override
String toString() {
  return 'Lancamento(id: $id, tipo: $tipo, data: $data, descricao: $descricao, referencia: $referencia, origem: $origem, itens: $itens, conciliado: $conciliado, observacao: $observacao)';
}


}

/// @nodoc
abstract mixin class _$LancamentoCopyWith<$Res> implements $LancamentoCopyWith<$Res> {
  factory _$LancamentoCopyWith(_Lancamento value, $Res Function(_Lancamento) _then) = __$LancamentoCopyWithImpl;
@override @useResult
$Res call({
 String id, LancamentoTipo tipo, DateTime data, String descricao, LancamentoReferencia referencia, LancamentoOrigem origem, List<LancamentoItem> itens, bool conciliado, String? observacao
});


@override $LancamentoReferenciaCopyWith<$Res> get referencia;@override $LancamentoOrigemCopyWith<$Res> get origem;

}
/// @nodoc
class __$LancamentoCopyWithImpl<$Res>
    implements _$LancamentoCopyWith<$Res> {
  __$LancamentoCopyWithImpl(this._self, this._then);

  final _Lancamento _self;
  final $Res Function(_Lancamento) _then;

/// Create a copy of Lancamento
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tipo = null,Object? data = null,Object? descricao = null,Object? referencia = null,Object? origem = null,Object? itens = null,Object? conciliado = null,Object? observacao = freezed,}) {
  return _then(_Lancamento(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as LancamentoTipo,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DateTime,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,referencia: null == referencia ? _self.referencia : referencia // ignore: cast_nullable_to_non_nullable
as LancamentoReferencia,origem: null == origem ? _self.origem : origem // ignore: cast_nullable_to_non_nullable
as LancamentoOrigem,itens: null == itens ? _self._itens : itens // ignore: cast_nullable_to_non_nullable
as List<LancamentoItem>,conciliado: null == conciliado ? _self.conciliado : conciliado // ignore: cast_nullable_to_non_nullable
as bool,observacao: freezed == observacao ? _self.observacao : observacao // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Lancamento
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoReferenciaCopyWith<$Res> get referencia {
  
  return $LancamentoReferenciaCopyWith<$Res>(_self.referencia, (value) {
    return _then(_self.copyWith(referencia: value));
  });
}/// Create a copy of Lancamento
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
mixin _$LancamentoDetails {

 String get id; LancamentoTipo get tipo; DateTime get data; String get descricao; LancamentoReferenciaDetail get referencia; LancamentoOrigemDetail get origem; List<LancamentoItemDetails> get itens; bool get conciliado; String? get observacao;
/// Create a copy of LancamentoDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LancamentoDetailsCopyWith<LancamentoDetails> get copyWith => _$LancamentoDetailsCopyWithImpl<LancamentoDetails>(this as LancamentoDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LancamentoDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.data, data) || other.data == data)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.referencia, referencia) || other.referencia == referencia)&&(identical(other.origem, origem) || other.origem == origem)&&const DeepCollectionEquality().equals(other.itens, itens)&&(identical(other.conciliado, conciliado) || other.conciliado == conciliado)&&(identical(other.observacao, observacao) || other.observacao == observacao));
}


@override
int get hashCode => Object.hash(runtimeType,id,tipo,data,descricao,referencia,origem,const DeepCollectionEquality().hash(itens),conciliado,observacao);

@override
String toString() {
  return 'LancamentoDetails(id: $id, tipo: $tipo, data: $data, descricao: $descricao, referencia: $referencia, origem: $origem, itens: $itens, conciliado: $conciliado, observacao: $observacao)';
}


}

/// @nodoc
abstract mixin class $LancamentoDetailsCopyWith<$Res>  {
  factory $LancamentoDetailsCopyWith(LancamentoDetails value, $Res Function(LancamentoDetails) _then) = _$LancamentoDetailsCopyWithImpl;
@useResult
$Res call({
 String id, LancamentoTipo tipo, DateTime data, String descricao, LancamentoReferenciaDetail referencia, LancamentoOrigemDetail origem, List<LancamentoItemDetails> itens, bool conciliado, String? observacao
});


$LancamentoReferenciaDetailCopyWith<$Res> get referencia;$LancamentoOrigemDetailCopyWith<$Res> get origem;

}
/// @nodoc
class _$LancamentoDetailsCopyWithImpl<$Res>
    implements $LancamentoDetailsCopyWith<$Res> {
  _$LancamentoDetailsCopyWithImpl(this._self, this._then);

  final LancamentoDetails _self;
  final $Res Function(LancamentoDetails) _then;

/// Create a copy of LancamentoDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tipo = null,Object? data = null,Object? descricao = null,Object? referencia = null,Object? origem = null,Object? itens = null,Object? conciliado = null,Object? observacao = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as LancamentoTipo,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DateTime,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,referencia: null == referencia ? _self.referencia : referencia // ignore: cast_nullable_to_non_nullable
as LancamentoReferenciaDetail,origem: null == origem ? _self.origem : origem // ignore: cast_nullable_to_non_nullable
as LancamentoOrigemDetail,itens: null == itens ? _self.itens : itens // ignore: cast_nullable_to_non_nullable
as List<LancamentoItemDetails>,conciliado: null == conciliado ? _self.conciliado : conciliado // ignore: cast_nullable_to_non_nullable
as bool,observacao: freezed == observacao ? _self.observacao : observacao // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LancamentoDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoReferenciaDetailCopyWith<$Res> get referencia {
  
  return $LancamentoReferenciaDetailCopyWith<$Res>(_self.referencia, (value) {
    return _then(_self.copyWith(referencia: value));
  });
}/// Create a copy of LancamentoDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoOrigemDetailCopyWith<$Res> get origem {
  
  return $LancamentoOrigemDetailCopyWith<$Res>(_self.origem, (value) {
    return _then(_self.copyWith(origem: value));
  });
}
}


/// Adds pattern-matching-related methods to [LancamentoDetails].
extension LancamentoDetailsPatterns on LancamentoDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LancamentoDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LancamentoDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LancamentoDetails value)  $default,){
final _that = this;
switch (_that) {
case _LancamentoDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LancamentoDetails value)?  $default,){
final _that = this;
switch (_that) {
case _LancamentoDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LancamentoTipo tipo,  DateTime data,  String descricao,  LancamentoReferenciaDetail referencia,  LancamentoOrigemDetail origem,  List<LancamentoItemDetails> itens,  bool conciliado,  String? observacao)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LancamentoDetails() when $default != null:
return $default(_that.id,_that.tipo,_that.data,_that.descricao,_that.referencia,_that.origem,_that.itens,_that.conciliado,_that.observacao);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LancamentoTipo tipo,  DateTime data,  String descricao,  LancamentoReferenciaDetail referencia,  LancamentoOrigemDetail origem,  List<LancamentoItemDetails> itens,  bool conciliado,  String? observacao)  $default,) {final _that = this;
switch (_that) {
case _LancamentoDetails():
return $default(_that.id,_that.tipo,_that.data,_that.descricao,_that.referencia,_that.origem,_that.itens,_that.conciliado,_that.observacao);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LancamentoTipo tipo,  DateTime data,  String descricao,  LancamentoReferenciaDetail referencia,  LancamentoOrigemDetail origem,  List<LancamentoItemDetails> itens,  bool conciliado,  String? observacao)?  $default,) {final _that = this;
switch (_that) {
case _LancamentoDetails() when $default != null:
return $default(_that.id,_that.tipo,_that.data,_that.descricao,_that.referencia,_that.origem,_that.itens,_that.conciliado,_that.observacao);case _:
  return null;

}
}

}

/// @nodoc


class _LancamentoDetails extends LancamentoDetails {
  const _LancamentoDetails({required this.id, required this.tipo, required this.data, required this.descricao, required this.referencia, required this.origem, required final  List<LancamentoItemDetails> itens, required this.conciliado, this.observacao}): _itens = itens,super._();
  

@override final  String id;
@override final  LancamentoTipo tipo;
@override final  DateTime data;
@override final  String descricao;
@override final  LancamentoReferenciaDetail referencia;
@override final  LancamentoOrigemDetail origem;
 final  List<LancamentoItemDetails> _itens;
@override List<LancamentoItemDetails> get itens {
  if (_itens is EqualUnmodifiableListView) return _itens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itens);
}

@override final  bool conciliado;
@override final  String? observacao;

/// Create a copy of LancamentoDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LancamentoDetailsCopyWith<_LancamentoDetails> get copyWith => __$LancamentoDetailsCopyWithImpl<_LancamentoDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LancamentoDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.tipo, tipo) || other.tipo == tipo)&&(identical(other.data, data) || other.data == data)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.referencia, referencia) || other.referencia == referencia)&&(identical(other.origem, origem) || other.origem == origem)&&const DeepCollectionEquality().equals(other._itens, _itens)&&(identical(other.conciliado, conciliado) || other.conciliado == conciliado)&&(identical(other.observacao, observacao) || other.observacao == observacao));
}


@override
int get hashCode => Object.hash(runtimeType,id,tipo,data,descricao,referencia,origem,const DeepCollectionEquality().hash(_itens),conciliado,observacao);

@override
String toString() {
  return 'LancamentoDetails(id: $id, tipo: $tipo, data: $data, descricao: $descricao, referencia: $referencia, origem: $origem, itens: $itens, conciliado: $conciliado, observacao: $observacao)';
}


}

/// @nodoc
abstract mixin class _$LancamentoDetailsCopyWith<$Res> implements $LancamentoDetailsCopyWith<$Res> {
  factory _$LancamentoDetailsCopyWith(_LancamentoDetails value, $Res Function(_LancamentoDetails) _then) = __$LancamentoDetailsCopyWithImpl;
@override @useResult
$Res call({
 String id, LancamentoTipo tipo, DateTime data, String descricao, LancamentoReferenciaDetail referencia, LancamentoOrigemDetail origem, List<LancamentoItemDetails> itens, bool conciliado, String? observacao
});


@override $LancamentoReferenciaDetailCopyWith<$Res> get referencia;@override $LancamentoOrigemDetailCopyWith<$Res> get origem;

}
/// @nodoc
class __$LancamentoDetailsCopyWithImpl<$Res>
    implements _$LancamentoDetailsCopyWith<$Res> {
  __$LancamentoDetailsCopyWithImpl(this._self, this._then);

  final _LancamentoDetails _self;
  final $Res Function(_LancamentoDetails) _then;

/// Create a copy of LancamentoDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tipo = null,Object? data = null,Object? descricao = null,Object? referencia = null,Object? origem = null,Object? itens = null,Object? conciliado = null,Object? observacao = freezed,}) {
  return _then(_LancamentoDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tipo: null == tipo ? _self.tipo : tipo // ignore: cast_nullable_to_non_nullable
as LancamentoTipo,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DateTime,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,referencia: null == referencia ? _self.referencia : referencia // ignore: cast_nullable_to_non_nullable
as LancamentoReferenciaDetail,origem: null == origem ? _self.origem : origem // ignore: cast_nullable_to_non_nullable
as LancamentoOrigemDetail,itens: null == itens ? _self._itens : itens // ignore: cast_nullable_to_non_nullable
as List<LancamentoItemDetails>,conciliado: null == conciliado ? _self.conciliado : conciliado // ignore: cast_nullable_to_non_nullable
as bool,observacao: freezed == observacao ? _self.observacao : observacao // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LancamentoDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LancamentoReferenciaDetailCopyWith<$Res> get referencia {
  
  return $LancamentoReferenciaDetailCopyWith<$Res>(_self.referencia, (value) {
    return _then(_self.copyWith(referencia: value));
  });
}/// Create a copy of LancamentoDetails
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
