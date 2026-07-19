import 'package:zzuna/config/providers.dart';
import 'package:zzuna/data/seed/app_seed.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:zzuna/ui/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routefly/routefly.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:zzuna/data/services/storage/firebase/firebase_options.dart';

import 'main.route.dart';
part 'main.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb) {
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  final container = ProviderContainer();

  if (dotenv.env['USE_LOCAL_STORAGE'] == 'true') {
    await initSeeds(container);
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MainApp(), //
    ),
  );
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
        } else if (user is LoggedUser) {
          final uid = user.id;

          if (!kIsWeb) {
            final db = FirebaseDatabase.instance;
            db.ref(uid).child('contas').keepSynced(true);
            db.ref(uid).child('cartoes').keepSynced(true);
            db.ref(uid).child('centros_custo').keepSynced(true);
            db.ref(uid).child('categorias').keepSynced(true);
          }

          Routefly.navigate(routePaths.home);
        }
      });
    });

    return MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: Routefly.routerConfig(
        routes: routes,
        initialPath: routePaths.auth.login, //
      ),
    );
  }
}

Future<void> initSeeds(ProviderContainer container) async {
  await AppSeed(
    contaRepository: container.read(contaRepositoryProvider),
    cartaoRepository: container.read(cartaoRepositoryProvider),
    categoriaRepository: container.read(categoriaRepositoryProvider),
    centroCustoRepository: container.read(centroCustoRepositoryProvider),
    extratoFaturaRepository: container.read(extratoFaturaRepositoryProvider),
    lancamentoRepository: container.read(lancamentoRepositoryProvider),
    authRepository: container.read(authRepositoryProvider),
    recalculateBalanceUseCase: container.read(
      recalculateExtratoFaturaBalanceUseCaseProvider,
    ), //
  ).execute();
}
