import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/ui/lancamentos/sidebar/models/lancamentos_sidebar_state.dart';

class LancamentosSidebarNotifier extends StateNotifier<LancamentosSidebarState> {
  LancamentosSidebarNotifier() : super(const LancamentosSidebarState());

  void setFiltro(String value) {
    state = state.copyWith(filtro: value);
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

  void toggleCategoria(
    String id, {
    List<String> subcategoriesIds = const [], //
  }) {
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

  void toggleContasSection() {
    state = state.copyWith(contasExpandidas: !state.contasExpandidas);
  }

  void toggleCartoesSection() {
    state = state.copyWith(cartoesExpandidos: !state.cartoesExpandidos);
  }

  void toggleCentrosSection() {
    state = state.copyWith(centrosExpandidos: !state.centrosExpandidos);
  }

  void toggleCategoriasSection() {
    state = state.copyWith(categoriasExpandidas: !state.categoriasExpandidas);
  }

  void toggleCategoriaExpandida(String id) {
    final current = {...state.categoriasExpandidasIds};
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(categoriasExpandidasIds: current);
  }

  void clearSelection() {
    state = state.copyWith(
      contasSelecionadas: const {},
      cartoesSelecionados: const {},
      centrosSelecionados: const {},
      categoriasSelecionadas: const {},
    );
  }

  void selectAllContas(List<String> ids) {
    state = state.copyWith(contasSelecionadas: ids.toSet());
  }

  void clearContas() {
    state = state.copyWith(contasSelecionadas: const {});
  }

  void selectAllCartoes(List<String> ids) {
    state = state.copyWith(cartoesSelecionados: ids.toSet());
  }

  void clearCartoes() {
    state = state.copyWith(cartoesSelecionados: const {});
  }

  void selectAllCentros(List<String> ids) {
    state = state.copyWith(centrosSelecionados: ids.toSet());
  }

  void clearCentros() {
    state = state.copyWith(centrosSelecionados: const {});
  }

  void selectAllCategorias(List<String> ids) {
    state = state.copyWith(categoriasSelecionadas: ids.toSet());
  }

  void clearCategorias() {
    state = state.copyWith(categoriasSelecionadas: const {});
  }
}
