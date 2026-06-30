import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/update_lancamentos_metadata_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';

class UpdateLancamentosMetadataUseCase {
  final LancamentoRepository _repository;

  UpdateLancamentosMetadataUseCase(this._repository);

  AsyncResult<Unit> execute(UpdateLancamentosMetadataDto dto) async {
    // 1. Buscar o lançamento de referência
    final refRes = await _repository.getById(dto.id);
    if (refRes.isError()) {
      return Failure(
        DomainException('Lançamento com ID ${dto.id} não encontrado.'),
      );
    }
    final refLaunch = refRes.getOrNull()!;

    // 2. Se não possuir grupo, apenas atualiza o lançamento de referência
    final grupoId = refLaunch.grupo?.grupoId;
    List<Lancamento> targetLaunches = [refLaunch];

    if (grupoId != null) {
      // Buscar todos os lançamentos do grupo
      final companionsRes = await _repository.getByGrupoId(grupoId);
      if (companionsRes.isError()) {
        return Failure(companionsRes.exceptionOrNull()!);
      }
      final allGroupLaunches = companionsRes.getOrThrow();

      // Filtrar para excluir lançamentos anteriores à data do lançamento atual (manter l.data >= refLaunch.data)
      targetLaunches = allGroupLaunches
          .where((l) => !l.data.isBefore(refLaunch.data))
          .toList();
    }

    // 3. Validar se há algum lançamento conciliado nos que serão alterados
    final hasReconciled = targetLaunches.any((l) => l.conciliado);
    if (hasReconciled) {
      return Failure(
        DomainException(
          'Há lançamentos conciliados e a operação foi abortada.',
        ),
      );
    }

    // 4. Mapear para DTOs e atualizar
    final updatedDtos = targetLaunches.map((l) {
      final lancamentoDto = LancamentoDto.fromEntity(l);

      final g = l.grupo;
      final (parcela, totalParcelas) = switch (g) {
        LancamentoGrupoParcelamento(:final parcela, :final totalParcelas) => (
          parcela,
          totalParcelas,
        ),
        LancamentoGrupoReplicacao(:final parcela, :final totalParcelas) => (
          parcela,
          totalParcelas,
        ),
        _ => (null, null),
      };

      if (grupoId != null && parcela != null && totalParcelas != null) {
        lancamentoDto.descricao = '${dto.descricao} ($parcela/$totalParcelas)';
      } else {
        lancamentoDto.descricao = dto.descricao;
      }

      lancamentoDto.observacao = dto.observacao;
      return lancamentoDto;
    }).toList();

    return _repository.updateAll(updatedDtos);
  }
}
