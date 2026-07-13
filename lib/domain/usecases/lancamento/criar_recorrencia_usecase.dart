import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/usecases/lancamento/apply_recorrencias_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';

/// Converte um lançamento simples em recorrente.
///
/// - Atualiza o lançamento com [LancamentoGrupo.recorrencia] usando o dia
///   da data do lançamento como [diaDoMes].
/// - Define a `sequencia` como 1 para o mês atual, incrementando nos futuros.
/// - Gera imediatamente cópias em todos os ExtratoFaturas futuros já existentes
///   para a mesma origem.
class CriarRecorrenciaUseCase {
  final LancamentoRepository _lancamentoRepository;
  final ExtratoFaturaRepository _extratoRepository;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;

  CriarRecorrenciaUseCase(
    this._lancamentoRepository,
    this._extratoRepository,
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

    // 2. Validar que não é recorrente ainda
    if (lanc.grupo is LancamentoGrupoRecorrencia) {
      return Failure(
        DomainException('Este lançamento já possui uma recorrência ativa.'),
      );
    }

    // 3. Criar grupo de recorrência
    final grupoId = const Uuid().v4();
    final diaDoMes = lanc.data.day;
    final novoGrupo = LancamentoGrupo.recorrencia(
      grupoId: grupoId,
      ativo: true,
      diaDoMes: diaDoMes,
      tipo: TipoRecorrencia.mensal,
      sequencia: 1,
    );

    final baseDescricao = lanc.descricao
        .replaceFirst(RegExp(r' - \d+$'), '')
        .trim();

    // 4. Atualizar o próprio lançamento com o grupo de recorrência
    final updateRes = await _lancamentoRepository.update(
      LancamentoDto(
        id: lanc.id,
        tipo: lanc.tipo,
        data: lanc.data,
        descricao: '$baseDescricao - 1',
        extratoFaturaId: lanc.extratoFaturaId,
        origem: lanc.origem,
        itens: lanc.itens,
        conciliado: lanc.conciliado,
        grupo: novoGrupo,
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

    // 5. Buscar ExtratoFatura do lançamento atual para saber a partir de qual mês avançar
    final currentExtratoRes = await _extratoRepository.getById(
      lanc.extratoFaturaId,
    );
    if (currentExtratoRes.isError()) return const Success(unit);
    final currentExtrato = currentExtratoRes.getOrThrow();

    // 6. Buscar todos os ExtratoFaturas futuros da mesma origem
    final futureRes = await _extratoRepository.searchAfter(
      lanc.origem,
      currentExtrato.ano,
      currentExtrato.mes,
    );
    if (futureRes.isError()) return const Success(unit);

    final futureExtratos = futureRes.getOrThrow()
      ..sort((a, b) => a.dataInicio.compareTo(b.dataInicio));

    // 7. Para cada extrato futuro já existente, criar o lançamento recorrente
    // Simulamos a lógica do ApplyRecorrenciasUseCase, mas a partir do lançamento
    // original (não do extrato anterior, pois acabamos de criar o grupo)
    if (futureExtratos.isNotEmpty) {
      final updatedLancRes = await _lancamentoRepository.getById(lancamentoId);
      if (updatedLancRes.isError()) return const Success(unit);

      final lancAtualizado = updatedLancRes.getOrThrow();

      final List<LancamentoDto> dtos = [];
      int sequenciaFutura = 2;
      for (final extrato in futureExtratos) {
        final dia = clampDayToMonth(diaDoMes, extrato.mes.numero, extrato.ano);
        final novaData = DateTime(extrato.ano, extrato.mes.numero, dia);

        dtos.add(
          LancamentoDto(
            id: const Uuid().v4(),
            tipo: lancAtualizado.tipo,
            data: novaData,
            descricao: '$baseDescricao - $sequenciaFutura',
            extratoFaturaId: extrato.id,
            origem: lancAtualizado.origem,
            itens: lancAtualizado.itens,
            conciliado: false,
            grupo: (novoGrupo as LancamentoGrupoRecorrencia).copyWith(
              sequencia: sequenciaFutura,
            ),
            observacao: lancAtualizado.observacao,
          ),
        );
        sequenciaFutura++;
      }

      if (dtos.isNotEmpty) {
        final createRes = await _lancamentoRepository.createAll(dtos);
        if (createRes.isError()) {
          return Failure(
            DomainException(
              'Falha ao criar cópias nos extratos futuros: '
              '${createRes.exceptionOrNull()}',
            ),
          );
        }
      }
    }

    // 8. Recalcular saldos a partir do mês atual
    final recalcRes = await _recalculateUseCase.execute(
      lanc.origem,
      startingAno: currentExtrato.ano,
      startingMes: currentExtrato.mes,
    );
    if (recalcRes.isError()) return Failure(recalcRes.exceptionOrNull()!);

    return const Success(unit);
  }
}
