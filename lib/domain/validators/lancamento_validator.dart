import 'package:lucid_validation/lucid_validation.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';

class LancamentoValidator<T extends LancamentoDto> extends LucidValidator<T> {
  LancamentoValidator() {
    ruleFor((dto) => dto.descricao, key: 'descricao')
        .notEmpty(message: 'Descrição é obrigatória')
        .minLength(3, message: 'Descrição deve ter no mínimo 3 caracteres');

    ruleFor((dto) => dto.data, key: 'data').must(
      (data) {
        final limit = DateTime.now().add(const Duration(days: 730));
        return data.isBefore(limit);
      },
      'Data não pode ser superior a 24 meses da data atual',
      'dataFutura',
    );

    ruleFor((dto) => dto.origem, key: 'origem').must(
      (origem) => switch (origem) {
        LancamentoOrigemConta(:final contaId) => contaId.isNotEmpty,
        LancamentoOrigemCartao(:final cartaoId) => cartaoId.isNotEmpty,
      },
      'Selecione uma conta ou cartão',
      'origemVazia',
    );

    ruleFor((dto) => dto.itens, key: 'itens').must(
      (itens) => itens.isNotEmpty,
      'Informe pelo menos um item',
      'semItens',
    );

    ruleFor((dto) => dto.itens, key: 'itensNumeros').must(
      (itens) => itens.every((item) => item.numero > 0),
      'Todos os itens devem ter número maior que zero',
      'numeroInvalido',
    );

    ruleFor((dto) => dto.itens, key: 'itensCategorias').must(
      (itens) => itens.every(
        (item) => switch (item) {
          LancamentoItemTransferencia() => true,
          _ => item.categoriaId.isNotEmpty,
        },
      ),
      'Todos os itens devem ter uma categoria',
      'categoriaObrigatoria',
    );

    ruleFor((dto) => dto.itens, key: 'itensCentrosCusto').must(
      (itens) => itens.every(
        (item) => switch (item) {
          LancamentoItemTransferencia() => true,
          _ => item.centroCustoId.isNotEmpty,
        },
      ),
      'Todos os itens devem ter um centro de custo',
      'centroCustoObrigatorio',
    );

    ruleFor((dto) => dto.itens, key: 'itensValores').must(
      (itens) => itens.every((item) => item.valor > 0),
      'Todos os itens devem ter valor maior que zero',
      'valorInvalido',
    );
  }
}
