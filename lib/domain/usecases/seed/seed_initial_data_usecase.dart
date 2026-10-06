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
        descricao: 'Supermercado',
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
      CategoriaDto(descricao: 'Saúde', categoriaPaiId: confortoId, ativo: true),
      CategoriaDto(
        descricao: 'Cuidados Pessoais',
        categoriaPaiId: confortoId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Manutenção e Reforma',
        categoriaPaiId: confortoId,
        ativo: true,
      ),

      // 4) Metas (3 filhas)
      CategoriaDto(descricao: 'Viagem', categoriaPaiId: metasId, ativo: true),
      CategoriaDto(
        descricao: 'Reserva de Emergência',
        categoriaPaiId: metasId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Eletrônicos e Bens',
        categoriaPaiId: metasId,
        ativo: true,
      ),

      // 5) Prazeres (3 filhas)
      CategoriaDto(
        descricao: 'Restaurantes',
        categoriaPaiId: prazeresId,
        ativo: true,
      ),
      CategoriaDto(descricao: 'Lazer', categoriaPaiId: prazeresId, ativo: true),
      CategoriaDto(
        descricao: 'Lanches',
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

    await _categoriaRepository.createAll(dtos);

    return const Success(unit);
  }
}
