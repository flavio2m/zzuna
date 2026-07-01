import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/usecases/lancamento/create_transferencia_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';

class TransferenciaCreateViewModel extends ChangeNotifier {
  final CreateTransferenciaUseCase _useCase;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;

  TransferenciaCreateViewModel(
    this._useCase,
    this._contaRepository,
    this._cartaoRepository,
  );

  List<LancamentoOrigemDetail> origens = [];
  bool isLoading = false;

  late final createCommand = Command1<Unit, CreateTransferenciaDto>(_create);

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

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
    isLoading = false;
    notifyListeners();
  }

  AsyncResult<Unit> _create(CreateTransferenciaDto dto) {
    return _useCase.execute(dto);
  }
}
