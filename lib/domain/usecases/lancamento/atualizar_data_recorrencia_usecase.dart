import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/usecases/lancamento/apply_recorrencias_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';

/// Atualiza o [diaDoMes] da recorrência para refletir a data atual do lançamento.
///
/// Visível somente quando [lancamento.data.day != grupo.diaDoMes].
/// Recalcula a [data] de todos os lançamentos futuros do grupo usando o novo dia.
class AtualizarDataRecorrenciaUseCase {
  final LancamentoRepository _lancamentoRepository;
  final LocalStorage<Lancamento> _lancamentoStorage;
  final ExtratoFaturaRepository _extratoRepository;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;

  AtualizarDataRecorrenciaUseCase(
    this._lancamentoRepository,
    this._lancamentoStorage,
    this._extratoRepository,
    this._recalculateUseCase,
  );

  AsyncResult<Unit> execute(String lancamentoId) async {
    // 1. Carregar lançamento de referência
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
          'Este lançamento não possui recorrência ativa para atualizar.',
        ),
      );
    }

    final novoDia = lanc.data.day;

    // 3. Buscar todos do grupo
    final grupoRes = await _lancamentoRepository.getByGrupoId(grupo.grupoId);
    if (grupoRes.isError()) return Failure(grupoRes.exceptionOrNull()!);
    final todoGrupo = grupoRes.getOrThrow();

    // 4. Filtrar somente futuros (data > lanc.data)
    final futuros = todoGrupo.where((l) => l.data.isAfter(lanc.data)).toList();

    if (futuros.isEmpty && novoDia == grupo.diaDoMes) {
      return const Success(unit); // nada a fazer
    }

    // 5. Novo grupo com diaDoMes atualizado
    final novoGrupo = LancamentoGrupo.recorrencia(
      grupoId: grupo.grupoId,
      ativo: grupo.ativo,
      diaDoMes: novoDia,
      tipo: grupo.tipo,
    );

    // 6. Atualizar o lançamento de referência com novo diaDoMes no grupo
    final updateRefRes = await _lancamentoRepository.update(
      LancamentoDto(
        id: lanc.id,
        tipo: lanc.tipo,
        data: lanc.data,
        descricao: lanc.descricao,
        extratoFaturaId: lanc.extratoFaturaId,
        origem: lanc.origem,
        itens: lanc.itens,
        conciliado: lanc.conciliado,
        grupo: novoGrupo,
        observacao: lanc.observacao,
      ),
    );
    if (updateRefRes.isError()) {
      return Failure(
        DomainException(
          'Falha ao atualizar lançamento de referência: '
          '${updateRefRes.exceptionOrNull()}',
        ),
      );
    }

    // 7. Atualizar data e grupo nos futuros
    final List<LancamentoDto> dtosToUpdate = [];
    for (final futuro in futuros) {
      final novaData = DateTime(
        futuro.data.year,
        futuro.data.month,
        clampDayToMonth(novoDia, futuro.data.month, futuro.data.year),
      );
      dtosToUpdate.add(
        LancamentoDto(
          id: futuro.id,
          tipo: futuro.tipo,
          data: novaData,
          descricao: futuro.descricao,
          extratoFaturaId: futuro.extratoFaturaId,
          origem: futuro.origem,
          itens: futuro.itens,
          conciliado: futuro.conciliado,
          grupo: novoGrupo,
          observacao: futuro.observacao,
        ),
      );
    }

    if (dtosToUpdate.isNotEmpty) {
      final updateAllRes = await _lancamentoRepository.updateAll(dtosToUpdate);
      if (updateAllRes.isError()) {
        return Failure(
          DomainException(
            'Falha ao atualizar lançamentos futuros: '
            '${updateAllRes.exceptionOrNull()}',
          ),
        );
      }
    }

    // 8. Recalcular saldos
    return _recalculateUseCase.execute(lanc.origem);
  }
}
