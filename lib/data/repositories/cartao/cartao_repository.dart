import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_filter_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';

class CartaoRepository
    implements BaseRepository<Cartao, CartaoDto, CartaoDto, CartaoFilterDto> {
  final BaseStorage<Cartao> _storage;

  final _streamController =
      StreamController<RepositoryEvent<Cartao>>.broadcast();

  CartaoRepository(BaseStorage<Cartao> storage) : _storage = storage;

  @override
  AsyncResult<Cartao> create(CartaoDto dto) async {
    final exists = await findByDescricao(dto.descricao).then(
      (result) => result.isSuccess(), //
    );

    if (exists) {
      return Failure(
        LocalStorageException(
          'Já existe um cartão com a descrição: ${dto.descricao}', //
        ),
      );
    }

    final cartao = Cartao(
      id: const Uuid().v4(),
      descricao: dto.descricao,
      limite: dto.limite,
      bancoSigla: dto.bancoSigla,
      ativo: dto.ativo,
      diaFechamento: dto.diaFechamento,
      dataInicial:
          dto.dataInicial ??
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            1, //
          ),
    );

    return _storage.create(cartao).onSuccess((cartao) {
      _streamController.add(RepositoryCreated(cartao));
    });
  }

  @override
  AsyncResult<Unit> createAll(List<CartaoDto> dtos) async {
    final entities = dtos
        .map(
          (dto) => Cartao(
            id: dto.id ?? const Uuid().v4(),
            descricao: dto.descricao,
            limite: dto.limite,
            bancoSigla: dto.bancoSigla,
            ativo: dto.ativo,
            diaFechamento: dto.diaFechamento,
            dataInicial:
                dto.dataInicial ??
                DateTime(DateTime.now().year, DateTime.now().month, 1),
          ),
        )
        .toList();

    final result = await _storage.createAll(entities);
    return result.onSuccess((_) {
      for (final e in entities) {
        _streamController.add(RepositoryCreated(e));
      }
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
      dataInicial: dto.dataInicial!,
    );
    return _storage.update(cartao).onSuccess((cartao) {
      _streamController.add(RepositoryUpdated(cartao));
    });
  }

  @override
  AsyncResult<Unit> updateAll(List<CartaoDto> dtos) async {
    final entities = dtos
        .map(
          (dto) => Cartao(
            id: dto.id!,
            descricao: dto.descricao,
            limite: dto.limite,
            bancoSigla: dto.bancoSigla,
            ativo: dto.ativo,
            diaFechamento: dto.diaFechamento,
            dataInicial: dto.dataInicial!,
          ),
        )
        .toList();

    final result = await _storage.updateAll(entities);
    return result.onSuccess((_) {
      for (final e in entities) {
        _streamController.add(RepositoryUpdated(e));
      }
    });
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    return _storage.delete(id).onSuccess((_) {
      _streamController.add(RepositoryDeleted(id));
    });
  }

  AsyncResult<List<Cartao>> getAll() async {
    return _storage.getAll();
  }

  @override
  AsyncResult<Cartao> getById(String id) async {
    return _storage.getById(id);
  }

  AsyncResult<Cartao> findByDescricao(String descricao) async {
    final searchFields = [
      SearchField(
        fieldName: 'descricao',
        value: descricao,
        type: SearchFieldType.string, //
      ),
    ];

    final cartoesResult = await _storage.searchByFields(searchFields);

    return cartoesResult.fold(
      (cartoes) {
        if (cartoes.isEmpty) {
          return Failure(
            LocalStorageException(
              'Cartão não encontrado: $descricao', //
            ),
          );
        }

        return Success(cartoes.first);
      },
      (error) {
        return Failure(
          LocalStorageException(
            'Erro ao buscar cartão: $descricao', //
          ),
        );
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
}
