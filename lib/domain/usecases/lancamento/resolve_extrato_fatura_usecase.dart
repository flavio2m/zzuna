import 'package:brasil_fields/brasil_fields.dart';
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
import 'package:zzuna/domain/usecases/lancamento/apply_recorrencias_usecase.dart';

class ResolveExtratoFaturaUseCase {
  final ExtratoFaturaRepository _extratoRepository;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final ApplyRecorrenciasUseCase? _applyRecorrenciasUseCase;

  ResolveExtratoFaturaUseCase(
    this._extratoRepository,
    this._contaRepository,
    this._cartaoRepository, {
    ApplyRecorrenciasUseCase? applyRecorrenciasUseCase,
  }) : _applyRecorrenciasUseCase = applyRecorrenciasUseCase;

  AsyncResult<ExtratoFatura> execute(ResolveExtratoFaturaDto dto) async {
    final origem = dto.origem;

    // 1. Localizar Conta/Cartão e obter dataInicial
    final infoRes = await _getDataInicial(origem);
    if (infoRes.isError()) {
      return Failure(infoRes.exceptionOrNull()!);
    }
    final info = infoRes.getOrThrow();
    final dataInicial = info.dataInicial;

    final targetMonth = DateTime(dto.data.year, dto.data.month, 1);
    if (targetMonth.isBefore(dataInicial)) {
      final dateStr = UtilData.obterDataDDMMAAAA(dto.data);
      final dataInicialStr = UtilData.obterDataDDMMAAAA(dataInicial);
      return Failure(
        DomainException(
          'A data do lançamento ($dateStr) não pode ser anterior à data '
          'inicial ($dataInicialStr) do(a) "${info.nomeOrigem}".',
        ),
      );
    }

    final mes = Mes.values.firstWhere((m) => m.numero == dto.data.month);

    // 2. Buscar extrato do período
    final targetRes = await _extratoRepository.searchByPeriodo(
      origem,
      dto.data.year,
      mes, //
    );
    if (targetRes.isError()) {
      return Failure(
        DomainException(
          'Erro ao buscar extrato do período: ${targetRes.exceptionOrNull()}', //
        ),
      );
    }

    final List<ExtratoFatura> existingExtratos = targetRes.getOrThrow();
    final ExtratoFatura extratoAlvo;

    if (existingExtratos.isEmpty) {
      // 3. Buscar extrato anterior para herdar o saldoInicial
      final prevRes = await _extratoRepository.searchPrevious(
        origem,
        dto.data.year,
        mes, //
      );
      if (prevRes.isError()) {
        return Failure(
          DomainException(
            'Erro ao buscar extrato anterior: ${prevRes.exceptionOrNull()}', //
          ),
        );
      }
      final List<ExtratoFatura> prevExtratos = prevRes.getOrThrow();
      final saldoInicial = prevExtratos.isEmpty
          ? 0.0
          : prevExtratos.first.saldoFinal;

      final newExtratoDto = ExtratoFaturaDto(
        origem: origem,
        ano: dto.data.year,
        mes: mes,
        dataInicio: DateTime(dto.data.year, dto.data.month, 1),
        dataFim: DateTime(
          dto.data.year,
          dto.data.month + 1,
          0,
          23,
          59,
          59,
          999,
        ),
        saldoInicial: saldoInicial,
        saldoFinal: saldoInicial,
        fechado: false,
      );

      final createRes = await _extratoRepository.create(newExtratoDto);
      if (createRes.isError()) {
        return Failure(
          DomainException(
            'Falha ao criar extrato automático: ${createRes.exceptionOrNull()}', //
          ),
        );
      }
      extratoAlvo = createRes.getOrThrow();

      // Hook: aplicar recorrências do extrato anterior no novo extrato
      if (_applyRecorrenciasUseCase != null) {
        await _applyRecorrenciasUseCase.execute(origem, extratoAlvo);
      }
    } else {
      extratoAlvo = existingExtratos.first;
    }

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

    // 6. Atualizar o saldoFinal do mês do lançamento (em memória)
    final updatedAlvo = _updateSaldoFinal(extratoAlvo, delta);

    // 7. Propagar esse mesmo delta para todos os extratos posteriores da
    // mesma origem (em memória)
    final propagatedRes = await _propagateDelta(origem, targetMonth, delta);
    if (propagatedRes.isError()) {
      return Failure(propagatedRes.exceptionOrNull()!);
    }
    final propagatedUpdated = propagatedRes.getOrThrow();

    // 8. Montar a lista de DTOs para atualização em lote
    final List<ExtratoFaturaDto> dtosToUpdate = [
      _toDto(updatedAlvo), ...propagatedUpdated.map(_toDto), //
    ];

    // 9. Realizar a chamada de atualização em lote
    final batchResult = await _extratoRepository.updateAll(dtosToUpdate);
    if (batchResult.isError()) {
      return Failure(
        DomainException(
          'Falha ao persistir alterações nos extratos: '
          '${batchResult.exceptionOrNull()}',
        ),
      );
    }

    return Success(updatedAlvo);
  }

  Future<Result<({DateTime dataInicial, String nomeOrigem})>> _getDataInicial(
    LancamentoOrigem origem,
  ) async {
    DateTime dataInicial;
    String nomeOrigem;
    if (origem is LancamentoOrigemConta) {
      final contaRes = await _contaRepository.getById(origem.contaId);
      if (contaRes.isError()) {
        return Failure(
          DomainException('Conta não encontrada: ${origem.contaId}'),
        );
      }
      final conta = contaRes.getOrThrow();
      dataInicial = conta.dataInicial;
      nomeOrigem = conta.descricao;
    } else if (origem is LancamentoOrigemCartao) {
      final cartaoRes = await _cartaoRepository.getById(origem.cartaoId);
      if (cartaoRes.isError()) {
        return Failure(
          DomainException('Cartão não encontrado: ${origem.cartaoId}'),
        );
      }
      final cartao = cartaoRes.getOrThrow();
      dataInicial = cartao.dataInicial;
      nomeOrigem = cartao.descricao;
    } else {
      return Failure(DomainException('Origem de lançamento desconhecida'));
    }
    return Success((
      dataInicial: DateTime(dataInicial.year, dataInicial.month, 1),
      nomeOrigem: nomeOrigem,
    ));
  }

  double _calculateDelta(LancamentoTipo tipo, double valor) {
    if (tipo == LancamentoTipo.receita) {
      return valor;
    }
    return -valor;
  }

  ExtratoFatura _updateSaldoFinal(ExtratoFatura extrato, double delta) {
    return extrato.copyWith(saldoFinal: extrato.saldoFinal + delta);
  }

  AsyncResult<List<ExtratoFatura>> _propagateDelta(
    LancamentoOrigem origem,
    DateTime targetMonth,
    double delta, //
  ) async {
    final mes = Mes.values.firstWhere((m) => m.numero == targetMonth.month);
    final res = await _extratoRepository.searchAfter(
      origem,
      targetMonth.year,
      mes, //
    );
    if (res.isError()) {
      return Failure(
        DomainException(
          'Erro ao buscar extratos futuros: ${res.exceptionOrNull()}', //
        ),
      );
    }

    final extratosFuturos = res.getOrThrow();
    final List<ExtratoFatura> updatedList = [];
    for (final extrato in extratosFuturos) {
      final updated = extrato.copyWith(
        saldoInicial: extrato.saldoInicial + delta,
        saldoFinal: extrato.saldoFinal + delta,
      );
      updatedList.add(updated);
    }
    return Success(updatedList);
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
