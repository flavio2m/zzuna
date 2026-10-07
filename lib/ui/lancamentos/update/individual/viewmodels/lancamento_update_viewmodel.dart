import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamento_usecase.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

class LancamentoUpdateViewModel extends ChangeNotifier {
  final UpdateLancamentoUseCase _useCase;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final CategoriaRepository _categoriaRepository;
  final CentroCustoRepository _centroCustoRepository;
  final CategoriaTreeUseCase _categoriaTreeUseCase;
  StreamSubscription? _categoriaSubscription;

  Set<String> _lastIncludeCategoriaIds = {};
  Set<String> _lastIncludeCentroCustoIds = {};
  String? _lastIncludeContaId;
  String? _lastIncludeCartaoId;

  LancamentoUpdateViewModel(
    this._useCase,
    this._contaRepository,
    this._cartaoRepository,
    this._categoriaRepository,
    this._centroCustoRepository,
    this._categoriaTreeUseCase,
  ) {
    _categoriaSubscription = _categoriaRepository.observer().listen((_) {
      load(
        includeCategoriaIds: _lastIncludeCategoriaIds,
        includeCentroCustoIds: _lastIncludeCentroCustoIds,
        includeContaId: _lastIncludeContaId,
        includeCartaoId: _lastIncludeCartaoId,
      );
    });
  }

  @override
  void dispose() {
    _categoriaSubscription?.cancel();
    super.dispose();
  }

  /// Lista unificada de origens (contas ativas + cartões ativos), preparada para a UI.
  List<LancamentoOrigemDetail> origens = [];

  /// Árvore de categorias processada pelo [CategoriaTreeUseCase].
  List<CategoriaDetails> categorias = [];

  /// Lista de centros de custo ativos.
  List<CentroCusto> centros = [];

  bool isLoading = false;

  late final updateCommand = Command1<Lancamento, LancamentoDto>(
    _useCase.execute,
  );

  /// Carrega todas as listas necessárias para o formulário de atualização.
  Future<void> load({
    Iterable<String> includeCategoriaIds = const [],
    Iterable<String> includeCentroCustoIds = const [],
    String? includeContaId,
    String? includeCartaoId,
  }) async {
    _lastIncludeCategoriaIds = includeCategoriaIds.toSet();
    _lastIncludeCentroCustoIds = includeCentroCustoIds.toSet();
    _lastIncludeContaId = includeContaId;
    _lastIncludeCartaoId = includeCartaoId;

    isLoading = true;
    notifyListeners();

    final contasResult = await _contaRepository.getAll();
    final cartoesResult = await _cartaoRepository.getAll();
    final categoriasResult = await _categoriaRepository.getAll();
    final centrosResult = await _centroCustoRepository.getAll();

    // Monta a lista de origens: contas ativas (+ conta do lançamento se inativa),
    // depois cartões ativos (+ cartão do lançamento se inativo)
    final novasOrigens = <LancamentoOrigemDetail>[];

    final contas = contasResult.getOrElse((_) => <Conta>[]);
    for (final conta in contas) {
      if (!conta.ativo && conta.id != includeContaId) continue;
      final banco = Bancos.bySigla(conta.bancoSigla).getOrNull();
      if (banco == null) continue;
      novasOrigens.add(
        LancamentoOrigemDetail.conta(
          conta: ContaDetails(
            id: conta.id,
            descricao: conta.descricao,
            banco: banco,
            ativo: conta.ativo,
            dataInicial: conta.dataInicial,
          ),
        ),
      );
    }

    final cartoes = cartoesResult.getOrElse((_) => <Cartao>[]);
    for (final cartao in cartoes) {
      if (!cartao.ativo && cartao.id != includeCartaoId) continue;
      final banco = Bancos.bySigla(cartao.bancoSigla).getOrNull();
      if (banco == null) continue;
      novasOrigens.add(
        LancamentoOrigemDetail.cartao(
          cartao: CartaoDetails(
            id: cartao.id,
            descricao: cartao.descricao,
            limite: cartao.limite,
            banco: banco,
            ativo: cartao.ativo,
            diaFechamento: cartao.diaFechamento,
            dataInicial: cartao.dataInicial,
          ),
        ),
      );
    }

    origens = novasOrigens;

    final allCategorias = categoriasResult.getOrElse((_) => <Categoria>[]);
    final Map<String, Categoria> categoriaMap = {
      for (final c in allCategorias) c.id: c,
    };

    final selectedCategoryIds = <String>{};
    for (final c in allCategorias) {
      if (c.ativo) {
        selectedCategoryIds.add(c.id);
      }
    }

    // Inclui as categorias especificadas do lançamento e seus ancestrais
    for (final catId in includeCategoriaIds) {
      String? currentId = catId;
      while (currentId != null && !selectedCategoryIds.contains(currentId)) {
        selectedCategoryIds.add(currentId);
        currentId = categoriaMap[currentId]?.categoriaPaiId;
      }
    }

    final categoriasList = allCategorias
        .where((c) => selectedCategoryIds.contains(c.id))
        .toList();
    categorias = _categoriaTreeUseCase.build(categoriasList);

    centros = centrosResult
        .getOrElse((_) => <CentroCusto>[])
        .where((cc) => cc.ativo || _lastIncludeCentroCustoIds.contains(cc.id))
        .toList();

    isLoading = false;
    notifyListeners();
  }
}
