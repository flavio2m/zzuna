import 'package:uuid/uuid.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/enums/cartao_comportamento_fechamento.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';

class SeedInitialDataUseCase {
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final CentroCustoRepository _centroCustoRepository;
  final CategoriaRepository _categoriaRepository;

  SeedInitialDataUseCase(
    this._contaRepository,
    this._cartaoRepository,
    this._centroCustoRepository,
    this._categoriaRepository,
  );

  AsyncResult<Unit> execute() async {
    // 1. Criar Contas Padrão
    final contaBB = CreateContaDto(
      descricao: 'BC Banco do Brasil',
      bancoSigla: 'BB',
      dataInicial: DateTime(DateTime.now().year, 1, 1),
      ativo: true,
    );
    await _contaRepository.create(contaBB);

    final carteira = CreateContaDto(
      descricao: 'Minha Carteira',
      bancoSigla: 'OUT',
      dataInicial: DateTime(DateTime.now().year, 1, 1),
      ativo: true,
    );
    await _contaRepository.create(carteira);

    // 2. Criar Cartão Padrão
    final cartao = CartaoDto(
      descricao: 'CC Visa Infinit',
      bancoSigla: 'BB',
      limite: 10000.0,
      diaFechamento: 10,
      dataInicial: DateTime(DateTime.now().year, 1, 1),
      ativo: true,
      comportamentoFechamento: CartaoComportamentoFechamento.migrarAnteriores,
    );
    await _cartaoRepository.create(cartao);

    // 3. Criar Centros de Custo Padrão
    final centroGeral = CentroCustoDto(
      descricao: 'Geral',
      ativo: true,
      padrao: true,
    );
    await _centroCustoRepository.create(centroGeral);

    final centroChacara = CentroCustoDto(descricao: 'Chácara', ativo: true);
    await _centroCustoRepository.create(centroChacara);

    // 4. Criar Categorias Padrão
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
      ),
      CategoriaDto(
        id: liberdadeFinanceiraId,
        descricao: 'Liberdade Financeira',
        ativo: true,
        percentualOrcamento: 25,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        id: confortoId,
        descricao: 'Conforto',
        ativo: true,
        percentualOrcamento: 15,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        id: metasId,
        descricao: 'Metas',
        ativo: true,
        percentualOrcamento: 15,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        id: prazeresId,
        descricao: 'Prazeres',
        ativo: true,
        percentualOrcamento: 10,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        id: conhecimentoId,
        descricao: 'Conhecimento',
        ativo: true,
        percentualOrcamento: 5,
        natureza: CategoriaNatureza.saida,
      ),
      CategoriaDto(
        id: receitasId,
        descricao: 'Receitas',
        ativo: true,
        percentualOrcamento: null,
        natureza: CategoriaNatureza.entrada,
      ),
      CategoriaDto(
        id: terceirosId,
        descricao: 'Terceiros',
        ativo: true,
        percentualOrcamento: null,
        natureza: CategoriaNatureza.saida,
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

    await _categoriaRepository.createAll(dtos);

    return const Success(unit);
  }
}
