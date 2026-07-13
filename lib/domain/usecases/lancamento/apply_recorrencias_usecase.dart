import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

/// Retorna o último dia válido do mês para o [diaDoMes] solicitado.
/// Ex: dia 31 em fevereiro → 28 ou 29; dia 31 em abril → 30.
int clampDayToMonth(int diaDoMes, int month, int year) {
  final lastDay = DateTime(year, month + 1, 0).day;
  return diaDoMes > lastDay ? lastDay : diaDoMes;
}

/// Aplicar recorrências ao criar um novo ExtratoFatura.
///
/// Chamado automaticamente após a criação de cada novo [ExtratoFatura].
/// Busca os lançamentos recorrentes ativos do extrato anterior da mesma origem
/// e cria cópias no novo extrato usando o [diaDoMes] armazenado no grupo.
class ApplyRecorrenciasUseCase {
  final ExtratoFaturaRepository _extratoRepository;
  final LancamentoRepository _lancamentoRepository;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;
  ApplyRecorrenciasUseCase(
    this._extratoRepository,
    this._lancamentoRepository,
    this._recalculateUseCase,
  );

  AsyncResult<Unit> execute(
    LancamentoOrigem origem,
    ExtratoFatura novoExtrato,
  ) async {
    // 1. Buscar extrato anterior da mesma origem
    final prevRes = await _extratoRepository.searchPrevious(
      origem,
      novoExtrato.ano,
      novoExtrato.mes,
    );
    if (prevRes.isError()) return const Success(unit);

    final prevList = prevRes.getOrThrow();
    if (prevList.isEmpty) return const Success(unit);
    final prevExtrato = prevList.first;

    // 2. Carregar apenas os lançamentos do extrato anterior e filtrar os
    // recorrentes ativos
    final lancRes = await _lancamentoRepository.searchByExtratoFaturaId(
      prevExtrato.id,
    );
    if (lancRes.isError()) return const Success(unit);

    final recorrentes = lancRes.getOrThrow().where((l) {
      final g = l.grupo;
      return g is LancamentoGrupoRecorrencia && g.ativo;
    }).toList();

    if (recorrentes.isEmpty) return const Success(unit);

    // 3. Criar cópias no novo extrato usando diaDoMes clampado ao mês alvo
    final dtos = recorrentes.map((l) {
      final grupo = l.grupo as LancamentoGrupoRecorrencia;
      final dia = clampDayToMonth(
        grupo.diaDoMes,
        novoExtrato.mes.numero,
        novoExtrato.ano,
      );
      final novaData = DateTime(novoExtrato.ano, novoExtrato.mes.numero, dia);

      final novaSequencia = grupo.sequencia + 1;
      final baseDescricao = l.descricao
          .replaceFirst(RegExp(r' - \d+$'), '')
          .trim();

      return LancamentoDto(
        id: const Uuid().v4(),
        tipo: l.tipo,
        data: novaData,
        descricao: '$baseDescricao - $novaSequencia',
        extratoFaturaId: novoExtrato.id,
        origem: l.origem,
        itens: l.itens,
        conciliado: false,
        grupo: LancamentoGrupo.recorrencia(
          grupoId: grupo.grupoId,
          ativo: true,
          diaDoMes: grupo.diaDoMes,
          tipo: grupo.tipo,
          sequencia: novaSequencia,
        ),
        observacao: l.observacao,
      );
    }).toList();

    final createRes = await _lancamentoRepository.createAll(dtos);
    if (createRes.isError()) {
      return Failure(
        DomainException(
          'Falha ao criar lançamentos recorrentes: ${createRes.exceptionOrNull()}',
        ),
      );
    }

    // 4. Recalcular saldo do novo extrato
    return _recalculateUseCase.execute(
      origem,
      startingAno: novoExtrato.ano,
      startingMes: novoExtrato.mes,
    );
  }
}
