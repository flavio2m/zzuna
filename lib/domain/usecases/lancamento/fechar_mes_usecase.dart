import 'dart:developer' as developer;
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';

class FecharMesUseCase {
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final ExtratoFaturaRepository _extratoRepository;
  final LancamentoRepository _lancamentoRepository;

  FecharMesUseCase(
    this._contaRepository,
    this._cartaoRepository,
    this._extratoRepository,
    this._lancamentoRepository,
  );

  AsyncResult<Unit> execute(Mes mes, int ano) async {
    final origensResult = await _obterTodasOrigens();
    if (origensResult.isError()) {
      return origensResult.map((_) => unit);
    }
    final origens = origensResult.getOrThrow();

    // 1. Validações
    final checkAnterior = await _validarExtratosAnterioresAbertos(
      origens,
      mes,
      ano,
    );
    if (checkAnterior.isError()) return checkAnterior;

    final checkNaoConciliados = await _validarLancamentosNaoConciliados(
      mes,
      ano,
    );
    if (checkNaoConciliados.isError()) return checkNaoConciliados;

    // Obtém os extratos atuais
    final extratosAtuais = <ExtratoFatura>[];
    for (final origem in origens) {
      final extratoResult = await _extratoRepository.searchByPeriodo(
        origem,
        ano,
        mes,
      );
      if (extratoResult.isSuccess()) {
        final lista = extratoResult.getOrThrow();
        if (lista.isNotEmpty) {
          extratosAtuais.add(lista.first);
        }
      }
    }

    if (extratosAtuais.isEmpty) {
      return Failure(
        DomainException('Nenhum extrato encontrado para o período.'),
      );
    }

    final List<ExtratoFaturaDto> extratosParaAtualizar = [];

    for (final extrato in extratosAtuais) {
      final lancRes = await _lancamentoRepository.searchByExtratoFaturaId(
        extrato.id,
      );
      if (lancRes.isError()) return Failure(lancRes.exceptionOrNull()!);
      final lancamentosDaOrigem = lancRes.getOrThrow();

      // 2. RecalculateExtratoFaturaBalanceUseCase
      final saldoCalculado = _recalcularSaldoFinal(
        extrato,
        lancamentosDaOrigem,
      );

      // 3. Corrigir delta
      final delta = saldoCalculado - extrato.saldoFinal;
      final bool changed = delta.abs() > 0.001 || !extrato.fechado;

      if (changed) {
        // 5. Marcar fechado
        extratosParaAtualizar.add(
          _toDto(extrato)
            ..setSaldoFinal(saldoCalculado)
            ..setFechado(true),
        );

        // 4. Propagar delta
        if (delta.abs() > 0.001) {
          final propagarResult = await _propagarDelta(
            extrato.origem,
            mes,
            ano,
            delta,
          );
          if (propagarResult.isError()) return propagarResult.map((_) => unit);
          extratosParaAtualizar.addAll(propagarResult.getOrThrow());
        }
      }
    }

    // 6. updateAll()
    if (extratosParaAtualizar.isNotEmpty) {
      return _extratoRepository.updateAll(extratosParaAtualizar);
    }

    return const Success(unit);
  }

  AsyncResult<List<LancamentoOrigem>> _obterTodasOrigens() async {
    final contasResult = await _contaRepository.getAll();
    if (contasResult.isError()) return contasResult.map((_) => []);

    final cartoesResult = await _cartaoRepository.getAll();
    if (cartoesResult.isError()) return cartoesResult.map((_) => []);

    return Success([
      ...contasResult.getOrThrow().map(
        (c) => LancamentoOrigem.conta(contaId: c.id),
      ),
      ...cartoesResult.getOrThrow().map(
        (c) => LancamentoOrigem.cartao(cartaoId: c.id),
      ),
    ]);
  }

  AsyncResult<Unit> _validarExtratosAnterioresAbertos(
    List<LancamentoOrigem> origens,
    Mes mes,
    int ano,
  ) async {
    for (final origem in origens) {
      final pastResult = await _extratoRepository.searchPrevious(
        origem,
        ano,
        mes,
        limit: 1,
      );
      if (pastResult.isSuccess()) {
        final pastList = pastResult.getOrThrow();
        if (pastList.isNotEmpty && !pastList.first.fechado) {
          return Failure(DomainException('O mês anterior não está fechado.'));
        }
      }
    }
    return const Success(unit);
  }

  AsyncResult<Unit> _validarLancamentosNaoConciliados(Mes mes, int ano) async {
    final filter = LancamentoFilterDto(ano: ano, mes: mes, conciliado: false);
    final naoConciliadosResult = await _lancamentoRepository.search(filter);

    if (naoConciliadosResult.isError()) {
      return naoConciliadosResult.map((_) => unit);
    }

    final naoConciliados = naoConciliadosResult.getOrThrow();
    if (naoConciliados.isNotEmpty) {
      for (final l in naoConciliados) {
        developer.log(
          'Lançamento não conciliado: id=${l.id}, extratoFaturaId='
          '${l.extratoFaturaId}, anoMes=${l.anoMes}, data=${l.data}, '
          'descricao=${l.descricao}',
          name: 'FecharMesUseCase',
        );
      }
      return Failure(
        DomainException(
          'Existem ${naoConciliados.length} lançamentos não conciliados.',
        ),
      );
    }

    return const Success(unit);
  }

  double _recalcularSaldoFinal(
    ExtratoFatura extrato,
    List<Lancamento> lancamentosDaOrigem,
  ) {
    double totalMovimentado = 0;
    for (final l in lancamentosDaOrigem) {
      if (l.tipo == LancamentoTipo.receita) {
        for (final item in l.itens) {
          totalMovimentado += item.valor;
        }
      } else if (l.tipo == LancamentoTipo.despesa) {
        for (final item in l.itens) {
          totalMovimentado -= item.valor;
        }
      } else if (l.tipo == LancamentoTipo.transferencia) {
        for (final item in l.itens) {
          switch (item) {
            case LancamentoItemTransferencia(
              :final origemEntrada,
              :final origemSaida,
            ):
              if (origemEntrada == extrato.origem) {
                totalMovimentado += item.valor;
              } else if (origemSaida == extrato.origem) {
                totalMovimentado -= item.valor;
              }
            default:
              break;
          }
        }
      }
    }
    return extrato.saldoInicial + totalMovimentado;
  }

  AsyncResult<List<ExtratoFaturaDto>> _propagarDelta(
    LancamentoOrigem origem,
    Mes mes,
    int ano,
    double delta,
  ) async {
    final nextResult = await _extratoRepository.searchAfter(origem, ano, mes);
    if (nextResult.isError()) {
      return nextResult.map((_) => []);
    }

    final nextList = nextResult.getOrThrow();
    final List<ExtratoFaturaDto> dtos = [];

    for (final nextExtrato in nextList) {
      dtos.add(
        _toDto(nextExtrato)
          ..setSaldoInicial(nextExtrato.saldoInicial + delta)
          ..setSaldoFinal(nextExtrato.saldoFinal + delta),
      );
    }

    return Success(dtos);
  }

  ExtratoFaturaDto _toDto(ExtratoFatura entity) {
    return ExtratoFaturaDto(
      id: entity.id,
      origem: entity.origem,
      ano: entity.ano,
      mes: entity.mes,
      dataInicio: entity.dataInicio,
      dataFim: entity.dataFim,
      saldoInicial: entity.saldoInicial,
      saldoFinal: entity.saldoFinal,
      fechado: entity.fechado,
    );
  }
}
