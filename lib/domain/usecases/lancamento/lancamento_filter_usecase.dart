import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

class LancamentoFilterUseCase {
  List<LancamentoDetails> execute(List<LancamentoDetails> list, LancamentoFilterDto filter) {
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

      // 3. Conciliado
      if (filter.conciliado != null) {
        if (item.conciliado != filter.conciliado) {
          return false;
        }
      }

      // 4. Contas
      if (filter.contasSelecionadas.isNotEmpty) {
        final origem = item.origem;
        if (origem is LancamentoOrigemContaDetail) {
          if (!filter.contasSelecionadas.contains(origem.conta.id)) {
            return false;
          }
        } else {
          return false;
        }
      }

      // 5. Cartões
      if (filter.cartoesSelecionados.isNotEmpty) {
        final origem = item.origem;
        if (origem is LancamentoOrigemCartaoDetail) {
          if (!filter.cartoesSelecionados.contains(origem.cartao.id)) {
            return false;
          }
        } else {
          return false;
        }
      }

      // 6. Centros de Custo
      if (filter.centrosSelecionados.isNotEmpty) {
        final hasMatch = item.itens.any(
          (i) => filter.centrosSelecionados.contains(i.centroCusto.id), //
        );
        if (!hasMatch) {
          return false;
        }
      }

      // 7. Categorias
      if (filter.categoriasSelecionadas.isNotEmpty) {
        final hasMatch = item.itens.any(
          (i) => filter.categoriasSelecionadas.contains(i.categoria.id), //
        );
        if (!hasMatch) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
