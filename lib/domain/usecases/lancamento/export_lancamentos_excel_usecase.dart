import 'package:excel/excel.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/utils/formatters/currency_formatter.dart';
import 'package:zzuna/utils/formatters/date_formatter.dart';

class ExportLancamentosExcelUseCase {
  List<int>? execute({
    required List<LancamentoDetails> lancamentos,
    required Set<String> lancamentosDesconsiderados,
  }) {
    final excel = Excel.createExcel();
    const sheetName = 'Extrato Fatura';
    excel.rename('Sheet1', sheetName);
    final sheet = excel[sheetName];

    // Cabeçalho
    sheet.appendRow([
      TextCellValue('Data'),
      TextCellValue('Descrição'),
      TextCellValue('Tipo'),
      TextCellValue('Conta/Cartão'),
      TextCellValue('Modo lançamento'),
      TextCellValue('Total'),
      TextCellValue('Situação'),
      TextCellValue('Nº Item'),
      TextCellValue('Centro de Custo'),
      TextCellValue('Categoria'),
      TextCellValue('Valor Item'),
    ]);

    for (final l in lancamentos) {
      if (lancamentosDesconsiderados.contains(l.id)) {
        continue;
      }

      final dataStr = DateFormatter.dma(l.data);
      final descricaoStr = l.descricao;
      final tipoStr = l.tipo.descricao;
      final contaCartaoStr = switch (l.origem) {
        LancamentoOrigemContaDetail(:final conta) => conta.descricao,
        LancamentoOrigemCartaoDetail(:final cartao) => cartao.descricao,
      };

      final modoStr = switch (l.grupo) {
        LancamentoGrupoParcelamento(:final parcela, :final totalParcelas) =>
          'Parcelado ($parcela/$totalParcelas)',
        LancamentoGrupoReplicacao(:final parcela, :final totalParcelas) =>
          'Replicado ($parcela de $totalParcelas)',
        LancamentoGrupoTransferencia() => 'Transferência',
        LancamentoGrupoRecorrencia(:final ativo) =>
          ativo ? 'Recorrente' : 'Recorrência Inativa',
        null => 'Simples',
      };

      final totalStr = CurrencyFormatter.formatWithoutSymbol(l.valor);
      final situacaoStr = l.conciliado ? 'Conciliado' : 'Não Conciliado';

      final itemRows =
          <
            ({
              String numero,
              String centroCusto,
              String categoria,
              String valor,
            })
          >[];

      for (final item in l.itens) {
        switch (item) {
          case LancamentoItemDetailsStandard(
            :final numero,
            :final centroCusto,
            :final categoria,
            :final valor,
          ):
            final catPath = _categoryPath(categoria);
            final valorFormatted = CurrencyFormatter.formatWithoutSymbol(valor);
            itemRows.add((
              numero: numero.toString(),
              centroCusto: centroCusto.descricao,
              categoria: catPath,
              valor: valorFormatted,
            ));
          case LancamentoItemDetailsTransferencia(
            :final numero,
            :final origemEntrada,
            :final origemSaida,
            :final valor,
          ):
            final entradaDesc = switch (origemEntrada) {
              LancamentoOrigemContaDetail(:final conta) => conta.descricao,
              LancamentoOrigemCartaoDetail(:final cartao) => cartao.descricao,
            };
            final saidaDesc = switch (origemSaida) {
              LancamentoOrigemContaDetail(:final conta) => conta.descricao,
              LancamentoOrigemCartaoDetail(:final cartao) => cartao.descricao,
            };
            final valorFormatted = CurrencyFormatter.formatWithoutSymbol(valor);
            itemRows.add((
              numero: numero.toString(),
              centroCusto: 'Transferência',
              categoria: 'Transferência ($saidaDesc -> $entradaDesc)',
              valor: valorFormatted,
            ));
        }
      }

      final startRowIndex = sheet.maxRows;

      if (itemRows.isEmpty) {
        sheet.appendRow([
          TextCellValue(dataStr),
          TextCellValue(descricaoStr),
          TextCellValue(tipoStr),
          TextCellValue(contaCartaoStr),
          TextCellValue(modoStr),
          TextCellValue(totalStr),
          TextCellValue(situacaoStr),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
        ]);
      } else {
        for (var i = 0; i < itemRows.length; i++) {
          final itemData = itemRows[i];
          sheet.appendRow([
            TextCellValue(dataStr),
            TextCellValue(descricaoStr),
            TextCellValue(tipoStr),
            TextCellValue(contaCartaoStr),
            TextCellValue(modoStr),
            TextCellValue(totalStr),
            TextCellValue(situacaoStr),
            TextCellValue(itemData.numero),
            TextCellValue(itemData.centroCusto),
            TextCellValue(itemData.categoria),
            TextCellValue(itemData.valor),
          ]);
        }

        if (itemRows.length > 1) {
          final endRowIndex = startRowIndex + itemRows.length - 1;
          for (var col = 0; col < 7; col++) {
            sheet.merge(
              CellIndex.indexByColumnRow(
                columnIndex: col,
                rowIndex: startRowIndex,
              ),
              CellIndex.indexByColumnRow(
                columnIndex: col,
                rowIndex: endRowIndex,
              ),
            );
          }
        }
      }
    }

    return excel.encode();
  }

  String _categoryPath(CategoriaDetails cat) {
    if (cat.categoriaPai != null) {
      return '${_categoryPath(cat.categoriaPai!)} > ${cat.descricao}';
    }
    return cat.descricao;
  }
}
