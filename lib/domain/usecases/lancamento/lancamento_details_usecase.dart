import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';

class LancamentoDetailsUseCase {
  final LancamentoRepository _lancamentoRepository;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final CategoriaRepository _categoriaRepository;
  final CentroCustoRepository _centroCustoRepository;
  final ExtratoFaturaRepository _extratoFaturaRepository;
  final CategoriaTreeUseCase _treeUseCase;

  LancamentoDetailsUseCase(
    this._lancamentoRepository,
    this._contaRepository,
    this._cartaoRepository,
    this._categoriaRepository,
    this._centroCustoRepository,
    this._extratoFaturaRepository,
    this._treeUseCase,
  );

  Future<List<LancamentoDetails>> execute({
    required Mes mes,
    required int ano,
  }) async {
    final lancamentosResult = await _lancamentoRepository.searchByPeriodo(
      mes: mes,
      ano: ano,
    );
    final lancamentos = lancamentosResult.getOrElse((_) => <Lancamento>[]);

    final contasResult = await _contaRepository.getAll();
    final cartoesResult = await _cartaoRepository.getAll();
    final categoriasResult = await _categoriaRepository.getAll();
    final centrosResult = await _centroCustoRepository.getAll();
    final extratoFaturasResult = await _extratoFaturaRepository.getAll();

    final contas = contasResult.getOrElse((_) => <Conta>[]);
    final cartoes = cartoesResult.getOrElse((_) => <Cartao>[]);
    final categorias = categoriasResult.getOrElse((_) => <Categoria>[]);
    final centros = centrosResult.getOrElse((_) => <CentroCusto>[]);
    final extratoFaturas = extratoFaturasResult.getOrElse(
      (_) => <ExtratoFatura>[],
    );

    final contaDetailsMap = _buildContaDetailsMap(contas);
    final cartaoDetailsMap = _buildCartaoDetailsMap(cartoes);
    final categoryDetailsMap = _buildCategoriaDetailsMap(categorias);
    final centroCustoMap = _buildCentroCustoMap(centros);
    final extratoFaturaDetailsMap = _buildExtratoFaturaDetailsMap(
      extratoFaturas,
      contaDetailsMap,
      cartaoDetailsMap,
    );

    final List<LancamentoDetails> detailsList = [];
    for (final l in lancamentos) {
      final details = _toDetails(
        l,
        contaDetailsMap,
        cartaoDetailsMap,
        centroCustoMap,
        categoryDetailsMap,
        extratoFaturaDetailsMap,
      );
      if (details != null) {
        detailsList.add(details);
      }
    }

    return detailsList;
  }

  Map<String, ContaDetails> _buildContaDetailsMap(List<Conta> contas) {
    final Map<String, ContaDetails> map = {};
    for (final c in contas) {
      final banco = Bancos.bySigla(c.bancoSigla).getOrNull();
      if (banco != null) {
        map[c.id] = ContaDetails(
          id: c.id,
          descricao: c.descricao,
          banco: banco,
          ativo: c.ativo,
          dataInicial: c.dataInicial,
        );
      }
    }
    return map;
  }

  Map<String, CartaoDetails> _buildCartaoDetailsMap(List<Cartao> cartoes) {
    final Map<String, CartaoDetails> map = {};
    for (final c in cartoes) {
      final banco = Bancos.bySigla(c.bancoSigla).getOrNull();
      if (banco != null) {
        map[c.id] = CartaoDetails(
          id: c.id,
          descricao: c.descricao,
          limite: c.limite,
          banco: banco,
          ativo: c.ativo,
          diaFechamento: c.diaFechamento,
          dataInicial: c.dataInicial,
        );
      }
    }
    return map;
  }

  Map<String, CategoriaDetails> _buildCategoriaDetailsMap(
    List<Categoria> categorias,
  ) {
    final tree = _treeUseCase.build(categorias);
    final Map<String, CategoriaDetails> map = {};

    void addCategoryToMap(CategoriaDetails cat) {
      map[cat.id] = cat;
      for (final sub in cat.subcategorias) {
        addCategoryToMap(sub);
      }
    }

    for (final root in tree) {
      addCategoryToMap(root);
    }
    return map;
  }

  Map<String, CentroCusto> _buildCentroCustoMap(List<CentroCusto> centros) {
    return {for (final c in centros) c.id: c};
  }

