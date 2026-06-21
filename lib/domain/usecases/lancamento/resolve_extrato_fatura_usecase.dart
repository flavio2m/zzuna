import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';

class ResolveExtratoFaturaUseCase {
  final ExtratoFaturaRepository _extratoRepository;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;

  ResolveExtratoFaturaUseCase(
    this._extratoRepository,
    this._contaRepository,
    this._cartaoRepository, //
  );

  AsyncResult<ExtratoFatura> execute(ResolveExtratoFaturaDto dto) async {
    final origem = dto.origem;

    // 1. Localizar Conta/Cartão e obter dataInicial
    final dataInicial = await _getDataInicial(origem);

    final targetMonth = DateTime(dto.data.year, dto.data.month, 1);
    if (targetMonth.isBefore(dataInicial)) {
      return Failure(
        DomainException(
          'Data do lançamento não pode ser anterior à data inicial do cartão/conta', //
        ),
      );
    }

    // 2. Localizar o último ExtratoFatura existente
    final ultimoEncontrado = await _findLastExtrato(
      origem,
      targetMonth,
      dataInicial, //
    );

    // 3. Criar automaticamente os meses faltantes
    final extratoAlvo = await _createMissingExtratos(
      origem,
      ultimoEncontrado,
      targetMonth,
      dataInicial, //
    );

    // 4. Validar se o extrato do mês do lançamento está fechado
    if (extratoAlvo.fechado) {
      return Failure(
        DomainException(
          'Não é possível registrar lançamentos em um período encerrado.', //
        ),
      );
    }

    // 5. Calcular o delta do lançamento
    final delta = _calculateDelta(dto.tipo, dto.valor);

    // 6. Atualizar o saldoFinal do mês do lançamento
    final updatedAlvo = await _updateSaldoFinal(extratoAlvo, delta);

    // 7. Propagar esse mesmo delta para todos os extratos posteriores da mesma origem
    await _propagateDelta(origem, targetMonth, delta);

    return Success(updatedAlvo);
  }

  Future<DateTime> _getDataInicial(LancamentoOrigem origem) async {
    DateTime dataInicial;
    if (origem is LancamentoOrigemConta) {
      final contaRes = await _contaRepository.getById(origem.contaId);
      if (contaRes.isError()) {
        throw Exception('Conta não encontrada: ${origem.contaId}');
      }
      dataInicial = contaRes.getOrThrow().dataInicial;
    } else if (origem is LancamentoOrigemCartao) {
      final cartaoRes = await _cartaoRepository.getById(origem.cartaoId);
      if (cartaoRes.isError()) {
        throw Exception('Cartão não encontrado: ${origem.cartaoId}');
      }
      dataInicial = cartaoRes.getOrThrow().dataInicial;
    } else {
      throw Exception('Origem de lançamento desconhecida');
    }
    return DateTime(dataInicial.year, dataInicial.month, 1);
  }

  Future<ExtratoFatura?> _findLastExtrato(
    LancamentoOrigem origem,
    DateTime targetMonth,
    DateTime dataInicial, //
  ) async {
    for (int y = targetMonth.year; y >= dataInicial.year; y--) {
      final res = await _extratoRepository.searchByOrigemAndAno(origem, y);
      final extratosOrigem = res.getOrElse((_) => <ExtratoFatura>[]);

      if (extratosOrigem.isNotEmpty) {
        extratosOrigem.sort((a, b) => a.dataInicio.compareTo(b.dataInicio));
        final anteriores = extratosOrigem.where((e) {
          final start = DateTime(e.ano, e.mes.numero, 1);
          return !start.isAfter(targetMonth);
        }).toList();

        if (anteriores.isNotEmpty) {
          return anteriores.last;
        }
      }
    }
    return null;
  }

