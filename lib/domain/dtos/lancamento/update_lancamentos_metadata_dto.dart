class UpdateLancamentosMetadataDto {
  final String id;
  final String descricao;
  final String? observacao;

  UpdateLancamentosMetadataDto({
    required this.id,
    required this.descricao,
    this.observacao,
  });
}