  Map<String, ExtratoFaturaDetails> _buildExtratoFaturaDetailsMap(
    List<ExtratoFatura> extratoFaturas,
    Map<String, ContaDetails> contaDetailsMap,
    Map<String, CartaoDetails> cartaoDetailsMap,
  ) {
    final Map<String, ExtratoFaturaDetails> map = {};
    for (final ef in extratoFaturas) {
      final origemDetail = switch (ef.origem) {
        LancamentoOrigemConta(contaId: final cid) =>
          contaDetailsMap[cid] != null
              ? LancamentoOrigemDetail.conta(conta: contaDetailsMap[cid]!)
              : null,
        LancamentoOrigemCartao(cartaoId: final cid) =>
          cartaoDetailsMap[cid] != null
              ? LancamentoOrigemDetail.cartao(cartao: cartaoDetailsMap[cid]!)
              : null,
      };

      if (origemDetail != null) {
        map[ef.id] = ExtratoFaturaDetails(
          id: ef.id,
          origem: origemDetail,
          ano: ef.ano,
          mes: ef.mes,
          dataInicio: ef.dataInicio,
          dataFim: ef.dataFim,
          saldoInicial: ef.saldoInicial,
          saldoFinal: ef.saldoFinal,
          fechado: ef.fechado,
        );
      }
    }
    return map;
  }

  List<LancamentoItemDetails> _buildItemDetails(
    List<LancamentoItem> items,
    Map<String, CentroCusto> centroCustoMap,
    Map<String, CategoriaDetails> categoryDetailsMap,
    Map<String, ContaDetails> contaDetailsMap,
    Map<String, CartaoDetails> cartaoDetailsMap,
  ) {
    final List<LancamentoItemDetails> itemDetails = [];
    for (final item in items) {
      item.map(
        (standard) {
          final cc = centroCustoMap[standard.centroCustoId];
          final cat = categoryDetailsMap[standard.categoriaId];
          if (cc != null && cat != null) {
            itemDetails.add(
              LancamentoItemDetails(
                numero: standard.numero,
                centroCusto: CentroCustoDetails(
                  id: cc.id,
                  descricao: cc.descricao,
                  ativo: cc.ativo,
                ),
                categoria: cat,
                valor: standard.valor,
              ),
            );
          }
        },
        transferencia: (t) {
          final detailSaida = _buildOrigem(
            t.origemSaida,
            contaDetailsMap,
            cartaoDetailsMap,
          );
          final detailEntrada = _buildOrigem(
            t.origemEntrada,
            contaDetailsMap,
            cartaoDetailsMap,
          );
          if (detailSaida != null && detailEntrada != null) {
            itemDetails.add(
              LancamentoItemDetails.transferencia(
                numero: t.numero,
                origemSaida: detailSaida,
                origemEntrada: detailEntrada,
                valor: t.valor,
              ),
            );
          }
        },
      );
    }
    return itemDetails;
  }

  LancamentoOrigemDetail? _buildOrigem(
    LancamentoOrigem origem,
    Map<String, ContaDetails> contaDetailsMap,
    Map<String, CartaoDetails> cartaoDetailsMap,
  ) {
    return switch (origem) {
      LancamentoOrigemConta(contaId: final contaId) =>
        contaDetailsMap[contaId] != null
            ? LancamentoOrigemDetail.conta(conta: contaDetailsMap[contaId]!)
            : null,
      LancamentoOrigemCartao(cartaoId: final cartaoId) =>
        cartaoDetailsMap[cartaoId] != null
            ? LancamentoOrigemDetail.cartao(cartao: cartaoDetailsMap[cartaoId]!)
            : null,
    };
  }

  LancamentoDetails? _toDetails(
    Lancamento l,
    Map<String, ContaDetails> contaDetailsMap,
    Map<String, CartaoDetails> cartaoDetailsMap,
    Map<String, CentroCusto> centroCustoMap,
    Map<String, CategoriaDetails> categoryDetailsMap,
    Map<String, ExtratoFaturaDetails> extratoFaturaDetailsMap,
  ) {
    final itemDetails = _buildItemDetails(
      l.itens,
      centroCustoMap,
      categoryDetailsMap,
      contaDetailsMap,
      cartaoDetailsMap,
    );

    final extratoFaturaDetail = extratoFaturaDetailsMap[l.extratoFaturaId];

    final origemDetail = _buildOrigem(
      l.origem,
      contaDetailsMap,
      cartaoDetailsMap,
    );

    if (extratoFaturaDetail == null || origemDetail == null) return null;

    return LancamentoDetails(
      id: l.id,
      tipo: l.tipo,
      data: l.data,
      descricao: l.descricao,
      extratoFatura: extratoFaturaDetail,
      origem: origemDetail,
      itens: itemDetails,
      conciliado: l.conciliado,
      grupo: l.grupo,
      observacao: l.observacao,
    );
  }
}