  Future<ExtratoFatura> _createMissingExtratos(
    LancamentoOrigem origem,
    ExtratoFatura? ultimoEncontrado,
    DateTime targetMonth,
    DateTime dataInicial,
  ) async {
    DateTime startMonth;
    double saldoAcumulado;

    if (ultimoEncontrado != null) {
      startMonth = DateTime(ultimoEncontrado.ano, ultimoEncontrado.mes.numero + 1, 1);
      saldoAcumulado = ultimoEncontrado.saldoFinal;
    } else {
      startMonth = dataInicial;
      saldoAcumulado = 0.0;
    }

    ExtratoFatura? currentLast = ultimoEncontrado;

    while (!startMonth.isAfter(targetMonth)) {
      final currentYear = startMonth.year;
      final currentMonthNum = startMonth.month;
      final mes = Mes.values.firstWhere((m) => m.numero == currentMonthNum);

      final newExtratoDto = ExtratoFaturaDto(
        origem: origem,
        ano: currentYear,
        mes: mes,
        dataInicio: DateTime(currentYear, currentMonthNum, 1),
        dataFim: DateTime(currentYear, currentMonthNum + 1, 0, 23, 59, 59, 999),
        saldoInicial: saldoAcumulado,
        saldoFinal: saldoAcumulado,
        fechado: false,
      );

      final createRes = await _extratoRepository.create(newExtratoDto);
      if (createRes.isError()) {
        throw Exception(
          'Falha ao criar extrato automático para $currentMonthNum/$currentYear', //
        );
      }

      currentLast = createRes.getOrThrow();
      saldoAcumulado = currentLast.saldoFinal;
      startMonth = DateTime(currentYear, currentMonthNum + 1, 1);
    }

    if (currentLast == null) {
      throw Exception('Falha ao resolver extrato fatura.');
    }

    return currentLast;
  }

  double _calculateDelta(LancamentoTipo tipo, double valor) {
    if (tipo == LancamentoTipo.receita) {
      return valor;
    }
    return -valor;
  }

  Future<ExtratoFatura> _updateSaldoFinal(
    ExtratoFatura extrato,
    double delta, //
  ) async {
    final updatedExtrato = extrato.copyWith(
      saldoFinal: extrato.saldoFinal + delta, //
    );

    final dto = ExtratoFaturaDto(
      id: updatedExtrato.id,
      origem: updatedExtrato.origem,
      ano: updatedExtrato.ano,
      mes: updatedExtrato.mes,
      dataInicio: updatedExtrato.dataInicio,
      dataFim: updatedExtrato.dataFim,
      saldoInicial: updatedExtrato.saldoInicial,
      saldoFinal: updatedExtrato.saldoFinal,
      fechado: updatedExtrato.fechado,
    );

    final updateRes = await _extratoRepository.update(dto);
    if (updateRes.isError()) {
      throw Exception('Falha ao persistir saldo final do extrato');
    }
    return updateRes.getOrThrow();
  }

  Future<void> _propagateDelta(
    LancamentoOrigem origem,
    DateTime targetMonth,
    double delta, //
  ) async {
    final res = await _extratoRepository.searchByOrigemAndAno(
      origem,
      targetMonth.year,
      targetMonth.month, //
    );
    final extratosOrigem = res.getOrElse((_) => <ExtratoFatura>[]);

    extratosOrigem.sort((a, b) => a.dataInicio.compareTo(b.dataInicio));

    //REFATORAR: criar atualização em lote para evitar múltiplas chamadas ao banco
    for (final extrato in extratosOrigem) {
      final start = DateTime(extrato.ano, extrato.mes.numero, 1);
      if (start.isAfter(targetMonth)) {
        final updated = extrato.copyWith(
          saldoInicial: extrato.saldoInicial + delta,
          saldoFinal: extrato.saldoFinal + delta,
        );

        final dto = ExtratoFaturaDto(
          id: updated.id,
          origem: updated.origem,
          ano: updated.ano,
          mes: updated.mes,
          dataInicio: updated.dataInicio,
          dataFim: updated.dataFim,
          saldoInicial: updated.saldoInicial,
          saldoFinal: updated.saldoFinal,
          fechado: updated.fechado,
        );

        final updateRes = await _extratoRepository.update(dto);
        if (updateRes.isError()) {
          throw Exception('Falha ao propagar delta para o extrato ${extrato.id}');
        }
      }
    }
  }
}
