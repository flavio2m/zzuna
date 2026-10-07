class LoadedUserDto {
  final String id;
  final String name;
  final String email;
  final double orcamento;

  LoadedUserDto({
    required this.id,
    required this.name,
    required this.email,
    this.orcamento = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'orcamento': orcamento,
  };

  factory LoadedUserDto.fromJson(Map<String, dynamic> json) {
    return LoadedUserDto(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      orcamento: (json['orcamento'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
