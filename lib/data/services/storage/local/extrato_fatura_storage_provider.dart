import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';

final extratoFaturaStorageProvider = Provider<LocalStorage<ExtratoFatura>>(
  (ref) => LocalStorage<ExtratoFatura>(
    collectionName: 'extrato_faturas',
    fromJson: (json) => ExtratoFatura.fromJson(json),
    toJson: (extratoFatura) => extratoFatura.toJson(),
  ),
);
