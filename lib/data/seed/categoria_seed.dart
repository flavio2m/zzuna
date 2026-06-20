import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';

class CategoriaSeed {
  final CategoriaRepository repository;

  CategoriaSeed(this.repository);

  Future<void> execute() async {
    final result = await repository.getAll();
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    // 1. Categorias raiz
    final alimentacao = (await repository.create(CategoriaDto(descricao: 'Alimentação', ativo: true))).getOrThrow();
    final transporte = (await repository.create(CategoriaDto(descricao: 'Transporte', ativo: true))).getOrThrow();
    final investimentos = (await repository.create(CategoriaDto(descricao: 'Investimentos', ativo: true))).getOrThrow();
    final moradia = (await repository.create(CategoriaDto(descricao: 'Moradia', ativo: true))).getOrThrow();
    final receitas = (await repository.create(CategoriaDto(descricao: 'Receitas', ativo: true))).getOrThrow();
    final saude = (await repository.create(CategoriaDto(descricao: 'Saúde', ativo: true))).getOrThrow();
    final terceiros = (await repository.create(CategoriaDto(descricao: 'Terceiros', ativo: true))).getOrThrow();
    final viagem = (await repository.create(CategoriaDto(descricao: 'Viagem', ativo: true))).getOrThrow();

    // Helper para criar subcategoria
    Future<void> addSub(String descricao, String paiId) async {
      await repository.create(CategoriaDto(descricao: descricao, categoriaPaiId: paiId, ativo: true));
    }

    // 1) Alimentação
    await addSub('Feira', alimentacao.id);
    await addSub('Horta', alimentacao.id);
    await addSub('Lanche', alimentacao.id);
    await addSub('Restaurantes', alimentacao.id);
    await addSub('Supermercado', alimentacao.id);
    await addSub('Outros', alimentacao.id);

    // 2) Transporte
    await addSub('Gadget', transporte.id);
    await addSub('IPVA, Taxas e Docs', transporte.id);
    await addSub('Limpeza', transporte.id);
    await addSub('Manutenção', transporte.id);
    await addSub('Combustível', transporte.id);
    await addSub('Diversos Transportes', transporte.id);

    // 3) Investimentos
    await addSub('Ações', investimentos.id);
    await addSub('Cashback', investimentos.id);
    await addSub('FII', investimentos.id);
    await addSub('Milhas/Pontos', investimentos.id);
    await addSub('Natura', investimentos.id);
    await addSub('Renda Fixa', investimentos.id);
    await addSub('Reservas', investimentos.id);
    await addSub('Diversos Investimentos', investimentos.id);

    // 4) Moradia
    await addSub('Água', moradia.id);
    await addSub('Cama, Mesa e Banho', moradia.id);
    await addSub('Cozinha', moradia.id);
    await addSub('Diversos Moradia', moradia.id);
    await addSub('Financeiras', moradia.id);
    await addSub('Gás', moradia.id);
    await addSub('Internet', moradia.id);
    await addSub('Jardim', moradia.id);
    await addSub('Luz', moradia.id);
    await addSub('Manutenção e Reforma', moradia.id);
    await addSub('Móveis e Decoração', moradia.id);
    await addSub('Telefone e comunicação', moradia.id);
    await addSub('Utensílios', moradia.id);

    // 5) Receitas
    await addSub('Artezanato', receitas.id);
    await addSub('Descontos e outros', receitas.id);
    await addSub('Financeiras', receitas.id);
    await addSub('Salário', receitas.id);
    await addSub('Serviços Prestados', receitas.id);
    await addSub('Diversos Receitas', receitas.id);

    // 6) Saúde
    await addSub('Dentista', saude.id);
    await addSub('Exames', saude.id);
    await addSub('Farmácia', saude.id);
    await addSub('Médico', saude.id);
    await addSub('Oftalmologista', saude.id);
    await addSub('Plano de Saúde', saude.id);
    await addSub('Diversos Saúde', saude.id);

    // 7) Terceiros
    await addSub('Mãe', terceiros.id);
    await addSub('Pai', terceiros.id);
    await addSub('Fulano da Silva', terceiros.id);

    // 8) Viagem
    await addSub('Alimentação Viagem', viagem.id);
    await addSub('Combustível Viagem', viagem.id);
    await addSub('Diversos Viagem', viagem.id);
    await addSub('Hospedagem', viagem.id);
    await addSub('Passagens', viagem.id);
    await addSub('Pedágios', viagem.id);
  }
}
