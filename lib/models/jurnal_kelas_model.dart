class JurnalKelasModel {
  final String idKelas;
  final String namaKelas;
  final String tgl;
  final List<JurnalKelasEntryModel> jurnalList;

  JurnalKelasModel({
    required this.idKelas,
    required this.namaKelas,
    required this.tgl,
    required this.jurnalList,
  });

  factory JurnalKelasModel.fromJson(Map<String, dynamic> json) {
    final rawJurnal = json['jurnal'];
    final jurnal = rawJurnal is List
        ? rawJurnal
              .map(
                (item) =>
                    JurnalKelasEntryModel.fromJson(item as Map<String, dynamic>),
              )
              .toList()
        : <JurnalKelasEntryModel>[];

    return JurnalKelasModel(
      idKelas: json['id_kelas']?.toString() ?? '',
      namaKelas: json['nama_kelas']?.toString() ?? '',
      tgl: json['tgl']?.toString() ?? '',
      jurnalList: jurnal,
    );
  }
}

class JurnalKelasEntryModel {
  final String id;
  final String namaGuru;
  final String mapel;
  final int? jamMulai;
  final int? jamSelesai;
  final String? materi;
  final String? catatan;

  JurnalKelasEntryModel({
    required this.id,
    required this.namaGuru,
    required this.mapel,
    this.jamMulai,
    this.jamSelesai,
    this.materi,
    this.catatan,
  });

  factory JurnalKelasEntryModel.fromJson(Map<String, dynamic> json) {
    return JurnalKelasEntryModel(
      id: json['id']?.toString() ?? '',
      namaGuru: json['nama_guru']?.toString() ?? '-',
      mapel: json['mapel']?.toString() ?? '-',
      jamMulai: json['jam_mulai'] is int
          ? json['jam_mulai'] as int
          : int.tryParse(json['jam_mulai']?.toString() ?? ''),
      jamSelesai: json['jam_selesai'] is int
          ? json['jam_selesai'] as int
          : int.tryParse(json['jam_selesai']?.toString() ?? ''),
      materi: json['materi']?.toString(),
      catatan: json['catatan']?.toString(),
    );
  }
}
