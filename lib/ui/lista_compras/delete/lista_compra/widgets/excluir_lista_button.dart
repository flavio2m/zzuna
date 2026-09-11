import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/ui/lista_compras/delete/lista_compra/viewmodels/lista_compras_delete_lista_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_confirmation_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class ExcluirListaButton extends ConsumerStatefulWidget {
  final ListaCompras lista;

  const ExcluirListaButton({super.key, required this.lista});

  @override
  ConsumerState<ExcluirListaButton> createState() => _ExcluirListaButtonState();
}

class _ExcluirListaButtonState extends ConsumerState<ExcluirListaButton> {
  late final ListaComprasDeleteListaViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(listaComprasDeleteListaViewModelProvider);
    _viewModel.excluirListaCommand.addListener(_onCommandStateChanged);
  }

  @override
  void dispose() {
    _viewModel.excluirListaCommand.removeListener(_onCommandStateChanged);
    super.dispose();
  }

  void _onCommandStateChanged() {
    final state = _viewModel.excluirListaCommand.value;
    state.onSuccess((_) {
      if (mounted) {
        AppSnackBar.showSuccess(
          context,
          'Lista de compras excluída com sucesso.',
        );
      }
    });
    state.onFailure((exception) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          exception?.toString() ?? 'Erro ao excluir lista de compras.',
        );
      }
    });
  }

  Future<void> _handleDelete() async {
    final confirm = await AppConfirmationDialog.show<String>(
      context: context,
      title: 'Excluir Lista de Compras',
      message:
          'Tem certeza que deseja excluir toda a lista de compras de '
          '${widget.lista.mes.descricao}/${widget.lista.ano}? '
          'Esta ação não pode ser desfeita.',
      actions: const {'cancel': 'Cancelar', 'confirm': 'Excluir'},
    );

    if (confirm == 'confirm' && mounted) {
      _viewModel.excluirListaCommand.execute(widget.lista);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel.excluirListaCommand,
      builder: (context, _) {
        final isRunning = _viewModel.excluirListaCommand.value.isRunning;

        return ButtonAdd(
          label: 'Excluir Lista',
          icon: Icons.delete_outline_rounded,
          color: AppColors.danger,
          loading: isRunning,
          onPressed: isRunning ? () {} : _handleDelete,
        );
      },
    );
  }
}
