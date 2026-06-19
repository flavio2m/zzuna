import 'dart:async';

import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/services/storage/base_storage.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';

// Imports para massa de dados temporária (seeding)
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_repository.dart';
import 'package:zzuna/data/repositories/lancamento/fatura_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/fatura_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_entity.dart';
import 'package:zzuna/domain/entities/lancamento/fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_item_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_referencia.dart';

class LancamentoRepository
    implements
        BaseRepository<
          Lancamento,
          LancamentoDto,
          LancamentoDto,
          LancamentoFilterDto //
        > {
  final BaseStorage<Lancamento> _storage;

  final _streamController = //
      StreamController<RepositoryEvent<Lancamento>>.broadcast();

  LancamentoRepository(LocalStorage<Lancamento> storage) : _storage = storage;

  @override
  AsyncResult<Lancamento> create(LancamentoDto dto) async {
    final lancamento = Lancamento(
      id: const Uuid().v4(),
      tipo: dto.tipo,
      data: dto.data,
      descricao: dto.descricao,
      referencia: dto.referencia,
      origem: dto.origem,
      itens: dto.itens,
      conciliado: dto.conciliado,
      observacao: dto.observacao,
    );

    return _storage.create(lancamento).onSuccess((model) {
      _streamController.add(RepositoryCreated(model));
    });
  }

  @override
  AsyncResult<Lancamento> update(LancamentoDto dto) async {
    final lancamento = Lancamento(
      id: dto.id!,
      tipo: dto.tipo,
      data: dto.data,
      descricao: dto.descricao,
      referencia: dto.referencia,
      origem: dto.origem,
      itens: dto.itens,
      conciliado: dto.conciliado,
      observacao: dto.observacao,
    );

    return _storage.update(lancamento).onSuccess((model) {
      _streamController.add(RepositoryUpdated(model));
    });
  }

  @override
  AsyncResult<Unit> delete(String id) async {
    return _storage.delete(id).onSuccess((_) {
      _streamController.add(RepositoryDeleted(id));
    });
  }

  @override
  AsyncResult<List<Lancamento>> getAll() async {
    // return _storage.getAll();

    // Garante que a massa de dados temporária está populada
    final result = await _storage.getAll();
    if (result.isError()) {
      return Failure(result.exceptionOrNull()!);
    }

    final list = result.getOrThrow();
    if (list.isEmpty) {
      await _seedLancamentos();
      return _storage.getAll();
    }

    return Success(list);
  }

  AsyncResult<List<Lancamento>> searchByPeriodo({
    required Mes mes,
    required int ano, //
  }) async {
    // REMOVER: Chama getAll para popular massa dados
    final all = await getAll();
    if (all.isError()) {
      return Failure(all.exceptionOrNull()!);
    }
    // REMOVER: Fim do hack para popular massa de dados

    final firstDay = DateTime(ano, mes.numero, 1);
    final lastDay = DateTime(ano, mes.numero + 1, 0, 23, 59, 59, 999);

    final searchFields = [
      SearchField(
        fieldName: 'data',
        value: [firstDay, lastDay],
        type: SearchFieldType.date, //
      ),
    ];

    final result = await _storage.searchByFields(searchFields);
    return result.fold(
      Success.new,
      (error) => Failure(
        LocalStorageException(
          'Erro ao buscar lançamentos por período', //
        ),
      ),
    );
  }

  @override
  AsyncResult<Lancamento> getById(String id) async {
    return _storage.getById(id);
  }

  @override
  AsyncResult<List<Lancamento>> search(LancamentoFilterDto filter) async {
    final all = await getAll();
    if (all.isError()) {
      return Failure(all.exceptionOrNull()!);
    }

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

    if (filter.tipo != null) {
      searchFields.add(
        SearchField(
          fieldName: 'tipo',
          value: filter.tipo!.name,
          type: SearchFieldType.string, //
        ),
      );
    }

    if (filter.conciliado != null) {
      searchFields.add(
        SearchField(
          fieldName: 'conciliado',
          value: filter.conciliado,
          type: SearchFieldType.boolean, //
        ),
      );
    }

    final result = await _storage.searchByFields(searchFields);

    return result.fold(
      Success.new,
      (error) => Failure(LocalStorageException('Erro ao buscar lançamentos')), //
    );
  }

  @override
  Stream<RepositoryEvent<Lancamento>> observer() {
    return _streamController.stream;
  }

  @override
  void dispose() {
    _streamController.close();
  }

  // Gera massa de dados temporária para testes (Maio e Junho 2026)
  Future<void> _seedLancamentos() async {
    final contaRepo = ContaRepository(
      LocalStorage<Conta>(
        collectionName: 'contas',
        fromJson: Conta.fromJson,
        toJson: (c) => c.toJson(), //
      ),
    );
    final cartaoRepo = CartaoRepository(
      LocalStorage<Cartao>(collectionName: 'cartoes', fromJson: Cartao.fromJson, toJson: (c) => c.toJson()),
    );
    final centroCustoRepo = CentroCustoRepository(
      LocalStorage<CentroCusto>(
        collectionName: 'centro_custos',
        fromJson: CentroCusto.fromJson,
        toJson: (c) => c.toJson(),
      ),
    );
    final categoriaRepo = CategoriaRepository(
      LocalStorage<Categoria>(collectionName: 'categorias', fromJson: Categoria.fromJson, toJson: (c) => c.toJson()),
    );
    final faturaRepo = FaturaRepository(
      LocalStorage<Fatura>(collectionName: 'faturas', fromJson: Fatura.fromJson, toJson: (c) => c.toJson()),
    );
    final extratoRepo = ExtratoRepository(
      LocalStorage<Extrato>(collectionName: 'extratos', fromJson: Extrato.fromJson, toJson: (c) => c.toJson()),
    );

    final contas = (await contaRepo.getAll()).getOrElse((_) => []);
    final cartoes = (await cartaoRepo.getAll()).getOrElse((_) => []);
    final centros = (await centroCustoRepo.getAll()).getOrElse((_) => []);
    final categorias = (await categoriaRepo.getAll()).getOrElse((_) => []);
    var faturas = (await faturaRepo.getAll()).getOrElse((_) => []);
    var extratos = (await extratoRepo.getAll()).getOrElse((_) => []);

    if (contas.isEmpty || cartoes.isEmpty || centros.isEmpty || categorias.isEmpty) {
      return;
    }

    if (faturas.isEmpty) {
      for (final c in cartoes) {
        for (final m in [Mes.maio, Mes.junho]) {
          final f = Fatura(
            id: const Uuid().v4(),
            cartaoId: c.id,
            ano: 2026,
            mes: m,
            dataInicio: DateTime(2026, m.numero, 1),
            dataFim: DateTime(2026, m.numero + 1, 0),
            fechada: false,
          );
          await faturaRepo.create(
            FaturaDto(
              id: f.id,
              cartaoId: f.cartaoId,
              ano: f.ano,
              mes: f.mes,
              dataInicio: f.dataInicio,
              dataFim: f.dataFim,
              fechada: f.fechada,
            ),
          );
        }
      }
      faturas = (await faturaRepo.getAll()).getOrElse((_) => []);
    }

    if (extratos.isEmpty) {
      for (final c in contas) {
        for (final m in [Mes.maio, Mes.junho]) {
          final e = Extrato(
            id: const Uuid().v4(),
            contaId: c.id,
            ano: 2026,
            mes: m,
            dataInicio: DateTime(2026, m.numero, 1),
            dataFim: DateTime(2026, m.numero + 1, 0),
            fechado: false,
          );
          await extratoRepo.create(
            ExtratoDto(
              id: e.id,
              contaId: e.contaId,
              ano: e.ano,
              mes: e.mes,
              dataInicio: e.dataInicio,
              dataFim: e.dataFim,
              fechado: e.fechado,
            ),
          );
        }
      }
      extratos = (await extratoRepo.getAll()).getOrElse((_) => []);
    }

    if (faturas.isEmpty || extratos.isEmpty) return;

    final firstConta = contas.first;
    final secondConta = contas.length > 1 ? contas[1] : firstConta;
    final firstCartao = cartoes.first;

    Extrato getExtrato(String contaId, Mes mes) {
      return extratos.firstWhere(
        (e) => e.contaId == contaId && e.mes == mes,
        orElse: () => extratos.firstWhere((e) => e.mes == mes),
      );
    }

    Fatura getFatura(String cartaoId, Mes mes) {
      return faturas.firstWhere(
        (f) => f.cartaoId == cartaoId && f.mes == mes,
        orElse: () => faturas.firstWhere((f) => f.mes == mes),
      );
    }

    final extratoJun1 = getExtrato(firstConta.id, Mes.junho);
    final extratoJun2 = getExtrato(secondConta.id, Mes.junho);
    final faturaJun1 = getFatura(firstCartao.id, Mes.junho);

    final extratoMay1 = getExtrato(firstConta.id, Mes.maio);
    final extratoMay2 = getExtrato(secondConta.id, Mes.maio);
    final faturaMay1 = getFatura(firstCartao.id, Mes.maio);

    String findCat(String query) {
      final match = categorias.firstWhere(
        (c) => c.descricao.toLowerCase().contains(query.toLowerCase()),
        orElse: () => categorias.first,
      );
      return match.id;
    }

    String findCc(String query) {
      final match = centros.firstWhere(
        (c) => c.descricao.toLowerCase().contains(query.toLowerCase()),
        orElse: () => centros.first,
      );
      return match.id;
    }

    final catReceitas = findCat('Receitas');
    final catViagem = findCat('Viagem');
    final catSupermercado = findCat('Supermercado');
    final catRestaurantes = findCat('Restaurantes');
    final catCombustivel = findCat('Combustível');
    final catSaude = findCat('Saúde');
    final catMoradia = findCat('Moradia');

    final ccPessoaA = findCc('Pessoa A');
    final ccPessoaB = findCc('Pessoa B');
    final ccMoradia = findCc('Moradia');
    final ccSaude = findCc('Saúde');
    final ccLazer = findCc('Lazer');
    final ccViagens = findCc('Viagens');

    final seeds = [
      // ---------------- JUNE 2026 SEEDS ----------------
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 6, 1),
        descricao: 'Salário Mensal Zzuna',
        referencia: LancamentoReferencia.extrato(extratoId: extratoJun1.id),
        origem: LancamentoOrigem.conta(contaId: firstConta.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccPessoaA, categoriaId: catReceitas, valor: 4800.00),
        ],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 3),
        descricao: 'Supermercado Carrefour',
        referencia: LancamentoReferencia.fatura(faturaId: faturaJun1.id),
        origem: LancamentoOrigem.cartao(cartaoId: firstCartao.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccMoradia, categoriaId: catSupermercado, valor: 524.15),
        ],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 5),
        descricao: 'Restaurante Pizzaria Bella',
        referencia: LancamentoReferencia.fatura(faturaId: faturaJun1.id),
        origem: LancamentoOrigem.cartao(cartaoId: firstCartao.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccLazer, categoriaId: catRestaurantes, valor: 145.20),
        ],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 7),
        descricao: 'Posto Petrobras Combustível',
        referencia: LancamentoReferencia.extrato(extratoId: extratoJun1.id),
        origem: LancamentoOrigem.conta(contaId: firstConta.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccMoradia, categoriaId: catCombustivel, valor: 82.50),
        ],
        conciliado: false,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 9),
        descricao: 'Drogasil Medicamentos',
        referencia: LancamentoReferencia.fatura(faturaId: faturaJun1.id),
        origem: LancamentoOrigem.cartao(cartaoId: firstCartao.id),
        itens: [LancamentoItem(id: const Uuid().v4(), centroCustoId: ccSaude, categoriaId: catSaude, valor: 35.90)],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 6, 11),
        descricao: 'Venda Computador Usado',
        referencia: LancamentoReferencia.extrato(extratoId: extratoJun2.id),
        origem: LancamentoOrigem.conta(contaId: secondConta.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccPessoaA, categoriaId: catReceitas, valor: 1250.00),
        ],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 13),
        descricao: 'Conta de Energia Enel',
        referencia: LancamentoReferencia.extrato(extratoId: extratoJun1.id),
        origem: LancamentoOrigem.conta(contaId: firstConta.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccPessoaA, categoriaId: catMoradia, valor: 120.00),
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccPessoaB, categoriaId: catMoradia, valor: 120.00),
        ],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 15),
        descricao: 'Condomínio Edifício Jardim',
        referencia: LancamentoReferencia.extrato(extratoId: extratoJun1.id),
        origem: LancamentoOrigem.conta(contaId: firstConta.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccMoradia, categoriaId: catMoradia, valor: 650.00),
        ],
        conciliado: false,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 17),
        descricao: 'Internet Fibra Claro',
        referencia: LancamentoReferencia.fatura(faturaId: faturaJun1.id),
        origem: LancamentoOrigem.cartao(cartaoId: firstCartao.id),
        itens: [LancamentoItem(id: const Uuid().v4(), centroCustoId: ccMoradia, categoriaId: catMoradia, valor: 99.90)],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 6, 19),
        descricao: 'Reembolso Despesas Viagem',
        referencia: LancamentoReferencia.extrato(extratoId: extratoJun1.id),
        origem: LancamentoOrigem.conta(contaId: firstConta.id),
        itens: [LancamentoItem(id: const Uuid().v4(), centroCustoId: ccViagens, categoriaId: catViagem, valor: 320.00)],
        conciliado: true,
      ),

      // ---------------- MAY 2026 SEEDS ----------------
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 5, 1),
        descricao: 'Salário Mensal Zzuna',
        referencia: LancamentoReferencia.extrato(extratoId: extratoMay1.id),
        origem: LancamentoOrigem.conta(contaId: firstConta.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccPessoaA, categoriaId: catReceitas, valor: 4800.00),
        ],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 3),
        descricao: 'Supermercado Pão de Açúcar',
        referencia: LancamentoReferencia.fatura(faturaId: faturaMay1.id),
        origem: LancamentoOrigem.cartao(cartaoId: firstCartao.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccMoradia, categoriaId: catSupermercado, valor: 412.30),
        ],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 5),
        descricao: 'Restaurante Sushi Zen',
        referencia: LancamentoReferencia.fatura(faturaId: faturaMay1.id),
        origem: LancamentoOrigem.cartao(cartaoId: firstCartao.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccLazer, categoriaId: catRestaurantes, valor: 189.50),
        ],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 8),
        descricao: 'Posto Ipiranga Combustível',
        referencia: LancamentoReferencia.extrato(extratoId: extratoMay1.id),
        origem: LancamentoOrigem.conta(contaId: firstConta.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccMoradia, categoriaId: catCombustivel, valor: 90.00),
        ],
        conciliado: false,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 10),
        descricao: 'Pague Menos Medicamentos',
        referencia: LancamentoReferencia.fatura(faturaId: faturaMay1.id),
        origem: LancamentoOrigem.cartao(cartaoId: firstCartao.id),
        itens: [LancamentoItem(id: const Uuid().v4(), centroCustoId: ccSaude, categoriaId: catSaude, valor: 45.20)],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 5, 12),
        descricao: 'Venda Bicicleta Usada',
        referencia: LancamentoReferencia.extrato(extratoId: extratoMay2.id),
        origem: LancamentoOrigem.conta(contaId: secondConta.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccPessoaA, categoriaId: catReceitas, valor: 800.00),
        ],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 15),
        descricao: 'Conta de Energia Enel',
        referencia: LancamentoReferencia.extrato(extratoId: extratoMay1.id),
        origem: LancamentoOrigem.conta(contaId: firstConta.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccPessoaA, categoriaId: catMoradia, valor: 110.00),
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccPessoaB, categoriaId: catMoradia, valor: 110.00),
        ],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 18),
        descricao: 'Condomínio Edifício Jardim',
        referencia: LancamentoReferencia.extrato(extratoId: extratoMay1.id),
        origem: LancamentoOrigem.conta(contaId: firstConta.id),
        itens: [
          LancamentoItem(id: const Uuid().v4(), centroCustoId: ccMoradia, categoriaId: catMoradia, valor: 650.00),
        ],
        conciliado: false,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 18),
        descricao: 'Internet Fibra Claro',
        referencia: LancamentoReferencia.fatura(faturaId: faturaMay1.id),
        origem: LancamentoOrigem.cartao(cartaoId: firstCartao.id),
        itens: [LancamentoItem(id: const Uuid().v4(), centroCustoId: ccMoradia, categoriaId: catMoradia, valor: 99.90)],
        conciliado: true,
      ),
      Lancamento(
        id: const Uuid().v4(),
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 5, 25),
        descricao: 'Reembolso Almoço Comercial',
        referencia: LancamentoReferencia.extrato(extratoId: extratoMay1.id),
        origem: LancamentoOrigem.conta(contaId: firstConta.id),
        itens: [LancamentoItem(id: const Uuid().v4(), centroCustoId: ccViagens, categoriaId: catViagem, valor: 75.00)],
        conciliado: true,
      ),
    ];

    for (final s in seeds) {
      await _storage.create(s);
    }
  }
}
