import 'package:result_dart/result_dart.dart';
import 'banco.dart';
import 'banco_regiao.dart';
import 'bancos_brasil.dart';
import 'bancos_europa.dart';

abstract final class Bancos {
  static const bancoOutros = Banco(
    sigla: 'OUT',
    descricao: 'Outros',
    icon: BancoIcon.outros,
    regiao: RegiaoBanco.geral,
  );

  static final List<Banco> items = [
    ...BancosBrasil.items,
    ...BancosEuropa.items,
    bancoOutros,
  ];

  static Result<Banco> bySigla(String sigla) {
    final banco = items.firstWhere(
      (b) => b.sigla == sigla,
      orElse: () => bancoOutros,
    );

    return Success(banco);
  }

  static List<Banco> byRegiao(RegiaoBanco regiao) {
    return items
        .where((b) => b.regiao == regiao || b.regiao == RegiaoBanco.geral)
        .toList();
  }
}
