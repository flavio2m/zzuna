import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/exception/repository_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_filter_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';

class CategoriaRepository implements BaseRepository<Categoria, CategoriaDto, CategoriaDto, CategoriaFilterDto> {
  final BaseStorage<Categoria> _storage;

  final _streamController = StreamController<RepositoryEvent<Categoria>>.broadcast();

  CategoriaRepository(LocalStorage<Categoria> storage) : _storage = storage;

  @override
  AsyncResult<Categoria> create(CategoriaDto dto) async {
    // Verifica se já existe categoria com a mesma descrição
    final exists = await findByDescricao(dto.descricao).then(
      (result) => result.isSuccess(), //
    );
    if (exists) {
      return Failure(
        RepositoryException(
          'Já existe uma categoria com a descrição: ${dto.descricao}', //
        ),
      );
    }
    // Verifica regra de hierarquia ao criar
    if (dto.categoriaPaiId != null) {
      final parentResult = await _storage.getById(dto.categoriaPaiId!);
      if (parentResult.isSuccess()) {
        final parent = parentResult.getOrThrow();
        if (parent.categoriaPaiId != null) {
          return Failure(
            RepositoryException(
              'Somente dois níveis são permitidos.', //
            ),
          );
        }
      }
    }
    final categoria = Categoria(
      id: const Uuid().v4(),
      descricao: dto.descricao,
      categoriaPaiId: dto.categoriaPaiId,
      ativo: dto.ativo,
    );
    return _storage.create(categoria).onSuccess((cat) {
      _streamController.add(RepositoryCreated(cat));
    });
  }

  @override
  AsyncResult<Categoria> update(CategoriaDto dto) async {
    // Busca a categoria existente
    final existingResult = await _storage.getById(dto.id!);
    if (existingResult.isError()) {
      return Failure(
        existingResult.exceptionOrNull()!, //
      );
    }
    // Se estiver alterando para subcategoria, validar nível
    if (dto.categoriaPaiId != null) {
      final parentResult = await _storage.getById(dto.categoriaPaiId!);
      if (parentResult.isSuccess()) {
        final parent = parentResult.getOrThrow();
        if (parent.categoriaPaiId != null) {
          return Failure(
            RepositoryException(
              'Somente dois níveis são permitidos.', //
            ),
          );
        }
      }
    }
    final categoria = Categoria(
      id: dto.id!,
      descricao: dto.descricao,
      categoriaPaiId: dto.categoriaPaiId,
      ativo: dto.ativo,
    );
    return _storage.update(categoria).onSuccess((cat) {
      _streamController.add(RepositoryUpdated(cat));
    });
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    return _storage.delete(id).onSuccess((_) {
      _streamController.add(RepositoryDeleted(id));
    });
  }

  @override
  AsyncResult<List<Categoria>> getAll() async {
    // return _storage.getAll();

    /// REFATORAR: Somente para testes: popula storage
    final result = await _storage.getAll();

    if (result.isError()) return Failure(result.exceptionOrNull()!);

    final list = result.getOrThrow();

    if (list.isEmpty) {
      await _seedCategorias();
      return _storage.getAll();
    }
    return Success(list);
  }

  @override
  AsyncResult<Categoria> getById(String id) async {
    return _storage.getById(id);
  }

  AsyncResult<Categoria> findByDescricao(String descricao) async {
    final searchFields = [
      SearchField(
        fieldName: 'descricao',
        value: descricao,
        type: SearchFieldType.string, //
      ),
    ];

    final result = await _storage.searchByFields(searchFields);

    return result.fold(
      (categorias) {
        if (categorias.isEmpty) {
          return Failure(
            LocalStorageException(
              'Categoria não encontrada: $descricao', //
            ),
          );
        }
        return Success(categorias.first);
      },
      (error) {
        return Failure(
          LocalStorageException(
            'Erro ao buscar categoria: $descricao', //
          ),
        );
      },
    );
  }

  @override
  AsyncResult<List<Categoria>> search(CategoriaFilterDto filter) async {
    final searchFields = <SearchField>[];
    if (filter.descricao.isNotEmpty) {
      searchFields.add(
        SearchField(
          fieldName: 'descricao',
          value: filter.descricao,
          type: SearchFieldType.string, //
        ),
      );
    }
    if (filter.ativo != null) {
      searchFields.add(
        SearchField(
          fieldName: 'ativo',
          value: filter.ativo,
          type: SearchFieldType.boolean, //
        ),
      );
    }
    final result = await _storage.searchByFields(searchFields);
    return result.fold(
      Success.new,
      (error) => Failure(
        RepositoryException(
          'Erro ao buscar categorias', //
        ),
      ),
    );
  }

