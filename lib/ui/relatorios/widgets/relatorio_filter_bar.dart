import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/ui/relatorios/filter/providers/relatorio_filter_provider.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_filter_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_year_stepper.dart';

class RelatorioFilterBar extends ConsumerWidget {
  const RelatorioFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(relatorioFilterProvider);
    final notifier = ref.read(relatorioFilterProvider.notifier);
    final maxYear = DateTime.now().year + 2;

    return AppFilterCard(
      initiallyExpanded: true,
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed:
                    (filterState.mes == Mes.janeiro && filterState.ano == 2025)
                    ? null
                    : () => notifier.mesAnterior(),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 130,
                child: AppDropdownFormField<Mes>(
                  label: 'Mês',
                  value: filterState.mes,
                  items: Mes.values
                      .map(
                        (mes) => AppDropdownMenuItem(
                          value: mes,
                          label: mes.descricao,
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    notifier.setMes(value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              AppYearStepper(
                value: filterState.ano,
                min: 2025,
                max: maxYear,
                onChanged: (value) {
                  notifier.setAno(value);
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed:
                    (filterState.mes == Mes.dezembro &&
                        filterState.ano == maxYear)
                    ? null
                    : () => notifier.proximoMes(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
