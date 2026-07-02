import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_itens_grupo_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';

class LancamentosUpdateValorGrupoViewModel extends ChangeNotifier {
  final UpdateLancamentosItensGrupoUseCase _useCase;
  final CategoriaTreeUseCase _categoriaTreeUseCase;
  final CentroCustoRepository _centroCustoRepository;
  final CategoriaRepository _categoriaRepository;

  LancamentosUpdateValorGrupoViewModel(
    this._useCase,
    this._categoriaTreeUseCase,
    this._centroCustoRepository,
    this._categoriaRepository,
  );

  List<CategoriaDetails> categorias = [];
  List<CentroCusto> centros = [];
  bool isLoading = false;

  late final updateValorGrupoCommand =
      Command1<Unit, ({String lancamentoId, List<LancamentoItem> novosItens})>(
        _updateValorGrupo,
      );

  AsyncResult<Unit> _updateValorGrupo(
    ({String lancamentoId, List<LancamentoItem> novosItens}) params,
  ) async {
    return _useCase.execute(
      lancamentoId: params.lancamentoId,
      novosItens: params.novosItens,
    );
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    final categoriasResult = await _categoriaRepository.getAll();
    final centrosResult = await _centroCustoRepository.getAll();

    final categoriasList = categoriasResult.getOrElse((_) => <Categoria>[]);
    categorias = _categoriaTreeUseCase.build(categoriasList);

    centros = centrosResult
        .getOrElse((_) => <CentroCusto>[])
        .where((cc) => cc.ativo)
        .toList();

    isLoading = false;
    notifyListeners();
  }
}
