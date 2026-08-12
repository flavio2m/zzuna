import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/export_lancamentos_excel_usecase.dart';
import 'package:zzuna/data/services/file/file_saver_service.dart';

typedef ExportParams = ({
  List<LancamentoDetails> lancamentos,
  Set<String> lancamentosDesconsiderados,
  Mes mes,
  int ano,
});

class ExportLancamentosViewModel extends ChangeNotifier {
  final ExportLancamentosExcelUseCase _excelUseCase;

  ExportLancamentosViewModel(this._excelUseCase) {
    exportCommand.addListener(notifyListeners);
  }

  late final exportCommand = Command1<String, ExportParams>(_export);

  AsyncResult<String> _export(ExportParams params) async {
    try {
      final bytes = _excelUseCase.execute(
        lancamentos: params.lancamentos,
        lancamentosDesconsiderados: params.lancamentosDesconsiderados,
      );

      if (bytes == null || bytes.isEmpty) {
        return Failure(Exception('Falha ao gerar o arquivo de planilha.'));
      }

      final monthStr = params.mes.numero.toString().padLeft(2, '0');
      final fileName = 'extrato_fatura_${params.ano}_$monthStr.xlsx';

      final savedPath = await FileSaverService.saveAndDownloadFile(
        bytes: bytes,
        fileName: fileName,
      );

      return Success(savedPath);
    } catch (e) {
      return Failure(Exception('Erro ao exportar planilha: $e'));
    }
  }

  @override
  void dispose() {
    exportCommand.removeListener(notifyListeners);
    super.dispose();
  }
}
