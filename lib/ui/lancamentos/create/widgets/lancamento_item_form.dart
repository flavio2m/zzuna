import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/categoria_field.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/centro_custo_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_currency_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_percent_form_field.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';

class LancamentoItemForm extends StatefulWidget {
  final List<CategoriaDetails> categorias;
  final List<CentroCusto> centros;
  final double totalValor;
  final LancamentoItem? initialItem;
  final Function(String centroCustoId, String categoriaId, double valor) onSave;
  final VoidCallback onCancel;

  const LancamentoItemForm({
    super.key,
    required this.categorias,
    required this.centros,
    required this.totalValor,
    this.initialItem,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<LancamentoItemForm> createState() => _LancamentoItemFormState();
}

class _LancamentoItemFormState extends State<LancamentoItemForm> {
  final _itemFormKey = GlobalKey<FormState>();

  String? _centroCustoId;
  String? _categoriaId;

  late final TextEditingController _percentController;
  late final TextEditingController _valueController;

  late final FocusNode _percentFocusNode;
  late final FocusNode _valueFocusNode;

  @override
  void initState() {
    super.initState();
    _percentFocusNode = FocusNode();
    _valueFocusNode = FocusNode();

    if (widget.initialItem != null) {
      _centroCustoId = widget.initialItem!.centroCustoId;
      _categoriaId = widget.initialItem!.categoriaId;
      final valor = widget.initialItem!.valor;
      final pct = widget.totalValor > 0 ? (valor / widget.totalValor) * 100 : 0.0;

      _percentController = TextEditingController(
        text: pct.toStringAsFixed(3).replaceAll('.', ','), //
      );
      _valueController = TextEditingController(
        text: UtilBrasilFields.obterReal(valor), //
      );
    } else {
      _percentController = TextEditingController();
      _valueController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _percentController.dispose();
    _valueController.dispose();
    _percentFocusNode.dispose();
    _valueFocusNode.dispose();
    super.dispose();
  }

  void _onPercentChanged(String val) {
    if (!_percentFocusNode.hasFocus) return;

    final cleanPct = val.replaceAll(',', '.');
    final pct = double.tryParse(cleanPct) ?? 0.0;
    final calculatedValue = (pct / 100) * widget.totalValor;

    setState(() {
      _valueController.text = UtilBrasilFields.obterReal(calculatedValue);
    });
  }

  void _onValueChanged(String val) {
    if (!_valueFocusNode.hasFocus) return;

    final cleanVal = val.replaceAll(RegExp(r'[^0-9]'), '');
    final doubleVal = cleanVal.isEmpty ? 0.0 : double.parse(cleanVal) / 100;

    if (widget.totalValor > 0) {
      final pct = (doubleVal / widget.totalValor) * 100;
      setState(() {
        _percentController.text = pct.toStringAsFixed(3).replaceAll('.', ',');
      });
    } else {
      setState(() {
        _percentController.text = '0,000';
      });
    }
  }

  void _submit() {
    if (_itemFormKey.currentState?.validate() ?? false) {
      final cleanVal = _valueController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final valor = cleanVal.isEmpty ? 0.0 : double.parse(cleanVal) / 100;
      widget.onSave(_centroCustoId!, _categoriaId!, valor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    final fieldsColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Centro de Custo e Categoria
        _ItemFormRow(
          isDesktop: isDesktop,
          left: CentroCustoField(
            centros: widget.centros,
            value: _centroCustoId,
            validator: //
            (cc) =>
                cc == null || cc.isEmpty ? 'Informe o centro de custo' : null,
            onChanged: (val) => setState(() => _centroCustoId = val),
          ),
          right: CategoriaField(
            categorias: widget.categorias,
            value: _categoriaId,
            validator: //
            (cat) =>
                cat == null || cat.isEmpty ? 'Informe a categoria' : null,
            onChanged: (val) => setState(() => _categoriaId = val),
          ),
        ),

        const AppSpacing(size: AppSpacingSize.md),

        // Percentual e Valor
        _ItemFormRow(
          isDesktop: isDesktop,
          left: AppPercentFormField(
            label: 'Percentual',
            controller: _percentController,
            focusNode: _percentFocusNode,
            min: 0.001,
            max: 100.0,
            onChanged: _onPercentChanged,
            validator: //
            (val) =>
                val == null || val.isEmpty ? 'Informe o percentual' : null,
          ),
          right: AppCurrencyFormField(
            label: 'Valor',
            controller: _valueController,
            focusNode: _valueFocusNode,
            onChanged: _onValueChanged,
            validator: //
            (val) =>
                val == null || val.isEmpty ? 'Informe o valor' : null,
          ),
        ),

        const AppSpacing(size: AppSpacingSize.md),

        // Botões de Ação
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Tooltip(
              message: 'Cancelar',
              child: ButtonCancel(onPressed: widget.onCancel, small: true), //
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: widget.initialItem != null ? 'Salvar' : 'Adicionar', //
              child: ButtonSave(
                onPressed: _submit,
                small: true,
                label: widget.initialItem != null ? 'Salvar' : 'Adicionar', //
              ),
            ),
          ],
        ),
      ],
    );

    return Form(
      key: _itemFormKey,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: fieldsColumn,
      ),
    );
  }
}

class _ItemFormRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  final bool isDesktop;

  const _ItemFormRow({
    required this.left,
    required this.right,
    required this.isDesktop, //
  });

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [left, const SizedBox(height: 16), right],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }
}
