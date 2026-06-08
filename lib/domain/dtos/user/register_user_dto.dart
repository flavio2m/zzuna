class RegisterUserDto {
  String? id; // Pode ter um ID, necessário para gerar o ID no repositório

  String name;
  String email;
  String password;

  RegisterUserDto({
    this.id,
    required this.name,
    required this.email,
    required this.password, //
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

  Map<String, dynamic> toJson() => {
    'name': name, 'email': email, 'password': password, //
  };
}
