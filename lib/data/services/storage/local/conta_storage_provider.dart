import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';

final contaStorageProvider = Provider<LocalStorage<Conta>>(
  (ref) => LocalStorage<Conta>(
    collectionName: 'contas',
    fromJson: (json) => Conta.fromJson(json),
    toJson: (conta) => conta.toJson(),
  ),
);
