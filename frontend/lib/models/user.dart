class User {
  int? id;
  String name;
  String role;
  String noTelp;
  String alamat;
  String email;

  User(
      {this.id,
      required this.name,
      required this.role,
      required this.noTelp,
      required this.alamat,
      required this.email});

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        role: json['role'],
        noTelp: json['no_telp'],
        alamat: json['alamat'],
        email: json['email']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'no_telp': noTelp,
      'alamat': alamat,
      'email': email
    };
  }
}
