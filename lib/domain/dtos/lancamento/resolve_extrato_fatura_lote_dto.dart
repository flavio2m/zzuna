import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class ResolveExtratoFaturaLoteDto {
  final List<ResolveExtratoFaturaItemDto> itens;

  const ResolveExtratoFaturaLoteDto({
    required this.itens,
  });
}

class ResolveExtratoFaturaItemDto {
  final LancamentoOrigem origem;
  final DateTime data;
  final double valor;
  final LancamentoTipo tipo;
  final bool? isTransferenciaEntrada;

  const ResolveExtratoFaturaItemDto({
    required this.origem,
    required this.data,
    required this.valor,
    required this.tipo,
    this.isTransferenciaEntrada,
  });
}
