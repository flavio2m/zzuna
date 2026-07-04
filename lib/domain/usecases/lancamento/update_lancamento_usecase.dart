import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_dto.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';

class UpdateLancamentoUseCase {
  final ResolveExtratoFaturaUseCase _resolveUseCase;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;
  final LancamentoRepository _repository;
  final ExtratoFaturaRepository _extratoRepository;
  final LancamentoValidator _validator;

  UpdateLancamentoUseCase(
    this._resolveUseCase,
    this._recalculateUseCase,
    this._repository,
    this._extratoRepository,
    this._validator,
  );

  AsyncResult<Lancamento> execute(LancamentoDto dto) async {
    if (dto.id == null) {
      return Failure(
        DomainException(
          'ID do lançamento é obrigatório para atualização.', //
        ),
      );
    }

    // 1. Carregar lançamento original para verificar estado prévio
    final originalResult = await _repository.getById(dto.id!);
    if (originalResult.isError()) {
      return Failure(originalResult.exceptionOrNull()!);
    }
    final original = originalResult.getOrNull()!;

    // 2. Validar novo DTO
    final validation = _validator.validate(dto);
    if (!validation.isValid) {
      return Failure(
        LocalStorageException(
          validation.exceptions.first.message,
          StackTrace.current, //
        ),
      );
    }

    // Validar que os itens possuem valor maior que 0
    for (final item in dto.itens) {
      if (item.valor <= 0) {
        return Failure(
          DomainException(
            'O valor de cada item deve ser superior a zero.', //
          ),
        );
      }
    }

    // 3. Validar se o período original está fechado
    final oldExtratoResult = await _extratoRepository.getById(
      original.extratoFaturaId, //
    );
    if (oldExtratoResult.isError()) {
      return Failure(DomainException('Extrato original não encontrado.'));
    }
    final oldExtrato = oldExtratoResult.getOrNull()!;
    if (oldExtrato.fechado) {
      return Failure(
        DomainException(
          'Não é possível editar lançamentos de um período encerrado.', //
        ),
      );
    }

    // 4. Calcular valor total calculado do novo lançamento (soma dos itens)
    final newValor = dto.itens.fold<double>(
      0.0,
      (sum, item) => sum + item.valor, //
    );

    // 5. Resolver novo ExtratoFatura (irá validar se está fechado e criar se não existir)
    final resolveDto = ResolveExtratoFaturaDto(
      origem: dto.origem,
      data: dto.data,
      valor: newValor,
      tipo: dto.tipo, //
    );
    final extratoResult = await _resolveUseCase.execute(resolveDto);
    if (extratoResult.isError()) {
      return Failure(extratoResult.exceptionOrNull()!);
    }
    final newExtrato = extratoResult.getOrNull()!;

    // 6. Atualizar DTO com o novo ID de extrato/fatura
    final updatedDto = dto.copyWith(extratoFaturaId: newExtrato.id);

    // 7. Persistir a alteração do lançamento no repositório
    final updateRes = await _repository.update(updatedDto);
    if (updateRes.isError()) {
      return Failure(updateRes.exceptionOrNull()!);
    }

    // 8. Recalcular os saldos
    final oldOrigem = original.origem;
    final newOrigem = dto.origem;

    if (oldOrigem == newOrigem) {
      final oldestDate = original.data.isBefore(dto.data)
          ? original.data
          : dto.data;
      final recalcRes = await _recalculateUseCase.execute(
        oldOrigem,
        startingAno: oldestDate.year,
        startingMes: Mes.fromDate(oldestDate),
      );
      if (recalcRes.isError()) return Failure(recalcRes.exceptionOrNull()!);
    } else {
      final oldRecalcRes = await _recalculateUseCase.execute(
        oldOrigem,
        startingAno: original.data.year,
        startingMes: Mes.fromDate(original.data),
      );
      if (oldRecalcRes.isError())
        return Failure(oldRecalcRes.exceptionOrNull()!);

      final newRecalcRes = await _recalculateUseCase.execute(
        newOrigem,
        startingAno: dto.data.year,
        startingMes: Mes.fromDate(dto.data),
      );
      if (newRecalcRes.isError())
        return Failure(newRecalcRes.exceptionOrNull()!);
    }

    return updateRes;
  }
}
