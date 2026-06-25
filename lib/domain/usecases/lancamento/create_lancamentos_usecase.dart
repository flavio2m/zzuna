import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_lote_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_faturas_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';

class CreateLancamentosUseCase {
  final ResolveExtratoFaturasUseCase _resolveUseCase;
  final LancamentoRepository _repository;
  final LancamentoValidator _validator;

  CreateLancamentosUseCase(
    this._resolveUseCase,
    this._repository,
    this._validator,
  );

  AsyncResult<List<Lancamento>> execute(List<LancamentoDto> dtos) async {
    try {
      // 1. Validar todos os DTOs
      for (final dto in dtos) {
        final validation = _validator.validate(dto);
        if (!validation.isValid) {
          return Failure(
            LocalStorageException(validation.exceptions.first.message, StackTrace.current),
          );
        }
      }

      // 2. Montar ResolveExtratoFaturaLoteDto e resolver extratos
      final resolveItems = dtos.map((dto) {
        final valorTotal = dto.itens.fold<double>(0.0, (sum, item) => sum + item.valor);
        return ResolveExtratoFaturaItemDto(
          origem: dto.origem,
          data: dto.data,
          valor: valorTotal,
          tipo: dto.tipo,
        );
      }).toList();

      final resolveDto = ResolveExtratoFaturaLoteDto(itens: resolveItems);
      final extratosResult = await _resolveUseCase.execute(resolveDto);
      if (extratosResult.isError()) {
        return Failure(extratosResult.exceptionOrNull()!);
      }
      final extratos = extratosResult.getOrThrow();

      // 3. Vincular extratoFaturaId nos DTOs e gerar UUIDs para os lançamentos
      for (final dto in dtos) {
        final matchingExtrato = extratos.firstWhere((extrato) {
          final isSameOrigem = extrato.origem == dto.origem;
          final isSameYear = extrato.ano == dto.data.year;
          final isSameMonth = extrato.mes.numero == dto.data.month;
          return isSameOrigem && isSameYear && isSameMonth;
        }, orElse: () {
          throw Exception(
            'Extrato correspondente não encontrado para o lançamento em ${dto.data.day}/${dto.data.month}/${dto.data.year}',
          );
        });

        dto.setExtratoFaturaId(matchingExtrato.id);
        if (dto.id == null) {
          dto.setId(const Uuid().v4());
        }
      }

      // 4. Persistir lançamentos em lote
      final createRes = await _repository.createAll(dtos);
      if (createRes.isError()) {
        return Failure(createRes.exceptionOrNull()!);
      }

      // 5. Retornar a lista de entidades criadas
      final lancamentos = dtos.map((dto) => Lancamento(
        id: dto.id!,
        tipo: dto.tipo,
        data: dto.data,
        descricao: dto.descricao,
        extratoFaturaId: dto.extratoFaturaId,
        origem: dto.origem,
        itens: dto.itens,
        conciliado: dto.conciliado,
        observacao: dto.observacao,
      )).toList();

      return Success(lancamentos);
    } catch (e, s) {
      return Failure(LocalStorageException('Erro ao cadastrar lançamentos em lote: $e', s));
    }
  }
}
