class LancamentosSidebarState {
  final String filtro;

  final bool contasExpandidas;
  final bool cartoesExpandidos;
  final bool centrosExpandidos;
  final bool categoriasExpandidas;

  final Set<String> categoriasExpandidasIds;

  const LancamentosSidebarState({
    this.filtro = '',
    this.contasExpandidas = true,
    this.cartoesExpandidos = true,
    this.centrosExpandidos = true,
    this.categoriasExpandidas = true,
    this.categoriasExpandidasIds = const {},
  });

  LancamentosSidebarState copyWith({
    String? filtro,
    bool? contasExpandidas,
    bool? cartoesExpandidos,
    bool? centrosExpandidos,
    bool? categoriasExpandidas,
    Set<String>? categoriasExpandidasIds,
  }) {
    return LancamentosSidebarState(
      filtro: filtro ?? this.filtro,
      contasExpandidas: contasExpandidas ?? this.contasExpandidas,
      cartoesExpandidos: cartoesExpandidos ?? this.cartoesExpandidos,
      centrosExpandidos: centrosExpandidos ?? this.centrosExpandidos,
      categoriasExpandidas: categoriasExpandidas ?? this.categoriasExpandidas,
      categoriasExpandidasIds: categoriasExpandidasIds ?? this.categoriasExpandidasIds,
    );
  }
}
