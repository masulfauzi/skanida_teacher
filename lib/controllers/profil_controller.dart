import '../models/guru_model.dart';
import '../services/auth_service.dart';

class ProfilController {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  GuruModel? guru;

  /// Fetch guru profile from API
  Future<void> fetchProfil() async {
    isLoading = true;
    errorMessage = null;

    try {
      final token = await AuthService.getToken();
      final id_guru = await AuthService.getIdGuru();
      final result = await _authService.getProfilGuru(
        token: token ?? '',
        id_guru: id_guru ?? '',
      );

      isLoading = false;

      if (result['success'] == true) {
        final data = result['data'];
        guru = GuruModel.fromJson(data is Map<String, dynamic> ? data : {});
      } else {
        errorMessage = result['message']?.toString() ?? 'Gagal memuat profil';
      }
    } catch (e) {
      isLoading = false;
      errorMessage = 'Terjadi kesalahan: $e';
    }
  }
}
