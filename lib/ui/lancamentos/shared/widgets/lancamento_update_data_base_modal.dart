import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_date_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';

class LancamentoUpdateDataBaseModal extends StatefulWidget {
  final String title;
  final String description;
  final bool isExecuting;
  final ValueChanged<DateTime> onSave;

  const LancamentoUpdateDataBaseModal({
    super.key,
    required this.title,
    required this.description,
    required this.isExecuting,
    required this.onSave,
  });

  @override
  State<LancamentoUpdateDataBaseModal> createState() =>
      _LancamentoUpdateDataBaseModalState();
}

class _LancamentoUpdateDataBaseModalState
    extends State<LancamentoUpdateDataBaseModal> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedData = DateTime.now();

  late final _dataController = TextEditingController(
    text: _formatDate(_selectedData!),
  );
  final _dataFocus = FocusNode();
  final _saveFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _dataController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _dataFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _dataController.dispose();
    _dataFocus.dispose();
    _saveFocus.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  bool get _canSubmit {
    final clean = _dataController.text.replaceAll('/', '');
    return clean.length == 8;
  }

  void _handleSubmit() {
    if (_selectedData == null) return;
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(_selectedData!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AppForm(
        title: widget.title,
        type: AppFormType.modal,
        actions: [
          ButtonCancel(onPressed: () => Navigator.of(context).pop()),
          ButtonSave(
            focusNode: _saveFocus,
            loading: widget.isExecuting,
            onPressed: widget.isExecuting || !_canSubmit ? null : _handleSubmit,
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.description,
              style: const TextStyle(fontSize: 14, color: AppColors.slate600),
            ),
            const AppSpacing(size: AppSpacingSize.md),
            AppDateFormField(
              label: 'Nova Data',
              controller: _dataController,
              focusNode: _dataFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _saveFocus.requestFocus(),
              onDateSelected: (date) {
                setState(() {
                  _selectedData = date;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
