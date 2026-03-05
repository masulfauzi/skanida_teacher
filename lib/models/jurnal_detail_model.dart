class JurnalDetailModel {
  final String? id;
  final String? hari;
  final String? kelas;
  final String? jamMulai;
  final String? jamSelesai;
  final String? mapel;
  final String? tglPembelajaran;
  final String? materi;
  final String? catatan;
  final List<SiswaModel> siswaList;

  JurnalDetailModel({
    this.id,
    this.hari,
    this.kelas,
    this.jamMulai,
    this.jamSelesai,
    this.mapel,
    this.tglPembelajaran,
    this.materi,
    this.catatan,
    this.siswaList = const [],
  });

  factory JurnalDetailModel.fromJson(
    Map<String, dynamic> json, {
    List<dynamic>? presensi,
  }) {
    List<SiswaModel> siswa = [];
    final rawList = presensi ?? json['presensi'];
    if (rawList != null && rawList is List) {
      siswa = rawList
          .map((item) => SiswaModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return JurnalDetailModel(
      id: json['id']?.toString(),
      hari: json['hari']?.toString(),
      kelas: json['kelas']?.toString(),
      jamMulai: json['jam_mulai']?.toString(),
      jamSelesai: json['jam_selesai']?.toString(),
      mapel: json['mapel']?.toString(),
      tglPembelajaran: json['tgl_pembelajaran']?.toString(),
      materi: json['materi']?.toString(),
      catatan: json['catatan']?.toString(),
      siswaList: siswa,
    );
  }
}

class SiswaModel {
  final String? idPresensi;
  final String? nama;
  String? statusKehadiran;

  SiswaModel({this.idPresensi, this.nama, this.statusKehadiran});

  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      idPresensi: json['id_presensi']?.toString(),
      nama: json['nama_siswa']?.toString(),
      statusKehadiran: json['status_kehadiran_pendek']?.toString(),
    );
  }
}
