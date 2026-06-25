import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';

class LancamentoItemDistributionUseCase {
  // Recalcular o item principal (Item 1) com base no valor total e nos outros itens
  List<LancamentoItem> _recalculateItemPrincipal(List<LancamentoItem> itens, double totalValor) {
    if (itens.isEmpty) return [];

    // Filtra todos os itens exceto o número 1
    final outrosItens = itens.where((item) => item.numero != 1).toList();
    final somaOutros = outrosItens.fold<double>(0.0, (sum, item) => sum + item.valor);

    // O valor do item 1 é a diferença do total com os outros
    // Usamos arredondamento de centavos para evitar problemas de ponto flutuante
    final valorItem1 = double.parse(
      (totalValor - somaOutros).toStringAsFixed(2), //
    );

    final item1Idx = itens.indexWhere((item) => item.numero == 1);
    final item1 = item1Idx != -1
        ? itens[item1Idx]
        : const LancamentoItem(
            numero: 1,
            centroCustoId: '',
            categoriaId: '',
            valor: 0.0, //
          );

    final updatedItem1 = item1.copyWith(valor: valorItem1);

    return [updatedItem1, ...outrosItens];
  }

  // Validar se os percentuais de todos os itens estão dentro dos limites
  Result<Unit> _validarPercentuais(List<LancamentoItem> itens, double totalValor) {
    if (totalValor <= 0) {
      return Failure(
        DomainException(
          'O valor total do lançamento deve ser maior que zero.', //
        ),
      );
    }

    for (final item in itens) {
      final percentual = (item.valor / totalValor) * 100;
      // Arredonda com 3 casas decimais conforme o requisito de precisão do campo
      final pctArredondado = double.parse(percentual.toStringAsFixed(3));

      if (item.numero == 1) {
        if (pctArredondado < 1.0) {
          return Failure(
            DomainException(
              'O Item 1 (principal) deve ter pelo menos 1% do valor total.', //
            ),
          );
        }
      } else {
        if (pctArredondado < 1.0 || pctArredondado > 99.0) {
          return Failure(
            DomainException(
              'Itens adicionais devem representar entre 1% e 99% do valor total.', //
            ),
          );
        }
      }
    }
    return const Success(unit);
  }

  // Validar se todos os itens possuem valor de no mínimo R$ 1,00
  Result<Unit> _validarValoresMinimos(List<LancamentoItem> itens) {
    for (final item in itens) {
      // Arredonda para evitar dízimas de ponto flutuante
      final valorArredondado = double.parse(item.valor.toStringAsFixed(2));
      if (valorArredondado < 1.00) {
        return Failure(
          DomainException(
            'Nenhum item pode ter valor inferior a R\$ 1,00.', //
          ),
        );
      }
    }
    return const Success(unit);
  }

  // Adicionar item
  Result<List<LancamentoItem>> addItem({
    required List<LancamentoItem> currentItems,
    required double totalValor,
    required String centroCustoId,
    required String categoriaId,
    required double itemValor,
  }) {
    // 1. Encontra o próximo número disponível
    final maxNumero =
        currentItems //
            .fold<int>(
              0,
              (max, item) => item.numero > max ? item.numero : max, //
            );
    final novoNumero = maxNumero + 1;

    final novoItem = LancamentoItem(
      numero: novoNumero,
      centroCustoId: centroCustoId,
      categoriaId: categoriaId,
      valor: double.parse(itemValor.toStringAsFixed(2)),
    );

    // Garante que o Item 1 exists
    final itensCopy = List<LancamentoItem>.from(currentItems);
    if (!itensCopy.any((item) => item.numero == 1)) {
      itensCopy.insert(
        0,
        const LancamentoItem(
          numero: 1,
          centroCustoId: '',
          categoriaId: '',
          valor: 0.0, //
        ),
      );
    }

    itensCopy.add(novoItem);

    // 2. Recalcula Item 1
    final itensAtualizados = _recalculateItemPrincipal(itensCopy, totalValor);

    // 3. Validações
    final valValores = _validarValoresMinimos(itensAtualizados);
    if (valValores.isError()) return Failure(valValores.exceptionOrNull()!);

    final valPercentuais = _validarPercentuais(itensAtualizados, totalValor);
    if (valPercentuais.isError()) {
      return Failure(valPercentuais.exceptionOrNull()!);
    }

    return Success(itensAtualizados);
  }

