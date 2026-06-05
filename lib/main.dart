import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routefly/routefly.dart';

import 'main.route.dart';
part 'main.g.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

@Main('lib/ui/')
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userProvider, (_, next) {
      next.whenData((user) {
        if (user is NotLoggedUser) {
          Routefly.navigate(routePaths.auth.login);
        } else {
          Routefly.navigate(routePaths.home);
        }
      });
    });

    return MaterialApp.router(
      routerConfig: Routefly.routerConfig(
        routes: routes,
        initialPath: routePaths.auth.login, //
      ),
    );
  }
}
