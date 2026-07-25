import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_filter_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';

class ReconcileLancamentosUseCase {
  final LancamentoRepository _repository;
  final ExtratoFaturaRepository _extratoRepository;

  ReconcileLancamentosUseCase(this._repository, this._extratoRepository);

  AsyncResult<Unit> execute({
    required List<String> ids,
    required bool conciliado,
  }) async {
    final Map<String, Lancamento> uniqueLancamentos = {};

    for (final id in ids) {
      final res = await _repository.getById(id);
      if (res.isError()) {
        return Failure(
          DomainException('Lançamento com ID $id não encontrado.'),
        );
      }
      final l = res.getOrThrow();
      uniqueLancamentos[l.id] = l;
    }

    final List<Lancamento> initialLancamentos = uniqueLancamentos.values
        .toList();
    for (final l in initialLancamentos) {
      if (l.tipo == LancamentoTipo.transferencia && l.grupo?.grupoId != null) {
        final grupoId = l.grupo!.grupoId;
        final companionsRes = await _repository.getByGrupoId(grupoId);
        if (companionsRes.isSuccess()) {
          for (final comp in companionsRes.getOrThrow()) {
            uniqueLancamentos[comp.id] = comp;
          }
        }
      }
    }

    // Validar se algum dos lançamentos pertence a um período/extrato encerrado
    for (final l in uniqueLancamentos.values) {
      if (l.extratoFaturaId.isNotEmpty) {
        final extratoRes = await _extratoRepository.getById(l.extratoFaturaId);
        if (extratoRes.isSuccess() && extratoRes.getOrNull()!.fechado) {
          return Failure(
            DomainException(
              'Não é possível alterar a conciliação de lançamentos em um '
              'período encerrado.',
            ),
          );
        }
      }

      final ano = l.anoMes ~/ 100;
      final mes = Mes.fromNumero(l.anoMes % 100);
      final periodRes = await _extratoRepository.search(
        ExtratoFaturaFilterDto(mes: mes, ano: ano),
      );
      if (periodRes.isSuccess()) {
        final extratos = periodRes.getOrThrow();
        if (extratos.any((e) => e.fechado)) {
          return Failure(
            DomainException(
              'Não é possível alterar a conciliação de lançamentos em um '
              'período encerrado.',
            ),
          );
        }
      }
    }

    final List<LancamentoDto> dtosToUpdate = [];
    for (final l in uniqueLancamentos.values) {
      if (l.conciliado == conciliado) {
        continue;
      }

      dtosToUpdate.add(
        LancamentoDto(
          id: l.id,
          tipo: l.tipo,
          data: l.data,
          descricao: l.descricao,
          origem: l.origem,
          extratoFaturaId: l.extratoFaturaId,
          itens: l.itens,
          conciliado: conciliado,
          anoMes: l.anoMes,
          grupo: l.grupo,
          observacao: l.observacao,
        ),
      );
    }

    if (dtosToUpdate.isEmpty) {
      return const Success(unit);
    }

    final updateResult = await _repository.updateAll(dtosToUpdate);
    if (updateResult.isError()) {
      return Failure(updateResult.exceptionOrNull()!);
    }

    return const Success(unit);
  }
}