  // Editar item
  Result<List<LancamentoItem>> editItem({
    required List<LancamentoItem> currentItems,
    required double totalValor,
    required int numero,
    required String centroCustoId,
    required String categoriaId,
    required double itemValor,
  }) {
    if (numero == 1) {
      return Failure(
        DomainException(
          'O Item 1 (principal) não pode ser editado diretamente.', //
        ),
      );
    }

    final index = currentItems.indexWhere((item) => item.numero == numero);
    if (index == -1) {
      return Failure(
        DomainException(
          'Item não encontrado para edição.', //
        ),
      );
    }

    final itensCopy = List<LancamentoItem>.from(currentItems);
    itensCopy[index] = LancamentoItem(
      numero: numero,
      centroCustoId: centroCustoId,
      categoriaId: categoriaId,
      valor: double.parse(itemValor.toStringAsFixed(2)),
    );

    // 2. Recalcula Item 1
    final itensAtualizados = _recalculateItemPrincipal(itensCopy, totalValor);

    // 3. Validações
    final valValores = _validarValoresMinimos(itensAtualizados);
    if (valValores.isError()) return Failure(valValores.exceptionOrNull()!);

    final valPercentuais = _validarPercentuais(itensAtualizados, totalValor);
    if (valPercentuais.isError()) {
      return Failure(valPercentuais.exceptionOrNull()!);
    }

    return Success(itensAtualizados);
  }

  // Excluir item
  Result<List<LancamentoItem>> removeItem({
    required List<LancamentoItem> currentItems,
    required double totalValor,
    required int numero,
  }) {
    if (numero == 1) {
      return Failure(
        DomainException(
          'O Item 1 (principal) não pode ser excluído.', //
        ),
      );
    }

    final index = currentItems.indexWhere((item) => item.numero == numero);
    if (index == -1) {
      return Failure(
        DomainException(
          'Item não encontrado para exclusão.', //
        ),
      );
    }

    final itensCopy = List<LancamentoItem>.from(currentItems)..removeAt(index);

    // Recalcula o Item 1 (o valor do item removido volta para o Item 1)
    final itensAtualizados = _recalculateItemPrincipal(itensCopy, totalValor);

    // Se sobrar apenas o Item 1, ele fica com 100% do valor total
    if (itensAtualizados.length == 1 && itensAtualizados.first.numero == 1) {
      itensAtualizados[0] = itensAtualizados[0].copyWith(valor: totalValor);
    }

    // Validações básicas apenas para garantir consistência
    final valValores = _validarValoresMinimos(itensAtualizados);
    if (valValores.isError()) return Failure(valValores.exceptionOrNull()!);

    return Success(itensAtualizados);
  }

