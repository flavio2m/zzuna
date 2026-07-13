import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';

/// Atualiza a [sequencia] de uma recorrência a partir de um lançamento.
///
/// Modifica a sequência do lançamento selecionado para [novaSequencia],
/// e atualiza todos os lançamentos futuros do mesmo grupo com incrementos sucessivos.
class AtualizarSequenciaRecorrenciaUseCase {
  final LancamentoRepository _lancamentoRepository;

  AtualizarSequenciaRecorrenciaUseCase(this._lancamentoRepository);

  AsyncResult<Unit> execute(String lancamentoId, int novaSequencia) async {
    // 1. Carregar lançamento de referência
    final lancRes = await _lancamentoRepository.getById(lancamentoId);
    if (lancRes.isError()) {
      return Failure(
        DomainException('Lançamento não encontrado: $lancamentoId'),
      );
    }
    final lanc = lancRes.getOrThrow();

    // 2. Validar que é recorrência
    final grupo = lanc.grupo;
    if (grupo is! LancamentoGrupoRecorrencia) {
      return Failure(
        DomainException(
          'Este lançamento não possui uma recorrência para atualizar a sequência.',
        ),
      );
    }

    // Se for a mesma sequência, não fazer nada
    if (grupo.sequencia == novaSequencia) {
      return const Success(unit);
    }

    // 3. Buscar todos do grupo
    final grupoRes = await _lancamentoRepository.getByGrupoId(grupo.grupoId);
    if (grupoRes.isError()) return Failure(grupoRes.exceptionOrNull()!);
    final todoGrupo = grupoRes.getOrThrow();

    // 4. Filtrar o atual e futuros (data >= lanc.data)
    final afetados =
        todoGrupo.where((l) => !l.data.isBefore(lanc.data)).toList()
          ..sort((a, b) => a.data.compareTo(b.data));

    // 5. Atualizar sequência e descrição de cada um
    final List<LancamentoDto> dtosToUpdate = [];
    int currentSeq = novaSequencia;

    for (final item in afetados) {
      final baseDescricao = item.descricao
          .replaceFirst(RegExp(r' - \d+$'), '')
          .trim();
      final itemGrupo = item.grupo as LancamentoGrupoRecorrencia;

      dtosToUpdate.add(
        LancamentoDto(
          id: item.id,
          tipo: item.tipo,
          data: item.data,
          descricao: '$baseDescricao - $currentSeq',
          extratoFaturaId: item.extratoFaturaId,
          origem: item.origem,
          itens: item.itens,
          conciliado: item.conciliado,
          grupo: itemGrupo.copyWith(sequencia: currentSeq),
          observacao: item.observacao,
        ),
      );
      currentSeq++;
    }

    // 6. Salvar atualizações
    if (dtosToUpdate.isNotEmpty) {
      final updateAllRes = await _lancamentoRepository.updateAll(dtosToUpdate);
      if (updateAllRes.isError()) {
        return Failure(
          DomainException(
            'Falha ao atualizar as sequências: ${updateAllRes.exceptionOrNull()}',
          ),
        );
      }
    }

    return const Success(unit);
  }
}
