class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? identitas;
  final String? id_guru;
  final String? token;
  final String? foto;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.identitas,
    this.id_guru,
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
      id_guru: json['id_guru'],
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
      'id_guru': id_guru,
      'token': token,
      'foto': foto,
    };
  }
}
