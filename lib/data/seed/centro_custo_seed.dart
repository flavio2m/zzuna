import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';

class CentroCustoSeed {
  final CentroCustoRepository repository;

  CentroCustoSeed(this.repository);

  Future<void> execute() async {
    final result = await repository.getAll();
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    final dtos = [
      CentroCustoDto(
        descricao: 'Geral',
        ativo: true,
        padrao: true,
      ),
      CentroCustoDto(
        descricao: 'Chácara',
        ativo: true,
      ),
    ];

    await repository.createAll(dtos);
  }
}
