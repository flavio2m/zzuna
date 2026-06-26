import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class RecalculateExtratoFaturaBalanceUseCase {
  final LocalStorage<ExtratoFatura> _extratoStorage;
  final LocalStorage<Lancamento> _lancamentoStorage;

  RecalculateExtratoFaturaBalanceUseCase(
    this._extratoStorage,
    this._lancamentoStorage,
  );

  Future<Result<Unit>> execute(LancamentoOrigem origem) async {
    // 1. Carregar os ExtratoFatura da origem
    final extratosResult = await _extratoStorage.getAll();
    if (extratosResult.isError()) {
      return Failure(Exception('Falha ao carregar extratos'));
    }
    final allExtratos = extratosResult.getOrThrow();
    final extratosOrigem = allExtratos.where((e) => e.origem == origem).toList();

    if (extratosOrigem.isEmpty) {
      return const Success(unit);
    }

    // 4. Ordenar os extratos por dataInicio
    extratosOrigem.sort((a, b) => a.dataInicio.compareTo(b.dataInicio));

    // 2. Carregar os lançamentos da origem
    final lancamentosResult = await _lancamentoStorage.getAll();
    if (lancamentosResult.isError()) {
      return Failure(Exception('Falha ao carregar lançamentos'));
    }
    final allLancamentos = lancamentosResult.getOrThrow();
    final lancamentosOrigem = allLancamentos.where((l) => l.origem == origem).toList();

    // 4. Ordenar os lançamentos por data crescente antes do cálculo
    lancamentosOrigem.sort((a, b) => a.data.compareTo(b.data));

    // 3. Recalcular saldoInicial e saldoFinal com propagação dos saldos
    // Regra: Não iniciar o primeiro ExtratoFatura com saldo zero. Iniciar com: saldoAtual = primeiroExtrato.saldoInicial
    // E depois: saldoFinal = saldoInicial + movimentações
    // saldoInicial do próximo período = saldoFinal do período anterior
    double saldoAtual = extratosOrigem.first.saldoInicial;

    for (int i = 0; i < extratosOrigem.length; i++) {
      final extrato = extratosOrigem[i];
      
      final saldoInicialPeriodo = i == 0 ? saldoAtual : saldoAtual;
      
      // Filtrar lançamentos que pertencem a este extratoFaturaId
      final lancamentosDoPeriodo = lancamentosOrigem.where((l) => l.extratoFaturaId == extrato.id).toList();
      
      double totalMovimentado = 0.0;
      for (final l in lancamentosDoPeriodo) {
        final valor = l.itens.fold<double>(0.0, (sum, item) => sum + item.valor);
        if (l.tipo == LancamentoTipo.receita) {
          totalMovimentado += valor;
        } else {
          totalMovimentado -= valor;
        }
      }

      final saldoFinalPeriodo = saldoInicialPeriodo + totalMovimentado;
      
      final updatedExtrato = extrato.copyWith(
        saldoInicial: saldoInicialPeriodo,
        saldoFinal: saldoFinalPeriodo,
      );

      // Atualizar no storage
      final updateRes = await _extratoStorage.update(updatedExtrato);
      if (updateRes.isError()) {
        return Failure(Exception('Falha ao atualizar extrato'));
      }

      saldoAtual = saldoFinalPeriodo;
    }

    return const Success(unit);
  }
}
