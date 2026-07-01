import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';

class ContaSeed {
  final ContaRepository repository;

  ContaSeed(this.repository);

  Future<void> execute() async {
    final result = await repository.getAll();
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    final bancos = Bancos.items.take(10).toList();

    final dtos = List.generate(
      bancos.length,
      (i) => CreateContaDto(
        descricao: 'Conta ${bancos[i].descricao}',
        bancoSigla: bancos[i].sigla,
        ativo: i != 9,
      ),
    );

    await repository.createAll(dtos);
  }
}
