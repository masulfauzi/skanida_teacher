import 'package:flutter/material.dart';
import '../helpers/date_helper.dart';
import '../models/presensi_kelas_model.dart';
import '../services/jurnal_service.dart';

class PresensiKelasView extends StatefulWidget {
  final String idKelas;
  final String namaKelas;

  const PresensiKelasView({
    super.key,
    required this.idKelas,
    required this.namaKelas,
  });

  @override
  State<PresensiKelasView> createState() => _PresensiKelasViewState();
}

class _PresensiKelasViewState extends State<PresensiKelasView> {
  PresensiKelasModel? _data;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await JurnalService.getPresensiKelas(widget.idKelas);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success'] == true) {
          _data = result['data'] as PresensiKelasModel;
        } else {
          _errorMessage = result['message'] as String?;
        }
      });
    }
  }

  String _displayStatus(String status) {
    if (status.toUpperCase() == 'BELUM PRESENSI') return 'Tidak Hadir';
    return status;
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'H':
      case 'HADIR':
        return Colors.green[100]!;
      case 'S':
      case 'SAKIT':
        return Colors.orange[100]!;
      case 'I':
      case 'IZIN':
        return Colors.blue[100]!;
      case 'A':
      case 'ALPHA':
      case 'ALPA':
      case 'BELUM PRESENSI':
      case 'TIDAK HADIR':
        return Colors.red[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Color _statusTextColor(String status) {
    switch (status.toUpperCase()) {
      case 'H':
      case 'HADIR':
        return Colors.green[800]!;
      case 'S':
      case 'SAKIT':
        return Colors.orange[800]!;
      case 'I':
      case 'IZIN':
        return Colors.blue[800]!;
      case 'A':
      case 'ALPHA':
      case 'ALPA':
      case 'BELUM PRESENSI':
      case 'TIDAK HADIR':
        return Colors.red[800]!;
      default:
        return Colors.grey[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaKelas),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateHelper.formatTanggal(_data?.tgl),
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.people, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Daftar Siswa (${_data?.siswaList.length ?? 0})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_data == null || _data!.siswaList.isEmpty)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Belum ada data siswa',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(_data!.siswaList.length, (index) {
                      final siswa = _data!.siswaList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            siswa.namaSiswa,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: (siswa.nis != null && siswa.nis!.isNotEmpty)
                              ? Text('NIS: ${siswa.nis}')
                              : null,
                          trailing: Chip(
                            label: Text(
                              _displayStatus(siswa.statusKehadiran),
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: _statusColor(
                              siswa.statusKehadiran,
                            ),
                            labelStyle: TextStyle(
                              color: _statusTextColor(siswa.statusKehadiran),
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
