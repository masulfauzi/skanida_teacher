# CLAUDE.md

Aplikasi Flutter **Skanida Teacher** untuk guru SMK Negeri 2 Semarang: jurnal mengajar, presensi siswa, jurnal kelas, dan persetujuan ijin siswa. Backend: REST API Laravel di `https://apps.smkn2semarang.sch.id/api` (bukan bagian repo ini).

## Perintah
- `flutter pub get` — install dependency
- `flutter run` — jalankan app
- `flutter analyze` — lint (`flutter_lints`, lihat `analysis_options.yaml`)
- `flutter test` — catatan: `test/widget_test.dart` masih template counter bawaan dan akan gagal; belum ada test nyata
- `dart run flutter_launcher_icons` — generate ikon dari `assets/images/skanida_teacher.png`

## Arsitektur (`lib/`)
- `main.dart` — inisialisasi `AuthService.init()` & `DateHelper.init()`, lalu `MaterialApp` dengan named routes (`/home`, `/login`, `/profil`, `/jurnal`, `/jurnal/create`, `/ijin-siswa`, `/presensi`, `/jurnal-kelas`, `/about`) dan `onGenerateRoute` untuk `/jurnal/detail` (argumen: id jurnal).
- `screens/splash_screen.dart` — delay 2 detik, cek `AuthService.isLoggedIn()` → `/home` atau `/login`.
- `views/` — semua layar, `StatefulWidget` + `setState` (tidak ada state-management library). Layar turunan (detail ijin, presensi kelas, jurnal kelas detail) dibuka via `MaterialPageRoute` langsung, bukan named route.
- `services/` — akses API, semua method `static` (kecuali `loginGuru`/`getProfilGuru` di `AuthService` yang instance method):
  - `auth_service.dart` — login (`POST /login-guru`), profil guru, dan sesi di `SharedPreferences` (`logged_in`, `token`, `user_name`, `id_guru`).
  - `jurnal_service.dart` — jurnal (list berpaginasi, create, detail), kelas, mapel, presensi kelas, jurnal kelas, ubah status presensi (`PUT /presensi/{id}`).
  - `ijin_siswa_service.dart` — daftar ijin, detail (`/keluar-kelas/{id}`), approve (`PATCH /keluar-kelas/{id}/approve`).
- `controllers/` — hanya dipakai untuk login & profil (`LoginController`, `ProfilController`); `home_controller.dart` tidak terpakai.
- `models/` — model plain dengan `factory fromJson` yang toleran null (`json['x']?.toString()`).
- `helpers/date_helper.dart` — format tanggal locale `id_ID` (`formatTanggal`, `formatDate`, `formatShort`).

## Konvensi
- **Pola service**: ambil `token`/`id_guru` dari `AuthService`, panggil `http` dengan header `Accept`/`Content-Type: application/json` + `Authorization: Bearer $token`, `log()` URL/status/body, lalu kembalikan `Map<String, dynamic>` berbentuk `{'success': bool, 'message': String, 'data': ...}`. Error jaringan ditangkap dan dikembalikan sebagai `success: false` ("Tidak dapat terhubung ke server: $e"), bukan di-throw. Ikuti pola ini untuk endpoint baru.
- Respons berpaginasi Laravel: list ada di `data.data`, meta di `data.current_page` / `data.last_page` / `data.total`; kode juga menangani `data` berupa list langsung.
- `_baseUrl` diduplikasi di tiap service — jika menambah service, pakai URL yang sama.
- Teks UI, pesan error, dan nama field berbahasa Indonesia; nama field mengikuti API (snake_case, mis. `id_guru`, `tgl_pembelajaran`).
- `JurnalDetailView` punya flag `readOnly`; dari Jurnal Kelas dibuka dengan `readOnly: true` sehingga status kehadiran tidak bisa diubah.
- Sebelum memakai `context` setelah `await`, cek `mounted` / `context.mounted`.
- Pesan commit: Conventional Commits berbahasa Indonesia (`feat: ...`, `fix: ...`).
