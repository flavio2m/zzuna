import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_filter_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';

class CartaoRepository implements BaseRepository<Cartao, CartaoDto, CartaoDto, CartaoFilterDto> {
  final BaseStorage<Cartao> _storage;

  final _streamController = StreamController<RepositoryEvent<Cartao>>.broadcast();

  CartaoRepository(LocalStorage<Cartao> storage) : _storage = storage;

  @override
  AsyncResult<Cartao> create(CartaoDto dto) async {
    final exists = await findByDescricao(dto.descricao).then((result) => result.isSuccess());

    if (exists) {
      return Failure(LocalStorageException('Já existe um cartão com a descrição: ${dto.descricao}'));
    }

    final cartao = Cartao(
      id: const Uuid().v4(),
      descricao: dto.descricao,
      limite: dto.limite,
      bancoSigla: dto.bancoSigla,
      ativo: dto.ativo,
      diaFechamento: dto.diaFechamento,
    );

    return _storage.create(cartao).onSuccess((cartao) {
      _streamController.add(RepositoryCreated(cartao));
    });
  }

  @override
  AsyncResult<Cartao> update(CartaoDto dto) async {
    final cartao = Cartao(
      id: dto.id!,
      descricao: dto.descricao,
      limite: dto.limite,
      bancoSigla: dto.bancoSigla,
      ativo: dto.ativo,
      diaFechamento: dto.diaFechamento,
    );
    return _storage.update(cartao).onSuccess((cartao) {
      _streamController.add(RepositoryUpdated(cartao));
    });
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    return _storage.delete(id).onSuccess((_) {
      _streamController.add(RepositoryDeleted(id));
    });
  }

  @override
  AsyncResult<List<Cartao>> getAll() async {
    // return _storage.getAll();

    /// REFATORAR: Somente para testes: popula storage
    final result = await _storage.getAll();

    if (result.isError()) {
      return Failure(result.exceptionOrNull()!);
    }

    final contas = result.getOrThrow();

    if (contas.isEmpty) {
      await _seedCartoes();
      return _storage.getAll();
    }

    return Success(contas);

    /// Fim do código de teste
  }

  @override
  AsyncResult<Cartao> getById(String id) async {
    return _storage.getById(id);
  }

  AsyncResult<Cartao> findByDescricao(String descricao) async {
    final searchFields = [SearchField(fieldName: 'descricao', value: descricao, type: SearchFieldType.string)];

    final cartoesResult = await _storage.searchByFields(searchFields);

    return cartoesResult.fold(
      (cartoes) {
        if (cartoes.isEmpty) {
          return Failure(LocalStorageException('Cartão não encontrado: $descricao'));
        }

        return Success(cartoes.first);
      },
      (error) {
        return Failure(LocalStorageException('Erro ao buscar cartão: $descricao'));
      },
    );
  }

  @override
  AsyncResult<List<Cartao>> search(CartaoFilterDto filter) async {
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

    if (filter.bancoSigla != null && filter.bancoSigla!.isNotEmpty) {
      searchFields.add(
        SearchField(
          fieldName: 'bancoSigla',
          value: filter.bancoSigla,
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

    final cartoesResult = await _storage.searchByFields(searchFields);

    return cartoesResult.fold(
      Success.new,
      (error) => Failure(
        LocalStorageException(
          'Erro ao buscar cartões', //
        ),
      ),
    );
  }

  @override
  Stream<RepositoryEvent<Cartao>> observer() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }

  // Para testes
  Future<void> _seedCartoes() async {
    final bancos = Bancos.items.take(10).toList();

    for (var i = 0; i < bancos.length; i++) {
      await _storage.create(
        Cartao(
          id: const Uuid().v4(),
          descricao: 'Cartão ${bancos[i].descricao}',
          limite: (i + 1) * 1000.0,
          bancoSigla: bancos[i].sigla,
          ativo: i != 9,
          diaFechamento: 5 + i,
        ),
      );
    }
  }
}
