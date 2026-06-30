import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_lote_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_faturas_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/validators/transferencia_validator.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class UpdateTransferenciaUseCase {
  final ResolveExtratoFaturasUseCase _resolveUseCase;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;
  final LancamentoRepository _repository;
  final ExtratoFaturaRepository _extratoRepository;
  final TransferenciaValidator _validator;

  UpdateTransferenciaUseCase(
    this._resolveUseCase,
    this._recalculateUseCase,
    this._repository,
    this._extratoRepository,
    this._validator,
  );

  AsyncResult<Unit> execute(String grupoId, CreateTransferenciaDto dto) async {
    // 1. Validar DTO
    final validation = _validator.validate(dto);
    if (!validation.isValid) {
      return Failure(
        LocalStorageException(
          validation.exceptions.first.message,
          StackTrace.current,
        ),
      );
    }

    // 2. Localizar lançamentos originais do grupo
    final allLaunchesRes = await _repository.getAll();
    if (allLaunchesRes.isError()) {
      return Failure(allLaunchesRes.exceptionOrNull()!);
    }
    final allLaunches = allLaunchesRes.getOrThrow();
    final groupLaunches = allLaunches
        .where((l) => l.grupo?.grupoId == grupoId)
        .toList();

    if (groupLaunches.length != 2) {
      return Failure(
        DomainException(
          'Transferência inconsistente ou incompleta. São necessários 2 '
          'lançamentos.',
        ),
      );
    }

    final first = groupLaunches[0];
    final second = groupLaunches[1];

    final firstItem = first.itens.isNotEmpty ? first.itens.first : null;
    if (firstItem == null) {
      return Failure(
        DomainException('Os lançamentos da transferência não possuem itens.'),
      );
    }

    // Determinar qual lançamento é a Saída e qual é a Entrada originais
    final Lancamento originalSaida;
    final Lancamento originalEntrada;

    switch (firstItem) {
      case LancamentoItemTransferencia(:final origemSaida):
        if (first.origem == origemSaida) {
          originalSaida = first;
          originalEntrada = second;
        } else {
          originalSaida = second;
          originalEntrada = first;
        }
      default:
        if (first.tipo == LancamentoTipo.transferencia) {
          originalSaida = first;
          originalEntrada = second;
        } else {
          return Failure(
            DomainException(
              'Os lançamentos originais não são transferências válidas.',
            ),
          );
        }
    }

    // 3. Validar se os extratos originais de ambos os lançamentos estão abertos
    final oldExtratoSaidaRes = await _extratoRepository.getById(
      originalSaida.extratoFaturaId,
    );
    final oldExtratoEntradaRes = await _extratoRepository.getById(
      originalEntrada.extratoFaturaId,
    );

    if (oldExtratoSaidaRes.isError() || oldExtratoEntradaRes.isError()) {
      return Failure(DomainException('Extrato original não encontrado.'));
    }

    final oldExtratoSaida = oldExtratoSaidaRes.getOrThrow();
    final oldExtratoEntrada = oldExtratoEntradaRes.getOrThrow();

    if (oldExtratoSaida.fechado || oldExtratoEntrada.fechado) {
      return Failure(
        DomainException(
          'Não é possível editar transferências de um período encerrado.',
        ),
      );
    }

    // 4. Resolver novos extratos destino via ResolveExtratoFaturasUseCase (lote)
    final resolveItems = [
      ResolveExtratoFaturaItemDto(
        origem: dto.origemSaida,
        data: dto.data,
        valor: dto.valor,
        tipo: LancamentoTipo.transferencia,
        isTransferenciaEntrada: false,
      ),
      ResolveExtratoFaturaItemDto(
        origem: dto.origemEntrada,
        data: dto.data,
        valor: dto.valor,
        tipo: LancamentoTipo.transferencia,
        isTransferenciaEntrada: true,
      ),
    ];

    final resolveDto = ResolveExtratoFaturaLoteDto(itens: resolveItems);
    final extratosResult = await _resolveUseCase.execute(resolveDto);
    if (extratosResult.isError()) {
      return Failure(extratosResult.exceptionOrNull()!);
    }
    final extratos = extratosResult.getOrThrow();

    final matchingExtratoSaidaIdx = extratos.indexWhere(
      (e) =>
          e.origem == dto.origemSaida &&
          e.ano == dto.data.year &&
          e.mes.numero == dto.data.month,
    );
    final matchingExtratoEntradaIdx = extratos.indexWhere(
      (e) =>
          e.origem == dto.origemEntrada &&
          e.ano == dto.data.year &&
          e.mes.numero == dto.data.month,
    );

    if (matchingExtratoSaidaIdx == -1 || matchingExtratoEntradaIdx == -1) {
      return Failure(
        DomainException('Extrato correspondente de destino não encontrado.'),
      );
    }

    final newExtratoSaida = extratos[matchingExtratoSaidaIdx];
    final newExtratoEntrada = extratos[matchingExtratoEntradaIdx];

    // 5. Montar os itens de transferência (numero deve ser 1)
    final transferItem = LancamentoItem.transferencia(
      numero: 1,
      origemEntrada: dto.origemEntrada,
      origemSaida: dto.origemSaida,
      valor: dto.valor,
    );

    // 6. Montar os dois LancamentoDtos preservando ID, grupoId e situação de conciliação
    final updatedSaidaDto = LancamentoDto(
      id: originalSaida.id,
      tipo: LancamentoTipo.transferencia,
      data: dto.data,
      descricao: dto.descricao,
      origem: dto.origemSaida,
      extratoFaturaId: newExtratoSaida.id,
      itens: [transferItem],
      conciliado: originalSaida.conciliado,
      grupo: originalSaida.grupo,
      observacao: dto.observacao,
    );

    final updatedEntradaDto = LancamentoDto(
      id: originalEntrada.id,
      tipo: LancamentoTipo.transferencia,
      data: dto.data,
      descricao: dto.descricao,
      origem: dto.origemEntrada,
      extratoFaturaId: newExtratoEntrada.id,
      itens: [transferItem],
      conciliado: originalEntrada.conciliado,
      grupo: originalEntrada.grupo,
      observacao: dto.observacao,
    );

    // 7. Salvar atualizações no repositório (updateAll em lote)
    final updateResult = await _repository.updateAll([
      updatedSaidaDto,
      updatedEntradaDto,
    ]);
    if (updateResult.isError()) {
      return Failure(updateResult.exceptionOrNull()!);
    }

    // 8. Recalcular saldos de todas as origens únicas envolvidas (originais e novas)
    final Set<LancamentoOrigem> affectedOrigins = {
      originalSaida.origem,
      originalEntrada.origem,
      dto.origemSaida,
      dto.origemEntrada,
    };

    for (final origem in affectedOrigins) {
      final recalcRes = await _recalculateUseCase.execute(origem);
      if (recalcRes.isError()) {
        return Failure(recalcRes.exceptionOrNull()!);
      }
    }

    return const Success(unit);
  }
}
