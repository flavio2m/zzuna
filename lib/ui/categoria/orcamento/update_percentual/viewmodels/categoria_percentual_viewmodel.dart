import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';

class CategoriaPercentualViewModel {
  final CategoriaRepository _categoriaRepository;

  CategoriaPercentualViewModel(this._categoriaRepository);

  late final updatePercentualCommand = Command1(_updatePercentual);

  AsyncResult<Categoria> _updatePercentual(
    ({Categoria categoria, double percentual}) params,
  ) async {
    final dto = CategoriaDto(
      id: params.categoria.id,
      descricao: params.categoria.descricao,
      categoriaPaiId: params.categoria.categoriaPaiId,
      ativo: params.categoria.ativo,
      percentualOrcamento: params.percentual,
      natureza: params.categoria.natureza,
      cor: params.categoria.cor,
    );
    return _categoriaRepository.update(dto);
  }
}
