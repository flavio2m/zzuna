class Credentials {
  String email;
  String password;

  Credentials({
    this.email = '', this.password = '',
  });

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }
}
