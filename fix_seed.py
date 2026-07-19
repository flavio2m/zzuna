import re

with open('lib/data/seed/lancamento_seed.dart', 'r') as f:
    content = f.read()

# execute
content = content.replace(
'''  Future<void> execute() async {
    final result = await repository.searchByPeriodo(mes: Mes.junho, ano: 2026);''',
'''  Future<void> execute() async {
    final hoje = DateTime.now();
    final mesAtual = Mes.values.firstWhere((e) => e.numero == hoje.month);
    final anoAtual = hoje.year;

    final result = await repository.searchByPeriodo(mes: mesAtual, ano: anoAtual);'''
)

content = content.replace(
'''    final seeds = <LancamentoDto>[];
    seeds.addAll(_criarLancamentosJunho(dependencies));
    seeds.addAll(_criarLancamentosMaio(dependencies));''',
'''    final hoje = DateTime.now();
    final mesAtualNum = hoje.month;
    final anoAtual = hoje.year;
    final mesAnteriorNum = mesAtualNum == 1 ? 12 : mesAtualNum - 1;
    final anoAnterior = mesAtualNum == 1 ? anoAtual - 1 : anoAtual;

    final seeds = <LancamentoDto>[];
    seeds.addAll(_criarLancamentosAtual(dependencies, anoAtual, mesAtualNum));
    seeds.addAll(_criarLancamentosAnterior(dependencies, anoAnterior, mesAnteriorNum));'''
)

# _carregarDependencias
content = content.replace(
'''  Future<_SeedDependencies?> _carregarDependencias() async {
    final contas = (await contaRepository.getAll()).getOrElse((_) => []);
    final cartoes = (await cartaoRepository.getAll()).getOrElse((_) => []);
    final centros = (await centroCustoRepository.getAll()).getOrElse((_) => []);
    final categorias = (await categoriaRepository.getAll()).getOrElse((_) => []);

    final extratoFaturasMay = (await extratoFaturaRepository.search(
      ExtratoFaturaFilterDto(mes: Mes.maio, ano: 2026),
    )).getOrElse((_) => []);
    final extratoFaturasJune = (await extratoFaturaRepository.search(
      ExtratoFaturaFilterDto(mes: Mes.junho, ano: 2026),
    )).getOrElse((_) => []);''',
'''  Future<_SeedDependencies?> _carregarDependencias() async {
    final contas = (await contaRepository.getAll()).getOrElse((_) => []);
    final cartoes = (await cartaoRepository.getAll()).getOrElse((_) => []);
    final centros = (await centroCustoRepository.getAll()).getOrElse((_) => []);
    final categorias = (await categoriaRepository.getAll()).getOrElse((_) => []);

    final hoje = DateTime.now();
    final mesAtualNum = hoje.month;
    final anoAtual = hoje.year;
    final mesAnteriorNum = mesAtualNum == 1 ? 12 : mesAtualNum - 1;
    final anoAnterior = mesAtualNum == 1 ? anoAtual - 1 : anoAtual;
    final mesAtual = Mes.values.firstWhere((e) => e.numero == mesAtualNum);
    final mesAnterior = Mes.values.firstWhere((e) => e.numero == mesAnteriorNum);

    final extratoFaturasMay = (await extratoFaturaRepository.search(
      ExtratoFaturaFilterDto(mes: mesAnterior, ano: anoAnterior),
    )).getOrElse((_) => []);
    final extratoFaturasJune = (await extratoFaturaRepository.search(
      ExtratoFaturaFilterDto(mes: mesAtual, ano: anoAtual),
    )).getOrElse((_) => []);'''
)

content = content.replace('''Mes.junho)''', '''mesAtual)''')
content = content.replace('''Mes.maio)''', '''mesAnterior)''')

content = content.replace('''List<LancamentoDto> _criarLancamentosJunho(_SeedDependencies dep) {''', '''List<LancamentoDto> _criarLancamentosAtual(_SeedDependencies dep, int ano, int mes) {''')
content = content.replace('''List<LancamentoDto> _criarLancamentosMaio(_SeedDependencies dep) {''', '''List<LancamentoDto> _criarLancamentosAnterior(_SeedDependencies dep, int ano, int mes) {''')

content = content.replace('''DateTime(2026, 6,''', '''DateTime(ano, mes,''')
content = content.replace('''DateTime(2026, 5,''', '''DateTime(ano, mes,''')

with open('lib/data/seed/lancamento_seed.dart', 'w') as f:
    f.write(content)
