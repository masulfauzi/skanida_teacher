class MapelModel {
  final String id;
  final String nama;

  MapelModel({required this.id, required this.nama});

  factory MapelModel.fromJson(Map<String, dynamic> json) {
    return MapelModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? json['mapel']?.toString() ?? '',
    );
  }

  @override
  String toString() => nama;
}
