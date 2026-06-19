import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_repository.dart';
import 'package:zzuna/data/repositories/lancamento/fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_entity.dart';
import 'package:zzuna/domain/entities/lancamento/fatura_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_item_entity.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_tree_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_referencia.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_referencia_detail.dart';

class LancamentoDetailsUseCase {
  final LancamentoRepository _lancamentoRepository;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final CategoriaRepository _categoriaRepository;
  final CentroCustoRepository _centroCustoRepository;
  final FaturaRepository _faturaRepository;
  final ExtratoRepository _extratoRepository;
  final CategoriaTreeUseCase _treeUseCase;

  LancamentoDetailsUseCase(
    this._lancamentoRepository,
    this._contaRepository,
    this._cartaoRepository,
    this._categoriaRepository,
    this._centroCustoRepository,
    this._faturaRepository,
    this._extratoRepository,
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
    final faturasResult = await _faturaRepository.getAll();
    final extratosResult = await _extratoRepository.getAll();

    final contas = contasResult.getOrElse((_) => <Conta>[]);
    final cartoes = cartoesResult.getOrElse((_) => <Cartao>[]);
    final categorias = categoriasResult.getOrElse((_) => <Categoria>[]);
    final centros = centrosResult.getOrElse((_) => <CentroCusto>[]);
    final faturas = faturasResult.getOrElse((_) => <Fatura>[]);
    final extratos = extratosResult.getOrElse((_) => <Extrato>[]);

    final contaDetailsMap = _buildContaDetailsMap(contas);
    final cartaoDetailsMap = _buildCartaoDetailsMap(cartoes);
    final categoryDetailsMap = _buildCategoriaDetailsMap(categorias);
    final centroCustoMap = _buildCentroCustoMap(centros);
    final faturaDetailsMap = _buildFaturaDetailsMap(faturas, cartaoDetailsMap);
    final extratoDetailsMap = _buildExtratoDetailsMap(
      extratos,
      contaDetailsMap,
    );

    final List<LancamentoDetails> detailsList = [];
    for (final l in lancamentos) {
      final details = _toDetails(
        l,
        contaDetailsMap,
        cartaoDetailsMap,
        centroCustoMap,
        categoryDetailsMap,
        faturaDetailsMap,
        extratoDetailsMap,
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

  Map<String, FaturaDetails> _buildFaturaDetailsMap(
    List<Fatura> faturas,
    Map<String, CartaoDetails> cartaoDetailsMap,
  ) {
    final Map<String, FaturaDetails> map = {};
    for (final f in faturas) {
      final cartao = cartaoDetailsMap[f.cartaoId];
      if (cartao != null) {
        map[f.id] = FaturaDetails(
          id: f.id,
          cartao: cartao,
          ano: f.ano,
          mes: f.mes,
          dataInicio: f.dataInicio,
          dataFim: f.dataFim,
          fechada: f.fechada,
        );
      }
    }
    return map;
  }

  Map<String, ExtratoDetails> _buildExtratoDetailsMap(
    List<Extrato> extratos,
    Map<String, ContaDetails> contaDetailsMap,
  ) {
    final Map<String, ExtratoDetails> map = {};
    for (final e in extratos) {
      final conta = contaDetailsMap[e.contaId];
      if (conta != null) {
        map[e.id] = ExtratoDetails(
          id: e.id,
          conta: conta,
          ano: e.ano,
          mes: e.mes,
          dataInicio: e.dataInicio,
          dataFim: e.dataFim,
          fechado: e.fechado,
        );
      }
    }
    return map;
  }

  List<LancamentoItemDetails> _buildItemDetails(
    List<LancamentoItem> items,
    Map<String, CentroCusto> centroCustoMap,
    Map<String, CategoriaDetails> categoryDetailsMap,
  ) {
    final List<LancamentoItemDetails> itemDetails = [];
    for (final item in items) {
      final cc = centroCustoMap[item.centroCustoId];
      final cat = categoryDetailsMap[item.categoriaId];
      if (cc != null && cat != null) {
        itemDetails.add(LancamentoItemDetails(
          id: item.id,
          centroCusto: CentroCustoDetails(
            id: cc.id,
            descricao: cc.descricao,
            ativo: cc.ativo,
          ),
          categoria: cat,
          valor: item.valor,
        ));
      }
    }
    return itemDetails;
  }

  LancamentoReferenciaDetail? _buildReferencia(
    LancamentoReferencia ref,
    Map<String, FaturaDetails> faturaDetailsMap,
    Map<String, ExtratoDetails> extratoDetailsMap,
  ) {
    return switch (ref) {
      ReferenciaFaturaLancamento(faturaId: final faturaId) =>
        faturaDetailsMap[faturaId] != null
            ? LancamentoReferenciaDetail.fatura(
                fatura: faturaDetailsMap[faturaId]!,
              )
            : null,
      ReferenciaExtratoLancamento(extratoId: final extratoId) =>
        extratoDetailsMap[extratoId] != null
            ? LancamentoReferenciaDetail.extrato(
                extrato: extratoDetailsMap[extratoId]!,
              )
            : null,
    };
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
            ? LancamentoOrigemDetail.cartao(
                cartao: cartaoDetailsMap[cartaoId]!,
              )
            : null,
    };
  }

  LancamentoDetails? _toDetails(
    Lancamento l,
    Map<String, ContaDetails> contaDetailsMap,
    Map<String, CartaoDetails> cartaoDetailsMap,
    Map<String, CentroCusto> centroCustoMap,
    Map<String, CategoriaDetails> categoryDetailsMap,
    Map<String, FaturaDetails> faturaDetailsMap,
    Map<String, ExtratoDetails> extratoDetailsMap,
  ) {
    final itemDetails = _buildItemDetails(
      l.itens,
      centroCustoMap,
      categoryDetailsMap,
    );

    final refDetail = _buildReferencia(
      l.referencia,
      faturaDetailsMap,
      extratoDetailsMap,
    );

    final origemDetail = _buildOrigem(
      l.origem,
      contaDetailsMap,
      cartaoDetailsMap,
    );

    if (refDetail == null || origemDetail == null) return null;

    return LancamentoDetails(
      id: l.id,
      tipo: l.tipo,
      data: l.data,
      descricao: l.descricao,
      referencia: refDetail,
      origem: origemDetail,
      itens: itemDetails,
      conciliado: l.conciliado,
      observacao: l.observacao,
    );
  }
}
