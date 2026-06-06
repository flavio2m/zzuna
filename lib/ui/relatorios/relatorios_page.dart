import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:flutter/material.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: AppText('Relatórios', variant: AppTextVariant.headline),
    );
  }
}
