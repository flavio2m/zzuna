import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
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
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamentos_usecase.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

class LancamentoCreateViewModel extends ChangeNotifier {
  final CreateLancamentoUseCase _useCase;
  final CreateLancamentosUseCase _batchUseCase;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final CategoriaRepository _categoriaRepository;
  final CentroCustoRepository _centroCustoRepository;
  final CategoriaTreeUseCase _categoriaTreeUseCase;

  LancamentoCreateViewModel(
    this._useCase,
    this._batchUseCase,
    this._contaRepository,
    this._cartaoRepository,
    this._categoriaRepository,
    this._centroCustoRepository,
    this._categoriaTreeUseCase,
  );

  /// Lista unificada de origens (contas ativas + cartões ativos), preparada para a UI.
  List<LancamentoOrigemDetail> origens = [];

  /// Árvore de categorias processada pelo [CategoriaTreeUseCase].
  List<CategoriaDetails> categorias = [];

  /// Lista de centros de custo ativos.
  List<CentroCusto> centros = [];

  bool isLoading = false;

  late final createCommand = Command1<List<Lancamento>, List<LancamentoDto>>(_createAll);

  /// Carrega todas as listas necessárias para o formulário de cadastro.
  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    final contasResult = await _contaRepository.getAll();
    final cartoesResult = await _cartaoRepository.getAll();
    final categoriasResult = await _categoriaRepository.getAll();
    final centrosResult = await _centroCustoRepository.getAll();

    // Monta a lista de origens: primeiro contas ativas, depois cartões ativos
    final novasOrigens = <LancamentoOrigemDetail>[];

    final contas = contasResult.getOrElse((_) => <Conta>[]);
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

    final cartoes = cartoesResult.getOrElse((_) => <Cartao>[]);
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

    final categoriasList = categoriasResult.getOrElse((_) => <Categoria>[]);
    categorias = _categoriaTreeUseCase.build(categoriasList);

    centros =
        centrosResult.getOrElse((_) => <CentroCusto>[]).where((cc) => cc.ativo).toList();

    isLoading = false;
    notifyListeners();
  }

  AsyncResult<List<Lancamento>> _createAll(List<LancamentoDto> dtos) async {
    if (dtos.isEmpty) return const Success([]);
    if (dtos.length == 1) {
      return _useCase.execute(dtos.first).map((l) => [l]);
    }
    return _batchUseCase.execute(dtos);
  }
}
