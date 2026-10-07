class RegisterUserDto {
  String? id; // Pode ter um ID, necessário para gerar o ID no repositório

  String name;
  String email;
  String password;
  double orcamento;

  RegisterUserDto({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.orcamento = 0.0,
  });

  void setName(String name) {
    this.name = name;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void setOrcamento(double orcamento) {
    this.orcamento = orcamento;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'orcamento': orcamento,
  };
}
