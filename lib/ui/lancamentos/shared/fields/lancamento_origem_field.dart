import 'package:flutter/material.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';

class LancamentoOrigemField extends StatelessWidget {
  final List<LancamentoOrigemDetail> origens;
  final LancamentoOrigem? value;
  final ValueChanged<LancamentoOrigem?>? onChanged;
  final String? Function(LancamentoOrigem?)? validator;
  final String label;
  final FocusNode? focusNode;
  final VoidCallback? onEnterPressed;

  final bool showAllOption;
  final String allOptionLabel;

  const LancamentoOrigemField({
    super.key,
    required this.origens,
    this.value,
    this.onChanged,
    this.validator,
    this.label = 'Conta / Cartão',
    this.focusNode,
    this.onEnterPressed,
    this.showAllOption = false,
    this.allOptionLabel = 'Todas',
  });

  String _labelFor(LancamentoOrigemDetail detalhe) {
    return switch (detalhe) {
      LancamentoOrigemContaDetail(:final conta) => 'Conta  ${conta.descricao}',
      LancamentoOrigemCartaoDetail(:final cartao) =>
        'Cartão  ${cartao.descricao}',
    };
  }

  LancamentoOrigem _origemFor(LancamentoOrigemDetail detalhe) {
    return switch (detalhe) {
      LancamentoOrigemContaDetail(:final conta) => LancamentoOrigem.conta(
        contaId: conta.id,
      ),
      LancamentoOrigemCartaoDetail(:final cartao) => LancamentoOrigem.cartao(
        cartaoId: cartao.id,
      ),
    };
  }

  /// Finds the matching LancamentoOrigem among the items list so
  /// the DropdownMenu can highlight the currently selected entry.
  LancamentoOrigem? _matchedValue() {
    final current = value;
    if (current == null) return null;
    for (final detalhe in origens) {
      final origem = _origemFor(detalhe);
      bool match = false;
      if (current is LancamentoOrigemConta && origem is LancamentoOrigemConta) {
        match = current.contaId == origem.contaId;
      } else if (current is LancamentoOrigemCartao &&
          origem is LancamentoOrigemCartao) {
        match = current.cartaoId == origem.cartaoId;
      }
      if (match) return origem;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppDropdownFormField<LancamentoOrigem?>(
      label: label,
      value: _matchedValue(),
      validator: validator,
      focusNode: focusNode,
      onEnterPressed: onEnterPressed,
      items: [
        if (showAllOption)
          AppDropdownMenuItem<LancamentoOrigem?>(
            value: null,
            label: allOptionLabel,
          ),
        ...origens.map(
          (detalhe) => AppDropdownMenuItem<LancamentoOrigem?>(
            value: _origemFor(detalhe),
            label: _labelFor(detalhe),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
