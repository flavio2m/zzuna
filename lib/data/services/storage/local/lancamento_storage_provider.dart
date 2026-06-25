import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';

final lancamentoStorageProvider = Provider<LocalStorage<Lancamento>>(
  (ref) => LocalStorage<Lancamento>(
    collectionName: 'lancamentos',
    fromJson: (json) => Lancamento.fromJson(json),
    toJson: (lancamento) => lancamento.toJson(),
  ),
);
