import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';

class CartaoSeed {
  final CartaoRepository repository;

  CartaoSeed(this.repository);

  Future<void> execute() async {
    final result = await repository.getAll();
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    final bancos = Bancos.items.take(10).toList();

    final dtos = List.generate(
      bancos.length,
      (i) => CartaoDto(
        descricao: 'Cartão ${bancos[i].descricao}',
        limite: (i + 1) * 1000.0,
        bancoSigla: bancos[i].sigla,
        ativo: i != 9,
        diaFechamento: 5 + i,
      ),
    );

    await repository.createAll(dtos);
  }
}
