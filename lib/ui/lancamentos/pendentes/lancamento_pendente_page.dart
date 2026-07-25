import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/pendentes/widgets/lancamento_pendente_filter_bar.dart';
import 'package:zzuna/ui/lancamentos/pendentes/widgets/lancamento_pendente_workspace.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';

class LancamentoPendentePage extends ConsumerStatefulWidget {
  const LancamentoPendentePage({super.key});

  @override
  ConsumerState<LancamentoPendentePage> createState() =>
      _LancamentoPendentePageState();
}

class _LancamentoPendentePageState
    extends ConsumerState<LancamentoPendentePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lancamentoPendenteViewModelProvider).loadCommand.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const AppCard(
            variant: AppCardVariant.filter,
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: LancamentoPendenteFilterBar(),
          ),
          const AppDivider(),
          const Expanded(
            child: AppCard(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 8),
              child: LancamentoPendenteWorkspace(),
            ),
          ),
        ],
      ),
    );
  }
}
