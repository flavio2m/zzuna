part of '../providers.dart';

final listaComprasRepositoryProvider = Provider<ListaComprasRepository>((ref) {
  final repository = ListaComprasRepository(
    ref.watch(listaComprasStorageProvider),
  );

  ref.onDispose(repository.dispose);

  return repository;
});

class ListaComprasFilterNotifier extends StateNotifier<ListaComprasFilterDto> {
  ListaComprasFilterNotifier()
    : super(
        ListaComprasFilterDto(
          ano: DateTime.now().year,
          mes: Mes.fromDate(DateTime.now()),
        ),
      );

  void setAno(int ano) {
    state = state.copyWith(ano: ano);
  }

  void setMes(Mes mes) {
    state = state.copyWith(mes: mes, situacao: null, supermercado: null);
  }

  void setSituacao(ItemCompraSituacao? situacao) {
    state = state.copyWith(situacao: situacao);
  }

  void setSupermercado(String? supermercado) {
    state = state.copyWith(supermercado: supermercado);
  }

  void mesAnterior() {
    if (state.mes == Mes.janeiro) {
      state = state.copyWith(
        mes: Mes.dezembro,
        ano: state.ano - 1,
        situacao: null,
        supermercado: null,
      );
    } else {
      state = state.copyWith(
        mes: state.mes.anterior,
        situacao: null,
        supermercado: null,
      );
    }
  }

  void proximoMes() {
    if (state.mes == Mes.dezembro) {
      state = state.copyWith(
        mes: Mes.janeiro,
        ano: state.ano + 1,
        situacao: null,
        supermercado: null,
      );
    } else {
      state = state.copyWith(
        mes: state.mes.proximo,
        situacao: null,
        supermercado: null,
      );
    }
  }
}

final listaComprasFilterProvider =
    StateNotifierProvider<ListaComprasFilterNotifier, ListaComprasFilterDto>((
      ref,
    ) {
      return ListaComprasFilterNotifier();
    });

final listaComprasListViewModelProvider =
    ChangeNotifierProvider.autoDispose<ListaComprasListViewModel>((ref) {
      final vm = ListaComprasListViewModel(
        ref.watch(listaComprasRepositoryProvider),
      );
      ref.listen(listaComprasFilterProvider, (previous, next) {
        vm.setFilter(next);
      });
      vm.setFilter(ref.read(listaComprasFilterProvider));
      return vm;
    });

final listaComprasCreateViewModelProvider =
    Provider<ItemComprasCreateViewModel>((ref) {
      return ItemComprasCreateViewModel(
        ref.watch(listaComprasRepositoryProvider),
      );
    });

final listaComprasComprarViewModelProvider =
    Provider<ListaComprasComprarViewModel>((ref) {
      return ListaComprasComprarViewModel(
        ref.watch(listaComprasRepositoryProvider),
      );
    });

final listaComprasStatusViewModelProvider =
    Provider<ListaComprasStatusViewModel>((ref) {
      return ListaComprasStatusViewModel(
        ref.watch(listaComprasRepositoryProvider),
      );
    });

final listaComprasDuplicarViewModelProvider =
    Provider<ListaComprasDuplicarViewModel>((ref) {
      return ListaComprasDuplicarViewModel(
        ref.watch(listaComprasRepositoryProvider),
      );
    });

final listaComprasDeleteViewModelProvider =
    Provider<ItemComprasDeleteViewModel>((ref) {
      return ItemComprasDeleteViewModel(
        ref.watch(listaComprasRepositoryProvider),
      );
    });

final listaComprasDeleteListaViewModelProvider =
    Provider<ListaComprasDeleteListaViewModel>((ref) {
      return ListaComprasDeleteListaViewModel(
        ref.watch(listaComprasRepositoryProvider),
      );
    });
