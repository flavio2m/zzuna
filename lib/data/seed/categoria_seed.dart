import 'package:uuid/uuid.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';

class CategoriaSeed {
  final CategoriaRepository repository;

  CategoriaSeed(this.repository);

  Future<void> execute() async {
    final result = await repository.getAll();
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    const uuid = Uuid();
    final custosFixosId = uuid.v4();
    final liberdadeFinanceiraId = uuid.v4();
    final confortoId = uuid.v4();
    final metasId = uuid.v4();
    final prazeresId = uuid.v4();
    final conhecimentoId = uuid.v4();
    final receitasId = uuid.v4();

    final dtos = <CategoriaDto>[
      // Categorias Pai
      CategoriaDto(id: custosFixosId, descricao: 'Custos Fixos', ativo: true),
      CategoriaDto(
        id: liberdadeFinanceiraId,
        descricao: 'Liberdade Financeira',
        ativo: true,
      ),
      CategoriaDto(id: confortoId, descricao: 'Conforto', ativo: true),
      CategoriaDto(id: metasId, descricao: 'Metas', ativo: true),
      CategoriaDto(id: prazeresId, descricao: 'Prazeres', ativo: true),
      CategoriaDto(id: conhecimentoId, descricao: 'Conhecimento', ativo: true),
      CategoriaDto(id: receitasId, descricao: 'Receitas', ativo: true),

      // 1) Custos Fixos (3 filhas)
      CategoriaDto(
        descricao: 'Moradia',
        categoriaPaiId: custosFixosId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Alimentação',
        categoriaPaiId: custosFixosId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Plano de Saúde',
        categoriaPaiId: custosFixosId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Transporte',
        categoriaPaiId: custosFixosId,
        ativo: true,
      ),

      // 2) Liberdade Financeira (3 filhas)
      CategoriaDto(
        descricao: 'Renda Fixa',
        categoriaPaiId: liberdadeFinanceiraId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Ações',
        categoriaPaiId: liberdadeFinanceiraId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'FII',
        categoriaPaiId: liberdadeFinanceiraId,
        ativo: true,
      ),

      // 3) Conforto (3 filhas)
      CategoriaDto(
        descricao: 'Cuidados Pessoais',
        categoriaPaiId: confortoId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Restaurantes',
        categoriaPaiId: confortoId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Roupas e Acessórios',
        categoriaPaiId: confortoId,
        ativo: true,
      ),

      // 4) Metas (3 filhas)
      CategoriaDto(descricao: 'Viagem', categoriaPaiId: metasId, ativo: true),
      CategoriaDto(
        descricao: 'Comprar/Trocar Carro',
        categoriaPaiId: metasId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Casa Reforma/Melhoria',
        categoriaPaiId: metasId,
        ativo: true,
      ),

      // 5) Prazeres (3 filhas)
      CategoriaDto(
        descricao: 'Churrasco/Festas',
        categoriaPaiId: prazeresId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Lanches',
        categoriaPaiId: prazeresId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Livros e Cursos',
        categoriaPaiId: prazeresId,
        ativo: true,
      ),

      // 6) Conhecimento (3 filhas)
      CategoriaDto(
        descricao: 'Cursos',
        categoriaPaiId: conhecimentoId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Livros',
        categoriaPaiId: conhecimentoId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Treinamentos',
        categoriaPaiId: conhecimentoId,
        ativo: true,
      ),

      // 7) Receitas (3 filhas)
      CategoriaDto(
        descricao: 'Salário',
        categoriaPaiId: receitasId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Rendimentos',
        categoriaPaiId: receitasId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Outras Receitas',
        categoriaPaiId: receitasId,
        ativo: true,
      ),
    ];

    await repository.createAll(dtos);
  }
}
