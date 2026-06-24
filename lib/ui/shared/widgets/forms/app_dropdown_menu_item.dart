import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class AppDropdownMenuItem<T> extends DropdownMenuItem<T> {
  final String label;
  final Widget? leading;

  AppDropdownMenuItem({
    super.key,
    required T value,
    required this.label,
    this.leading, //
  }) : super(
         value: value,
         child: Row(
           children: [
             if (leading != null) ...[leading, const SizedBox(width: 8)],
             Expanded(child: AppText(label)),
           ],
         ),
       );
}
