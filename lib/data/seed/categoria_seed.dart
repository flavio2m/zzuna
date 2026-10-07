import 'package:uuid/uuid.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/statics/categoria/categoria_cores.dart';

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
    final terceirosId = uuid.v4();

    final dtos = <CategoriaDto>[
      // Categorias Pai
      CategoriaDto(
        id: custosFixosId,
        descricao: 'Custos Fixos',
        ativo: true,
        percentualOrcamento: 30,
        natureza: CategoriaNatureza.saida,
        cor: CategoriaCores.azulCustosFixos,
      ),
      CategoriaDto(
        id: liberdadeFinanceiraId,
        descricao: 'Liberdade Financeira',
        ativo: true,
        percentualOrcamento: 25,
        natureza: CategoriaNatureza.saida,
        cor: CategoriaCores.roxoSolar,
      ),
      CategoriaDto(
        id: confortoId,
        descricao: 'Conforto',
        ativo: true,
        percentualOrcamento: 15,
        natureza: CategoriaNatureza.saida,
        cor: CategoriaCores.rosaConforto,
      ),
      CategoriaDto(
        id: metasId,
        descricao: 'Metas',
        ativo: true,
        percentualOrcamento: 15,
        natureza: CategoriaNatureza.saida,
        cor: CategoriaCores.purpuraMetas,
      ),
      CategoriaDto(
        id: prazeresId,
        descricao: 'Prazeres',
        ativo: true,
        percentualOrcamento: 10,
        natureza: CategoriaNatureza.saida,
        cor: CategoriaCores.laranjaPrazeres,
      ),
      CategoriaDto(
        id: conhecimentoId,
        descricao: 'Conhecimento',
        ativo: true,
        percentualOrcamento: 5,
        natureza: CategoriaNatureza.saida,
        cor: CategoriaCores.amareloConhecimento,
      ),
      CategoriaDto(
        id: receitasId,
        descricao: 'Receitas',
        ativo: true,
        percentualOrcamento: null,
        natureza: CategoriaNatureza.entrada,
        cor: CategoriaCores.esmeraldaReceitas,
      ),
      CategoriaDto(
        id: terceirosId,
        descricao: 'Terceiros',
        ativo: true,
        percentualOrcamento: null,
        natureza: CategoriaNatureza.saida,
        cor: CategoriaCores.cinzaTerceiros,
      ),

      // 1) Custos Fixos (3 filhas)
      CategoriaDto(
        descricao: 'Moradia',
        categoriaPaiId: custosFixosId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Supermercado',
        categoriaPaiId: custosFixosId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Transporte',
        categoriaPaiId: custosFixosId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),

      // 2) Liberdade Financeira (3 filhas)
      CategoriaDto(
        descricao: 'Renda Fixa',
        categoriaPaiId: liberdadeFinanceiraId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Ações',
        categoriaPaiId: liberdadeFinanceiraId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'FII',
        categoriaPaiId: liberdadeFinanceiraId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),

      // 3) Conforto (3 filhas)
      CategoriaDto(
        descricao: 'Saúde',
        categoriaPaiId: confortoId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Cuidados Pessoais',
        categoriaPaiId: confortoId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Manutenção e Reforma',
        categoriaPaiId: confortoId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),

      // 4) Metas (3 filhas)
      CategoriaDto(
        descricao: 'Viagem',
        categoriaPaiId: metasId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Reserva de Emergência',
        categoriaPaiId: metasId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Eletrônicos e Bens',
        categoriaPaiId: metasId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),

      // 5) Prazeres (3 filhas)
      CategoriaDto(
        descricao: 'Restaurantes',
        categoriaPaiId: prazeresId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Lazer',
        categoriaPaiId: prazeresId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Lanches',
        categoriaPaiId: prazeresId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),

      // 6) Conhecimento (3 filhas)
      CategoriaDto(
        descricao: 'Cursos',
        categoriaPaiId: conhecimentoId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Livros',
        categoriaPaiId: conhecimentoId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        descricao: 'Treinamentos',
        categoriaPaiId: conhecimentoId,
        ativo: true,
        natureza: CategoriaNatureza.saida,
      ),

      // 7) Receitas (3 filhas)
      CategoriaDto(
        descricao: 'Salário',
        categoriaPaiId: receitasId,
        ativo: true,
        natureza: CategoriaNatureza.entrada,
      ),
      CategoriaDto(
        descricao: 'Rendimentos',
        categoriaPaiId: receitasId,
        ativo: true,
        natureza: CategoriaNatureza.entrada,
      ),
      CategoriaDto(
        descricao: 'Outras Receitas',
        categoriaPaiId: receitasId,
        ativo: true,
        natureza: CategoriaNatureza.entrada,
      ),
    ];

    await repository.createAll(dtos);
  }
}
