// lib/domain/entities/categoria_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'categoria_entity.freezed.dart';
part 'categoria_entity.g.dart';

@freezed
sealed class Categoria with _$Categoria {
  const factory Categoria({
    required String id,
    required String descricao,
    String? categoriaPaiId,
    required bool ativo,
  }) = _Categoria;

  factory Categoria.fromJson(Map<String, dynamic> json) => _$CategoriaFromJson(json);
}

@freezed
sealed class CategoriaDetails with _$CategoriaDetails {
  const factory CategoriaDetails({
    required String id,
    required String descricao,
    required bool ativo,
    required CategoriaDetails? categoriaPai,
    required List<CategoriaDetails> subcategorias,
  }) = _CategoriaDetails;
}
