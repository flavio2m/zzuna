import 'banco.dart';
import 'banco_regiao.dart';

abstract final class BancosEuropa {
  static const items = [
    Banco(
      sigla: 'WIZ',
      descricao: 'Wizink',
      icon: BancoIcon.wizink,
      regiao: RegiaoBanco.europa,
    ),
    Banco(
      sigla: 'NOV',
      descricao: 'Novo Banco',
      icon: BancoIcon.novoBanco,
      regiao: RegiaoBanco.europa,
    ),
    Banco(
      sigla: 'OPB',
      descricao: 'Openbank',
      icon: BancoIcon.openbank,
      regiao: RegiaoBanco.europa,
    ),
  ];
}
