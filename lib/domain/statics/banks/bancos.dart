import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/statics/banks/banco.dart';

abstract final class Bancos {
  static const items = [
    Banco(sigla: 'BB', descricao: 'Banco do Brasil', icon: BancoIcon.bancoDoBrasil),
    Banco(sigla: 'BNB', descricao: 'Banco do Nordeste', icon: BancoIcon.bancoDoNordeste),
    Banco(sigla: 'BRA', descricao: 'Bradesco', icon: BancoIcon.bradesco),
    Banco(sigla: 'C6', descricao: 'C6 Bank', icon: BancoIcon.c6),
    Banco(sigla: 'CEF', descricao: 'Caixa Econômica Federal', icon: BancoIcon.caixa),
    Banco(sigla: 'INT', descricao: 'Inter', icon: BancoIcon.inter),
    Banco(sigla: 'ITA', descricao: 'Itaú', icon: BancoIcon.itau),
    Banco(sigla: 'NUB', descricao: 'Nubank', icon: BancoIcon.nubank),
    Banco(sigla: 'OUT', descricao: 'Outros', icon: BancoIcon.outros),
    Banco(sigla: 'SAN', descricao: 'Santander', icon: BancoIcon.santander),
    Banco(sigla: 'SCO', descricao: 'Sicoob', icon: BancoIcon.sicoob),
    Banco(sigla: 'SIC', descricao: 'Sicredi', icon: BancoIcon.sicredi),
  ];

  static Result<Banco> bySigla(String sigla) {
    final banco = items.where((banco) => banco.sigla == sigla);

    if (banco.isEmpty) {
      return Failure(Exception('Banco não encontrado para a sigla: $sigla'));
    }

    return Success(banco.first);
  }
}
