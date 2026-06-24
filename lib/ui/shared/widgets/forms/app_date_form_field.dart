import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class AppDateFormField extends StatefulWidget {
  final String label;
  final IconData? icon;
  final ValueChanged<DateTime>? onDateSelected;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppDateFormField({
    super.key,
    required this.label,
    this.icon,
    this.onDateSelected,
    this.validator,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<AppDateFormField> createState() => _AppDateFormFieldState();
}

class _AppDateFormFieldState extends State<AppDateFormField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  /// Indica se o controller é gerenciado internamente (deve ser disposed)
  late final bool _ownsController;
  late final bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();

    _ownsController = widget.controller == null;
    _controller = //
        widget.controller ?? TextEditingController(text: widget.initialValue ?? '');

    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  /// Ao receber foco, seleciona todo o texto para facilitar a substituição.
  void _onFocusChange() {
    if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length, //
      );
    }
  }

  /// Converte a string dd/MM/yyyy em DateTime, retorna null se inválida.
  DateTime? _parse(String text) {
    final clean = text.replaceAll('/', '');
    if (clean.length != 8) return null;
    try {
      final day = int.parse(clean.substring(0, 2));
      final month = int.parse(clean.substring(2, 4));
      final year = int.parse(clean.substring(4, 8));
      final date = DateTime(year, month, day);
      // DateTime normaliza datas inválidas (ex: 31/02 → 03/03); rejeite-as:
      if (date.day != day || date.month != month || date.year != year) {
        return null;
      }
      return date;
    } catch (_) {
      return null;
    }
  }

  Future<void> _openPicker() async {
    final current = _parse(_controller.text) ?? DateTime.now();
    final int anoMaximo = DateTime.now().year + 2;
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2025),
      lastDate: DateTime(anoMaximo),
    );
    if (picked != null) {
      final formatted = _formatDate(picked);
      _controller.text = formatted;
      widget.onDateSelected?.call(picked);
    }
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  void _onChanged(String value) {
    final date = _parse(value);
    if (date != null) {
      widget.onDateSelected?.call(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      style: const TextStyle(fontSize: 14),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      keyboardType: TextInputType.datetime,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, DataInputFormatter()],
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_month_outlined),
          tooltip: 'Selecionar data',
          color: AppColors.primary,
          onPressed: _openPicker,
        ),
      ),
      onChanged: _onChanged,
    );
  }
}
