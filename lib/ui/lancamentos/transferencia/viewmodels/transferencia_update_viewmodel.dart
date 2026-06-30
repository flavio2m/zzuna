import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/usecases/lancamento/update_transferencia_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';

class TransferenciaUpdateViewModel extends ChangeNotifier {
  final UpdateTransferenciaUseCase _useCase;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;
  final LancamentoRepository _lancamentoRepository;
  final String grupoId;

  TransferenciaUpdateViewModel(
    this._useCase,
    this._contaRepository,
    this._cartaoRepository,
    this._lancamentoRepository,
    this.grupoId,
  );

  List<LancamentoOrigemDetail> origens = [];
  bool isLoading = false;

  DateTime? data;
  String? descricao;
  double? valor;
  LancamentoOrigem? origemSaida;
  LancamentoOrigem? origemEntrada;
  String? observacao;

  late final updateCommand = Command1<Unit, CreateTransferenciaDto>(_update);

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    // 1. Carregar as origens ativas
    final contasResult = await _contaRepository.getAll();
    final cartoesResult = await _cartaoRepository.getAll();

    final novasOrigens = <LancamentoOrigemDetail>[];

    final contas = contasResult.getOrElse((_) => <Conta>[]);
    for (final conta in contas) {
      if (!conta.ativo) continue;
      final banco = Bancos.bySigla(conta.bancoSigla).getOrNull();
      if (banco == null) continue;
      novasOrigens.add(
        LancamentoOrigemDetail.conta(
          conta: ContaDetails(
            id: conta.id,
            descricao: conta.descricao,
            banco: banco,
            ativo: conta.ativo,
            dataInicial: conta.dataInicial,
          ),
        ),
      );
    }

    final cartoes = cartoesResult.getOrElse((_) => <Cartao>[]);
    for (final cartao in cartoes) {
      if (!cartao.ativo) continue;
      final banco = Bancos.bySigla(cartao.bancoSigla).getOrNull();
      if (banco == null) continue;
      novasOrigens.add(
        LancamentoOrigemDetail.cartao(
          cartao: CartaoDetails(
            id: cartao.id,
            descricao: cartao.descricao,
            limite: cartao.limite,
            banco: banco,
            ativo: cartao.ativo,
            diaFechamento: cartao.diaFechamento,
            dataInicial: cartao.dataInicial,
          ),
        ),
      );
    }

    origens = novasOrigens;

    // 2. Carregar os dois lançamentos da transferência
    final allResult = await _lancamentoRepository.getAll();
    final all = allResult.getOrElse((_) => []);
    final groupLaunches = all
        .where((item) => item.grupo?.grupoId == grupoId)
        .toList();

    if (groupLaunches.length == 2) {
      final first = groupLaunches[0];

      final firstItem = first.itens.isNotEmpty ? first.itens.first : null;
      if (firstItem != null) {
        switch (firstItem) {
          case LancamentoItemTransferencia(
            :final origemSaida,
            :final origemEntrada,
            :final valor,
          ):
            this.origemSaida = origemSaida;
            this.origemEntrada = origemEntrada;
            this.valor = valor;
          default:
            break;
        }
      }

      data = first.data;
      descricao = first.descricao;
      observacao = first.observacao;
    }

    isLoading = false;
    notifyListeners();
  }

  AsyncResult<Unit> _update(CreateTransferenciaDto dto) {
    return _useCase.execute(grupoId, dto);
  }
}
