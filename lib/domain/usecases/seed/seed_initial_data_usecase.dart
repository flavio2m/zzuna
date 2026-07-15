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
    // 1. Criar Conta Padrão
    final conta = CreateContaDto(
      descricao: 'Conta Principal',
      bancoSigla: 'OUT',
      ativo: true,
    );
    await _contaRepository.create(conta);

    // 2. Criar Cartão Padrão
    final cartao = CartaoDto(
      descricao: 'Cartão Principal',
      bancoSigla: 'OUT',
      limite: 1000,
      diaFechamento: 1,
      ativo: true,
    );
    await _cartaoRepository.create(cartao);

    // 3. Criar Centro de Custo Padrão
    final centro = CentroCustoDto(
      descricao: 'Moradia',
      ativo: true,
      padrao: true,
    );
    await _centroCustoRepository.create(centro);

    // 4. Criar Categorias Padrão
    const uuid = Uuid();
    final alimentacaoId = uuid.v4();
    final transporteId = uuid.v4();
    final investimentosId = uuid.v4();
    final moradiaId = uuid.v4();
    final receitasId = uuid.v4();
    final saudeId = uuid.v4();
    final terceirosId = uuid.v4();
    final viagemId = uuid.v4();
    final higieneId = uuid.v4();
    final pessoalId = uuid.v4();

    final dtos = <CategoriaDto>[
      CategoriaDto(id: alimentacaoId, descricao: 'Alimentação', ativo: true),
      CategoriaDto(id: transporteId, descricao: 'Transporte', ativo: true),
      CategoriaDto(
        id: investimentosId,
        descricao: 'Investimentos',
        ativo: true,
      ),
      CategoriaDto(id: moradiaId, descricao: 'Moradia', ativo: true),
      CategoriaDto(id: receitasId, descricao: 'Receitas', ativo: true),
      CategoriaDto(id: saudeId, descricao: 'Saúde', ativo: true),
      CategoriaDto(id: terceirosId, descricao: 'Terceiros', ativo: true),
      CategoriaDto(id: viagemId, descricao: 'Viagem', ativo: true),
      CategoriaDto(id: higieneId, descricao: 'Higiene e Beleza', ativo: true),
      CategoriaDto(id: pessoalId, descricao: 'Pessoal', ativo: true),

      // 1) Alimentação
      CategoriaDto(
        descricao: 'Feira',
        categoriaPaiId: alimentacaoId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Horta',
        categoriaPaiId: alimentacaoId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Lanche',
        categoriaPaiId: alimentacaoId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Restaurantes',
        categoriaPaiId: alimentacaoId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Supermercado',
        categoriaPaiId: alimentacaoId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Outros',
        categoriaPaiId: alimentacaoId,
        ativo: true,
      ),

      // 2) Transporte
      CategoriaDto(
        descricao: 'Gadget',
        categoriaPaiId: transporteId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'IPVA, Taxas e Docs',
        categoriaPaiId: transporteId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Limpeza',
        categoriaPaiId: transporteId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Manutenção',
        categoriaPaiId: transporteId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Combustível',
        categoriaPaiId: transporteId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Diversos Transportes',
        categoriaPaiId: transporteId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Pedágio e Estacionamento',
        categoriaPaiId: transporteId,
        ativo: true,
      ),

      // Higiene e Beleza
      CategoriaDto(
        descricao: 'Cabelereiro',
        categoriaPaiId: higieneId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Higiene Pessoal',
        categoriaPaiId: higieneId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Perfumes e Colônias',
        categoriaPaiId: higieneId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Produtos de Limpeza',
        categoriaPaiId: higieneId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Diversos Higiene Pessoal',
        categoriaPaiId: higieneId,
        ativo: true,
      ),

      // Pessoal
      CategoriaDto(descricao: 'Roupas', categoriaPaiId: pessoalId, ativo: true),
      CategoriaDto(
        descricao: 'Calçados',
        categoriaPaiId: pessoalId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Eletrônicos',
        categoriaPaiId: pessoalId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Diversos Pessoal',
        categoriaPaiId: pessoalId,
        ativo: true,
      ),

      // 3) Investimentos
      CategoriaDto(
        descricao: 'Ações',
        categoriaPaiId: investimentosId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Cashback',
        categoriaPaiId: investimentosId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'FII',
        categoriaPaiId: investimentosId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Renda Fixa',
        categoriaPaiId: investimentosId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Reservas',
        categoriaPaiId: investimentosId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Diversos Investimentos',
        categoriaPaiId: investimentosId,
        ativo: true,
      ),

      // 4) Moradia
      CategoriaDto(descricao: 'Água', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(
        descricao: 'Cama, Mesa e Banho',
        categoriaPaiId: moradiaId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Cozinha',
        categoriaPaiId: moradiaId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Diversos Moradia',
        categoriaPaiId: moradiaId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Financeiras',
        categoriaPaiId: moradiaId,
        ativo: true,
      ),
      CategoriaDto(descricao: 'Gás', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(
        descricao: 'Internet',
        categoriaPaiId: moradiaId,
        ativo: true,
      ),
      CategoriaDto(descricao: 'Jardim', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Luz', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(
        descricao: 'Manutenção e Reforma',
        categoriaPaiId: moradiaId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Móveis e Decoração',
        categoriaPaiId: moradiaId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Telefone e comunicação',
        categoriaPaiId: moradiaId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Utensílios',
        categoriaPaiId: moradiaId,
        ativo: true,
      ),

      // 5) Receitas
      CategoriaDto(
        descricao: 'Artezanato',
        categoriaPaiId: receitasId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Descontos e outros',
        categoriaPaiId: receitasId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Financeiras',
        categoriaPaiId: receitasId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Salário',
        categoriaPaiId: receitasId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Serviços Prestados',
        categoriaPaiId: receitasId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Diversos Receitas',
        categoriaPaiId: receitasId,
        ativo: true,
      ),

      // 6) Saúde
      CategoriaDto(descricao: 'Dentista', categoriaPaiId: saudeId, ativo: true),
      CategoriaDto(descricao: 'Exames', categoriaPaiId: saudeId, ativo: true),
      CategoriaDto(descricao: 'Farmácia', categoriaPaiId: saudeId, ativo: true),
      CategoriaDto(descricao: 'Médico', categoriaPaiId: saudeId, ativo: true),
      CategoriaDto(
        descricao: 'Oftalmologista',
        categoriaPaiId: saudeId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Plano de Saúde',
        categoriaPaiId: saudeId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Diversos Saúde',
        categoriaPaiId: saudeId,
        ativo: true,
      ),

      // 7) Terceiros
      CategoriaDto(descricao: 'Mãe', categoriaPaiId: terceirosId, ativo: true),
      CategoriaDto(descricao: 'Pai', categoriaPaiId: terceirosId, ativo: true),
      CategoriaDto(
        descricao: 'Filho',
        categoriaPaiId: terceirosId,
        ativo: true,
      ),

      // 8) Viagem
      CategoriaDto(
        descricao: 'Alimentação',
        categoriaPaiId: viagemId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Combustível',
        categoriaPaiId: viagemId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Diversos Viagem',
        categoriaPaiId: viagemId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Hospedagem',
        categoriaPaiId: viagemId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Passagens',
        categoriaPaiId: viagemId,
        ativo: true,
      ),
      CategoriaDto(
        descricao: 'Pedágios',
        categoriaPaiId: viagemId,
        ativo: true,
      ),
    ];

    await _categoriaRepository.createAll(dtos);

    return const Success(unit);
  }
}
