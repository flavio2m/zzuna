import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class CreateTransferenciaDto {
  final DateTime data;
  final String descricao;
  final double valor;
  final LancamentoOrigem origemSaida;
  final LancamentoOrigem origemEntrada;
  final String? observacao;

  CreateTransferenciaDto({
    required this.data,
    this.descricao = 'Transferência',
    required this.valor,
    required this.origemSaida,
    required this.origemEntrada,
    this.observacao,
  });
}
