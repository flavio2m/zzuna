import 'package:flutter/foundation.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/models/orcamento/orcamento_comparativo_model.dart';
import 'package:zzuna/domain/usecases/orcamento/get_orcamento_comparativo_usecase.dart';

class OrcamentoComparativoViewModel extends ChangeNotifier {
  final GetOrcamentoComparativoUseCase _useCase;

  OrcamentoComparativoViewModel(this._useCase);

  OrcamentoMensalComparativoModel calcular({
    required List<LancamentoDetails> lancamentos,
    required List<Categoria> categoriasPai,
    required double rendaReferencia,
  }) {
    return _useCase.execute(
      lancamentos: lancamentos,
      categoriasPai: categoriasPai,
      rendaReferencia: rendaReferencia,
    );
  }
}
