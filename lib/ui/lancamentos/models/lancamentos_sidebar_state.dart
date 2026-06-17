class LancamentosSidebarState {
  final String filtro;

  final Set<String> contasSelecionadas;
  final Set<String> cartoesSelecionados;
  final Set<String> centrosSelecionados;
  final Set<String> categoriasSelecionadas;

  final bool contasExpandidas;
  final bool cartoesExpandidos;
  final bool centrosExpandidos;
  final bool categoriasExpandidas;

  final Set<String> categoriasExpandidasIds;

  const LancamentosSidebarState({
    this.filtro = '',
    this.contasSelecionadas = const {},
    this.cartoesSelecionados = const {},
    this.centrosSelecionados = const {},
    this.categoriasSelecionadas = const {},
    this.contasExpandidas = true,
    this.cartoesExpandidos = true,
    this.centrosExpandidos = true,
    this.categoriasExpandidas = true,
    this.categoriasExpandidasIds = const {},
  });

  LancamentosSidebarState copyWith({
    String? filtro,
    Set<String>? contasSelecionadas,
    Set<String>? cartoesSelecionados,
    Set<String>? centrosSelecionados,
    Set<String>? categoriasSelecionadas,
    bool? contasExpandidas,
    bool? cartoesExpandidos,
    bool? centrosExpandidos,
    bool? categoriasExpandidas,
    Set<String>? categoriasExpandidasIds,
  }) {
    return LancamentosSidebarState(
      filtro: filtro ?? this.filtro,
      contasSelecionadas: contasSelecionadas ?? this.contasSelecionadas,
      cartoesSelecionados: cartoesSelecionados ?? this.cartoesSelecionados,
      centrosSelecionados: centrosSelecionados ?? this.centrosSelecionados,
      categoriasSelecionadas: categoriasSelecionadas ?? this.categoriasSelecionadas,
      contasExpandidas: contasExpandidas ?? this.contasExpandidas,
      cartoesExpandidos: cartoesExpandidos ?? this.cartoesExpandidos,
      centrosExpandidos: centrosExpandidos ?? this.centrosExpandidos,
      categoriasExpandidas: categoriasExpandidas ?? this.categoriasExpandidas,
      categoriasExpandidasIds: categoriasExpandidasIds ?? this.categoriasExpandidasIds,
    );
  }
}
