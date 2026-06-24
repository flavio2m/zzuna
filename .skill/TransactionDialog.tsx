import React, { useState, useEffect } from 'react';
import { LancamentoComDetalhes, ItemLancamento, Categoria, Conta, Cartao, CentroCusto, TipoLancamento, TipoOrigem, StatusLancamento } from '../types';
import { getDocumentoParaLancamento } from '../data/mockData';
import { X, Plus, Trash2, Calendar, AlertTriangle, HelpCircle, AlertOctagon, RefreshCw, FileText } from 'lucide-react';

interface TransactionDialogProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (data: {
    lancamento: Partial<LancamentoComDetalhes>;
    itens: Partial<ItemLancamento>[];
    applyOption?: 'ONLY_THIS' | 'FROM_THIS_ONWARD' | 'ALL_IN_GROUP';
  }) => void;
  editingTransaction: LancamentoComDetalhes | null;
  categorias: Categoria[];
  contas: Conta[];
  cartoes: Cartao[];
  centrosCusto: CentroCusto[];
}

export default function TransactionDialog({
  isOpen,
  onClose,
  onSave,
  editingTransaction,
  categorias,
  contas,
  cartoes,
  centrosCusto
}: TransactionDialogProps) {
  // Core Fields
  const [data, setData] = useState('2026-03-05');
  const [descricao, setDescricao] = useState('');
  const [tipo, setTipo] = useState<TipoLancamento>('DESPESA');
  const [tipoOrigem, setTipoOrigem] = useState<TipoOrigem>('CARTAO');
  const [origemId, setOrigemId] = useState('');
  const [valorTotal, setValorTotal] = useState<number>(0);
  const [observacao, setObservacao] = useState('');
  const [status, setStatus] = useState<StatusLancamento>('PENDENTE');
  const [recorrente, setRecorrente] = useState(false);

  // Group / Installment / Replication options (Adding action variables)
  const [isDividido, setIsDividido] = useState(false);
  const [numParcelas, setNumParcelas] = useState<number>(3);

  const [isReplicado, setIsReplicado] = useState(false);
  const [parcelaInicial, setParcelaInicial] = useState<number>(1);
  const [parcelaFinal, setParcelaFinal] = useState<number>(5);

  // Multi-Category Splits (Rateio)
  const [isRateioExpanded, setIsRateioExpanded] = useState(false);
  const [rateioLines, setRateioLines] = useState<Array<{
    categoriaId: string;
    centroCustoId: string;
    valor: number;
    percentual: number;
  }>>([]);

  // Save Apply Option state for editing grouped elements
  const [applyOption, setApplyOption] = useState<'ONLY_THIS' | 'FROM_THIS_ONWARD' | 'ALL_IN_GROUP'>('ONLY_THIS');

  // Future warning confirmation
  const [confirmFuture, setConfirmFuture] = useState(false);

  // Sync state if editing
  useEffect(() => {
    if (editingTransaction) {
      setData(editingTransaction.data);
      setDescricao(editingTransaction.descricao);
      setTipo(editingTransaction.tipo);
      setTipoOrigem(editingTransaction.tipoOrigem);
      setOrigemId(editingTransaction.origemId);
      setValorTotal(editingTransaction.valorTotal);
      setObservacao(editingTransaction.observacao || '');
      setStatus(editingTransaction.status);
      setRecorrente(editingTransaction.recorrente || false);
      
      // Group configurations
      setIsDividido(false);
      setIsReplicado(false);

      // Rateio configuration (if more than 1 item)
      if (editingTransaction.itens && editingTransaction.itens.length > 1) {
        setIsRateioExpanded(true);
        setRateioLines(editingTransaction.itens.map(it => ({
          categoriaId: it.categoriaId,
          centroCustoId: it.centroCustoId,
          valor: it.valor,
          percentual: Number(((it.valor / editingTransaction.valorTotal) * 100).toFixed(2))
        })));
      } else {
        setIsRateioExpanded(false);
        const itemFirst = editingTransaction.itens?.[0];
        setRateioLines([{
          categoriaId: itemFirst?.categoriaId || (categorias.find(c => c.parentId !== null)?.id || ''),
          centroCustoId: itemFirst?.centroCustoId || 'cc_geral',
          valor: editingTransaction.valorTotal,
          percentual: 100
        }]);
      }
    } else {
      // Reset to defaults for addition
      setData('2026-03-05');
      setDescricao('');
      setTipo('DESPESA');
      setTipoOrigem('CARTAO');
      const firstCard = cartoes.find(c => c.ativo)?.id || '';
      setOrigemId(firstCard);
      setValorTotal(0);
      setObservacao('');
      setStatus('PENDENTE');
      setRecorrente(false);
      setIsDividido(false);
      setNumParcelas(7); // standard default case 6.2
      setIsReplicado(false);
      setParcelaInicial(5); // standard default case 6.3
      setParcelaFinal(10);
      setIsRateioExpanded(false);
      setConfirmFuture(false);

      const defaultCatId = categorias.find(c => c.parentId !== null && c.ativo)?.id || 'cat_supermercado_goncalves';
      setRateioLines([{
        categoriaId: defaultCatId,
        centroCustoId: 'cc_geral',
        valor: 0,
        percentual: 100
      }]);
    }
  }, [editingTransaction, isOpen, cartoes, contas, categorias]);

  // Adjust default OrigemId when toggle between Account/Card happens
  useEffect(() => {
    if (!editingTransaction) {
      if (tipoOrigem === 'CARTAO') {
        setOrigemId(cartoes.find(c => c.ativo)?.id || '');
      } else {
        setOrigemId(contas.find(c => c.ativo)?.id || '');
      }
    }
  }, [tipoOrigem, cartoes, contas, editingTransaction]);

  // Sync Rateio single line if not expanded
  useEffect(() => {
    if (!isRateioExpanded && rateioLines.length <= 1) {
      updateSingleLineValue(valorTotal);
    }
  }, [valorTotal, isRateioExpanded]);

  const updateSingleLineValue = (total: number) => {
    setRateioLines(prev => {
      if (prev.length === 0) {
        return [{
          categoriaId: categorias.find(c => c.parentId !== null)?.id || '',
          centroCustoId: 'cc_geral',
          valor: total,
          percentual: 100
        }];
      }
      const updated = [...prev];
      updated[0] = { ...updated[0], valor: total, percentual: 100 };
      return updated;
    });
  };

  // --- REQUISITO 3.1: Determinar documento e situação retroativa ---
  const evaluatedDoc = getDocumentoParaLancamento(data, tipoOrigem, origemId, cartoes, contas);
  const isDocumentoFechado = evaluatedDoc.docStatus === 'FECHADA';

  // --- REQUISITO 4.6 (Validação 2): Lançamento > 30 dias futuro ---
  const checkIsFuture30Days = (): boolean => {
    const transactionDate = new Date(data + 'T00:00:00');
    const simulationBaseDate = new Date('2026-03-05T00:00:00'); // Based on Mar 5th, 2026 clock
    const diffTime = transactionDate.getTime() - simulationBaseDate.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays > 30;
  };

  const isFutureLimitExceeded = checkIsFuture30Days();

  // Rateio Helpers
  const handleAddRateioLine = () => {
    const defaultCat = categorias.find(c => c.parentId !== null && c.ativo)?.id || '';
    setRateioLines([...rateioLines, {
      categoriaId: defaultCat,
      centroCustoId: 'cc_geral',
      valor: 0,
      percentual: 0
    }]);
  };

  const handleRemoveRateioLine = (index: number) => {
    const updated = rateioLines.filter((_, idx) => idx !== index);
    setRateioLines(updated);
  };

  const handleUpdateLine = (index: number, field: string, value: any) => {
    const updated = [...rateioLines];
    const item = { ...updated[index] };

    if (field === 'categoriaId') item.categoriaId = value;
    else if (field === 'centroCustoId') item.centroCustoId = value;
    else if (field === 'valor') {
      const valNum = Number(value) || 0;
      item.valor = valNum;
      item.percentual = valorTotal > 0 ? Number(((valNum / valorTotal) * 100).toFixed(2)) : 0;
    } else if (field === 'percentual') {
      const pctNum = Number(value) || 0;
      item.percentual = pctNum;
      item.valor = Number(((pctNum / 100) * valorTotal).toFixed(2));
    }

    updated[index] = item;
    setRateioLines(updated);
  };

  // Auto spread remaining value evenly
  const handleDistributeRemaining = () => {
    const sumSpecified = rateioLines.reduce((sum, line, idx) => sum + (idx === rateioLines.length - 1 ? 0 : line.valor), 0);
    const remaining = Math.max(0, valorTotal - sumSpecified);
    if (rateioLines.length > 0) {
      const updated = [...rateioLines];
      const lastIdx = updated.length - 1;
      updated[lastIdx] = {
        ...updated[lastIdx],
        valor: Number(remaining.toFixed(2)),
        percentual: valorTotal > 0 ? Number(((remaining / valorTotal) * 100).toFixed(2)) : 0
      };
      setRateioLines(updated);
    }
  };

  const handleDistributeEvenly = () => {
    if (rateioLines.length === 0) return;
    const splitCount = rateioLines.length;
    const baseVal = Math.floor((valorTotal / splitCount) * 100) / 100;
    const pennies = Number((valorTotal - (baseVal * splitCount)).toFixed(2));

    const updated = rateioLines.map((line, idx) => {
      const finalVal = idx === 0 ? Number((baseVal + pennies).toFixed(2)) : baseVal;
      return {
        ...line,
        valor: finalVal,
        percentual: valorTotal > 0 ? Number(((finalVal / valorTotal) * 100).toFixed(2)) : 100 / splitCount
      };
    });
    setRateioLines(updated);
  };

  // Computations for validation summaries
  const sumRateioValues = rateioLines.reduce((acc, line) => acc + line.valor, 0);
  const rateioMatchesTotal = Math.abs(sumRateioValues - valorTotal) < 0.01;

  // Selected Card or Account object
  const activeOrigem = tipoOrigem === 'CARTAO' 
    ? cartoes.find(c => c.id === origemId)
    : contas.find(c => c.id === origemId);

  const isOrigemInativa = activeOrigem ? !activeOrigem.ativo : false;

  // --- REQUISITO 4.2 / 4.3 CALCULAÇÃO DE PARCELAMENTO PREVIA ---
  // Se parcelado (Dividir): Parcela 1 recebe o centavo de arredondamento
  const getInstallmentsPreview = (): Array<{ num: number; valor: number }> => {
    if (!isDividido || numParcelas <= 1) return [];
    const baseAmount = Math.floor((valorTotal / numParcelas) * 100) / 100;
    const remainingPennies = Number((valorTotal - (baseAmount * numParcelas)).toFixed(2));
    
    const preview: Array<{ num: number; valor: number }> = [];
    for (let i = 1; i <= numParcelas; i++) {
      const value = i === 1 ? Number((baseAmount + remainingPennies).toFixed(2)) : baseAmount;
      preview.push({ num: i, valor: value });
    }
    return preview;
  };

  // Se replicado: Parcela Inicial à Final, mesmo valor completo por parcela
  const getReplicationsPreview = (): { totalCount: number; precoFinal: number } => {
    if (!isReplicado || parcelaFinal < parcelaInicial) return { totalCount: 0, precoFinal: 0 };
    const totalCount = (parcelaFinal - parcelaInicial) + 1;
    const precoFinal = totalCount * valorTotal;
    return { totalCount, precoFinal };
  };

  const handleSaveWrapper = () => {
    // --- REQUISITO 4.6 VALIDATION CHECK ---
    // 1. Não permitir lançamento em fatura fechada
    if (isDocumentoFechado) {
      alert("Operação proibida: O período financeiro (Fatura/Extrato) correspondente à data informada encontra-se FECHADO.");
      return;
    }

    // 2. Não permitir conta/cartão inativo
    if (isOrigemInativa) {
      alert("Operação proibida: A origem de débito (Conta ou Cartão) selecionada encontra-se INATIVA.");
      return;
    }

    // 3. Rateio bate com total?
    if (isRateioExpanded && !rateioMatchesTotal) {
      alert(`Erro no Rateio: A soma dos itens rateados (R$ ${sumRateioValues.toFixed(2)}) não bate com o Valor Total (R$ ${valorTotal.toFixed(2)}). Diferença: R$ ${(valorTotal - sumSpecifiedRateio).toFixed(2)}`);
      return;
    }

    // 4. Confirmação futuro >30 dias
    if (isFutureLimitExceeded && !confirmFuture) {
      const conf = window.confirm("Atenção! Esta transação está programada para ocorrer a mais de 30 dias na frente. Deseja prosseguir com o lançamento futuro?");
      if (!conf) return;
    }

    // Prepare items to register
    let itemsToSave: Partial<ItemLancamento>[] = [];

    if (isRateioExpanded) {
      itemsToSave = rateioLines.map(line => ({
        categoriaId: line.categoriaId,
        centroCustoId: line.centroCustoId,
        valor: line.valor
      }));
    } else {
      // Just 1 single category assigned
      itemsToSave = [{
        categoriaId: rateioLines[0]?.categoriaId || categorias.find(c => c.parentId !== null)?.id,
        centroCustoId: rateioLines[0]?.centroCustoId || 'cc_geral',
        valor: valorTotal
      }];
    }

    onSave({
      lancamento: {
        id: editingTransaction?.id,
        data,
        descricao,
        tipo,
        valorTotal,
        tipoOrigem,
        origemId,
        observacao,
        status,
        recorrente,
        // Carry down attributes if they are modified
        grupoId: editingTransaction?.grupoId || null,
        tipoGrupo: editingTransaction?.tipoGrupo || null,
        parcelaNumero: editingTransaction?.parcelaNumero || null,
        totalParcelas: editingTransaction?.totalParcelas || null,
      },
      itens: itemsToSave,
      applyOption: editingTransaction?.grupoId ? applyOption : undefined,
      // Pass down dynamic parameters if creating newly divided or replicated groups
      ... (isDividido && !editingTransaction ? { isDividido, numParcelas } : {}),
      ... (isReplicado && !editingTransaction ? { isReplicado, parcelaInicial, parcelaFinal } : {})
    });
  };

  const sumSpecifiedRateio = rateioLines.reduce((acc, line) => acc + line.valor, 0);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 z-50 font-sans overflow-y-auto">
      <div className="bg-white rounded-2xl border border-slate-200 shadow-2xl w-full max-w-2xl max-h-[90vh] flex flex-col overflow-hidden animate-scale-in">
        
        {/* Modal Header */}
        <div className="bg-slate-50 px-6 py-4 border-b border-slate-200 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold">
              $
            </div>
            <div>
              <h2 className="font-extrabold text-slate-800 text-sm">
                {editingTransaction ? 'Editar Lançamento' : 'Novo Lançamento'}
              </h2>
              <p className="text-[10px] text-slate-500 font-medium">ZZuna Finance Engine v1.0</p>
            </div>
          </div>
          <button 
            onClick={onClose}
            className="p-1.5 rounded-lg text-slate-400 hover:text-slate-600 hover:bg-slate-100 transition-colors"
          >
            <X size={18} />
          </button>
        </div>

        {/* Modal Scrollable Core Content */}
        <div className="p-6 flex-1 overflow-y-auto space-y-5">
          {/* Closed Invoice / Document Alert (REQUISITO 4.6 VALIDATION 1) */}
          {isDocumentoFechado && (
            <div className="bg-rose-50 border border-rose-200 rounded-xl p-3 flex gap-3 text-rose-800 animate-pulse">
              <AlertOctagon className="text-rose-600 flex-shrink-0 mt-0.5" size={18} />
              <div className="text-xs">
                <span className="font-extrabold block">Competência Financeira Fechada!</span>
                A data selecionada ({data}) cai na competência <span className="font-bold underline">{evaluatedDoc.docDescricao}</span> que já se encontra <strong>FECHADA</strong>. Não é permitido adicionar ou alterar registros nesta data.
              </div>
            </div>
          )}

          {/* Inactive Origin alert (REQUISITO 4.6 VALIDATION 4) */}
          {isOrigemInativa && (
            <div className="bg-amber-50 border border-amber-200 rounded-xl p-3 flex gap-3 text-amber-800">
              <AlertTriangle className="text-amber-600 flex-shrink-0 mt-0.5" size={16} />
              <div className="text-xs">
                <span className="font-extrabold block">Atenção: Cartão ou Conta Inativa!</span>
                Essa conta ou cartão selecionado está marcado como <span className="font-bold uppercase">Inativo</span> no cadastro geral do sistema. Reative-o para autorizar movimentações.
              </div>
            </div>
          )}

          {/* Future over 30 days Confirmation Banner (REQUISITO 4.6 VALIDATION 2) */}
          {isFutureLimitExceeded && !isDocumentoFechado && (
            <div className="bg-amber-50 border border-amber-200 rounded-xl p-3 flex gap-3 text-amber-800">
              <Calendar className="text-amber-600 flex-shrink-0 mt-0.5" size={16} />
              <div className="text-xs space-y-1.5 w-full">
                <span className="font-extrabold block">Projeção Futura Extensa (&gt;30 Dias)!</span>
                Este lançamento ({data}) está agendado para ocorrer no futuro. Marque a caixa abaixo para confirmar esta programação financeira.
                <label className="flex items-center gap-2 mt-1 cursor-pointer select-none">
                  <input
                    id="future-confirm-checkbox"
                    type="checkbox"
                    checked={confirmFuture}
                    onChange={(e) => setConfirmFuture(e.target.checked)}
                    className="rounded border-amber-400 text-amber-600 focus:ring-amber-500 w-3.5 h-3.5"
                  />
                  <span className="font-bold text-amber-900 leading-tight">Estou ciente e confirmo este lançamento futuro</span>
                </label>
              </div>
            </div>
          )}

          {/* Form Basic row */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {/* Description */}
            <div className="space-y-1">
              <label className="text-[11px] font-bold text-slate-500 uppercase tracking-wider block">Descrição do Lançamento</label>
              <input
                id="dialog-desc-input"
                type="text"
                placeholder="Ex: Compra Riachuelo, Supermercado Gonçalves..."
                value={descricao}
                onChange={(e) => setDescricao(e.target.value)}
                className="w-full text-xs font-medium text-slate-800 px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:border-emerald-500"
              />
            </div>

            {/* Date */}
            <div className="space-y-1">
              <label className="text-[11px] font-bold text-slate-500 uppercase tracking-wider block">Data do Evento</label>
              <input
                id="dialog-date-input"
                type="date"
                value={data}
                onChange={(e) => setData(e.target.value)}
                className="w-full text-xs font-semibold text-slate-800 px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:border-emerald-500"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {/* Tipo (Debito/credito/receita) */}
            <div className="space-y-1">
              <label className="text-[11px] font-bold text-slate-500 uppercase tracking-wider block">Tipo de Fluxo</label>
              <select
                id="dialog-tipo-select"
                value={tipo}
                onChange={(e) => setTipo(e.target.value as TipoLancamento)}
                className="w-full text-xs font-semibold text-slate-800 px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:border-emerald-500 bg-white"
              >
                <option value="DESPESA">Despesa (Débito)</option>
                <option value="RECEITA">Receita (Entrada)</option>
                <option value="TRANSFERENCIA">Transferência</option>
              </select>
            </div>

            {/* Origem Selector */}
            <div className="space-y-1">
              <label className="text-[11px] font-bold text-slate-500 uppercase tracking-wider block">Tipo Origem</label>
              <div className="grid grid-cols-2 gap-1 bg-slate-100 p-0.5 rounded-lg border border-slate-200">
                <button
                  type="button"
                  onClick={() => setTipoOrigem('CARTAO')}
                  className={`py-1 text-[10px] font-bold rounded-md transition-all ${
                    tipoOrigem === 'CARTAO' ? 'bg-white text-slate-800 shadow-sm' : 'text-slate-500 hover:text-slate-700'
                  }`}
                >
                  Cartão Crédito
                </button>
                <button
                  type="button"
                  onClick={() => setTipoOrigem('CONTA')}
                  className={`py-1 text-[10px] font-bold rounded-md transition-all ${
                    tipoOrigem === 'CONTA' ? 'bg-white text-slate-800 shadow-sm' : 'text-slate-500 hover:text-slate-700'
                  }`}
                >
                  Conta Corrente
                </button>
              </div>
            </div>

            {/* Select specific card or account */}
            <div className="space-y-1">
              <label className="text-[11px] font-bold text-slate-500 uppercase tracking-wider block">Selecione Origem</label>
              <select
                id="dialog-origemid-select"
                value={origemId}
                onChange={(e) => setOrigemId(e.target.value)}
                className="w-full text-xs font-semibold text-slate-800 px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:border-emerald-500 bg-white"
              >
                {tipoOrigem === 'CARTAO' 
                  ? cartoes.map(c => <option key={c.id} value={c.id}>{c.descricao} {!c.ativo ? '(Inativo)' : ''}</option>)
                  : contas.map(co => <option key={co.id} value={co.id}>{co.descricao} {!co.ativo ? '(Inativo)' : ''}</option>)
                }
              </select>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {/* Valor total */}
            <div className="space-y-1">
              <label className="text-[11px] font-bold text-slate-500 uppercase tracking-wider block">Valor Total (R$)</label>
              <div className="relative">
                <span className="absolute left-3 top-2 text-xs font-bold text-slate-400">R$</span>
                <input
                  id="dialog-valortotal-input"
                  type="number"
                  step="0.01"
                  placeholder="0,00"
                  value={valorTotal || ''}
                  onChange={(e) => setValorTotal(Number(e.target.value) || 0)}
                  className="w-full text-xs font-extrabold text-slate-800 pl-9 pr-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:border-emerald-500 font-mono"
                />
              </div>
            </div>

            {/* Auto Period determination display */}
            <div className="bg-slate-50 border border-slate-200 rounded-lg p-3 space-y-1 flex flex-col justify-center">
              <div className="flex items-center gap-1.5 text-[9px] uppercase font-mono font-extrabold text-slate-400 tracking-wider">
                <FileText size={11} className="text-slate-400" />
                Vínculo Financeiro Automático
              </div>
              <div className="flex justify-between items-center text-xs font-semibold text-slate-700">
                <span className="truncate">{evaluatedDoc.docDescricao}</span>
                <span className={`px-1.5 py-0.2 rounded font-mono font-bold text-[9px] ${
                  evaluatedDoc.docStatus === 'ABERTA' ? 'bg-emerald-100 text-emerald-800' : 'bg-rose-100 text-rose-800'
                }`}>
                  {evaluatedDoc.docStatus}
                </span>
              </div>
            </div>
          </div>

          {/* Group Edit Application Options (REQUISITO 4.5 EDITAR LANÇAMENTO DE GRUPO) */}
          {editingTransaction?.grupoId && (
            <div className="bg-indigo-50 border border-indigo-150 rounded-xl p-4 space-y-2">
              <div className="text-xs text-indigo-900 font-bold flex items-center gap-1.5 col-span-2">
                <RefreshCw size={13} className="text-indigo-600 rotate-180" />
                Este lançamento integra um grupo de transações vinculadas. Como deseja salvar?
              </div>
              <div className="grid grid-cols-3 gap-2">
                <button
                  type="button"
                  onClick={() => setApplyOption('ONLY_THIS')}
                  className={`py-2 px-3 text-[10px] font-bold rounded-lg border text-center transition-all ${
                    applyOption === 'ONLY_THIS'
                      ? 'bg-indigo-600 border-indigo-600 text-white shadow-md'
                      : 'bg-white border-slate-200 text-slate-600 hover:bg-slate-50'
                  }`}
                >
                  Apenas este Evento
                </button>
                <button
                  type="button"
                  onClick={() => setApplyOption('FROM_THIS_ONWARD')}
                  className={`py-2 px-3 text-[10px] font-bold rounded-lg border text-center transition-all ${
                    applyOption === 'FROM_THIS_ONWARD'
                      ? 'bg-indigo-600 border-indigo-600 text-white shadow-md'
                      : 'bg-white border-slate-200 text-slate-600 hover:bg-slate-50'
                  }`}
                >
                  A partir deste fluxo
                </button>
                <button
                  type="button"
                  onClick={() => setApplyOption('ALL_IN_GROUP')}
                  className={`py-2 px-3 text-[10px] font-bold rounded-lg border text-center transition-all ${
                    applyOption === 'ALL_IN_GROUP'
                      ? 'bg-indigo-600 border-indigo-600 text-white shadow-md'
                      : 'bg-white border-slate-200 text-slate-600 hover:bg-slate-50'
                  }`}
                >
                  Todos do Grupo
                </button>
              </div>
            </div>
          )}

          {/* NOVO LANÇAMENTO OPTIONS (Installment / Replication) */}
          {!editingTransaction && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 border-t border-slate-100 pt-4">
              {/* Opção Dividir (Parcelamento - REQUISITO 4.2 / 6.2) */}
              <div className={`p-4 border border-slate-200 rounded-xl transition-all ${isDividido ? 'border-indigo-500 bg-indigo-50/10' : 'bg-slate-50/40 hover:bg-slate-50'}`}>
                <label className="flex items-center gap-2 cursor-pointer select-none">
                  <input
                    id="dividido-checkbox"
                    type="checkbox"
                    checked={isDividido}
                    onChange={(e) => {
                      setIsDividido(e.target.checked);
                      if (e.target.checked) setIsReplicado(false);
                    }}
                    className="rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
                  />
                  <div>
                    <span className="text-xs font-bold text-slate-800 block">Compra Parcelada (Dividir)</span>
                    <span className="text-[10px] text-slate-500 block leading-tight">Fracionar valor da compra em N vezes</span>
                  </div>
                </label>

                {isDividido && (
                  <div className="mt-3 space-y-3 p-3 bg-white border border-slate-200 rounded-lg animate-fade-in text-xs">
                    <div className="flex items-center justify-between">
                      <span className="text-[10px] font-bold text-slate-500 uppercase tracking-wider">Número de Parcelas:</span>
                      <input
                        id="num-parcelas-input"
                        type="number"
                        min="2"
                        max="60"
                        value={numParcelas}
                        onChange={(e) => setNumParcelas(Math.max(2, Number(e.target.value) || 2))}
                        className="w-16 px-1.5 py-0.5 border border-slate-300 rounded font-bold font-mono text-center text-xs"
                      />
                    </div>
                    {/* Penny distribution breakdown visualization */}
                    <div className="bg-indigo-50/50 p-2.5 rounded text-[10px] space-y-1 font-mono">
                      <span className="font-bold text-indigo-900 block uppercase text-[8px] tracking-wider mb-1">Ajuste de Centavos Automático ZZuna</span>
                      {getInstallmentsPreview().slice(0, 3).map(p => (
                        <div key={p.num} className="flex justify-between items-center text-[10px] text-slate-600">
                          <span>Alt. Parcela {p.num}:</span>
                          <span className="font-extrabold text-slate-800">R$ {p.valor.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}</span>
                        </div>
                      ))}
                      {numParcelas > 3 && (
                        <div className="flex justify-between items-center text-[9px] text-slate-400 italic">
                          <span>... parcelas 4 a {numParcelas}:</span>
                          <span className="font-bold">R$ {getInstallmentsPreview()[numParcelas - 1]?.valor.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}</span>
                        </div>
                      )}
                    </div>
                  </div>
                )}
              </div>

              {/* Opção Replicar Parcelas (REQUISITO 4.3 / 6.3) */}
              <div className={`p-4 border border-slate-200 rounded-xl transition-all ${isReplicado ? 'border-purple-500 bg-purple-50/10' : 'bg-slate-50/40 hover:bg-slate-50'}`}>
                <label className="flex items-center gap-2 cursor-pointer select-none">
                  <input
                    id="replicado-checkbox"
                    type="checkbox"
                    checked={isReplicado}
                    onChange={(e) => {
                      setIsReplicado(e.target.checked);
                      if (e.target.checked) setIsDividido(false);
                    }}
                    className="rounded border-slate-300 text-purple-600 focus:ring-purple-500"
                  />
                  <div>
                    <span className="text-xs font-bold text-slate-800 block">Replicar Parcelas</span>
                    <span className="text-[10px] text-slate-500 block leading-tight">Repetir o valor integral do item</span>
                  </div>
                </label>

                {isReplicado && (
                  <div className="mt-3 space-y-3 p-3 bg-white border border-slate-200 rounded-lg animate-fade-in text-xs">
                    <div className="grid grid-cols-2 gap-2">
                      <div className="space-y-1">
                        <span className="text-[9px] font-bold text-slate-500 uppercase tracking-wider block">Parcela Inicial:</span>
                        <input
                          id="parcela-inicial-input"
                          type="number"
                          min="1"
                          value={parcelaInicial}
                          onChange={(e) => setParcelaInicial(Math.max(1, Number(e.target.value) || 1))}
                          className="w-full px-2 py-1 border border-slate-300 rounded font-mono font-bold text-xs"
                        />
                      </div>
                      <div className="space-y-1">
                        <span className="text-[9px] font-bold text-slate-500 uppercase tracking-wider block">Parcela Final:</span>
                        <input
                          id="parcela-final-input"
                          type="number"
                          min={parcelaInicial}
                          value={parcelaFinal}
                          onChange={(e) => setParcelaFinal(Math.max(parcelaInicial, Number(e.target.value) || parcelaInicial))}
                          className="w-full px-2 py-1 border border-slate-300 rounded font-mono font-bold text-xs"
                        />
                      </div>
                    </div>
                    {/* Preview summary */}
                    <div className="bg-purple-100/50 p-2 rounded text-[10px] text-purple-900 font-semibold space-y-1">
                      <div className="flex justify-between items-center text-[10px]">
                        <span>Parcelas Geradas:</span>
                        <span className="font-bold">{getReplicationsPreview().totalCount} lançamentos</span>
                      </div>
                      <div className="flex justify-between items-center text-[10px] border-t border-purple-200/50 pt-1">
                        <span>Compromisso Financeiro Total:</span>
                        <span className="font-extrabold text-xs">R$ {getReplicationsPreview().precoFinal.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}</span>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            </div>
          )}

          {/* RATEIO MULTI-CATEGORIA (REQUISITO 4.4 / 6.4 - SEMPRE CRIA ITEM FINANCEIRO) */}
          <div className="border-t border-slate-100 pt-4">
            <div className="flex items-center justify-between mb-3">
              <div>
                <span className="text-xs font-bold text-slate-800 block">Rateio por Categorias</span>
                <span className="text-[10px] text-slate-500 block">Classifique a transação em múltiplos centros de custo / categorias</span>
              </div>
              <button
                type="button"
                onClick={() => {
                  setIsRateioExpanded(!isRateioExpanded);
                  if (!isRateioExpanded && rateioLines.length <= 1) {
                    // Populate initial rateio list
                    const defaultCat = categorias.find(c => c.parentId !== null && c.ativo)?.id || '';
                    setRateioLines([
                      { categoriaId: defaultCat, centroCustoId: 'cc_geral', valor: Number((valorTotal * 0.7).toFixed(2)), percentual: 70 },
                      { categoriaId: categorias.find(c => c.parentId !== null && c.id !== defaultCat)?.id || defaultCat, centroCustoId: 'cc_geral', valor: Number((valorTotal * 0.3).toFixed(2)), percentual: 30 }
                    ]);
                  } else {
                    // Reduce to single item
                    updateSingleLineValue(valorTotal);
                  }
                }}
                className="text-[10px] font-bold text-teal-600 hover:text-teal-800 bg-teal-50 border border-teal-100 rounded-lg px-2.5 py-1 flex items-center gap-1 transition-all"
              >
                {isRateioExpanded ? 'Reduzir para Item Único' : 'Detalhar Rateio (Multi-Categoria)'}
              </button>
            </div>

            {isRateioExpanded && (
              <div className="bg-teal-50/20 border border-teal-100 rounded-xl p-4 space-y-3 animate-fade-in text-xs">
                {/* Lines header */}
                <div className="grid grid-cols-12 gap-2 text-[10px] font-bold text-slate-400 uppercase tracking-wider pb-1 border-b border-teal-100/30">
                  <span className="col-span-4">Categoria</span>
                  <span className="col-span-3">Centro de Custo</span>
                  <span className="col-span-2">Porcentagem (%)</span>
                  <span className="col-span-2">Valor (R$)</span>
                  <span className="col-span-1 text-center">Ação</span>
                </div>

                {/* Edit lines loop */}
                <div className="space-y-2">
                  {rateioLines.map((line, idx) => (
                    <div key={idx} className="grid grid-cols-12 gap-2 items-center">
                      {/* Categoria list */}
                      <select
                        value={line.categoriaId}
                        onChange={(e) => handleUpdateLine(idx, 'categoriaId', e.target.value)}
                        className="col-span-4 text-xs font-semibold px-2 py-1.5 border border-slate-200 rounded bg-white text-slate-800 focus:outline-none"
                      >
                        {categorias.filter(c => c.parentId !== null && c.ativo).map(c => (
                          <option key={c.id} value={c.id}>{c.descricao}</option>
                        ))}
                      </select>

                      {/* Centro de Custo */}
                      <select
                        value={line.centroCustoId}
                        onChange={(e) => handleUpdateLine(idx, 'centroCustoId', e.target.value)}
                        className="col-span-3 text-xs font-semibold px-2 py-1.5 border border-slate-200 rounded bg-white text-slate-800 focus:outline-none"
                      >
                        {centrosCusto.filter(cc => cc.ativo).map(cc => (
                          <option key={cc.id} value={cc.id}>{cc.descricao}</option>
                        ))}
                      </select>

                      {/* Percentual */}
                      <div className="col-span-2 relative">
                        <input
                          type="number"
                          placeholder="%"
                          min="0"
                          max="100"
                          step="0.1"
                          value={line.percentual || ''}
                          onChange={(e) => handleUpdateLine(idx, 'percentual', e.target.value)}
                          className="w-full text-xs font-mono font-bold pr-4 pl-2 py-1.5 border border-slate-200 rounded text-slate-800 text-right focus:outline-none"
                        />
                        <span className="absolute right-1 text-[10px] text-slate-400 top-2">%</span>
                      </div>

                      {/* Valor */}
                      <div className="col-span-2 relative">
                        <input
                          type="number"
                          placeholder="0,00"
                          step="0.01"
                          value={line.valor || ''}
                          onChange={(e) => handleUpdateLine(idx, 'valor', e.target.value)}
                          className="w-full text-xs font-mono font-bold pl-2 py-1.5 border border-slate-200 rounded text-slate-800 text-right focus:outline-none"
                        />
                      </div>

                      {/* Remove action button */}
                      <div className="col-span-1 text-center">
                        <button
                          type="button"
                          onClick={() => handleRemoveRateioLine(idx)}
                          disabled={rateioLines.length <= 1}
                          className="p-1 text-rose-500 hover:text-rose-700 hover:bg-rose-50 rounded transition-colors disabled:opacity-30 disabled:cursor-not-allowed"
                        >
                          <Trash2 size={13} />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Adding and spreading tools bar */}
                <div className="flex flex-wrap items-center justify-between gap-2 pt-2 border-t border-teal-100/30">
                  <button
                    type="button"
                    onClick={handleAddRateioLine}
                    className="flex items-center gap-1 text-[10px] font-bold text-teal-800 hover:text-teal-950 bg-white border border-teal-200 rounded px-2.5 py-1 shadow-xs cursor-pointer"
                  >
                    <Plus size={11} /> Adicionar categoria rateada
                  </button>
                  <div className="flex gap-2">
                    <button
                      type="button"
                      onClick={handleDistributeEvenly}
                      className="text-[10px] font-bold text-slate-600 hover:text-slate-800 bg-white border border-slate-200 rounded px-2 py-1 shadow-xs"
                    >
                      Dividir Igualmente
                    </button>
                    <button
                      type="button"
                      onClick={handleDistributeRemaining}
                      className="text-[10px] font-bold text-slate-600 hover:text-slate-800 bg-white border border-slate-200 rounded px-2 py-1 shadow-xs"
                    >
                      Ajustar última linha
                    </button>
                  </div>
                </div>

                {/* Validation status of Rateio */}
                <div className="bg-white px-3 py-2 border border-teal-100 rounded-lg flex justify-between items-center text-[10px] font-mono">
                  <div className="space-y-0.5">
                    <span className="text-slate-400 block uppercase font-bold text-[8px] tracking-wider">Status do Rateio</span>
                    <span className="text-slate-600">Soma: R$ {sumRateioValues.toLocaleString('pt-BR', { minimumFractionDigits: 2 })} de R$ {valorTotal.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}</span>
                  </div>
                  {rateioMatchesTotal ? (
                    <span className="text-emerald-600 font-extrabold uppercase tracking-wide">✓ Valores batem exatamente!</span>
                  ) : (
                    <span className="text-rose-600 font-extrabold uppercase tracking-wide">✗ Falta R$ {Math.abs(valorTotal - sumRateioValues).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}</span>
                  )}
                </div>
              </div>
            )}
          </div>

          {/* Observations and status check */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 border-t border-slate-150 pt-4">
            <div className="space-y-1">
              <label className="text-[11px] font-bold text-slate-500 uppercase tracking-wider block">Observações do Lançamento</label>
              <textarea
                id="dialog-obs-textarea"
                rows={2}
                value={observacao}
                onChange={(e) => setObservacao(e.target.value)}
                placeholder="Ex. Detalhes adicionais, local, etc."
                className="w-full text-xs font-medium text-slate-700 px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:border-emerald-500"
              />
            </div>

            <div className="flex flex-col justify-center space-y-4 px-1">
              {/* Recurrent entry */}
              <label className="flex items-center gap-2 cursor-pointer select-none">
                <input
                  id="dialog-recorrente-checkbox"
                  type="checkbox"
                  checked={recorrente}
                  onChange={(e) => setRecorrente(e.target.checked)}
                  className="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500 w-4 h-4"
                />
                <div>
                  <span className="text-xs font-bold text-slate-800 block">Lançamento Recorrente</span>
                  <span className="text-[10px] text-slate-500 block leading-none">Esta despesa se repete todos os meses de forma periódica</span>
                </div>
              </label>

              {/* Status toggle selector */}
              <div className="space-y-1">
                <span className="text-[11px] font-bold text-slate-500 uppercase tracking-wider block">Estágio de Conciliação</span>
                <div className="grid grid-cols-2 gap-1 bg-slate-150 p-0.5 rounded-lg border border-slate-250 w-full">
                  <button
                    type="button"
                    onClick={() => setStatus('PENDENTE')}
                    className={`py-1 text-[10px] font-black rounded-md transition-all ${
                      status === 'PENDENTE' ? 'bg-orange-500 text-white shadow-sm' : 'text-slate-500 hover:text-slate-700'
                    }`}
                  >
                    ⏳ Pendente (Agendado)
                  </button>
                  <button
                    type="button"
                    onClick={() => setStatus('CONSOLIDADO')}
                    className={`py-1 text-[10px] font-black rounded-md transition-all ${
                      status === 'CONSOLIDADO' ? 'bg-emerald-600 text-white shadow-sm' : 'text-slate-500 hover:text-slate-700'
                    }`}
                  >
                    ✓ Ativo (Consolidado)
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Modal Actions Footer */}
        <div className="bg-slate-50 px-6 py-4 border-t border-slate-200 flex justify-between items-center flex-shrink-0">
          <div className="text-[10px] font-bold text-slate-400">
            {evaluatedDoc.docStatus === 'FECHADA' ? (
              <span className="text-rose-600 font-extrabold">Competência Fechada</span>
            ) : isOrigemInativa ? (
              <span className="text-rose-600 font-extrabold">Origem Inativa</span>
            ) : (
              <span>Pronto para gravação no banco</span>
            )}
          </div>
          <div className="flex gap-2">
            <button
              type="button"
              onClick={onClose}
              className="bg-white hover:bg-slate-100 border border-slate-200 text-slate-700 text-xs font-bold px-4 py-2 rounded-lg transition-colors cursor-pointer"
            >
              Cancelar
            </button>
            <button
              type="button"
              onClick={handleSaveWrapper}
              disabled={isDocumentoFechado || isOrigemInativa || (isRateioExpanded && !rateioMatchesTotal)}
              className="bg-emerald-600 hover:bg-emerald-700 disabled:opacity-40 disabled:cursor-not-allowed text-white text-xs font-bold px-6 py-2 rounded-lg transition-colors cursor-pointer"
            >
              Confirmar Lançamento
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}