import 'package:zzuna/config/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(logoutViewModelProvider);

    return ElevatedButton(onPressed: viewModel.logoutCommand.execute, child: const Text('Logout'));
  }
}
