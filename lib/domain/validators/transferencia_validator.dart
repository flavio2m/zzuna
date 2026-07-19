import 'package:lucid_validation/lucid_validation.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class TransferenciaValidator extends LucidValidator<CreateTransferenciaDto> {
  TransferenciaValidator() {
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

    ruleFor((dto) => dto.origemSaida, key: 'origemSaida').must(
      (origem) => switch (origem) {
        LancamentoOrigemConta(:final contaId) => contaId.isNotEmpty,
        LancamentoOrigemCartao(:final cartaoId) => cartaoId.isNotEmpty,
      },
      'Selecione a conta ou cartão de origem',
      'origemSaidaVazia',
    );

    ruleFor((dto) => dto.origemEntrada, key: 'origemEntrada').must(
      (origem) => switch (origem) {
        LancamentoOrigemConta(:final contaId) => contaId.isNotEmpty,
        LancamentoOrigemCartao(:final cartaoId) => cartaoId.isNotEmpty,
      },
      'Selecione a conta ou cartão de destino',
      'origemEntradaVazia',
    );

    ruleFor((dto) => dto, key: 'origemDiferente').must(
      (dto) => dto.origemSaida != dto.origemEntrada,
      'A conta/cartão de origem deve ser diferente do destino',
      'mesmaOrigem',
    );

    ruleFor((dto) => dto.valor, key: 'valor').must(
      (valor) => valor > 0,
      'O valor deve ser maior que zero',
      'valorInvalido',
    );

    ruleFor((dto) => dto.ocorrencias, key: 'ocorrencias').must(
      (ocorrencias) => ocorrencias >= 1 && ocorrencias <= 24,
      'A quantidade de meses deve ser entre 1 e 24',
      'ocorrenciasInvalidas',
    );
  }
}
