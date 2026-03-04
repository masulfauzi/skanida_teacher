class KelasModel {
  final String id;
  final String nama;

  KelasModel({required this.id, required this.nama});

  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? json['kelas']?.toString() ?? '',
    );
  }

  @override
  String toString() => nama;
}
