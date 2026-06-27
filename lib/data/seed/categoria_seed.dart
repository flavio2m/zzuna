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
    final alimentacaoId = uuid.v4();
    final transporteId = uuid.v4();
    final investimentosId = uuid.v4();
    final moradiaId = uuid.v4();
    final receitasId = uuid.v4();
    final saudeId = uuid.v4();
    final terceirosId = uuid.v4();
    final viagemId = uuid.v4();

    final dtos = <CategoriaDto>[
      CategoriaDto(id: alimentacaoId, descricao: 'Alimentação', ativo: true),
      CategoriaDto(id: transporteId, descricao: 'Transporte', ativo: true),
      CategoriaDto(id: investimentosId, descricao: 'Investimentos', ativo: true),
      CategoriaDto(id: moradiaId, descricao: 'Moradia', ativo: true),
      CategoriaDto(id: receitasId, descricao: 'Receitas', ativo: true),
      CategoriaDto(id: saudeId, descricao: 'Saúde', ativo: true),
      CategoriaDto(id: terceirosId, descricao: 'Terceiros', ativo: true),
      CategoriaDto(id: viagemId, descricao: 'Viagem', ativo: true),

      // 1) Alimentação
      CategoriaDto(descricao: 'Feira', categoriaPaiId: alimentacaoId, ativo: true),
      CategoriaDto(descricao: 'Horta', categoriaPaiId: alimentacaoId, ativo: true),
      CategoriaDto(descricao: 'Lanche', categoriaPaiId: alimentacaoId, ativo: true),
      CategoriaDto(descricao: 'Restaurantes', categoriaPaiId: alimentacaoId, ativo: true),
      CategoriaDto(descricao: 'Supermercado', categoriaPaiId: alimentacaoId, ativo: true),
      CategoriaDto(descricao: 'Outros', categoriaPaiId: alimentacaoId, ativo: true),

      // 2) Transporte
      CategoriaDto(descricao: 'Gadget', categoriaPaiId: transporteId, ativo: true),
      CategoriaDto(descricao: 'IPVA, Taxas e Docs', categoriaPaiId: transporteId, ativo: true),
      CategoriaDto(descricao: 'Limpeza', categoriaPaiId: transporteId, ativo: true),
      CategoriaDto(descricao: 'Manutenção', categoriaPaiId: transporteId, ativo: true),
      CategoriaDto(descricao: 'Combustível', categoriaPaiId: transporteId, ativo: true),
      CategoriaDto(descricao: 'Diversos Transportes', categoriaPaiId: transporteId, ativo: true),

      // 3) Investimentos
      CategoriaDto(descricao: 'Ações', categoriaPaiId: investimentosId, ativo: true),
      CategoriaDto(descricao: 'Cashback', categoriaPaiId: investimentosId, ativo: true),
      CategoriaDto(descricao: 'FII', categoriaPaiId: investimentosId, ativo: true),
      CategoriaDto(descricao: 'Milhas/Pontos', categoriaPaiId: investimentosId, ativo: true),
      CategoriaDto(descricao: 'Natura', categoriaPaiId: investimentosId, ativo: true),
      CategoriaDto(descricao: 'Renda Fixa', categoriaPaiId: investimentosId, ativo: true),
      CategoriaDto(descricao: 'Reservas', categoriaPaiId: investimentosId, ativo: true),
      CategoriaDto(descricao: 'Diversos Investimentos', categoriaPaiId: investimentosId, ativo: true),

      // 4) Moradia
      CategoriaDto(descricao: 'Água', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Cama, Mesa e Banho', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Cozinha', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Diversos Moradia', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Financeiras', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Gás', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Internet', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Jardim', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Luz', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Manutenção e Reforma', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Móveis e Decoração', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Telefone e comunicação', categoriaPaiId: moradiaId, ativo: true),
      CategoriaDto(descricao: 'Utensílios', categoriaPaiId: moradiaId, ativo: true),

      // 5) Receitas
      CategoriaDto(descricao: 'Artezanato', categoriaPaiId: receitasId, ativo: true),
      CategoriaDto(descricao: 'Descontos e outros', categoriaPaiId: receitasId, ativo: true),
      CategoriaDto(descricao: 'Financeiras', categoriaPaiId: receitasId, ativo: true),
      CategoriaDto(descricao: 'Salário', categoriaPaiId: receitasId, ativo: true),
      CategoriaDto(descricao: 'Serviços Prestados', categoriaPaiId: receitasId, ativo: true),
      CategoriaDto(descricao: 'Diversos Receitas', categoriaPaiId: receitasId, ativo: true),

      // 6) Saúde
      CategoriaDto(descricao: 'Dentista', categoriaPaiId: saudeId, ativo: true),
      CategoriaDto(descricao: 'Exames', categoriaPaiId: saudeId, ativo: true),
      CategoriaDto(descricao: 'Farmácia', categoriaPaiId: saudeId, ativo: true),
      CategoriaDto(descricao: 'Médico', categoriaPaiId: saudeId, ativo: true),
      CategoriaDto(descricao: 'Oftalmologista', categoriaPaiId: saudeId, ativo: true),
      CategoriaDto(descricao: 'Plano de Saúde', categoriaPaiId: saudeId, ativo: true),
      CategoriaDto(descricao: 'Diversos Saúde', categoriaPaiId: saudeId, ativo: true),

      // 7) Terceiros
      CategoriaDto(descricao: 'Mãe', categoriaPaiId: terceirosId, ativo: true),
      CategoriaDto(descricao: 'Pai', categoriaPaiId: terceirosId, ativo: true),
      CategoriaDto(descricao: 'Fulano da Silva', categoriaPaiId: terceirosId, ativo: true),

      // 8) Viagem
      CategoriaDto(descricao: 'Alimentação Viagem', categoriaPaiId: viagemId, ativo: true),
      CategoriaDto(descricao: 'Combustível Viagem', categoriaPaiId: viagemId, ativo: true),
      CategoriaDto(descricao: 'Diversos Viagem', categoriaPaiId: viagemId, ativo: true),
      CategoriaDto(descricao: 'Hospedagem', categoriaPaiId: viagemId, ativo: true),
      CategoriaDto(descricao: 'Passagens', categoriaPaiId: viagemId, ativo: true),
      CategoriaDto(descricao: 'Pedágios', categoriaPaiId: viagemId, ativo: true),
    ];

    await repository.createAll(dtos);
  }
}
