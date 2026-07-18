import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class AppFilterCard extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget? collapsedHeaderAction;

  final bool initiallyExpanded;

  const AppFilterCard({
    super.key,
    this.title = 'Opções',
    this.initiallyExpanded = true,
    required this.child,
    this.collapsedHeaderAction,
  });

  @override
  State<AppFilterCard> createState() => _AppFilterCardState();
}

class _AppFilterCardState extends State<AppFilterCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

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
          Row(
            children: [
              InkWell(
                onTap: _toggleExpanded,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8),
                  child: AppText(widget.title, variant: AppTextVariant.body),
                ),
              ),
              if (!_expanded && widget.collapsedHeaderAction != null)
                Expanded(child: widget.collapsedHeaderAction!)
              else
                const Spacer(),
              InkWell(
                onTap: _toggleExpanded,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8),
                  child: Icon(
                    _expanded ? Icons.expand_more : Icons.chevron_right,
                  ),
                ),
              ),
            ],
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                const AppSpacing(size: AppSpacingSize.sm),
                widget.child,
                const AppSpacing(size: AppSpacingSize.sm),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
