import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/exception/local_storage_exception.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamentos_usecase.dart';
import 'package:zzuna/domain/validators/transferencia_validator.dart';

class CreateTransferenciaUseCase {
  final CreateLancamentosUseCase _createLancamentosUseCase;
  final TransferenciaValidator _validator;

  CreateTransferenciaUseCase(this._createLancamentosUseCase, this._validator);

  AsyncResult<Unit> execute(CreateTransferenciaDto dto) async {
    // 1. Validar
    final validation = _validator.validate(dto);
    if (!validation.isValid) {
      return Failure(
        LocalStorageException(
          validation.exceptions.first.message,
          StackTrace.current,
        ),
      );
    }

    final List<LancamentoDto> allDtos = [];

    for (int i = 0; i < dto.ocorrencias; i++) {
      final grupoId = const Uuid().v4();
      final grupo = LancamentoGrupo.transferencia(grupoId: grupoId);

      final transferItem = LancamentoItem.transferencia(
        numero: 1,
        origemEntrada: dto.origemEntrada,
        origemSaida: dto.origemSaida,
        valor: dto.valor,
      );

      final date = _addMonths(dto.data, i);
      final itemDescricao = dto.ocorrencias > 1
          ? '${dto.descricao} ${i + 1}'
          : dto.descricao;

      final dtoSaida = LancamentoDto(
        tipo: LancamentoTipo.transferencia,
        data: date,
        descricao: itemDescricao,
        origem: dto.origemSaida,
        itens: [transferItem],
        conciliado: false,
        grupo: grupo,
        observacao: dto.observacao,
      );

      final dtoEntrada = LancamentoDto(
        tipo: LancamentoTipo.transferencia,
        data: date,
        descricao: itemDescricao,
        origem: dto.origemEntrada,
        itens: [transferItem],
        conciliado: false,
        grupo: grupo,
        observacao: dto.observacao,
      );

      allDtos.add(dtoSaida);
      allDtos.add(dtoEntrada);
    }

    // 5. Delegar criação em lote para CreateLancamentosUseCase
    final result = await _createLancamentosUseCase.execute(allDtos);
    if (result.isError()) {
      return Failure(result.exceptionOrNull()!);
    }

    return const Success(unit);
  }

  DateTime _addMonths(DateTime date, int months) {
    if (months == 0) return date;

    int nextYear = date.year;
    int nextMonth = date.month + months;

    while (nextMonth > 12) {
      nextMonth -= 12;
      nextYear++;
    }

    int nextDay = date.day;
    int lastDayOfNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;

    if (nextDay > lastDayOfNextMonth) {
      nextDay = lastDayOfNextMonth;
    }

    return DateTime(
      nextYear,
      nextMonth,
      nextDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }
}
