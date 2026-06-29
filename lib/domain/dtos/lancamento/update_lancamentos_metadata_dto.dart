class UpdateLancamentosMetadataDto {
  final List<String> ids;
  final String? descricao;
  final String? observacao;

  UpdateLancamentosMetadataDto({
    required this.ids,
    this.descricao,
    this.observacao,
  });
}
