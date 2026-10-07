import 'package:flutter/material.dart';

abstract final class CategoriaCores {
  static const azulCustosFixos = '#0084FF';
  static const roxoSolar = '#7C6DF2';
  static const rosaConforto = '#F43F85';
  static const purpuraMetas = '#A855F7';
  static const laranjaPrazeres = '#FF6B00';
  static const amareloConhecimento = '#FFD600';
  static const esmeraldaReceitas = '#10B981';
  static const ciano = '#06B6D4';
  static const magenta = '#EC4899';
  static const cinzaTerceiros = '#64748B';

  static const List<String> padrao = [
    azulCustosFixos,
    roxoSolar,
    rosaConforto,
    purpuraMetas,
    laranjaPrazeres,
    amareloConhecimento,
    esmeraldaReceitas,
    ciano,
    magenta,
    cinzaTerceiros,
  ];

  static Color parseHex(
    String? hex, {
    Color fallback = const Color(0xFF64748B),
  }) {
    if (hex == null || hex.trim().isEmpty) return fallback;
    try {
      final clean = hex.replaceAll('#', '').replaceAll('0x', '').trim();
      if (clean.length == 6) {
        return Color(int.parse('FF$clean', radix: 16));
      } else if (clean.length == 8) {
        return Color(int.parse(clean, radix: 16));
      }
    } catch (_) {}
    return fallback;
  }

  static String toHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}
