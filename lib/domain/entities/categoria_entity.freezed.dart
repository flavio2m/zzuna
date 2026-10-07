// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categoria_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Categoria {

 String get id; String get descricao; String? get categoriaPaiId; bool get ativo; double? get percentualOrcamento; CategoriaNatureza get natureza; String? get cor;
/// Create a copy of Categoria
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriaCopyWith<Categoria> get copyWith => _$CategoriaCopyWithImpl<Categoria>(this as Categoria, _$identity);

  /// Serializes this Categoria to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Categoria&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.categoriaPaiId, categoriaPaiId) || other.categoriaPaiId == categoriaPaiId)&&(identical(other.ativo, ativo) || other.ativo == ativo)&&(identical(other.percentualOrcamento, percentualOrcamento) || other.percentualOrcamento == percentualOrcamento)&&(identical(other.natureza, natureza) || other.natureza == natureza)&&(identical(other.cor, cor) || other.cor == cor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,descricao,categoriaPaiId,ativo,percentualOrcamento,natureza,cor);

@override
String toString() {
  return 'Categoria(id: $id, descricao: $descricao, categoriaPaiId: $categoriaPaiId, ativo: $ativo, percentualOrcamento: $percentualOrcamento, natureza: $natureza, cor: $cor)';
}


}

