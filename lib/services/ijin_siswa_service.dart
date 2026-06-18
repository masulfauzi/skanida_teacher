import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class IjinSiswaService {
  static const String _baseUrl = 'https://apps.smkn2semarang.sch.id/api';

  static Future<Map<String, dynamic>> getDaftarIjinSiswa() async {
    final token = await AuthService.getToken();
    final idGuru = await AuthService.getIdGuru();

    if (token == null) {
      return {'success': false, 'message': 'Token tidak ditemukan', 'data': []};
    }

    final url = Uri.parse('$_baseUrl/daftar-ijin-siswa?id_guru=$idGuru');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('=== IJIN SISWA DEBUG ===');
      log('URL: $url');
      log('Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');
      log('========================');

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'] ?? 'Data berhasil diambil',
          'data': body['data'] ?? [],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal mengambil data',
          'data': [],
        };
      }
    } catch (e) {
      log('Error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: $e', 'data': []};
    }
  }

  static Future<Map<String, dynamic>> getDetailIjinSiswa(String id) async {
    final token = await AuthService.getToken();

    if (token == null) {
      return {
        'success': false,
        'message': 'Token tidak ditemukan',
        'data': null,
      };
    }

    final url = Uri.parse('$_baseUrl/keluar-kelas/$id');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('=== DETAIL IJIN SISWA DEBUG ===');
      log('URL: $url');
      log('Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');
      log('===============================');

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'] ?? 'Data berhasil diambil',
          'data': body['data'],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal mengambil data',
          'data': null,
        };
      }
    } catch (e) {
      log('Error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
        'data': null,
      };
    }
  }

  static Future<Map<String, dynamic>> approveIjinSiswa(String id) async {
    final token = await AuthService.getToken();

    if (token == null) {
      return {'success': false, 'message': 'Token tidak ditemukan'};
    }

    final url = Uri.parse('$_baseUrl/keluar-kelas/$id/approve');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('=== APPROVE IJIN SISWA DEBUG ===');
      log('URL: $url');
      log('Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');
      log('================================');

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'] ?? 'Ijin berhasil disetujui',
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal menyetujui ijin',
        };
      }
    } catch (e) {
      log('Error: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
