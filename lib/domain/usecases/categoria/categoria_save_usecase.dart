import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';

/// Centraliza as regras de negócio para criar e atualizar categorias.
///
/// Regras de validação (aplicadas antes de gravar):
/// - Descrição única no mesmo nível (mesma categoria pai).
/// - Categoria não pode ser pai dela mesma.
/// - Categoria pai informada deve existir.
/// - Máximo de 2 níveis: a categoria pai deve ser raiz e uma categoria
///   que possui subcategorias não pode se tornar subcategoria.
///
/// Regras de hierarquia de status (aplicadas após gravar):
/// - Categoria inativa: todas as subcategorias ativas são desativadas.
/// - Subcategoria ativa: se a categoria pai estiver inativa, ela é ativada.
class CategoriaSaveUseCase {
  final CategoriaRepository _repository;

  CategoriaSaveUseCase(this._repository);

  AsyncResult<Categoria> create(CategoriaDto dto) async {
    return _save(dto, isUpdate: false);
  }

  AsyncResult<Categoria> update(CategoriaDto dto) async {
    if (dto.id == null) {
      return Failure(
        DomainException('Categoria sem identificador para atualização.'),
      );
    }
    return _save(dto, isUpdate: true);
  }

  AsyncResult<Categoria> _save(
    CategoriaDto dto, {
    required bool isUpdate,
  }) async {
    final todasResult = await _repository.getAll();
    if (todasResult.isError()) {
      return Failure(todasResult.exceptionOrNull()!);
    }
    final todas = todasResult.getOrThrow();

    final erro = _validar(dto, todas, isUpdate: isUpdate);
    if (erro != null) return Failure(erro);

    final saveResult = isUpdate
        ? await _repository.update(dto)
        : await _repository.create(dto);
    if (saveResult.isError()) return saveResult;

    final categoria = saveResult.getOrThrow();

    final syncResult = await _sincronizarHierarquia(categoria, todas);
    if (syncResult.isError()) {
      return Failure(syncResult.exceptionOrNull()!);
    }

    return Success(categoria);
  }

  // ---------------------------------------------------------------------------
  // Validações
  // ---------------------------------------------------------------------------

  DomainException? _validar(
    CategoriaDto dto,
    List<Categoria> todas, {
    required bool isUpdate,
  }) {
    final id = isUpdate ? dto.id : null;

    if (_existeDuplicada(dto.descricao, dto.categoriaPaiId, todas, id)) {
      return DomainException(
        'Já existe uma categoria com a descrição "${dto.descricao}" '
        'neste nível.',
      );
    }

    final paiId = dto.categoriaPaiId;
    if (paiId == null) return null;

    if (id != null && paiId == id) {
      return DomainException('Uma categoria não pode ser pai dela mesma.');
    }

    final pai = todas.where((c) => c.id == paiId).firstOrNull;
    if (pai == null) {
      return DomainException('Categoria pai não encontrada.');
    }

    if (pai.categoriaPaiId != null) {
      return DomainException('Somente dois níveis são permitidos.');
    }

    if (id != null && todas.any((c) => c.categoriaPaiId == id)) {
      return DomainException(
        'Somente dois níveis são permitidos. Esta categoria possui '
        'subcategorias e não pode se tornar uma subcategoria.',
      );
    }

    return null;
  }

  bool _existeDuplicada(
    String descricao,
    String? categoriaPaiId,
    List<Categoria> todas,
    String? excludeId,
  ) {
    final normalizada = descricao.trim().toLowerCase();
    return todas.any(
      (c) =>
          c.categoriaPaiId == categoriaPaiId &&
          c.id != excludeId &&
          c.descricao.trim().toLowerCase() == normalizada,
    );
  }

  // ---------------------------------------------------------------------------
  // Hierarquia de status (ativo/inativo)
  // ---------------------------------------------------------------------------

  AsyncResult<Unit> _sincronizarHierarquia(
    Categoria categoria,
    List<Categoria> todas,
  ) async {
    final ajustes = <Categoria>[];

    if (!categoria.ativo) {
      ajustes.addAll(
        todas
            .where((c) => c.categoriaPaiId == categoria.id && c.ativo)
            .map((c) => c.copyWith(ativo: false)),
      );
    }

    final paiId = categoria.categoriaPaiId;
    if (categoria.ativo && paiId != null) {
      final pai = todas.where((c) => c.id == paiId).firstOrNull;
      if (pai != null && !pai.ativo) {
        ajustes.add(pai.copyWith(ativo: true));
      }
    }

    if (ajustes.isEmpty) return const Success(unit);

    return _repository.updateAll(ajustes.map(_toDto).toList());
  }

  CategoriaDto _toDto(Categoria c) => CategoriaDto(
    id: c.id,
    descricao: c.descricao,
    categoriaPaiId: c.categoriaPaiId,
    ativo: c.ativo,
    percentualOrcamento: c.percentualOrcamento,
    natureza: c.natureza,
    cor: c.cor,
  );
}
