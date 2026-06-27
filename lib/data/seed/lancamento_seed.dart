import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class LancamentoSeed {
  final LancamentoRepository repository;
  final ContaRepository contaRepository;
  final CartaoRepository cartaoRepository;
  final CategoriaRepository categoriaRepository;
  final CentroCustoRepository centroCustoRepository;
  final ExtratoFaturaRepository extratoFaturaRepository;

  LancamentoSeed({
    required this.repository,
    required this.contaRepository,
    required this.cartaoRepository,
    required this.categoriaRepository,
    required this.centroCustoRepository,
    required this.extratoFaturaRepository,
  });

  Future<void> execute() async {
    final result = await repository.getAll();
    final list = result.getOrElse((_) => []);
    if (list.isNotEmpty) return;

    final dependencies = await _carregarDependencias();
    if (dependencies == null) return;

    final seeds = <LancamentoDto>[];
    seeds.addAll(_criarLancamentosJunho(dependencies));
    seeds.addAll(_criarLancamentosMaio(dependencies));

    if (seeds.isNotEmpty) {
      await repository.createAll(seeds);
    }
  }

  Future<_SeedDependencies?> _carregarDependencias() async {
    final contas = (await contaRepository.getAll()).getOrElse((_) => []);
    final cartoes = (await cartaoRepository.getAll()).getOrElse((_) => []);
    final centros = (await centroCustoRepository.getAll()).getOrElse((_) => []);
    final categorias = (await categoriaRepository.getAll()).getOrElse((_) => []);
    final extratoFaturas = (await extratoFaturaRepository.getAll()).getOrElse((_) => []);

    if (contas.isEmpty || cartoes.isEmpty || centros.isEmpty || categorias.isEmpty || extratoFaturas.isEmpty) {
      return null;
    }

    final firstConta = contas.first;
    final secondConta = contas.length > 1 ? contas[1] : firstConta;
    final firstCartao = cartoes.first;

    ExtratoFatura getExtratoFatura(LancamentoOrigem origem, Mes mes) {
      return extratoFaturas.firstWhere(
        (ef) => ef.origem == origem && ef.mes == mes,
        orElse: () => extratoFaturas.firstWhere((ef) => ef.mes == mes),
      );
    }

    final efJun1 = getExtratoFatura(LancamentoOrigem.conta(contaId: firstConta.id), Mes.junho);
    final efJun2 = getExtratoFatura(LancamentoOrigem.conta(contaId: secondConta.id), Mes.junho);
    final efJunCard = getExtratoFatura(LancamentoOrigem.cartao(cartaoId: firstCartao.id), Mes.junho);

    final efMay1 = getExtratoFatura(LancamentoOrigem.conta(contaId: firstConta.id), Mes.maio);
    final efMay2 = getExtratoFatura(LancamentoOrigem.conta(contaId: secondConta.id), Mes.maio);
    final efMayCard = getExtratoFatura(LancamentoOrigem.cartao(cartaoId: firstCartao.id), Mes.maio);

    String findCat(String query) {
      final match = categorias.firstWhere(
        (c) => c.descricao.toLowerCase().contains(query.toLowerCase()),
        orElse: () => categorias.first,
      );
      return match.id;
    }

    String findCc(String query) {
      final match = centros.firstWhere(
        (c) => c.descricao.toLowerCase().contains(query.toLowerCase()),
        orElse: () => centros.first,
      );
      return match.id;
    }

    return _SeedDependencies(
      firstConta: firstConta,
      secondConta: secondConta,
      firstCartao: firstCartao,
      efJun1Id: efJun1.id,
      efJun2Id: efJun2.id,
      efJunCardId: efJunCard.id,
      efMay1Id: efMay1.id,
      efMay2Id: efMay2.id,
      efMayCardId: efMayCard.id,
      catReceitas: findCat('Receitas'),
      catViagem: findCat('Viagem'),
      catSupermercado: findCat('Supermercado'),
      catRestaurantes: findCat('Restaurantes'),
      catCombustivel: findCat('Combustível'),
      catSaude: findCat('Saúde'),
      catMoradia: findCat('Moradia'),
      ccPessoaA: findCc('Pessoa A'),
      ccPessoaB: findCc('Pessoa B'),
      ccMoradia: findCc('Moradia'),
      ccSaude: findCc('Saúde'),
      ccLazer: findCc('Lazer'),
      ccViagens: findCc('Viagens'),
    );
  }

  List<LancamentoDto> _criarLancamentosJunho(_SeedDependencies dep) {
    return [
      LancamentoDto(
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 6, 1),
        descricao: 'Salário Mensal Zzuna',
        extratoFaturaId: dep.efJun1Id,
        origem: LancamentoOrigem.conta(contaId: dep.firstConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccPessoaA,
            categoriaId: dep.catReceitas,
            valor: 4800.00,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 3),
        descricao: 'Supermercado Carrefour',
        extratoFaturaId: dep.efJunCardId,
        origem: LancamentoOrigem.cartao(cartaoId: dep.firstCartao.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccMoradia,
            categoriaId: dep.catSupermercado,
            valor: 524.15,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 5),
        descricao: 'Restaurante Pizzaria Bella',
        extratoFaturaId: dep.efJunCardId,
        origem: LancamentoOrigem.cartao(cartaoId: dep.firstCartao.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccLazer,
            categoriaId: dep.catRestaurantes,
            valor: 145.20,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 7),
        descricao: 'Posto Petrobras Combustível',
        extratoFaturaId: dep.efJun1Id,
        origem: LancamentoOrigem.conta(contaId: dep.firstConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccMoradia,
            categoriaId: dep.catCombustivel,
            valor: 82.50,
          ),
        ],
        conciliado: false,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 9),
        descricao: 'Drogasil Medicamentos',
        extratoFaturaId: dep.efJunCardId,
        origem: LancamentoOrigem.cartao(cartaoId: dep.firstCartao.id),
        itens: [
          LancamentoItem(numero: 1, centroCustoId: dep.ccSaude, categoriaId: dep.catSaude, valor: 35.90),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 6, 11),
        descricao: 'Venda Computador Usado',
        extratoFaturaId: dep.efJun2Id,
        origem: LancamentoOrigem.conta(contaId: dep.secondConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccPessoaA,
            categoriaId: dep.catReceitas,
            valor: 1250.00,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 13),
        descricao: 'Conta de Energia Enel',
        extratoFaturaId: dep.efJun1Id,
        origem: LancamentoOrigem.conta(contaId: dep.firstConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccPessoaA,
            categoriaId: dep.catMoradia,
            valor: 120.00,
          ),
          LancamentoItem(
            numero: 2,
            centroCustoId: dep.ccPessoaB,
            categoriaId: dep.catMoradia,
            valor: 120.00,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 15),
        descricao: 'Condomínio Edifício Jardim',
        extratoFaturaId: dep.efJun1Id,
        origem: LancamentoOrigem.conta(contaId: dep.firstConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccMoradia,
            categoriaId: dep.catMoradia,
            valor: 650.00,
          ),
        ],
        conciliado: false,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 17),
        descricao: 'Internet Fibra Claro',
        extratoFaturaId: dep.efJunCardId,
        origem: LancamentoOrigem.cartao(cartaoId: dep.firstCartao.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccMoradia,
            categoriaId: dep.catMoradia,
            valor: 99.90,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 6, 19),
        descricao: 'Reembolso Despesas Viagem',
        extratoFaturaId: dep.efJun1Id,
        origem: LancamentoOrigem.conta(contaId: dep.firstConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccViagens,
            categoriaId: dep.catViagem,
            valor: 320.00,
          ),
        ],
        conciliado: true,
      ),
    ];
  }

  List<LancamentoDto> _criarLancamentosMaio(_SeedDependencies dep) {
    return [
      LancamentoDto(
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 5, 1),
        descricao: 'Salário Mensal Zzuna',
        extratoFaturaId: dep.efMay1Id,
        origem: LancamentoOrigem.conta(contaId: dep.firstConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccPessoaA,
            categoriaId: dep.catReceitas,
            valor: 4800.00,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 3),
        descricao: 'Supermercado Pão de Açúcar',
        extratoFaturaId: dep.efMayCardId,
        origem: LancamentoOrigem.cartao(cartaoId: dep.firstCartao.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccMoradia,
            categoriaId: dep.catSupermercado,
            valor: 412.30,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 5),
        descricao: 'Restaurante Sushi Zen',
        extratoFaturaId: dep.efMayCardId,
        origem: LancamentoOrigem.cartao(cartaoId: dep.firstCartao.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccLazer,
            categoriaId: dep.catRestaurantes,
            valor: 189.50,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 8),
        descricao: 'Posto Ipiranga Combustível',
        extratoFaturaId: dep.efMay1Id,
        origem: LancamentoOrigem.conta(contaId: dep.firstConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccMoradia,
            categoriaId: dep.catCombustivel,
            valor: 90.00,
          ),
        ],
        conciliado: false,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 10),
        descricao: 'Pague Menos Medicamentos',
        extratoFaturaId: dep.efMayCardId,
        origem: LancamentoOrigem.cartao(cartaoId: dep.firstCartao.id),
        itens: [
          LancamentoItem(numero: 1, centroCustoId: dep.ccSaude, categoriaId: dep.catSaude, valor: 45.20),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 5, 12),
        descricao: 'Venda Bicicleta Usada',
        extratoFaturaId: dep.efMay2Id,
        origem: LancamentoOrigem.conta(contaId: dep.secondConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccPessoaA,
            categoriaId: dep.catReceitas,
            valor: 800.00,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 15),
        descricao: 'Conta de Energia Enel',
        extratoFaturaId: dep.efMay1Id,
        origem: LancamentoOrigem.conta(contaId: dep.firstConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccPessoaA,
            categoriaId: dep.catMoradia,
            valor: 110.00,
          ),
          LancamentoItem(
            numero: 2,
            centroCustoId: dep.ccPessoaB,
            categoriaId: dep.catMoradia,
            valor: 110.00,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 18),
        descricao: 'Condomínio Edifício Jardim',
        extratoFaturaId: dep.efMay1Id,
        origem: LancamentoOrigem.conta(contaId: dep.firstConta.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccMoradia,
            categoriaId: dep.catMoradia,
            valor: 650.00,
          ),
        ],
        conciliado: false,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 18),
        descricao: 'Internet Fibra Claro',
        extratoFaturaId: dep.efMayCardId,
        origem: LancamentoOrigem.cartao(cartaoId: dep.firstCartao.id),
        itens: [
          LancamentoItem(
            numero: 1,
            centroCustoId: dep.ccMoradia,
            categoriaId: dep.catMoradia,
            valor: 99.90,
          ),
        ],
        conciliado: true,
      ),
      LancamentoDto(
        tipo: LancamentoTipo.receita,
        data: DateTime(2026, 5, 25),
        descricao: 'Reembolso Almoço Comercial',
        extratoFaturaId: dep.efMay1Id,
        origem: LancamentoOrigem.conta(contaId: dep.firstConta.id),
        itens: [
          LancamentoItem(numero: 1, centroCustoId: dep.ccViagens, categoriaId: dep.catViagem, valor: 75.00),
        ],
        conciliado: true,
      ),
    ];
  }
}

