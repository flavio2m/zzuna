import 'banco.dart';
import 'banco_regiao.dart';

abstract final class BancosBrasil {
  static const items = [
    Banco(
      sigla: 'BB',
      descricao: 'Banco do Brasil',
      icon: BancoIcon.bancoDoBrasil,
      regiao: RegiaoBanco.brasil,
    ),
    Banco(
      sigla: 'BNB',
      descricao: 'Banco do Nordeste',
      icon: BancoIcon.bancoDoNordeste,
      regiao: RegiaoBanco.brasil,
    ),
    Banco(
      sigla: 'BRA',
      descricao: 'Bradesco',
      icon: BancoIcon.bradesco,
      regiao: RegiaoBanco.brasil,
    ),
    Banco(
      sigla: 'C6',
      descricao: 'C6 Bank',
      icon: BancoIcon.c6,
      regiao: RegiaoBanco.brasil,
    ),
    Banco(
      sigla: 'CEF',
      descricao: 'Caixa Econômica Federal',
      icon: BancoIcon.caixa,
      regiao: RegiaoBanco.brasil,
    ),
    Banco(
      sigla: 'INT',
      descricao: 'Inter',
      icon: BancoIcon.inter,
      regiao: RegiaoBanco.brasil,
    ),
    Banco(
      sigla: 'ITA',
      descricao: 'Itaú',
      icon: BancoIcon.itau,
      regiao: RegiaoBanco.brasil,
    ),
    Banco(
      sigla: 'NUB',
      descricao: 'Nubank',
      icon: BancoIcon.nubank,
      regiao: RegiaoBanco.brasil,
    ),
    Banco(
      sigla: 'SAN',
      descricao: 'Santander',
      icon: BancoIcon.santander,
      regiao: RegiaoBanco.brasil,
    ),
    Banco(
      sigla: 'SCO',
      descricao: 'Sicoob',
      icon: BancoIcon.sicoob,
      regiao: RegiaoBanco.brasil,
    ),
    Banco(
      sigla: 'SIC',
      descricao: 'Sicredi',
      icon: BancoIcon.sicredi,
      regiao: RegiaoBanco.brasil,
    ),
  ];
}
