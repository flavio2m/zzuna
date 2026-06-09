import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';

final cartaoStorageProvider = Provider<LocalStorage<Cartao>>(
  (ref) => LocalStorage<Cartao>(
    collectionName: 'cartoes',
    fromJson: (json) => Cartao.fromJson(json),
    toJson: (cartao) => cartao.toJson(),
  ),
);
