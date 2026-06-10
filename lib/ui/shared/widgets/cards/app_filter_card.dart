import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class AppFilterCard extends StatefulWidget {
  final String title;
  final Widget child;

  const AppFilterCard({super.key, this.title = 'Opções', required this.child});

  @override
  State<AppFilterCard> createState() => _AppFilterCardState();
}

class _AppFilterCardState extends State<AppFilterCard> {
  bool _expanded = true;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            child: Row(
              children: [
                AppText(widget.title, variant: AppTextVariant.body), //

                const Spacer(),

                Icon(_expanded ? Icons.expand_more : Icons.chevron_right),
              ],
            ),
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                const AppSpacing(size: AppSpacingSize.md),
                widget.child,
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
