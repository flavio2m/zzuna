import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/models/orcamento/orcamento_comparativo_model.dart';
import 'package:zzuna/domain/usecases/orcamento/get_orcamento_comparativo_usecase.dart';

class OrcamentoComparativoViewModel extends ChangeNotifier {
  final GetOrcamentoComparativoUseCase _useCase;
  final CategoriaRepository _categoriaRepository;
  StreamSubscription? _categoriaSub;

  List<Categoria> _categorias = [];
  List<Categoria> get categorias => _categorias;

  OrcamentoComparativoViewModel(this._useCase, this._categoriaRepository) {
    _categoriaSub = _categoriaRepository.observer().listen((_) {
      loadCategorias();
    });
    loadCategorias();
  }

  @override
  void dispose() {
    _categoriaSub?.cancel();
    super.dispose();
  }

  Future<void> loadCategorias() async {
    final result = await _categoriaRepository.getAll();
    _categorias = result.getOrElse((_) => <Categoria>[]);
    notifyListeners();
  }

  OrcamentoMensalComparativoModel calcular({
    required List<LancamentoDetails> lancamentos,
    required double rendaReferencia,
    List<Categoria>? categoriasPai,
  }) {
    return _useCase.execute(
      lancamentos: lancamentos,
      categoriasPai: categoriasPai ?? _categorias,
      rendaReferencia: rendaReferencia,
    );
  }
}
