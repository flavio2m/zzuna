import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/base_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/enums/lancamento_modo.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

class LancamentoPendenteViewModel extends ChangeNotifier {
  final LancamentoDetailsUseCase _detailsUseCase;
  final LancamentoFilterUseCase _filterUseCase;
  final LancamentoRepository _repository;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final CategoriaRepository _categoriaRepository;
  final CentroCustoRepository _centroCustoRepository;
  final CategoriaTreeUseCase _categoriaTreeUseCase;

  List<LancamentoDetails> _allLancamentos = [];
  List<LancamentoDetails> lancamentosVisiveis = [];

  List<LancamentoOrigemDetail> origens = [];
  List<CategoriaDetails> categorias = [];
  List<CentroCusto> centros = [];

  LancamentoFilterDto _currentFilter = const LancamentoFilterDto();

  final Set<String> _selectedIds = {};
  Set<String> get selectedLancamentoIds => _selectedIds;

  bool _pendingLoad = false;
  StreamSubscription? _repositorySubscription;

  late final loadCommand = Command0(_load);

  LancamentoPendenteViewModel(
    this._detailsUseCase,
    this._filterUseCase,
    this._repository,
    this._contaRepository,
    this._cartaoRepository,
    this._categoriaRepository,
    this._centroCustoRepository,
    this._categoriaTreeUseCase,
  ) {
    _repositorySubscription = _repository.observer().listen((event) {
      if (event is RepositoryUpdated<Lancamento>) {
        final updated = event.model;
        final index = _allLancamentos.indexWhere((l) => l.id == updated.id);

        if (index != -1) {
          final existing = _allLancamentos[index];
          final updatedValor = updated.itens.fold<double>(
            0.0,
            (total, item) => total + item.valor,
          );

          final isStructuralChanged =
              existing.anoMes != updated.anoMes ||
              existing.tipo != updated.tipo ||
              existing.valor != updatedValor ||
              existing.descricao != updated.descricao;

          if (isStructuralChanged) {
            _triggerLoad();
          } else {
            _allLancamentos[index] = existing.copyWith(
              conciliado: updated.conciliado,
            );
            _applyFilter();
          }
        } else {
          _triggerLoad();
        }
      } else {
        _triggerLoad();
      }
    });

    loadCommand.addListener(() {
      if (!loadCommand.value.isRunning && _pendingLoad) {
        _pendingLoad = false;
        loadCommand.execute();
      }
    });
  }

  void _triggerLoad() {
    if (loadCommand.value.isRunning) {
      _pendingLoad = true;
    } else {
      _pendingLoad = false;
      loadCommand.execute();
    }
  }

