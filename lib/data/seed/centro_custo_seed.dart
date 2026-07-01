import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';

class CentroCustoSeed {
  final CentroCustoRepository repository;

  CentroCustoSeed(this.repository);

  Future<void> execute() async {
    final result = await repository.getAll();
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    const descricoes = [
      'Moradia',
      'Viagens',
      'Lazer',
      'Educação',
      'Saúde',
      'Pessoa A',
      'Pessoa B',
      'Pessoa C',
      'Jurídico',
      'Terceiros',
    ];

    final dtos = List.generate(
      descricoes.length,
      (i) => CentroCustoDto(
        descricao: descricoes[i],
        ativo: i != 9,
      ),
    );

    await repository.createAll(dtos);
  }
}
