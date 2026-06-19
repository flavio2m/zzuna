import 'dart:async';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/utils/comparers/string_comparer.dart';

class LancamentosSidebarViewModel {
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final CentroCustoRepository _centroCustoRepository;
  final CategoriaRepository _categoriaRepository;
  final CategoriaTreeUseCase _treeUseCase;

  final List<StreamSubscription> _subscriptions = [];

  List<ContaDetails> contas = [];
  List<CartaoDetails> cartoes = [];
  List<CentroCusto> centros = [];
  List<CategoriaDetails> categorias = [];

  LancamentosSidebarViewModel(
    this._contaRepository,
    this._cartaoRepository,
    this._centroCustoRepository,
    this._categoriaRepository,
    this._treeUseCase,
  ) {
    _subscriptions.add(
      _contaRepository.observer().listen((_) => loadCommand.execute()), //
    );
    _subscriptions.add(
      _cartaoRepository.observer().listen((_) => loadCommand.execute()), //
    );
    _subscriptions.add(
      _centroCustoRepository.observer().listen((_) => loadCommand.execute()), //
    );
    _subscriptions.add(
      _categoriaRepository.observer().listen((_) => loadCommand.execute()), //
    );
  }

  late final loadCommand = Command0(_load);

  AsyncResult<Unit> _load() async {
    // 1. Load Contas
    final contasResult = await _contaRepository.getAll();
    if (contasResult.isSuccess()) {
      final list = contasResult.getOrThrow();
      contas = list.map(_toContaDetails).toList()
        ..sort(
          (a, b) => StringComparer.compareIgnoreAccents(
            a.descricao,
            b.descricao, //
          ),
        );
    }

    // 2. Load Cartoes
    final cartoesResult = await _cartaoRepository.getAll();
    if (cartoesResult.isSuccess()) {
      final list = cartoesResult.getOrThrow();
      cartoes = list.map(_toCartaoDetails).toList()
        ..sort(
          (a, b) => StringComparer.compareIgnoreAccents(
            a.descricao,
            b.descricao, //
          ),
        );
    }

    // 3. Load Centros de Custo
    final centrosResult = await _centroCustoRepository.getAll();
    if (centrosResult.isSuccess()) {
      centros = centrosResult.getOrThrow()
        ..sort(
          (a, b) => StringComparer.compareIgnoreAccents(
            a.descricao,
            b.descricao, //
          ),
        );
    }

    // 4. Load Categorias
    final categoriasResult = await _categoriaRepository.getAll();
    if (categoriasResult.isSuccess()) {
      final list = categoriasResult.getOrThrow()
        ..sort(
          (a, b) => StringComparer.compareIgnoreAccents(
            a.descricao,
            b.descricao, //
          ),
        );
      categorias = _treeUseCase.build(list);
    }

    return const Success(unit);
  }

  ContaDetails _toContaDetails(Conta conta) {
    final banco = Bancos.bySigla(conta.bancoSigla).getOrThrow();
    return ContaDetails(
      id: conta.id,
      descricao: conta.descricao,
      banco: banco,
      ativo: conta.ativo, //
    );
  }

  CartaoDetails _toCartaoDetails(Cartao cartao) {
    final banco = Bancos.bySigla(cartao.bancoSigla).getOrThrow();
    return CartaoDetails(
      id: cartao.id,
      descricao: cartao.descricao,
      limite: cartao.limite,
      banco: banco,
      ativo: cartao.ativo,
      diaFechamento: cartao.diaFechamento,
    );
  }

  List<ContaDetails> filteredContas(String filtro) {
    if (filtro.isEmpty) return contas;
    return contas
        .where(
          (c) => c.descricao.toLowerCase().contains(filtro.toLowerCase()), //
        )
        .toList();
  }

  List<CartaoDetails> filteredCartoes(String filtro) {
    if (filtro.isEmpty) return cartoes;
    return cartoes
        .where(
          (c) => c.descricao.toLowerCase().contains(filtro.toLowerCase()), //
        )
        .toList();
  }

  List<CentroCusto> filteredCentros(String filtro) {
    if (filtro.isEmpty) return centros;
    return centros
        .where(
          (c) => c.descricao.toLowerCase().contains(filtro.toLowerCase()), //
        )
        .toList();
  }

  List<CategoriaDetails> filteredCategorias(String filtro) {
    if (filtro.isEmpty) return categorias;
    return categorias.where((c) => _matchesCategoryFilter(c, filtro)).toList();
  }

  bool _matchesCategoryFilter(CategoriaDetails category, String filter) {
    final query = filter.toLowerCase();
    return category.descricao.toLowerCase().contains(query) ||
        category.subcategorias.any(
          (child) => _matchesCategoryFilter(child, filter), //
        );
  }

  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
  }
}
