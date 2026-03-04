import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/jurnal_model.dart';
import '../models/kelas_model.dart';
import '../models/mapel_model.dart';
import 'auth_service.dart';

class JurnalService {
  static const String _baseUrl = 'https://apps.smkn2semarang.sch.id/api';

  static Future<Map<String, dynamic>> getJurnal({int page = 1}) async {
    final token = await AuthService.getToken();
    final idGuru = await AuthService.getIdGuru();

    if (token == null || idGuru == null) {
      return {
        'success': false,
        'message': 'Token atau ID Guru tidak ditemukan',
        'data': <JurnalModel>[],
        'currentPage': 1,
        'lastPage': 1,
        'total': 0,
      };
    }

    final url = Uri.parse('$_baseUrl/jurnal?id_guru=$idGuru&page=$page');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('=== JURNAL DEBUG ===');
      debugPrint('URL: $url');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('====================');

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final dynamic rawData = body['data'];
        List<dynamic> rawList = [];
        int currentPage = 1;
        int lastPage = 1;
        int total = 0;

        if (rawData is Map) {
          // Paginated response: data.data contains the list
          rawList = rawData['data'] is List ? rawData['data'] : [];
          currentPage = rawData['current_page'] ?? 1;
          lastPage = rawData['last_page'] ?? 1;
          total = rawData['total'] ?? 0;
        } else if (rawData is List) {
          rawList = rawData;
        }

        final jurnalList = rawList
            .map((item) => JurnalModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return {
          'success': true,
          'data': jurnalList,
          'currentPage': currentPage,
          'lastPage': lastPage,
          'total': total,
          'message': body['message'] ?? 'Berhasil',
        };
      } else {
        return {
          'success': false,
          'data': <JurnalModel>[],
          'currentPage': 1,
          'lastPage': 1,
          'total': 0,
          'message':
              body['message'] ?? 'Gagal memuat jurnal (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'data': <JurnalModel>[],
        'currentPage': 1,
        'lastPage': 1,
        'total': 0,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> createJurnal({
    required String hari,
    required String kelas,
    required String jamMulai,
    required String jamSelesai,
    required String mapel,
    required String tglPembelajaran,
    required String materi,
    String? catatan,
  }) async {
    final token = await AuthService.getToken();
    final idGuru = await AuthService.getIdGuru();

    if (token == null || idGuru == null) {
      return {
        'success': false,
        'message': 'Token atau ID Guru tidak ditemukan',
      };
    }

    final url = Uri.parse('$_baseUrl/jurnal');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id_guru': idGuru,
          'hari': hari,
          'kelas': kelas,
          'jam_mulai': jamMulai,
          'jam_selesai': jamSelesai,
          'mapel': mapel,
          'tgl_pembelajaran': tglPembelajaran,
          'materi': materi,
          'catatan': catatan ?? '',
        }),
      );

      debugPrint('=== CREATE JURNAL DEBUG ===');
      debugPrint('URL: $url');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('============================');

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': body['message'] ?? 'Jurnal berhasil disimpan',
        };
      } else {
        return {
          'success': false,
          'message':
              body['message'] ??
              'Gagal menyimpan jurnal (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  static Future<List<KelasModel>> getKelas() async {
    final token = await AuthService.getToken();

    if (token == null) return [];

    final url = Uri.parse('$_baseUrl/kelas');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('=== KELAS DEBUG ===');
      debugPrint('URL: $url');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('====================');

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final dynamic rawData = body['data'] ?? body;
        List<dynamic> rawList;

        if (rawData is List) {
          rawList = rawData;
        } else if (rawData is Map && rawData.containsKey('data')) {
          rawList = rawData['data'] is List ? rawData['data'] : [];
        } else {
          rawList = [];
        }

        return rawList
            .map((item) => KelasModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching kelas: $e');
    }

    return [];
  }

  static Future<List<MapelModel>> getMapel() async {
    final token = await AuthService.getToken();

    if (token == null) return [];

    final url = Uri.parse('$_baseUrl/mapel');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('=== MAPEL DEBUG ===');
      debugPrint('URL: $url');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('====================');

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final dynamic rawData = body['data'] ?? body;
        List<dynamic> rawList;

        if (rawData is List) {
          rawList = rawData;
        } else if (rawData is Map && rawData.containsKey('data')) {
          rawList = rawData['data'] is List ? rawData['data'] : [];
        } else {
          rawList = [];
        }

        return rawList
            .map((item) => MapelModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching mapel: $e');
    }

    return [];
  }
}
