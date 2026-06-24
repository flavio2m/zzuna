import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';

class AppDropdownFormField<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  const AppDropdownFormField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  State<AppDropdownFormField<T>> createState() => _AppDropdownFormFieldState<T>();
}

class _AppDropdownFormFieldState<T> extends State<AppDropdownFormField<T>> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _syncLabel();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant AppDropdownFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || oldWidget.items != widget.items) {
      _syncLabel();
    }
  }

  void _syncLabel() {
    final match = widget.items
        .whereType<AppDropdownMenuItem<T>>()
        .cast<AppDropdownMenuItem<T>>()
        .where((e) => e.value == widget.value)
        .firstOrNull;
    _controller.text = match?.label ?? '';
  }

  List<DropdownMenuEntry<T>> get _entries {
    return widget.items.map((item) {
      const itemStyle = ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(0, 44)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

      if (item is AppDropdownMenuItem<T>) {
        return DropdownMenuEntry<T>(
          value: item.value as T,
          label: item.label,
          leadingIcon: item.leading,
          style: itemStyle,
        );
      }
      return DropdownMenuEntry<T>(
        value: item.value as T,
        label: item.value.toString(),
        style: itemStyle, //
      );
    }).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: widget.value,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) {
                // Allow Enter to confirm – handled internally by DropdownMenu
              },
              child: DropdownMenu<T>(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                enableFilter: true,
                enableSearch: true,
                expandedInsets: EdgeInsets.zero,
                menuHeight: 240,
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).cardColor),
                  elevation: const WidgetStatePropertyAll(4),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), //
                    ),
                  ),
                ),
                initialSelection: widget.value,
                textStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.slate900, //
                ),
                label: Text(widget.label),
                inputDecorationTheme: InputDecorationTheme(
                  border: const OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error, //
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                dropdownMenuEntries: _entries,
                onSelected: widget.enabled
                    ? (value) {
                        state.didChange(value);
                        widget.onChanged?.call(value);
                      }
                    : null,
              ),
            ),
            if (state.hasError) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.error, //
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
