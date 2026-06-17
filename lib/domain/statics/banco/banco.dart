import 'package:flutter/material.dart';

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
}

class Banco {
  final String descricao;
  final String sigla;
  final BancoIcon icon;

  const Banco({required this.descricao, required this.sigla, required this.icon});

  IconData getIcon() {
    switch (icon) {
      case BancoIcon.bancoDoBrasil:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.bancoDoNordeste:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.bradesco:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.c6:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.caixa:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.inter:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.itau:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.nubank:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.outros:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.santander:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.sicoob:
        return Icons.account_balance_wallet_outlined;
      case BancoIcon.sicredi:
        return Icons.account_balance_wallet_outlined;
    }
  }
}
