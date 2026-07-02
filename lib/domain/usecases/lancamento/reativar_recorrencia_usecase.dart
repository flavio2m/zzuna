import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/usecases/lancamento/apply_recorrencias_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';

/// Reativa uma recorrência que foi finalizada.
///
/// - Marca o lançamento com [ativo: true].
/// - Gera imediatamente cópias nos ExtratoFaturas futuros já existentes,
///   usando o [diaDoMes] armazenado no grupo.
class ReativarRecorrenciaUseCase {
  final LancamentoRepository _lancamentoRepository;
  final LocalStorage<Lancamento> _lancamentoStorage;
  final ExtratoFaturaRepository _extratoRepository;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;

  ReativarRecorrenciaUseCase(
    this._lancamentoRepository,
    this._lancamentoStorage,
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

    // 2. Validar que é recorrência inativa
    final grupo = lanc.grupo;
    if (grupo is! LancamentoGrupoRecorrencia) {
      return Failure(
        DomainException(
          'Este lançamento não possui uma recorrência para reativar.',
        ),
      );
    }
    if (grupo.ativo) {
      return Failure(
        DomainException('A recorrência deste lançamento já está ativa.'),
      );
    }

    // 3. Reativar: atualizar o grupo com ativo: true
    final grupoAtivo = LancamentoGrupo.recorrencia(
      grupoId: grupo.grupoId,
      ativo: true,
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
        grupo: grupoAtivo,
        observacao: lanc.observacao,
      ),
    );
    if (updateRes.isError()) {
      return Failure(
        DomainException(
          'Falha ao reativar recorrência: ${updateRes.exceptionOrNull()}',
        ),
      );
    }

    // 4. Buscar extrato atual do lançamento
    final currentExtratoRes = await _extratoRepository.getById(
      lanc.extratoFaturaId,
    );
    if (currentExtratoRes.isError()) return const Success(unit);
    final currentExtrato = currentExtratoRes.getOrThrow();

    // 5. Buscar ExtratoFaturas futuros da mesma origem
    final futureRes = await _extratoRepository.searchAfter(
      lanc.origem,
      currentExtrato.ano,
      currentExtrato.mes,
    );
    if (futureRes.isError()) return const Success(unit);

    final futureExtratos = futureRes.getOrThrow()
      ..sort((a, b) => a.dataInicio.compareTo(b.dataInicio));

    // 6. Para cada extrato futuro, criar o lançamento recorrente
    if (futureExtratos.isNotEmpty) {
      final updatedLancRes = await _lancamentoStorage.getAll();
      if (updatedLancRes.isError()) return const Success(unit);

      final lancAtualizado = updatedLancRes.getOrThrow().firstWhere(
        (l) => l.id == lancamentoId,
      );

      final List<LancamentoDto> dtos = [];
      for (final extrato in futureExtratos) {
        // Verificar se já existe lançamento desse grupo neste extrato (evitar duplicatas)
        final jaExiste = updatedLancRes.getOrThrow().any(
          (l) =>
              l.extratoFaturaId == extrato.id &&
              l.grupo is LancamentoGrupoRecorrencia &&
              (l.grupo as LancamentoGrupoRecorrencia).grupoId == grupo.grupoId,
        );
        if (jaExiste) continue;

        final dia = clampDayToMonth(
          grupo.diaDoMes,
          extrato.mes.numero,
          extrato.ano,
        );
        final novaData = DateTime(extrato.ano, extrato.mes.numero, dia);

        dtos.add(
          LancamentoDto(
            id: const Uuid().v4(),
            tipo: lancAtualizado.tipo,
            data: novaData,
            descricao: lancAtualizado.descricao,
            extratoFaturaId: extrato.id,
            origem: lancAtualizado.origem,
            itens: lancAtualizado.itens,
            conciliado: false,
            grupo: grupoAtivo,
            observacao: lancAtualizado.observacao,
          ),
        );
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

    // 7. Recalcular saldos
    return _recalculateUseCase.execute(lanc.origem);
  }
}
