import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/sidebar/widgets/accounts_side_menu.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/lancamento_filter_bar.dart';
import 'package:zzuna/ui/lancamentos/list/widgets/transactions_workspace.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';

class LancamentosPage extends ConsumerStatefulWidget {
  const LancamentosPage({super.key});

  @override
  ConsumerState<LancamentosPage> createState() => _LancamentosPageState();
}

class _LancamentosPageState extends ConsumerState<LancamentosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lancamentosListViewModelProvider).loadCommand.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        AccountsSideMenu(),
        Expanded(
          child: Column(
            children: [
              AppCard(
                variant: AppCardVariant.filter,
                margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                child: LancamentoFilterBar(),
              ),
              AppDivider(),
              Expanded(
                child: AppCard(
                  margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 8),
                  child: TransactionsWorkspace(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
