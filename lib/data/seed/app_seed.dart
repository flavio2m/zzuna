import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/data/seed/cartao_seed.dart';
import 'package:zzuna/data/seed/categoria_seed.dart';
import 'package:zzuna/data/seed/centro_custo_seed.dart';
import 'package:zzuna/data/seed/conta_seed.dart';
import 'package:zzuna/data/seed/extrato_fatura_seed.dart';
import 'package:zzuna/data/seed/lancamento_seed.dart';

class AppSeed {
  final ContaRepository contaRepository;
  final CartaoRepository cartaoRepository;
  final CategoriaRepository categoriaRepository;
  final CentroCustoRepository centroCustoRepository;
  final ExtratoFaturaRepository extratoFaturaRepository;
  final LancamentoRepository lancamentoRepository;

  AppSeed({
    required this.contaRepository,
    required this.cartaoRepository,
    required this.categoriaRepository,
    required this.centroCustoRepository,
    required this.extratoFaturaRepository,
    required this.lancamentoRepository,
  });

  Future<void> execute() async {
    await ContaSeed(contaRepository).execute();
    await CartaoSeed(cartaoRepository).execute();
    await CategoriaSeed(categoriaRepository).execute();
    await CentroCustoSeed(centroCustoRepository).execute();
    await ExtratoFaturaSeed(
      repository: extratoFaturaRepository,
      contaRepository: contaRepository,
      cartaoRepository: cartaoRepository,
    ).execute();
    await LancamentoSeed(
      repository: lancamentoRepository,
      contaRepository: contaRepository,
      cartaoRepository: cartaoRepository,
      categoriaRepository: categoriaRepository,
      centroCustoRepository: centroCustoRepository,
      extratoFaturaRepository: extratoFaturaRepository,
    ).execute();
  }
}
