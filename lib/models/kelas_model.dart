class KelasModel {
  final String id;
  final String nama;
  final String konsentrasiKeahlian;

  KelasModel({
    required this.id,
    required this.nama,
    this.konsentrasiKeahlian = '',
  });

  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? json['kelas']?.toString() ?? '',
      konsentrasiKeahlian: json['konsentrasi_keahlian']?.toString() ?? '',
    );
  }

  @override
  String toString() => nama;
}
