import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

final centroCustoStorageProvider = Provider<LocalStorage<CentroCusto>>(
  (ref) => LocalStorage<CentroCusto>(
    collectionName: 'centro_custos',
    fromJson: (json) => CentroCusto.fromJson(json),
    toJson: (centro) => centro.toJson(),
  ),
);
