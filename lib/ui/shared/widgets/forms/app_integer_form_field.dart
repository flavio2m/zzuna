import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'app_text_form_field.dart';

class AppIntegerFormField extends StatefulWidget {
  final String label;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final int? min;
  final int? max;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const AppIntegerFormField({
    super.key,
    required this.label,
    this.icon,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.min,
    this.max,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<AppIntegerFormField> createState() => _AppIntegerFormFieldState();
}

class _AppIntegerFormFieldState extends State<AppIntegerFormField> {
  TextEditingController? _internalController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialValue ?? '',
      );
    }
    _effectiveController.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant AppIntegerFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      final oldController = oldWidget.controller ?? _internalController;
      oldController?.removeListener(_handleControllerChanged);

      if (widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
      } else {
        _internalController = TextEditingController(
          text: widget.initialValue ?? oldController?.text ?? '',
        );
      }
      _effectiveController.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    super.dispose();
  }

  void _changeValue(int delta) {
    final text = _effectiveController.text;
    int currentVal = int.tryParse(text) ?? widget.min ?? 0;
    int newVal = currentVal + delta;
    if (widget.min != null && newVal < widget.min!) {
      newVal = widget.min!;
    }
    if (widget.max != null && newVal > widget.max!) {
      newVal = widget.max!;
    }
    final newText = newVal.toString();
    _effectiveController.text = newText;
    _effectiveController.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );
    widget.onChanged?.call(newText);
  }

  @override
  Widget build(BuildContext context) {
    final valueText = _effectiveController.text;
    final value = int.tryParse(valueText);

    final canDecrement =
        value == null || widget.min == null || value > widget.min!;
    final canIncrement =
        value == null || widget.max == null || value < widget.max!;

    return AppTextFormField(
      label: widget.label,
      icon: widget.icon,
      onChanged: widget.onChanged,
      validator: (val) {
        if (widget.validator != null) {
          final res = widget.validator!(val);
          if (res != null) return res;
        }
        if (val != null && val.isNotEmpty) {
          final parsed = int.tryParse(val);
          if (parsed == null) {
            return 'Valor inválido';
          }
          if (widget.min != null && parsed < widget.min!) {
            return 'Mínimo de ${widget.min}';
          }
          if (widget.max != null && parsed > widget.max!) {
            return 'Máximo de ${widget.max}';
          }
        }
        return null;
      },
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: _effectiveController,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeFocus(
            child: IconButton(
              iconSize: 16,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: const Icon(Icons.remove, color: AppColors.slate600),
              onPressed: canDecrement ? () => _changeValue(-1) : null,
            ),
          ),
          Container(width: 1, height: 20, color: AppColors.border),
          ExcludeFocus(
            child: IconButton(
              iconSize: 16,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: const Icon(Icons.add, color: AppColors.slate600),
              onPressed: canIncrement ? () => _changeValue(1) : null,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
