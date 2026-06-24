import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';

class CreateLancamentoUseCase {
  final ResolveExtratoFaturaUseCase _resolveUseCase;
  final LancamentoRepository _repository;
  final LancamentoValidator _validator;

  CreateLancamentoUseCase(
    this._resolveUseCase,
    this._repository,
    this._validator,
  );

  AsyncResult<Lancamento> execute(LancamentoDto dto) async {
    try {
      // 1. Validar DTO
      final validation = _validator.validate(dto);
      if (!validation.isValid) {
        return Failure(
          LocalStorageException(validation.exceptions.first.message, StackTrace.current),
        );
      }

      // 2. Calcular valor total do lançamento
      final valorTotal = dto.itens.fold<double>(0.0, (sum, item) => sum + item.valor);

      // 3. Resolver ExtratoFatura
      final resolveDto = ResolveExtratoFaturaDto(origem: dto.origem, data: dto.data, valor: valorTotal, tipo: dto.tipo);

      final extratoResult = await _resolveUseCase.execute(resolveDto);
      if (extratoResult.isError()) {
        return Failure(extratoResult.exceptionOrNull()!);
      }
      final extrato = extratoResult.getOrThrow();

      // 4. Preencher extratoFaturaId no DTO de forma imutável
      final updatedDto = dto.copyWith(extratoFaturaId: extrato.id);

      // 5. Persistir
      return _repository.create(updatedDto);
    } catch (e, s) {
      return Failure(LocalStorageException('Erro ao cadastrar lançamento: $e', s));
    }
  }
}
