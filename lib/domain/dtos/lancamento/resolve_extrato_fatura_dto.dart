import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class ResolveExtratoFaturaDto {
  final LancamentoOrigem origem;
  final DateTime data;
  final double valor;
  final LancamentoTipo tipo;

  const ResolveExtratoFaturaDto({
    required this.origem,
    required this.data,
    required this.valor,
    required this.tipo,
  });
}
