import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/domain/enums/mes.dart';
import '../models/relatorio_filter_state.dart';

class RelatorioFilterNotifier extends StateNotifier<RelatorioFilterState> {
  RelatorioFilterNotifier() : super(RelatorioFilterState.initial());

  void setMes(Mes? mes) {
    if (mes != null) {
      state = state.copyWith(mes: mes);
    }
  }

  void setAno(int ano) {
    state = state.copyWith(ano: ano);
  }

  void mesAnterior() {
    if (state.mes == Mes.janeiro) {
      if (state.ano > 2025) {
        state = state.copyWith(mes: Mes.dezembro, ano: state.ano - 1);
      }
    } else {
      final prevMesIndex = state.mes.index - 1;
      state = state.copyWith(mes: Mes.values[prevMesIndex]);
    }
  }

  void proximoMes() {
    final maxYear = DateTime.now().year + 2;
    if (state.mes == Mes.dezembro) {
      if (state.ano < maxYear) {
        state = state.copyWith(mes: Mes.janeiro, ano: state.ano + 1);
      }
    } else {
      final nextMesIndex = state.mes.index + 1;
      state = state.copyWith(mes: Mes.values[nextMesIndex]);
    }
  }
}

final relatorioFilterProvider =
    StateNotifierProvider<RelatorioFilterNotifier, RelatorioFilterState>((ref) {
      return RelatorioFilterNotifier();
    });