  AsyncResult<List<LancamentoDetails>> _load() async {
    _selectedIds.clear();

    final contasResult = await _contaRepository.getAll();
    final cartoesResult = await _cartaoRepository.getAll();
    final categoriasResult = await _categoriaRepository.getAll();
    final centrosResult = await _centroCustoRepository.getAll();

    final contas = contasResult.getOrElse((_) => <Conta>[]);
    final cartoes = cartoesResult.getOrElse((_) => <Cartao>[]);
    final catEntities = categoriasResult.getOrElse((_) => <Categoria>[]);
    centros = centrosResult.getOrElse((_) => <CentroCusto>[]);

    categorias = _categoriaTreeUseCase.build(catEntities);

    final novasOrigens = <LancamentoOrigemDetail>[];
    for (final conta in contas) {
      if (!conta.ativo) continue;
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
    for (final cartao in cartoes) {
      if (!cartao.ativo) continue;
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

    final allDetails = await _detailsUseCase.executeUnconsolidated();
    _allLancamentos = allDetails;
    _applyFilter();
    return Success(lancamentosVisiveis);
  }

  void _applyFilter() {
    lancamentosVisiveis = _filterUseCase.execute(
      _allLancamentos,
      _currentFilter,
    );
    notifyListeners();
  }

  void updateFilter({
    String? descricao,
    LancamentoTipo? tipo,
    bool clearTipo = false,
    LancamentoModo? modo,
    bool clearModo = false,
    Set<String>? contasSelecionadas,
    Set<String>? cartoesSelecionados,
    Set<String>? centrosSelecionados,
    Set<String>? categoriasSelecionadas,
  }) {
    _currentFilter = LancamentoFilterDto(
      descricao: descricao ?? _currentFilter.descricao,
      tipo: clearTipo ? null : (tipo ?? _currentFilter.tipo),
      modo: clearModo ? null : (modo ?? _currentFilter.modo),
      conciliado: false, // Sempre filtrar não conciliados
      contasSelecionadas:
          contasSelecionadas ?? _currentFilter.contasSelecionadas,
      cartoesSelecionados:
          cartoesSelecionados ?? _currentFilter.cartoesSelecionados,
      centrosSelecionados:
          centrosSelecionados ?? _currentFilter.centrosSelecionados,
      categoriasSelecionadas:
          categoriasSelecionadas ?? _currentFilter.categoriasSelecionadas,
    );
    _applyFilter();
  }

  void setOrigem(LancamentoOrigem? origem) {
    if (origem == null) {
      updateFilter(contasSelecionadas: {}, cartoesSelecionados: {});
    } else if (origem is LancamentoOrigemConta) {
      updateFilter(
        contasSelecionadas: {origem.contaId},
        cartoesSelecionados: {},
      );
    } else if (origem is LancamentoOrigemCartao) {
      updateFilter(
        contasSelecionadas: {},
        cartoesSelecionados: {origem.cartaoId},
      );
    }
  }

  LancamentoOrigem? get selectedOrigem {
    if (_currentFilter.contasSelecionadas.isNotEmpty) {
      return LancamentoOrigem.conta(
        contaId: _currentFilter.contasSelecionadas.first,
      );
    }
    if (_currentFilter.cartoesSelecionados.isNotEmpty) {
      return LancamentoOrigem.cartao(
        cartaoId: _currentFilter.cartoesSelecionados.first,
      );
    }
    return null;
  }

  void setCategoria(String? categoriaId) {
    if (categoriaId == null) {
      updateFilter(categoriasSelecionadas: {});
    } else {
      updateFilter(categoriasSelecionadas: {categoriaId});
    }
  }

  String? get selectedCategoria {
    if (_currentFilter.categoriasSelecionadas.isNotEmpty) {
      return _currentFilter.categoriasSelecionadas.first;
    }
    return null;
  }

  void setCentroCusto(String? centroId) {
    if (centroId == null) {
      updateFilter(centrosSelecionados: {});
    } else {
      updateFilter(centrosSelecionados: {centroId});
    }
  }

  String? get selectedCentroCusto {
    if (_currentFilter.centrosSelecionados.isNotEmpty) {
      return _currentFilter.centrosSelecionados.first;
    }
    return null;
  }

  LancamentoFilterDto get currentFilter => _currentFilter;

  // ── Seleção ──────────────────────────────────────────────────────────────

  void toggleSelection(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }

  void toggleSelectionForList(List<String> ids, bool select) {
    if (select) {
      _selectedIds.addAll(ids);
    } else {
      _selectedIds.removeAll(ids);
    }
    notifyListeners();
  }

  bool get allSelected {
    if (lancamentosVisiveis.isEmpty) return false;
    return lancamentosVisiveis.every((l) => _selectedIds.contains(l.id));
  }

  void selectAll() {
    _selectedIds.addAll(lancamentosVisiveis.map((l) => l.id));
    notifyListeners();
  }

  void toggleSelectAll() {
    if (allSelected) {
      _selectedIds.removeAll(lancamentosVisiveis.map((l) => l.id));
    } else {
      selectAll();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _repositorySubscription?.cancel();
    super.dispose();
  }
}
