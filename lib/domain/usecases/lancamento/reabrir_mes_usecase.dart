import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class ReabrirMesUseCase {
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final ExtratoFaturaRepository _extratoRepository;

  ReabrirMesUseCase(
    this._contaRepository,
    this._cartaoRepository,
    this._extratoRepository,
  );

  AsyncResult<Unit> execute(Mes mes, int ano) async {
    final origensResult = await _obterTodasOrigens();
    if (origensResult.isError()) {
      return origensResult.map((_) => unit);
    }
    final origens = origensResult.getOrThrow();

    // 1. Validar se o mês seguinte está fechado
    final checkProximo = await _validarExtratosProximosFechados(
      origens,
      mes,
      ano,
    );
    if (checkProximo.isError()) return checkProximo;

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
      if (extrato.fechado) {
        extratosParaAtualizar.add(_toDto(extrato)..setFechado(false));
      }
    }

    // 2. updateAll()
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

  AsyncResult<Unit> _validarExtratosProximosFechados(
    List<LancamentoOrigem> origens,
    Mes mes,
    int ano,
  ) async {
    for (final origem in origens) {
      final nextResult = await _extratoRepository.searchNext(
        origem,
        ano,
        mes,
        limit: 1,
      );
      if (nextResult.isSuccess()) {
        final nextList = nextResult.getOrThrow();
        if (nextList.isNotEmpty && nextList.first.fechado) {
          return Failure(
            DomainException(
              'O mês seguinte já está fechado. Reabra-o primeiro.',
            ),
          );
        }
      }
    }
    return const Success(unit);
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
