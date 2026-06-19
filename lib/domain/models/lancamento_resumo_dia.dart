import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';

class LancamentoResumoDia {
  final DateTime data;
  final double saldo;
  final List<LancamentoDetails> lancamentos;

  const LancamentoResumoDia({
    required this.data,
    required this.saldo,
    required this.lancamentos,
  });
}
