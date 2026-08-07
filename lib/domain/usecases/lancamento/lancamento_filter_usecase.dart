import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/lancamento_modo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

class LancamentoFilterUseCase {
  List<LancamentoDetails> execute(
    List<LancamentoDetails> list,
    LancamentoFilterDto filter, //
  ) {
    return list.where((item) {
      // 1. Descrição
      if (filter.descricao.isNotEmpty) {
        final query = filter.descricao.toLowerCase();
        if (!item.descricao.toLowerCase().contains(query)) {
          return false;
        }
      }

      // 2. Tipo
      if (filter.tipo != null) {
        if (item.tipo != filter.tipo) {
          return false;
        }
      }

      // 3. Modo
      if (filter.modo != null) {
        switch (filter.modo!) {
          case LancamentoModo.parcelado:
            if (item.grupo is! LancamentoGrupoParcelamento) return false;
            break;
          case LancamentoModo.replicado:
            if (item.grupo is! LancamentoGrupoReplicacao) return false;
            break;
          case LancamentoModo.recorrencia:
            if (item.grupo is! LancamentoGrupoRecorrencia) return false;
            break;
          case LancamentoModo.simples:
            if (item.grupo != null) return false;
            break;
        }
      }

      // 4. Conciliado
      if (filter.conciliado != null) {
        if (item.conciliado != filter.conciliado) {
          return false;
        }
      }

      // 5. Contas e Cartões (Filtro aditivo/OU entre eles se ambos ou algum estiver selecionado)
      final temContasFiltro = filter.contasSelecionadas.isNotEmpty;
      final temCartoesFiltro = filter.cartoesSelecionados.isNotEmpty;

      if (temContasFiltro || temCartoesFiltro) {
        final origem = item.origem;
        bool match = false;

        if (origem is LancamentoOrigemContaDetail) {
          match =
              temContasFiltro &&
              filter.contasSelecionadas.contains(
                origem.conta.id, //
              );
        } else if (origem is LancamentoOrigemCartaoDetail) {
          match =
              temCartoesFiltro &&
              filter.cartoesSelecionados.contains(
                origem.cartao.id, //
              );
        }

        if (!match) {
          return false;
        }
      }

      // 6. Centros de Custo
      if (filter.centrosSelecionados.isNotEmpty) {
        final hasMatch = item.itens.any(
          (i) => switch (i) {
            LancamentoItemDetailsStandard(:final centroCusto) =>
              filter.centrosSelecionados.contains(centroCusto.id),
            _ => false,
          },
        );
        if (!hasMatch) {
          return false;
        }
      }

      // 7. Categorias
      if (filter.categoriasSelecionadas.isNotEmpty) {
        final hasMatch = item.itens.any(
          (i) => switch (i) {
            LancamentoItemDetailsStandard(:final categoria) =>
              filter.categoriasSelecionadas.contains(categoria.id),
            _ => false,
          },
        );
        if (!hasMatch) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
