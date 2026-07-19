import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_filter_dto.dart';

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
    final hoje = DateTime.now();
    final mesAtual = Mes.values.firstWhere((e) => e.numero == hoje.month);
    final anoAtual = hoje.year;

    final result = await repository.search(
      ExtratoFaturaFilterDto(mes: mesAtual, ano: anoAtual),
    );
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    final contas = (await contaRepository.getAll()).getOrElse((_) => []);
    final cartoes = (await cartaoRepository.getAll()).getOrElse((_) => []);

    final mesAnterior = DateTime(hoje.year, hoje.month - 1, 1);
    final periodos = [mesAnterior, hoje];

    final dtos = <ExtratoFaturaDto>[];

    for (final c in cartoes) {
      for (final p in periodos) {
        final m = Mes.values.firstWhere((e) => e.numero == p.month);
        final ano = p.year;
        dtos.add(
          ExtratoFaturaDto(
            origem: LancamentoOrigem.cartao(cartaoId: c.id),
            ano: ano,
            mes: m,
            dataInicio: DateTime(ano, m.numero, 1),
            dataFim: DateTime(ano, m.numero + 1, 0),
            saldoInicial: 0.0,
            saldoFinal: 0.0,
            fechado: false,
          ),
        );
      }
    }

    for (final c in contas) {
      for (final p in periodos) {
        final m = Mes.values.firstWhere((e) => e.numero == p.month);
        final ano = p.year;
        dtos.add(
          ExtratoFaturaDto(
            origem: LancamentoOrigem.conta(contaId: c.id),
            ano: ano,
            mes: m,
            dataInicio: DateTime(ano, m.numero, 1),
            dataFim: DateTime(ano, m.numero + 1, 0),
            saldoInicial: 0.0,
            saldoFinal: 0.0,
            fechado: false,
          ),
        );
      }
    }

    if (dtos.isNotEmpty) {
      await repository.createAll(dtos);
    }
  }
}
