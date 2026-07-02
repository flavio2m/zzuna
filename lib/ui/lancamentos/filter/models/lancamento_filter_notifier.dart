import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/lancamentos/filter/models/lancamento_filter_state.dart';

class LancamentoFilterNotifier extends StateNotifier<LancamentoFilterState> {
  LancamentoFilterNotifier()
    : super(
        LancamentoFilterState(
          mes: Mes.fromDate(DateTime.now()),
          ano: DateTime.now().year,
        ),
      );

  void setDescricao(String value) {
    state = state.copyWith(descricao: value);
  }

  void setMes(Mes? value) {
    if (value != null) {
      state = state.copyWith(mes: value);
    }
  }

  void setAno(int? value) {
    if (value != null) {
      state = state.copyWith(ano: value);
    }
  }

  void setTipo(LancamentoTipo? value) {
    state = state.copyWith(tipo: value, clearTipo: value == null);
  }

  void setConciliado(bool? value) {
    state = state.copyWith(conciliado: value, clearConciliado: value == null);
  }

  void toggleConta(String id) {
    final current = {...state.contasSelecionadas};
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(contasSelecionadas: current);
  }

  void toggleCartao(String id) {
    final current = {...state.cartoesSelecionados};
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(cartoesSelecionados: current);
  }

  void toggleCentroCusto(String id) {
    final current = {...state.centrosSelecionados};
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(centrosSelecionados: current);
  }

  void toggleCategoria(String id, {List<String> subcategoriesIds = const []}) {
    final current = {...state.categoriasSelecionadas};
    final select = !current.contains(id);
    if (select) {
      current.add(id);
      current.addAll(subcategoriesIds);
    } else {
      current.remove(id);
      current.removeAll(subcategoriesIds);
    }
    state = state.copyWith(categoriasSelecionadas: current);
  }

  void clear() {
    state = state.copyWith(
      descricao: '',
      tipo: null,
      conciliado: null,
      clearTipo: true,
      clearConciliado: true,
      contasSelecionadas: const {},
      cartoesSelecionados: const {},
      centrosSelecionados: const {},
      categoriasSelecionadas: const {},
    );
  }

  void clearContas() {
    state = state.copyWith(contasSelecionadas: const {});
  }

  void clearCartoes() {
    state = state.copyWith(cartoesSelecionados: const {});
  }

  void clearCentros() {
    state = state.copyWith(centrosSelecionados: const {});
  }

  void clearCategorias() {
    state = state.copyWith(categoriasSelecionadas: const {});
  }

  void selectAllContas(List<String> ids) {
    state = state.copyWith(contasSelecionadas: ids.toSet());
  }

  void selectAllCartoes(List<String> ids) {
    state = state.copyWith(cartoesSelecionados: ids.toSet());
  }

  void selectAllCentros(List<String> ids) {
    state = state.copyWith(centrosSelecionados: ids.toSet());
  }

  void selectAllCategorias(List<String> ids) {
    state = state.copyWith(categoriasSelecionadas: ids.toSet());
  }

  void mesAnterior() {
    const minYear = 2025;
    if (state.mes == Mes.janeiro && state.ano == minYear) {
      return;
    }
    if (state.mes == Mes.janeiro) {
      state = state.copyWith(mes: state.mes.anterior, ano: state.ano - 1);
    } else {
      state = state.copyWith(mes: state.mes.anterior);
    }
  }

  void proximoMes() {
    final maxYear = DateTime.now().year + 2;
    if (state.mes == Mes.dezembro && state.ano == maxYear) {
      return;
    }
    if (state.mes == Mes.dezembro) {
      state = state.copyWith(mes: state.mes.proximo, ano: state.ano + 1);
    } else {
      state = state.copyWith(mes: state.mes.proximo);
    }
  }
}