/// @nodoc
abstract mixin class $CategoriaCopyWith<$Res>  {
  factory $CategoriaCopyWith(Categoria value, $Res Function(Categoria) _then) = _$CategoriaCopyWithImpl;
@useResult
$Res call({
 String id, String descricao, String? categoriaPaiId, bool ativo, double? percentualOrcamento, CategoriaNatureza natureza, String? cor
});




}
/// @nodoc
class _$CategoriaCopyWithImpl<$Res>
    implements $CategoriaCopyWith<$Res> {
  _$CategoriaCopyWithImpl(this._self, this._then);

  final Categoria _self;
  final $Res Function(Categoria) _then;

/// Create a copy of Categoria
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? descricao = null,Object? categoriaPaiId = freezed,Object? ativo = null,Object? percentualOrcamento = freezed,Object? natureza = null,Object? cor = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,categoriaPaiId: freezed == categoriaPaiId ? _self.categoriaPaiId : categoriaPaiId // ignore: cast_nullable_to_non_nullable
as String?,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,percentualOrcamento: freezed == percentualOrcamento ? _self.percentualOrcamento : percentualOrcamento // ignore: cast_nullable_to_non_nullable
as double?,natureza: null == natureza ? _self.natureza : natureza // ignore: cast_nullable_to_non_nullable
as CategoriaNatureza,cor: freezed == cor ? _self.cor : cor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Categoria].
extension CategoriaPatterns on Categoria {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Categoria value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Categoria() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Categoria value)  $default,){
final _that = this;
switch (_that) {
case _Categoria():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Categoria value)?  $default,){
final _that = this;
switch (_that) {
case _Categoria() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String descricao,  String? categoriaPaiId,  bool ativo,  double? percentualOrcamento,  CategoriaNatureza natureza,  String? cor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Categoria() when $default != null:
return $default(_that.id,_that.descricao,_that.categoriaPaiId,_that.ativo,_that.percentualOrcamento,_that.natureza,_that.cor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String descricao,  String? categoriaPaiId,  bool ativo,  double? percentualOrcamento,  CategoriaNatureza natureza,  String? cor)  $default,) {final _that = this;
switch (_that) {
case _Categoria():
return $default(_that.id,_that.descricao,_that.categoriaPaiId,_that.ativo,_that.percentualOrcamento,_that.natureza,_that.cor);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String descricao,  String? categoriaPaiId,  bool ativo,  double? percentualOrcamento,  CategoriaNatureza natureza,  String? cor)?  $default,) {final _that = this;
switch (_that) {
case _Categoria() when $default != null:
return $default(_that.id,_that.descricao,_that.categoriaPaiId,_that.ativo,_that.percentualOrcamento,_that.natureza,_that.cor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Categoria implements Categoria {
  const _Categoria({required this.id, required this.descricao, this.categoriaPaiId, required this.ativo, this.percentualOrcamento, this.natureza = CategoriaNatureza.saida, this.cor});
  factory _Categoria.fromJson(Map<String, dynamic> json) => _$CategoriaFromJson(json);

@override final  String id;
@override final  String descricao;
@override final  String? categoriaPaiId;
@override final  bool ativo;
@override final  double? percentualOrcamento;
@override@JsonKey() final  CategoriaNatureza natureza;
@override final  String? cor;

/// Create a copy of Categoria
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoriaCopyWith<_Categoria> get copyWith => __$CategoriaCopyWithImpl<_Categoria>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoriaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Categoria&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.categoriaPaiId, categoriaPaiId) || other.categoriaPaiId == categoriaPaiId)&&(identical(other.ativo, ativo) || other.ativo == ativo)&&(identical(other.percentualOrcamento, percentualOrcamento) || other.percentualOrcamento == percentualOrcamento)&&(identical(other.natureza, natureza) || other.natureza == natureza)&&(identical(other.cor, cor) || other.cor == cor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,descricao,categoriaPaiId,ativo,percentualOrcamento,natureza,cor);

@override
String toString() {
  return 'Categoria(id: $id, descricao: $descricao, categoriaPaiId: $categoriaPaiId, ativo: $ativo, percentualOrcamento: $percentualOrcamento, natureza: $natureza, cor: $cor)';
}


}

/// @nodoc
abstract mixin class _$CategoriaCopyWith<$Res> implements $CategoriaCopyWith<$Res> {
  factory _$CategoriaCopyWith(_Categoria value, $Res Function(_Categoria) _then) = __$CategoriaCopyWithImpl;
@override @useResult
$Res call({
 String id, String descricao, String? categoriaPaiId, bool ativo, double? percentualOrcamento, CategoriaNatureza natureza, String? cor
});




}
/// @nodoc
class __$CategoriaCopyWithImpl<$Res>
    implements _$CategoriaCopyWith<$Res> {
  __$CategoriaCopyWithImpl(this._self, this._then);

  final _Categoria _self;
  final $Res Function(_Categoria) _then;

/// Create a copy of Categoria
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? descricao = null,Object? categoriaPaiId = freezed,Object? ativo = null,Object? percentualOrcamento = freezed,Object? natureza = null,Object? cor = freezed,}) {
  return _then(_Categoria(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,categoriaPaiId: freezed == categoriaPaiId ? _self.categoriaPaiId : categoriaPaiId // ignore: cast_nullable_to_non_nullable
as String?,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,percentualOrcamento: freezed == percentualOrcamento ? _self.percentualOrcamento : percentualOrcamento // ignore: cast_nullable_to_non_nullable
as double?,natureza: null == natureza ? _self.natureza : natureza // ignore: cast_nullable_to_non_nullable
as CategoriaNatureza,cor: freezed == cor ? _self.cor : cor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CategoriaDetails {

 String get id; String get descricao; bool get ativo; CategoriaDetails? get categoriaPai; List<CategoriaDetails> get subcategorias; double? get percentualOrcamento; CategoriaNatureza get natureza; String? get cor;
/// Create a copy of CategoriaDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriaDetailsCopyWith<CategoriaDetails> get copyWith => _$CategoriaDetailsCopyWithImpl<CategoriaDetails>(this as CategoriaDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriaDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.ativo, ativo) || other.ativo == ativo)&&(identical(other.categoriaPai, categoriaPai) || other.categoriaPai == categoriaPai)&&const DeepCollectionEquality().equals(other.subcategorias, subcategorias)&&(identical(other.percentualOrcamento, percentualOrcamento) || other.percentualOrcamento == percentualOrcamento)&&(identical(other.natureza, natureza) || other.natureza == natureza)&&(identical(other.cor, cor) || other.cor == cor));
}


@override
int get hashCode => Object.hash(runtimeType,id,descricao,ativo,categoriaPai,const DeepCollectionEquality().hash(subcategorias),percentualOrcamento,natureza,cor);

@override
String toString() {
  return 'CategoriaDetails(id: $id, descricao: $descricao, ativo: $ativo, categoriaPai: $categoriaPai, subcategorias: $subcategorias, percentualOrcamento: $percentualOrcamento, natureza: $natureza, cor: $cor)';
}


}

/// @nodoc
abstract mixin class $CategoriaDetailsCopyWith<$Res>  {
  factory $CategoriaDetailsCopyWith(CategoriaDetails value, $Res Function(CategoriaDetails) _then) = _$CategoriaDetailsCopyWithImpl;
@useResult
$Res call({
 String id, String descricao, bool ativo, CategoriaDetails? categoriaPai, List<CategoriaDetails> subcategorias, double? percentualOrcamento, CategoriaNatureza natureza, String? cor
});


$CategoriaDetailsCopyWith<$Res>? get categoriaPai;

}
/// @nodoc
class _$CategoriaDetailsCopyWithImpl<$Res>
    implements $CategoriaDetailsCopyWith<$Res> {
  _$CategoriaDetailsCopyWithImpl(this._self, this._then);

  final CategoriaDetails _self;
  final $Res Function(CategoriaDetails) _then;

/// Create a copy of CategoriaDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? descricao = null,Object? ativo = null,Object? categoriaPai = freezed,Object? subcategorias = null,Object? percentualOrcamento = freezed,Object? natureza = null,Object? cor = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,categoriaPai: freezed == categoriaPai ? _self.categoriaPai : categoriaPai // ignore: cast_nullable_to_non_nullable
as CategoriaDetails?,subcategorias: null == subcategorias ? _self.subcategorias : subcategorias // ignore: cast_nullable_to_non_nullable
as List<CategoriaDetails>,percentualOrcamento: freezed == percentualOrcamento ? _self.percentualOrcamento : percentualOrcamento // ignore: cast_nullable_to_non_nullable
as double?,natureza: null == natureza ? _self.natureza : natureza // ignore: cast_nullable_to_non_nullable
as CategoriaNatureza,cor: freezed == cor ? _self.cor : cor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CategoriaDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoriaDetailsCopyWith<$Res>? get categoriaPai {
    if (_self.categoriaPai == null) {
    return null;
  }

  return $CategoriaDetailsCopyWith<$Res>(_self.categoriaPai!, (value) {
    return _then(_self.copyWith(categoriaPai: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategoriaDetails].
extension CategoriaDetailsPatterns on CategoriaDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoriaDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoriaDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoriaDetails value)  $default,){
final _that = this;
switch (_that) {
case _CategoriaDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoriaDetails value)?  $default,){
final _that = this;
switch (_that) {
case _CategoriaDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String descricao,  bool ativo,  CategoriaDetails? categoriaPai,  List<CategoriaDetails> subcategorias,  double? percentualOrcamento,  CategoriaNatureza natureza,  String? cor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoriaDetails() when $default != null:
return $default(_that.id,_that.descricao,_that.ativo,_that.categoriaPai,_that.subcategorias,_that.percentualOrcamento,_that.natureza,_that.cor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String descricao,  bool ativo,  CategoriaDetails? categoriaPai,  List<CategoriaDetails> subcategorias,  double? percentualOrcamento,  CategoriaNatureza natureza,  String? cor)  $default,) {final _that = this;
switch (_that) {
case _CategoriaDetails():
return $default(_that.id,_that.descricao,_that.ativo,_that.categoriaPai,_that.subcategorias,_that.percentualOrcamento,_that.natureza,_that.cor);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String descricao,  bool ativo,  CategoriaDetails? categoriaPai,  List<CategoriaDetails> subcategorias,  double? percentualOrcamento,  CategoriaNatureza natureza,  String? cor)?  $default,) {final _that = this;
switch (_that) {
case _CategoriaDetails() when $default != null:
return $default(_that.id,_that.descricao,_that.ativo,_that.categoriaPai,_that.subcategorias,_that.percentualOrcamento,_that.natureza,_that.cor);case _:
  return null;

}
}

}

/// @nodoc


class _CategoriaDetails implements CategoriaDetails {
  const _CategoriaDetails({required this.id, required this.descricao, required this.ativo, required this.categoriaPai, required final  List<CategoriaDetails> subcategorias, this.percentualOrcamento, this.natureza = CategoriaNatureza.saida, this.cor}): _subcategorias = subcategorias;
  

@override final  String id;
@override final  String descricao;
@override final  bool ativo;
@override final  CategoriaDetails? categoriaPai;
 final  List<CategoriaDetails> _subcategorias;
@override List<CategoriaDetails> get subcategorias {
  if (_subcategorias is EqualUnmodifiableListView) return _subcategorias;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subcategorias);
}

@override final  double? percentualOrcamento;
@override@JsonKey() final  CategoriaNatureza natureza;
@override final  String? cor;

/// Create a copy of CategoriaDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoriaDetailsCopyWith<_CategoriaDetails> get copyWith => __$CategoriaDetailsCopyWithImpl<_CategoriaDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoriaDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.descricao, descricao) || other.descricao == descricao)&&(identical(other.ativo, ativo) || other.ativo == ativo)&&(identical(other.categoriaPai, categoriaPai) || other.categoriaPai == categoriaPai)&&const DeepCollectionEquality().equals(other._subcategorias, _subcategorias)&&(identical(other.percentualOrcamento, percentualOrcamento) || other.percentualOrcamento == percentualOrcamento)&&(identical(other.natureza, natureza) || other.natureza == natureza)&&(identical(other.cor, cor) || other.cor == cor));
}


@override
int get hashCode => Object.hash(runtimeType,id,descricao,ativo,categoriaPai,const DeepCollectionEquality().hash(_subcategorias),percentualOrcamento,natureza,cor);

@override
String toString() {
  return 'CategoriaDetails(id: $id, descricao: $descricao, ativo: $ativo, categoriaPai: $categoriaPai, subcategorias: $subcategorias, percentualOrcamento: $percentualOrcamento, natureza: $natureza, cor: $cor)';
}


}

/// @nodoc
abstract mixin class _$CategoriaDetailsCopyWith<$Res> implements $CategoriaDetailsCopyWith<$Res> {
  factory _$CategoriaDetailsCopyWith(_CategoriaDetails value, $Res Function(_CategoriaDetails) _then) = __$CategoriaDetailsCopyWithImpl;
@override @useResult
$Res call({
 String id, String descricao, bool ativo, CategoriaDetails? categoriaPai, List<CategoriaDetails> subcategorias, double? percentualOrcamento, CategoriaNatureza natureza, String? cor
});


@override $CategoriaDetailsCopyWith<$Res>? get categoriaPai;

}
/// @nodoc
class __$CategoriaDetailsCopyWithImpl<$Res>
    implements _$CategoriaDetailsCopyWith<$Res> {
  __$CategoriaDetailsCopyWithImpl(this._self, this._then);

  final _CategoriaDetails _self;
  final $Res Function(_CategoriaDetails) _then;

/// Create a copy of CategoriaDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? descricao = null,Object? ativo = null,Object? categoriaPai = freezed,Object? subcategorias = null,Object? percentualOrcamento = freezed,Object? natureza = null,Object? cor = freezed,}) {
  return _then(_CategoriaDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,descricao: null == descricao ? _self.descricao : descricao // ignore: cast_nullable_to_non_nullable
as String,ativo: null == ativo ? _self.ativo : ativo // ignore: cast_nullable_to_non_nullable
as bool,categoriaPai: freezed == categoriaPai ? _self.categoriaPai : categoriaPai // ignore: cast_nullable_to_non_nullable
as CategoriaDetails?,subcategorias: null == subcategorias ? _self._subcategorias : subcategorias // ignore: cast_nullable_to_non_nullable
as List<CategoriaDetails>,percentualOrcamento: freezed == percentualOrcamento ? _self.percentualOrcamento : percentualOrcamento // ignore: cast_nullable_to_non_nullable
as double?,natureza: null == natureza ? _self.natureza : natureza // ignore: cast_nullable_to_non_nullable
as CategoriaNatureza,cor: freezed == cor ? _self.cor : cor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CategoriaDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoriaDetailsCopyWith<$Res>? get categoriaPai {
    if (_self.categoriaPai == null) {
    return null;
  }

  return $CategoriaDetailsCopyWith<$Res>(_self.categoriaPai!, (value) {
    return _then(_self.copyWith(categoriaPai: value));
  });
}
}

// dart format on
