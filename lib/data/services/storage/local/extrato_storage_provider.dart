import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_entity.dart';

final extratoStorageProvider = Provider<LocalStorage<Extrato>>(
  (ref) => LocalStorage<Extrato>(
    collectionName: 'extratos',
    fromJson: (json) => Extrato.fromJson(json),
    toJson: (extrato) => extrato.toJson(),
  ),
);