class _SeedDependencies {
  final Conta firstConta;
  final Conta secondConta;
  final Cartao firstCartao;

  final String efJun1Id;
  final String efJun2Id;
  final String efJunCardId;

  final String efMay1Id;
  final String efMay2Id;
  final String efMayCardId;

  final String catReceitas;
  final String catViagem;
  final String catSupermercado;
  final String catRestaurantes;
  final String catCombustivel;
  final String catSaude;
  final String catMoradia;

  final String ccPessoaA;
  final String ccPessoaB;
  final String ccMoradia;
  final String ccSaude;
  final String ccLazer;
  final String ccViagens;

  _SeedDependencies({
    required this.firstConta,
    required this.secondConta,
    required this.firstCartao,
    required this.efJun1Id,
    required this.efJun2Id,
    required this.efJunCardId,
    required this.efMay1Id,
    required this.efMay2Id,
    required this.efMayCardId,
    required this.catReceitas,
    required this.catViagem,
    required this.catSupermercado,
    required this.catRestaurantes,
    required this.catCombustivel,
    required this.catSaude,
    required this.catMoradia,
    required this.ccPessoaA,
    required this.ccPessoaB,
    required this.ccMoradia,
    required this.ccSaude,
    required this.ccLazer,
    required this.ccViagens,
  });
}
