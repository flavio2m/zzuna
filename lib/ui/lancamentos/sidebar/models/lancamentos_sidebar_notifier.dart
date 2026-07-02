import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/ui/lancamentos/sidebar/models/lancamentos_sidebar_state.dart';

class LancamentosSidebarNotifier
    extends StateNotifier<LancamentosSidebarState> {
  LancamentosSidebarNotifier() : super(const LancamentosSidebarState());

  void setFiltro(String value) {
    state = state.copyWith(filtro: value);
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
}
