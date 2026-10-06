import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';

class ContaSeed {
  final ContaRepository repository;

  ContaSeed(this.repository);

  Future<void> execute() async {
    final result = await repository.getAll();
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    final dtos = [
      CreateContaDto(
        descricao: 'BC Banco do Brasil',
        bancoSigla: 'BB',
        dataInicial: DateTime(DateTime.now().year, 1, 1),
        ativo: true,
      ),
      CreateContaDto(
        descricao: 'Minha Carteira',
        bancoSigla: 'OUT',
        dataInicial: DateTime(DateTime.now().year, 1, 1),
        ativo: true,
      ),
    ];

    await repository.createAll(dtos);
  }
}
