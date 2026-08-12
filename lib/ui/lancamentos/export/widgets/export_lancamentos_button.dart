import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';

class ExportLancamentosButton extends ConsumerWidget {
  const ExportLancamentosButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportViewModel = ref.watch(exportLancamentosViewModelProvider);

    ref.listen(
      exportLancamentosViewModelProvider.select((vm) => vm.exportCommand.value),
      (previous, next) {
        next.when(
          data: (savedPath) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Planilha exportada com sucesso: $savedPath'),
                backgroundColor: AppColors.emerald600,
              ),
            );
          },
          failure: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao exportar planilha: $error'),
                backgroundColor: AppColors.danger,
              ),
            );
          },
          orElse: () {},
        );
      },
    );

    return ListenableBuilder(
      listenable: exportViewModel.exportCommand,
      builder: (context, _) {
        final isRunning = exportViewModel.exportCommand.value.isRunning;

        return ButtonAdd(
          icon: Icons.table_chart_outlined,
          label: 'Exportar XLS',
          color: AppColors.emerald800,
          loading: isRunning,
          onPressed: isRunning
              ? () {}
              : () {
                  final listViewModel = ref.read(
                    lancamentosListViewModelProvider,
                  );
                  final filterState = ref.read(lancamentoFilterProvider);

                  final List<LancamentoDetails> lancamentos =
                      listViewModel.resumoMensal?.dias
                          .expand((d) => d.lancamentos)
                          .toList() ??
                      [];

                  if (lancamentos.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Nenhum lançamento visível para exportar.',
                        ),
                      ),
                    );
                    return;
                  }

                  exportViewModel.exportCommand.execute((
                    lancamentos: lancamentos,
                    lancamentosDesconsiderados:
                        filterState.lancamentosDesconsiderados,
                    mes: filterState.mes,
                    ano: filterState.ano,
                  ));
                },
        );
      },
    );
  }
}
