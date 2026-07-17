import 'package:flutter/material.dart';
import 'banco_regiao.dart';

enum BancoIcon {
  bancoDoBrasil,
  bancoDoNordeste,
  bradesco,
  c6,
  caixa,
  inter,
  itau,
  nubank,
  outros,
  santander,
  sicoob,
  sicredi,
  wizink,
  novoBanco,
  openbank,
}

class Banco {
  final String descricao;
  final String sigla;
  final BancoIcon icon;
  final RegiaoBanco regiao;

  const Banco({
    required this.descricao,
    required this.sigla,
    required this.icon,
    required this.regiao,
  });

  IconData getIcon() {
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
        return Icons.account_balance_wallet_outlined;
    }
  }
}
