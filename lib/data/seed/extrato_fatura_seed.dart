import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class ExtratoFaturaSeed {
  final ExtratoFaturaRepository repository;
  final ContaRepository contaRepository;
  final CartaoRepository cartaoRepository;

  ExtratoFaturaSeed({
    required this.repository,
    required this.contaRepository,
    required this.cartaoRepository,
  });

  Future<void> execute() async {
    final result = await repository.getAll();
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    final contas = (await contaRepository.getAll()).getOrElse((_) => []);
    final cartoes = (await cartaoRepository.getAll()).getOrElse((_) => []);

    for (final c in cartoes) {
      for (final m in [Mes.maio, Mes.junho]) {
        await repository.create(
          ExtratoFaturaDto(
            origem: LancamentoOrigem.cartao(cartaoId: c.id),
            ano: 2026,
            mes: m,
            dataInicio: DateTime(2026, m.numero, 1),
            dataFim: DateTime(2026, m.numero + 1, 0),
            saldoInicial: 0.0,
            saldoFinal: 0.0,
            fechado: false,
          ),
        );
      }
    }

    for (final c in contas) {
      for (final m in [Mes.maio, Mes.junho]) {
        await repository.create(
          ExtratoFaturaDto(
            origem: LancamentoOrigem.conta(contaId: c.id),
            ano: 2026,
            mes: m,
            dataInicio: DateTime(2026, m.numero, 1),
            dataFim: DateTime(2026, m.numero + 1, 0),
            saldoInicial: 0.0,
            saldoFinal: 0.0,
            fechado: false,
          ),
        );
      }
    }
  }
}
