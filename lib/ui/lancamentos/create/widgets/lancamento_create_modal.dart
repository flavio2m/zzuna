import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_item_entity.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/ui/lancamentos/create/viewmodels/lancamento_create_viewmodel.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/categoria_field.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/centro_custo_field.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/lancamento_origem_field.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/lancamento_tipo_field.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_currency_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_date_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_area_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';
import 'package:uuid/uuid.dart';

class LancamentoCreateModal extends ConsumerStatefulWidget {
  const LancamentoCreateModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(context: context, child: const LancamentoCreateModal());
  }

  @override
  ConsumerState<LancamentoCreateModal> createState() => _LancamentoCreateModalState();
}

class _LancamentoCreateModalState extends ConsumerState<LancamentoCreateModal> {
  final _formKey = GlobalKey<FormState>();
  final dto = LancamentoDto();
  final validator = LancamentoValidator();

  // Controla o valor monetário do único item
  double _valor = 0;

  late final LancamentoCreateViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(lancamentoCreateViewModelProvider);
    viewModel.createCommand.addListener(_commandListener);
    viewModel.load();
  }

  @override
  void dispose() {
    viewModel.createCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.createCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Lançamento criado com sucesso');
      Navigator.pop(context);
    });

    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  void _handleSubmit() {
    // Atualiza o item com o valor atual antes de validar
    _syncItem();

    if (_formKey.currentState?.validate() ?? false) {
      viewModel.createCommand.execute(dto);
    }
  }

  void _syncItem() {
    final itemId = dto.itens.isNotEmpty ? dto.itens.first.id : const Uuid().v4();
    final categoriaId = dto.itens.isNotEmpty ? dto.itens.first.categoriaId : '';
    final centroCustoId = dto.itens.isNotEmpty ? dto.itens.first.centroCustoId : '';

    dto.setItens([
      LancamentoItem(
        id: itemId,
        categoriaId: categoriaId,
        centroCustoId: centroCustoId,
        valor: _valor, //
      ),
    ]);
  }

  void _updateItemField({String? categoriaId, String? centroCustoId}) {
    final current = dto.itens.isNotEmpty
        ? dto.itens.first
        : LancamentoItem(
            id: const Uuid().v4(),
            categoriaId: '',
            centroCustoId: '',
            valor: _valor, //
          );

    dto.setItens([
      LancamentoItem(
        id: current.id,
        categoriaId: categoriaId ?? current.categoriaId,
        centroCustoId: centroCustoId ?? current.centroCustoId,
        valor: _valor,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return AppForm(
          formKey: _formKey,
          title: 'Novo Lançamento',
          type: AppFormType.modal,
          actions: [
            ButtonCancel(onPressed: () => Navigator.of(context).pop()),
            ListenableBuilder(
              listenable: viewModel.createCommand,
              builder: (_, _) {
                return ButtonSave(
                  onPressed: viewModel.createCommand.value.isRunning ? null : _handleSubmit, //
                );
              },
            ),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Data
              AppDateFormField(
                label: 'Data',
                initialValue: _formatDate(dto.data),
                validator: validator.byField(dto, 'data'),
                onDateSelected: (date) => setState(() => dto.setData(date)),
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 2. Descrição
              AppTextFormField(
                label: 'Descrição',
                icon: Icons.description_outlined,
                validator: validator.byField(dto, 'descricao'),
                onChanged: (value) {
                  dto.setDescricao(value);
                  setState(() {});
                },
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 3. Tipo
              LancamentoTipoField(
                value: dto.tipo,
                onChanged: (tipo) {
                  if (tipo != null) setState(() => dto.setTipo(tipo));
                },
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 4. Conta / Cartão
              LancamentoOrigemField(
                origens: viewModel.origens,
                value: dto.origem,
                validator: (_) => validator.byField(dto, 'origem')(null),
                onChanged: (origem) {
                  if (origem != null) setState(() => dto.setOrigem(origem));
                },
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 5. Categoria
              CategoriaField(
                categorias: viewModel.categorias,
                value: dto.itens.isNotEmpty ? dto.itens.first.categoriaId : null,
                validator: validator.byField(dto, 'itensCategorias'),
                onChanged: (categoriaId) {
                  setState(() => _updateItemField(categoriaId: categoriaId ?? ''));
                },
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 6. Centro de Custo
              CentroCustoField(
                centros: viewModel.centros,
                value: dto.itens.isNotEmpty ? dto.itens.first.centroCustoId : null,
                validator: validator.byField(dto, 'itensCentrosCusto'),
                onChanged: (centroCustoId) {
                  setState(() => _updateItemField(centroCustoId: centroCustoId ?? ''));
                },
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 7. Valor
              AppCurrencyFormField(
                label: 'Valor',
                icon: Icons.attach_money,
                validator: validator.byField(dto, 'itensValores'),
                onChanged: (raw) {
                  final clean = raw.replaceAll(RegExp(r'[^0-9]'), '');
                  setState(() {
                    _valor = clean.isEmpty ? 0 : double.parse(clean) / 100;
                    _syncItem();
                  });
                },
              ),

              const AppSpacing(size: AppSpacingSize.md),

              // 8. Observação (opcional)
              AppTextAreaFormField(
                label: 'Observação',
                icon: Icons.notes,
                onChanged: (value) => dto.setObservacao(value.isEmpty ? null : value),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    return '$d/$m/$y';
  }
}
