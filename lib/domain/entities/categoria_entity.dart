import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/statics/categoria/categoria_cores.dart';

part 'categoria_entity.freezed.dart';
part 'categoria_entity.g.dart';

@freezed
sealed class Categoria with _$Categoria {
  const factory Categoria({
    required String id,
    required String descricao,
    String? categoriaPaiId,
    required bool ativo,
    double? percentualOrcamento,
    @Default(CategoriaNatureza.saida) CategoriaNatureza natureza,
    String? cor,
  }) = _Categoria;

  factory Categoria.fromJson(Map<String, dynamic> json) =>
      _$CategoriaFromJson(json);
}

@freezed
sealed class CategoriaDetails with _$CategoriaDetails {
  const factory CategoriaDetails({
    required String id,
    required String descricao,
    required bool ativo,
    required CategoriaDetails? categoriaPai,
    required List<CategoriaDetails> subcategorias,
    double? percentualOrcamento,
    @Default(CategoriaNatureza.saida) CategoriaNatureza natureza,
    String? cor,
  }) = _CategoriaDetails;
}

extension CategoriaColorExtension on Categoria {
  Color get categoryColor => CategoriaCores.parseHex(cor);
}

extension CategoriaDetailsColorExtension on CategoriaDetails {
  Color get categoryColor => CategoriaCores.parseHex(cor ?? categoriaPai?.cor);
}

extension CategoriaListActiveExtension on Iterable<Categoria> {
  /// Retorna apenas categorias ativas, garantindo que se o pai estiver inativo,
  /// as filhas também são desconsideradas.
  List<Categoria> onlyActive() {
    final map = {for (final c in this) c.id: c};
    return where((c) {
      if (!c.ativo) return false;
      if (c.categoriaPaiId != null) {
        final parent = map[c.categoriaPaiId];
        if (parent == null || !parent.ativo) return false;
      }
      return true;
    }).toList();
  }
}
