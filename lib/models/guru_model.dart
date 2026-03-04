class GuruModel {
  final String id;
  final String nama;
  final String? nip;
  final String? nik;
  final String? email;
  final String? no_hp;
  final String? tempat_lahir;
  final String? tgl_lahir;
  final String? alamat;
  final String? rt;
  final String? rw;
  final String? kelurahan;
  final String? kecamatan;
  final String? kota;
  final String? provinsi;
  final String? tmt_cpns;
  final String? tmt_pns;
  final String? mapel;
  final String? pangkat;
  final String? golongan;
  final String? is_aktif;
  final String? teacherids;
  final String? foto;

  GuruModel({
    required this.id,
    required this.nama,
    this.nip,
    this.nik,
    this.email,
    this.no_hp,
    this.tempat_lahir,
    this.tgl_lahir,
    this.alamat,
    this.rt,
    this.rw,
    this.kelurahan,
    this.kecamatan,
    this.kota,
    this.provinsi,
    this.tmt_cpns,
    this.tmt_pns,
    this.mapel,
    this.pangkat,
    this.golongan,
    this.is_aktif,
    this.teacherids,
    this.foto,
  });

  factory GuruModel.fromJson(Map<String, dynamic> json) {
    return GuruModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      nip: json['nip'],
      nik: json['nik'],
      email: json['email'],
      no_hp: json['no_hp'],
      tempat_lahir: json['tempat_lahir'],
      tgl_lahir: json['tgl_lahir'],
      alamat: json['alamat'],
      rt: json['rt'],
      rw: json['rw'],
      kelurahan: json['kelurahan'],
      kecamatan: json['kecamatan'],
      kota: json['kota'],
      provinsi: json['provinsi'],
      tmt_cpns: json['tmt_cpns'],
      tmt_pns: json['tmt_pns'],
      mapel: json['mapel'],
      pangkat: json['pangkat'],
      golongan: json['golongan'],
      is_aktif: json['is_aktif'],
      teacherids: json['teacherids'],
      foto: json['foto'],
    );
  }

  /// Get formatted alamat (strip HTML tags)
  String get alamatBersih {
    if (alamat == null) return '-';
    return alamat!.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  /// Get full alamat with RT/RW
  String get alamatLengkap {
    final parts = <String>[];
    if (alamatBersih != '-') parts.add(alamatBersih);
    if (rt != null && rw != null) parts.add('RT $rt/RW $rw');
    if (kelurahan != null) parts.add(kelurahan!);
    if (kecamatan != null) parts.add(kecamatan!);
    if (kota != null) parts.add(kota!);
    if (provinsi != null) parts.add(provinsi!);
    return parts.isNotEmpty ? parts.join(', ') : '-';
  }
}