  @override
  Stream<RepositoryEvent<Categoria>> observer() => _streamController.stream;

  @override
  void dispose() {
    _streamController.close();
  }

  // -----------------------------------------------------------------
  // Seed de categorias (conforme especificação)
  // -----------------------------------------------------------------
  Future<void> _seedCategorias() async {
    // 1. Categorias raiz
    final alimentacao = Categoria(id: const Uuid().v4(), descricao: 'Alimentação', ativo: true);
    final transporte = Categoria(id: const Uuid().v4(), descricao: 'Transporte', ativo: true);
    final investimentos = Categoria(id: const Uuid().v4(), descricao: 'Investimentos', ativo: true);
    final moradia = Categoria(id: const Uuid().v4(), descricao: 'Moradia', ativo: true);
    final receitas = Categoria(id: const Uuid().v4(), descricao: 'Receitas', ativo: true);
    final saude = Categoria(id: const Uuid().v4(), descricao: 'Saúde', ativo: true);
    final terceiros = Categoria(id: const Uuid().v4(), descricao: 'Terceiros', ativo: true);
    final viagem = Categoria(id: const Uuid().v4(), descricao: 'Viagem', ativo: true);

    final List<Categoria> seeds = [alimentacao, transporte, investimentos, moradia, receitas, saude, terceiros, viagem];

    // Helper para criar subcategoria
    void addSub(String descricao, String paiId) {
      seeds.add(Categoria(id: const Uuid().v4(), descricao: descricao, categoriaPaiId: paiId, ativo: true));
    }

    // 1) Alimentação
    addSub('Feira', alimentacao.id);
    addSub('Horta', alimentacao.id);
    addSub('Lanche', alimentacao.id);
    addSub('Restaurantes', alimentacao.id);
    addSub('Supermercado', alimentacao.id);
    addSub('Outros', alimentacao.id);

    // 2) Transporte
    addSub('Gadget', transporte.id);
    addSub('IPVA, Taxas e Docs', transporte.id);
    addSub('Limpeza', transporte.id);
    addSub('Manutenção', transporte.id);
    addSub('Combustível', transporte.id);
    addSub('Diversos Transportes', transporte.id);

    // 3) Investimentos
    addSub('Ações', investimentos.id);
    addSub('Cashback', investimentos.id);
    addSub('FII', investimentos.id);
    addSub('Milhas/Pontos', investimentos.id);
    addSub('Natura', investimentos.id);
    addSub('Renda Fixa', investimentos.id);
    addSub('Reservas', investimentos.id);
    addSub('Diversos Investimentos', investimentos.id);

    // 4) Moradia
    addSub('Água', moradia.id);
    addSub('Cama, Mesa e Banho', moradia.id);
    addSub('Cozinha', moradia.id);
    addSub('Diversos Moradia', moradia.id);
    addSub('Financeiras', moradia.id);
    addSub('Gás', moradia.id);
    addSub('Internet', moradia.id);
    addSub('Jardim', moradia.id);
    addSub('Luz', moradia.id);
    addSub('Manutenção e Reforma', moradia.id);
    addSub('Móveis e Decoração', moradia.id);
    addSub('Telefone e comunicação', moradia.id);
    addSub('Utensílios', moradia.id);

    // 5) Receitas
    addSub('Artezanato', receitas.id);
    addSub('Descontos e outros', receitas.id);
    addSub('Financeiras', receitas.id);
    addSub('Salário', receitas.id);
    addSub('Serviços Prestados', receitas.id);
    addSub('Diversos Receitas', receitas.id);

    // 6) Saúde
    addSub('Dentista', saude.id);
    addSub('Exames', saude.id);
    addSub('Farmácia', saude.id);
    addSub('Médico', saude.id);
    addSub('Oftalmologista', saude.id);
    addSub('Plano de Saúde', saude.id);
    addSub('Diversos Saúde', saude.id);

    // 7) Terceiros
    addSub('Mãe', terceiros.id);
    addSub('Pai', terceiros.id);
    addSub('Fulano da Silva', terceiros.id);

    // 8) Viagem
    addSub('Alimentação Viagem', viagem.id);
    addSub('Combustível Viagem', viagem.id);
    addSub('Diversos Viagem', viagem.id);
    addSub('Hospedagem', viagem.id);
    addSub('Passagens', viagem.id);
    addSub('Pedágios', viagem.id);

    for (final cat in seeds) {
      await _storage.create(cat);
    }
  }
}
