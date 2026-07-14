import 'package:flutter/material.dart';
import 'package:zzuna/domain/statics/banco/banco.dart';

class BankIconMapper {
  static IconData byIcon(BancoIcon icon) {
    switch (icon) {
      case BancoIcon.bancoDoBrasil:
      case BancoIcon.bancoDoNordeste:
      case BancoIcon.bradesco:
      case BancoIcon.c6:
      case BancoIcon.caixa:
      case BancoIcon.inter:
      case BancoIcon.itau:
      case BancoIcon.nubank:
      case BancoIcon.outros:
      case BancoIcon.santander:
      case BancoIcon.sicoob:
      case BancoIcon.sicredi:
      case BancoIcon.wizink:
      case BancoIcon.novoBanco:
      case BancoIcon.openbank:
        return Icons.account_balance;
    }
  }
}
