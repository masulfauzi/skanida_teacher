import 'package:flutter/foundation.dart';

class JurnalModel {
  final String? id;
  final String? kelas;
  final String? tanggal;
  final String? mapel;

  JurnalModel({this.id, this.kelas, this.tanggal, this.mapel});

  factory JurnalModel.fromJson(Map<String, dynamic> json) {
    debugPrint(
      '=== JURNAL fromJson: id=${json['id']}, keys=${json.keys.toList()} ===',
    );
    return JurnalModel(
      id: json['id']?.toString(),
      kelas: json['kelas']?.toString(),
      tanggal: json['tgl_pembelajaran']?.toString(),
      mapel: json['mapel']?.toString(),
    );
  }
}
