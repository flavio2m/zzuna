import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/lancamentos/pendentes/widgets/lancamento_pendente_list_item.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class LancamentoPendenteWorkspace extends ConsumerWidget {
  const LancamentoPendenteWorkspace({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(lancamentoPendenteViewModelProvider);

    return Container(
      color: AppColors.background,
      child: ListenableBuilder(
        listenable: Listenable.merge([viewModel.loadCommand, viewModel]),
        builder: (context, _) {
          final state = viewModel.loadCommand.value;
          final lancamentos = viewModel.lancamentosVisiveis;

          if (state.isRunning && lancamentos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure) {
            return Center(
              child: Text(
                'Erro ao carregar lançamentos: ${state.getExceptionOrNull()}',
                style: const TextStyle(color: AppColors.danger),
              ),
            );
          }

          if (lancamentos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 48,
                    color: AppColors.slate400,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Nenhum lançamento pendente encontrado.',
                    style: TextStyle(color: AppColors.slate500),
                  ),
                ],
              ),
            );
          }

          // Agrupar por data (apenas a data, sem horário)
          final Map<DateTime, List<LancamentoDetails>> byDay = {};
          for (final l in lancamentos) {
            final day = DateTime(l.data.year, l.data.month, l.data.day);
            byDay.putIfAbsent(day, () => []).add(l);
          }
          final sortedDays = byDay.keys.toList()..sort();

          Widget content = ListView.separated(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            itemCount: sortedDays.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final day = sortedDays[index];
              return LancamentoPendenteDayCard(
                data: day,
                lancamentos: byDay[day]!,
              );
            },
          );

          if (state.isRunning) {
            return Stack(
              children: [
                content,
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ),
              ],
            );
          }

          return content;
        },
      ),
    );
  }
}
