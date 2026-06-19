import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/fatura_entity.dart';

final faturaStorageProvider = Provider<LocalStorage<Fatura>>(
  (ref) => LocalStorage<Fatura>(
    collectionName: 'faturas',
    fromJson: (json) => Fatura.fromJson(json),
    toJson: (fatura) => fatura.toJson(),
  ),
);
