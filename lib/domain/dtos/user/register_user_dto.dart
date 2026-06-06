class RegisterUserDto {
  String name;
  String email;
  String password;

  RegisterUserDto({
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
