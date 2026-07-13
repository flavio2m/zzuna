import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/apply_recorrencias_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class SyncRecorrenciasMesUseCase {
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final ExtratoFaturaRepository _extratoRepository;
  final LancamentoRepository _lancamentoRepository;
  final ApplyRecorrenciasUseCase _applyRecorrenciasUseCase;

  SyncRecorrenciasMesUseCase(
    this._contaRepository,
    this._cartaoRepository,
    this._extratoRepository,
    this._lancamentoRepository,
    this._applyRecorrenciasUseCase,
  );

  Future<Result<Unit>> execute(Mes mes, int ano) async {
    final origens = <LancamentoOrigem>[];

    final contasRes = await _contaRepository.getAll();
    if (contasRes.isSuccess()) {
      for (final conta in contasRes.getOrThrow()) {
        if (conta.ativo) {
          origens.add(LancamentoOrigem.conta(contaId: conta.id));
        }
      }
    }

    final cartoesRes = await _cartaoRepository.getAll();
    if (cartoesRes.isSuccess()) {
      for (final cartao in cartoesRes.getOrThrow()) {
        if (cartao.ativo) {
          origens.add(LancamentoOrigem.cartao(cartaoId: cartao.id));
        }
      }
    }

    for (final origem in origens) {
      // Verifica se já existe extrato para o mês/ano alvo
      final targetRes = await _extratoRepository.searchByPeriodo(
        origem,
        ano,
        mes,
      );
      if (targetRes.isError() || targetRes.getOrThrow().isNotEmpty) {
        continue;
      }

      // Busca o extrato anterior
      final prevRes = await _extratoRepository.searchPrevious(origem, ano, mes);
      if (prevRes.isError()) continue;

      final prevExtratos = prevRes.getOrThrow();
      if (prevExtratos.isEmpty) continue;

      final prevExtrato = prevExtratos.first;

      // Buscar apenas os lançamentos deste extrato anterior
      final prevLancRes = await _lancamentoRepository.searchByExtratoFaturaId(
        prevExtrato.id,
      );
      if (prevLancRes.isError()) continue;

      // Verifica se o extrato anterior possui alguma recorrência ativa
      final hasActiveRecurrence = prevLancRes.getOrThrow().any((l) {
        final g = l.grupo;
        return g is LancamentoGrupoRecorrencia && g.ativo;
      });

      if (!hasActiveRecurrence) continue;

      // Se possui recorrência, cria o extrato e aplica as recorrências
      final newExtratoDto = ExtratoFaturaDto(
        origem: origem,
        ano: ano,
        mes: mes,
        dataInicio: DateTime(ano, mes.numero, 1),
        dataFim: DateTime(ano, mes.numero + 1, 0, 23, 59, 59, 999),
        saldoInicial: prevExtrato.saldoFinal,
        saldoFinal: prevExtrato.saldoFinal,
        fechado: false,
      );

      final createRes = await _extratoRepository.create(newExtratoDto);
      if (createRes.isSuccess()) {
        final extratoAlvo = createRes.getOrThrow();
        await _applyRecorrenciasUseCase.execute(origem, extratoAlvo);
      }
    }

    return const Success(unit);
  }
}
