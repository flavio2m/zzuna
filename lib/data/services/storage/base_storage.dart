import 'package:result_dart/result_dart.dart';

/// Tipo do valor pesquisado.
///
/// Utilizado pela implementação do Storage para realizar as conversões
/// necessárias (SharedPreferences, Firebase Realtime, etc.).
enum SearchFieldType { string, boolean, date, int }

/// Operador utilizado na pesquisa.
///
/// Exemplos:
///
/// Igual:
///   periodo == 202506
///
/// Menor ou igual:
///   periodo <= 202506
///
/// Maior ou igual:
///   periodo >= 202506
///
/// Intervalo:
///   data between [01/01, 31/01]
enum SearchOperator { equal, lessThan, lessThanOrEqual, greaterThan, greaterThanOrEqual, between }

/// Ordenação dos resultados.
enum SearchOrder { ascending, descending }

/// Representa um filtro de pesquisa.
///
/// Exemplos:
///
/// Igual:
/// SearchField(
///   fieldName: 'ano',
///   value: 2025,
///   type: SearchFieldType.int,
/// )
///
/// Maior ou igual:
/// SearchField(
///   fieldName: 'periodo',
///   value: 202506,
///   type: SearchFieldType.int,
///   operator: SearchOperator.greaterThanOrEqual,
/// )
///
/// Intervalo:
/// SearchField(
///   fieldName: 'data',
///   value: [inicio, fim],
///   type: SearchFieldType.date,
///   operator: SearchOperator.between,
/// )
class SearchField {
  final String fieldName;

  final dynamic value;

  final SearchFieldType type;

  final SearchOperator operator;

  const SearchField({
    required this.fieldName,
    required this.value,
    required this.type,
    this.operator = SearchOperator.equal,
  });
}

abstract class BaseStorage<T extends Object> {
  AsyncResult<T> create(T model);

  AsyncResult<T> update(T model);

  /// Atualização em lote.
  ///
  /// LocalStorage pode implementar chamando update() para cada item.
  /// Implementações futuras (Firebase, SQLite, etc.) poderão realizar
  /// operações atômicas ou batch.
  AsyncResult<Unit> updateAll(List<T> models);

  AsyncResult<Unit> delete(String id);

  AsyncResult<List<T>> getAll();

  AsyncResult<T> getById(String id);

  /// Pesquisa genérica.
  ///
  /// Exemplos:
  ///
  /// Buscar por igualdade:
  /// searchByFields([
  ///   SearchField(
  ///   fieldName: 'origemKey',
  ///   value: 'conta_123',
  ///   type: SearchFieldType.string,
  ///   ),
  /// ]);
  ///
  /// Buscar registros a partir de um período:
  /// searchByFields(
  ///   [
  ///     SearchField(
  ///       fieldName: 'periodo',
  ///       value: 202506,
  ///       type: SearchFieldType.int,
  ///       operator: SearchOperator.greaterThanOrEqual,
  ///     ),
  ///   ],
  ///   orderBy: 'periodo',
  /// );
  ///
  /// Buscar o último registro anterior:
  /// searchByFields(
  ///   [
  ///     SearchField(
  ///       fieldName: 'periodo',
  ///       value: 202506,
  ///       type: SearchFieldType.int,
  ///       operator: SearchOperator.lessThanOrEqual,
  ///     ),
  ///   ],
  ///   orderBy: 'periodo',
  ///   order: SearchOrder.descending,
  ///   limit: 1,
  /// );
  ///
  /// Buscar os três primeiros registros:
  /// searchByFields(
  ///   const [],
  ///   orderBy: 'periodo',
  ///   limit: 3,
  /// );
  ///
  /// No SharedPreferences essas opções podem ser aplicadas em memória.
  /// No Firebase Realtime elas poderão ser convertidas para:
  /// - orderByChild(...)
  /// - startAt(...)
  /// - endAt(...)
  /// - limitToFirst(...)
  /// - limitToLast(...)
  AsyncResult<List<T>> searchByFields(
    List<SearchField> fields, {
    String? orderBy,
    SearchOrder order = SearchOrder.ascending,
    int? limit,
  });
}
