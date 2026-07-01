import 'package:flutter/material.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/lancamento_origem_field.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';

class LancamentosUpdateOrigemDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<LancamentoOrigemDetail> origens;
  final LancamentoOrigem initialOrigem;
  final bool isLoading;
  final Function(LancamentoOrigem novaOrigem) onSave;

  const LancamentosUpdateOrigemDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.origens,
    required this.initialOrigem,
    required this.isLoading,
    required this.onSave,
  });

  @override
  State<LancamentosUpdateOrigemDialog> createState() =>
      _LancamentosUpdateOrigemDialogState();
}

class _LancamentosUpdateOrigemDialogState
    extends State<LancamentosUpdateOrigemDialog> {
  final _formKey = GlobalKey<FormState>();
  LancamentoOrigem? _novaOrigem;

  @override
  void initState() {
    super.initState();
    _novaOrigem = widget.initialOrigem;
  }

  void _handleSubmit() {
    if (_novaOrigem == null) {
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(_novaOrigem!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppForm(
      formKey: _formKey,
      title: widget.title,
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ButtonSave(onPressed: widget.isLoading ? null : _handleSubmit),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.subtitle,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          const AppSpacing(size: AppSpacingSize.md),

          LancamentoOrigemField(
            origens: widget.origens,
            value: _novaOrigem,
            validator: (val) =>
                val == null ? 'Selecione a conta ou cartão' : null,
            onChanged: (origem) {
              if (origem != null) {
                setState(() {
                  _novaOrigem = origem;
                });
              }
            },
          ),
          const AppSpacing(size: AppSpacingSize.md),
        ],
      ),
    );
  }
}
