import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/enums/cartao_comportamento_fechamento.dart';

class CartaoSeed {
  final CartaoRepository repository;

  CartaoSeed(this.repository);

  Future<void> execute() async {
    final result = await repository.getAll();
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    final dtos = [
      CartaoDto(
        descricao: 'CC Visa Infinit',
        limite: 10000.0,
        bancoSigla: 'BB',
        dataInicial: DateTime(DateTime.now().year, 1, 1),
        ativo: true,
        diaFechamento: 10,
        comportamentoFechamento: CartaoComportamentoFechamento.migrarAnteriores,
      ),
    ];

    await repository.createAll(dtos);
  }
}
