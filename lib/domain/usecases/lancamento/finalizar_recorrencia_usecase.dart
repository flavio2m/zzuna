import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';

/// Finaliza a recorrência de um lançamento.
///
/// - O lançamento clicado é mantido mas marcado como [ativo: false].
/// - Todos os lançamentos do mesmo grupo com [data > lancamento.data] são excluídos.
/// - Os saldos dos extratos afetados são recalculados.
class FinalizarRecorrenciaUseCase {
  final LancamentoRepository _lancamentoRepository;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;

  FinalizarRecorrenciaUseCase(
    this._lancamentoRepository,
    this._recalculateUseCase,
  );

  AsyncResult<Unit> execute(String lancamentoId) async {
    // 1. Carregar lançamento
    final lancRes = await _lancamentoRepository.getById(lancamentoId);
    if (lancRes.isError()) {
      return Failure(
        DomainException('Lançamento não encontrado: $lancamentoId'),
      );
    }
    final lanc = lancRes.getOrThrow();

    // 2. Validar que é recorrência ativa
    final grupo = lanc.grupo;
    if (grupo is! LancamentoGrupoRecorrencia || !grupo.ativo) {
      return Failure(
        DomainException(
          'Este lançamento não possui uma recorrência ativa para finalizar.',
        ),
      );
    }

    // 3. Buscar todos os lançamentos do grupo
    final grupoRes = await _lancamentoRepository.getByGrupoId(grupo.grupoId);
    if (grupoRes.isError()) {
      return Failure(grupoRes.exceptionOrNull()!);
    }
    final todoGrupo = grupoRes.getOrThrow();

    // 4. Filtrar futuros (data estritamente maior que a data do lançamento clicado)
    final futuros = todoGrupo.where((l) => l.data.isAfter(lanc.data)).toList();

    // 5. Excluir os futuros
    for (final futuro in futuros) {
      final deleteRes = await _lancamentoRepository.delete(futuro.id);
      if (deleteRes.isError()) {
        return Failure(
          DomainException(
            'Falha ao excluir lançamento futuro ${futuro.id}: '
            '${deleteRes.exceptionOrNull()}',
          ),
        );
      }
    }

    // 6. Marcar o lançamento clicado como ativo: false
    final grupoInativo = LancamentoGrupo.recorrencia(
      grupoId: grupo.grupoId,
      ativo: false,
      diaDoMes: grupo.diaDoMes,
      tipo: grupo.tipo,
    );
    final updateRes = await _lancamentoRepository.update(
      LancamentoDto(
        id: lanc.id,
        tipo: lanc.tipo,
        data: lanc.data,
        descricao: lanc.descricao,
        extratoFaturaId: lanc.extratoFaturaId,
        origem: lanc.origem,
        itens: lanc.itens,
        conciliado: lanc.conciliado,
        grupo: grupoInativo,
        observacao: lanc.observacao,
      ),
    );
    if (updateRes.isError()) {
      return Failure(
        DomainException(
          'Falha ao atualizar lançamento: ${updateRes.exceptionOrNull()}',
        ),
      );
    }

    // 7. Recalcular saldo da origem
    return _recalculateUseCase.execute(
      lanc.origem,
      startingAno: lanc.data.year,
      startingMes: Mes.fromDate(lanc.data),
    );
  }
}
