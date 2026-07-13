import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';

class RecalculateExtratoFaturaBalanceUseCase {
  final ExtratoFaturaRepository _extratoRepository;
  final LancamentoRepository _lancamentoRepository;

  RecalculateExtratoFaturaBalanceUseCase(
    this._extratoRepository,
    this._lancamentoRepository,
  );

  /// Recalcula os saldos a partir de um [startingAno] e [startingMes] específicos.
  /// Se os parâmetros não forem fornecidos, retorna um erro, forçando a
  /// arquitetura a sempre ser cirúrgica e otimizada (não varrer toda a conta).
  Future<Result<Unit>> execute(
    LancamentoOrigem origem, {
    required int startingAno,
    required Mes startingMes,
  }) async {
    // 1. Buscar o extrato alvo e todos os posteriores
    final targetRes = await _extratoRepository.searchByPeriodo(
      origem,
      startingAno,
      startingMes,
    );
    if (targetRes.isError()) return Failure(targetRes.exceptionOrNull()!);
    final targetList = targetRes.getOrThrow();

    final futureRes = await _extratoRepository.searchAfter(
      origem,
      startingAno,
      startingMes,
    );
    if (futureRes.isError()) return Failure(futureRes.exceptionOrNull()!);
    final futureList = futureRes.getOrThrow();

    final extratosOrigem = [...targetList, ...futureList];
    if (extratosOrigem.isEmpty) {
      return const Success(unit);
    }
    extratosOrigem.sort((a, b) => a.dataInicio.compareTo(b.dataInicio));

    // 2. Definir o saldoAtual baseado no saldoFinal do ExtratoFatura IMEDIATAMENTE ANTERIOR
    double saldoAtual = 0.0;
    final firstExtrato = extratosOrigem.first;
    final prevRes = await _extratoRepository.searchPrevious(
      origem,
      firstExtrato.ano,
      firstExtrato.mes,
    );
    if (prevRes.isError()) return Failure(prevRes.exceptionOrNull()!);
    final prevList = prevRes.getOrThrow();

    if (prevList.isNotEmpty) {
      saldoAtual = prevList.first.saldoFinal;
    } else {
      saldoAtual = firstExtrato.saldoInicial;
    }

    // 3. Iterar e propagar o saldo
    for (int i = 0; i < extratosOrigem.length; i++) {
      final extrato = extratosOrigem[i];
      final saldoInicialPeriodo = saldoAtual;

      // Buscar APENAS os lançamentos deste extrato (Zero risco de Memory Leak)
      final lancRes = await _lancamentoRepository.searchByExtratoFaturaId(
        extrato.id,
      );
      if (lancRes.isError()) return Failure(lancRes.exceptionOrNull()!);
      final lancamentosDoPeriodo = lancRes.getOrThrow();

      double totalMovimentado = 0.0;
      for (final l in lancamentosDoPeriodo) {
        if (l.tipo == LancamentoTipo.receita) {
          totalMovimentado += l.itens.fold<double>(
            0.0,
            (sum, item) => sum + item.valor,
          );
        } else if (l.tipo == LancamentoTipo.despesa) {
          totalMovimentado -= l.itens.fold<double>(
            0.0,
            (sum, item) => sum + item.valor,
          );
        } else if (l.tipo == LancamentoTipo.transferencia) {
          for (final item in l.itens) {
            switch (item) {
              case LancamentoItemTransferencia(
                :final origemEntrada,
                :final origemSaida,
              ):
                if (origem == origemEntrada) {
                  totalMovimentado += item.valor;
                } else if (origem == origemSaida) {
                  totalMovimentado -= item.valor;
                }
              default:
                break;
            }
          }
        }
      }

      final saldoFinalPeriodo = saldoInicialPeriodo + totalMovimentado;

      if (extrato.saldoInicial != saldoInicialPeriodo ||
          extrato.saldoFinal != saldoFinalPeriodo) {
        final updateRes = await _extratoRepository.update(
          ExtratoFaturaDto(
            id: extrato.id,
            origem: extrato.origem,
            ano: extrato.ano,
            mes: extrato.mes,
            dataInicio: extrato.dataInicio,
            dataFim: extrato.dataFim,
            saldoInicial: saldoInicialPeriodo,
            saldoFinal: saldoFinalPeriodo,
            fechado: extrato.fechado,
          ),
        );
        if (updateRes.isError()) {
          return Failure(Exception('Falha ao atualizar extrato'));
        }
      }

      saldoAtual = saldoFinalPeriodo;
    }

    return const Success(unit);
  }
}