  // Distribuir arredondamentos para Parcelamento
  List<List<LancamentoItem>> distributeParcelas({
    required double totalValor,
    required int parcelasCount,
    required List<LancamentoItem> baseItems,
  }) {
    if (parcelasCount <= 0) return [];

    // 1. Calcula o valor de cada parcela com a lógica atual de centavos
    final totalCentavos = (totalValor * 100).round();
    final baseCentavos = totalCentavos ~/ parcelasCount;
    final restoCentavos = totalCentavos % parcelasCount;

    final valoresParcelas = List<double>.generate(parcelasCount, (i) {
      final centavos = baseCentavos + (i == 0 ? restoCentavos : 0);
      return centavos / 100.0;
    });

    // Se houver apenas um item (Item 1), mantemos a lógica simples
    if (baseItems.length <= 1) {
      return List.generate(parcelasCount, (index) {
        final item = baseItems.isEmpty
            ? const LancamentoItem(
                numero: 1,
                categoriaId: '',
                centroCustoId: '',
                valor: 0.0, //
              )
            : baseItems.first;
        return [item.copyWith(valor: valoresParcelas[index])];
      });
    }

    // Calcular percentuais dos itens base com base no totalValor
    final percentuais = baseItems
        .map(
          (item) => item.valor / totalValor, //
        )
        .toList();

    final resultado = <List<LancamentoItem>>[];

    for (int p = 0; p < parcelasCount; p++) {
      final valorParcela = valoresParcelas[p];
      final valorParcelaCentavos = (valorParcela * 100).round();

      int somaItensParcelaCentavos = 0;
      final itensParcela = <LancamentoItem>[];

      for (int i = 0; i < baseItems.length; i++) {
        final item = baseItems[i];
        final pct = percentuais[i];

        // Aplica o percentual no valor da parcela e arredonda para centavos
        final valorItemCentavos = (valorParcelaCentavos * pct).round();

        itensParcela.add(item.copyWith(valor: valorItemCentavos / 100.0));
        somaItensParcelaCentavos += valorItemCentavos;
      }

      // Corrige diferença de centavos no último item da parcela
      final diferencaCentavos = valorParcelaCentavos - somaItensParcelaCentavos;
      if (diferencaCentavos != 0) {
        final ultimoIdx = itensParcela.length - 1;
        final ultimoItem = itensParcela[ultimoIdx];
        final novoValorCentavos = (ultimoItem.valor * 100).round() + diferencaCentavos; //
        itensParcela[ultimoIdx] = ultimoItem.copyWith(
          valor: novoValorCentavos / 100.0, //
        );
      }

      resultado.add(itensParcela);
    }

    return resultado;
  }

  // Recalcular itens para Replicação (mantendo apenas percentuais)
  List<LancamentoItem> distributeReplicado({
    required double valorReplica,
    required List<LancamentoItem> baseItems,
    required double baseTotalValor,
  }) {
    if (baseItems.isEmpty) return [];
    if (baseItems.length <= 1) {
      return [baseItems.first.copyWith(valor: valorReplica)];
    }

    // Calcula os percentuais com base no baseTotalValor
    final percentuais = baseItems
        .map(
          (item) => item.valor / baseTotalValor, //
        )
        .toList();
    final valorReplicaCentavos = (valorReplica * 100).round();

    int somaItensCentavos = 0;
    final novosItens = <LancamentoItem>[];

    for (int i = 0; i < baseItems.length; i++) {
      final item = baseItems[i];
      final pct = percentuais[i];
      final valorItemCentavos = (valorReplicaCentavos * pct).round();

      novosItens.add(item.copyWith(valor: valorItemCentavos / 100.0));
      somaItensCentavos += valorItemCentavos;
    }

    // Corrige qualquer diferença de centavos no último item
    final diferencaCentavos = valorReplicaCentavos - somaItensCentavos;
    if (diferencaCentavos != 0) {
      final ultimoIdx = novosItens.length - 1;
      final ultimoItem = novosItens[ultimoIdx];
      final novoValorCentavos = //
          (ultimoItem.valor * 100).round() + diferencaCentavos; //
      novosItens[ultimoIdx] = ultimoItem.copyWith(
        valor: novoValorCentavos / 100.0, //
      );
    }

    return novosItens;
  }

  // Validar a distribuição completa
  Result<Unit> validateDistribution(List<LancamentoItem> itens, double totalValor) {
    final valValores = _validarValoresMinimos(itens);
    if (valValores.isError()) return Failure(valValores.exceptionOrNull()!);

    final valPercentuais = _validarPercentuais(itens, totalValor);
    if (valPercentuais.isError()) {
      return Failure(valPercentuais.exceptionOrNull()!);
    }

    return const Success(unit);
  }
}
