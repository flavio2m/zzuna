import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';

class LancamentoFilterUseCase {
  List<LancamentoDetails> execute(List<LancamentoDetails> list, LancamentoFilterDto filter) {
    return list.where((item) {
      if (filter.descricao.isNotEmpty) {
        final query = filter.descricao.toLowerCase();
        if (!item.descricao.toLowerCase().contains(query)) {
          return false;
        }
      }

      if (filter.tipo != null) {
        if (item.tipo != filter.tipo) {
          return false;
        }
      }

      if (filter.conciliado != null) {
        if (item.conciliado != filter.conciliado) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
