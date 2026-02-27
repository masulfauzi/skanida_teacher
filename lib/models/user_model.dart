class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? identitas;
  final String? idGuru;
  final String? token;
  final String? foto;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.identitas,
    this.idGuru,
    this.token,
    this.foto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      identitas: json['identitas'],
      idGuru: json['id_guru'],
      token: token ?? json['token'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'identitas': identitas,
      'id_guru': idGuru,
      'token': token,
      'foto': foto,
    };
  }
}
