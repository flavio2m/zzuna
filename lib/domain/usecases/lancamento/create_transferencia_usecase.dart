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

    // 2. Gerar grupoId único (Uuid.v4())
    final grupoId = const Uuid().v4();
    final grupo = LancamentoGrupo.transferencia(grupoId: grupoId);

    // 3. Montar os itens de transferência (numero deve ser 1)
    final transferItem = LancamentoItem.transferencia(
      numero: 1,
      origemEntrada: dto.origemEntrada,
      origemSaida: dto.origemSaida,
      valor: dto.valor,
    );

    // 4. Montar os dois LancamentoDtos
    final dtoSaida = LancamentoDto(
      tipo: LancamentoTipo.transferencia,
      data: dto.data,
      descricao: dto.descricao,
      origem: dto.origemSaida,
      itens: [transferItem],
      conciliado: false,
      grupo: grupo,
      observacao: dto.observacao,
    );

    final dtoEntrada = LancamentoDto(
      tipo: LancamentoTipo.transferencia,
      data: dto.data,
      descricao: dto.descricao,
      origem: dto.origemEntrada,
      itens: [transferItem],
      conciliado: false,
      grupo: grupo,
      observacao: dto.observacao,
    );

    // 5. Delegar criação em lote para CreateLancamentosUseCase
    final result = await _createLancamentosUseCase.execute([
      dtoSaida,
      dtoEntrada,
    ]);
    if (result.isError()) {
      return Failure(result.exceptionOrNull()!);
    }

    return const Success(unit);
  }
}
