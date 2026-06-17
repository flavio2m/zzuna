import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/viewmodels/lancamentos_sidebar_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/widgets/sidebar_search.dart';
import 'package:zzuna/ui/lancamentos/widgets/sidebar_conta_section.dart';
import 'package:zzuna/ui/lancamentos/widgets/sidebar_cartao_section.dart';
import 'package:zzuna/ui/lancamentos/widgets/sidebar_centro_custo_section.dart';
import 'package:zzuna/ui/lancamentos/widgets/sidebar_categoria_section.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class AccountsSideMenu extends ConsumerStatefulWidget {
  const AccountsSideMenu({super.key});

  @override
  ConsumerState<AccountsSideMenu> createState() => _AccountsSideMenuState();
}

class _AccountsSideMenuState extends ConsumerState<AccountsSideMenu> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lancamentosSidebarViewModelProvider).loadCommand.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    final LancamentosSidebarViewModel viewModel = ref.watch(
      lancamentosSidebarViewModelProvider, //
    );
    final sidebarState = ref.watch(lancamentosSidebarStateProvider);

    return ListenableBuilder(
      listenable: viewModel.loadCommand,
      builder: (context, _) {
        final filteredContas = viewModel.filteredContas(sidebarState.filtro);
        final filteredCartoes = viewModel.filteredCartoes(sidebarState.filtro);
        final filteredCentros = viewModel.filteredCentros(sidebarState.filtro);
        final filteredCategorias = viewModel.filteredCategorias(sidebarState.filtro);

        return Container(
          width: 280,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(right: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            children: [
              const SidebarSearch(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.slate100), //
                          ),
                        ),
                        child: Column(
                          children: [
                            SidebarContaSection(items: filteredContas),
                            const Divider(height: 18, color: AppColors.slate100),
                            SidebarCartaoSection(items: filteredCartoes),
                            const Divider(height: 18, color: AppColors.slate100),
                            SidebarCentroCustoSection(items: filteredCentros),
                          ],
                        ),
                      ),
                      SidebarCategoriaSection(items: filteredCategorias),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
