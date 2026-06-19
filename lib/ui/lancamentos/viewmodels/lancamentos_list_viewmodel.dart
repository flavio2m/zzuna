import 'dart:async';

import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_details_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';

class LancamentosListViewModel {
  final LancamentoDetailsUseCase _detailsUseCase;
  final LancamentoFilterUseCase _filterUseCase;
  final LancamentoRepository _repository;
  StreamSubscription? _repositorySubscription;

  String? descricaoQuery;
  LancamentoTipo? tipoSelecionado;
  bool? conciliadoSelecionado;
  Mes mesSelecionado = Mes.fromDate(DateTime.now());
  int anoSelecionado = DateTime.now().year;

  List<LancamentoDetails> lancamentos = [];

  LancamentosListViewModel(
    this._detailsUseCase,
    this._filterUseCase,
    this._repository,
  ) {
    _repositorySubscription = _repository.observer().listen((_) {
      loadCommand.execute();
    });
  }

  late final loadCommand = Command0(_load);

  AsyncResult<List<LancamentoDetails>> _load() async {
    try {
      final allDetails = await _detailsUseCase.execute(
        mes: mesSelecionado,
        ano: anoSelecionado,
      );
      final filter = LancamentoFilterDto(
        descricao: descricaoQuery ?? '',
        tipo: tipoSelecionado,
        conciliado: conciliadoSelecionado,
      );
      final filtered = _filterUseCase.execute(allDetails, filter);
      lancamentos = filtered;
      return Success(filtered);
    } catch (e) {
      return Failure(Exception('Erro ao carregar lançamentos: $e'));
    }
  }

  void setDescricao(String value) {
    descricaoQuery = value;
  }

  void setTipo(LancamentoTipo? value) {
    tipoSelecionado = value;
    loadCommand.execute();
  }

  void setConciliado(bool? value) {
    conciliadoSelecionado = value;
    loadCommand.execute();
  }

  void setMes(Mes? value) {
    if (value != null) {
      mesSelecionado = value;
      loadCommand.execute();
    }
  }

  void setAno(int? value) {
    if (value != null) {
      anoSelecionado = value;
      loadCommand.execute();
    }
  }

  void mesAnterior() {
    const minYear = 2025;
    if (mesSelecionado == Mes.janeiro && anoSelecionado == minYear) {
      return;
    }
    if (mesSelecionado == Mes.janeiro) {
      anoSelecionado--;
    }
    mesSelecionado = mesSelecionado.anterior;
    loadCommand.execute();
  }

  void proximoMes() {
    final maxYear = DateTime.now().year + 2;
    if (mesSelecionado == Mes.dezembro && anoSelecionado == maxYear) {
      return;
    }
    if (mesSelecionado == Mes.dezembro) {
      anoSelecionado++;
    }
    mesSelecionado = mesSelecionado.proximo;
    loadCommand.execute();
  }

  void pesquisar() {
    loadCommand.execute();
  }

  void dispose() {
    _repositorySubscription?.cancel();
  }
}
