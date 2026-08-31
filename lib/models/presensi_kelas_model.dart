class PresensiKelasModel {
  final String idKelas;
  final String namaKelas;
  final String tgl;
  final List<PresensiSiswaModel> siswaList;

  PresensiKelasModel({
    required this.idKelas,
    required this.namaKelas,
    required this.tgl,
    required this.siswaList,
  });

  factory PresensiKelasModel.fromJson(Map<String, dynamic> json) {
    final rawSiswa = json['siswa'];
    final siswa = rawSiswa is List
        ? rawSiswa
              .map(
                (item) =>
                    PresensiSiswaModel.fromJson(item as Map<String, dynamic>),
              )
              .toList()
        : <PresensiSiswaModel>[];

    return PresensiKelasModel(
      idKelas: json['id_kelas']?.toString() ?? '',
      namaKelas: json['nama_kelas']?.toString() ?? '',
      tgl: json['tgl']?.toString() ?? '',
      siswaList: siswa,
    );
  }
}

class PresensiSiswaModel {
  final String idSiswa;
  final String namaSiswa;
  final String? nis;
  final String? nisn;
  final String statusKehadiran;
  final String? waktuPresensi;

  PresensiSiswaModel({
    required this.idSiswa,
    required this.namaSiswa,
    this.nis,
    this.nisn,
    required this.statusKehadiran,
    this.waktuPresensi,
  });

  factory PresensiSiswaModel.fromJson(Map<String, dynamic> json) {
    return PresensiSiswaModel(
      idSiswa: json['id_siswa']?.toString() ?? '',
      namaSiswa: json['nama_siswa']?.toString() ?? '-',
      nis: json['nis']?.toString(),
      nisn: json['nisn']?.toString(),
      statusKehadiran: json['status_kehadiran']?.toString() ?? '-',
      waktuPresensi: json['waktu_presensi']?.toString(),
    );
  }
}
