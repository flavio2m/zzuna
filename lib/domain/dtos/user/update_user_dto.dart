class UpdateUserDto {
  final String id;
  final String name;
  final String email;

  UpdateUserDto({required this.id, required this.name, required this.email});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}
