import 'package:flutter/material.dart';
import '../services/ijin_siswa_service.dart';
import 'ijin_siswa_detail_view.dart';

class IjinSiswaView extends StatefulWidget {
  const IjinSiswaView({super.key});

  @override
  State<IjinSiswaView> createState() => _IjinSiswaViewState();
}

class _IjinSiswaViewState extends State<IjinSiswaView> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = IjinSiswaService.getDaftarIjinSiswa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ijin Siswa'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? {};
          final success = data['success'] as bool? ?? false;
          final message = data['message'] as String? ?? '';
          final items = data['data'] as List<dynamic>? ?? [];

          if (!success) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(message),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dataFuture = IjinSiswaService.getDaftarIjinSiswa();
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Tidak ada data ijin siswa'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              setState(() {
                _dataFuture = IjinSiswaService.getDaftarIjinSiswa();
              });
              return _dataFuture;
            },
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final item = items[index] as Map<String, dynamic>;
                final id = item['id']?.toString() ?? '';
                final namaSiswa = item['nama_siswa'] ?? 'N/A';
                final keperluan = item['keperluan'] ?? '-';
                final tanggal = item['tanggal'] ?? '-';
                final jenisIjin = item['jenis_ijin_keluar_kelas'] ?? '-';
                final jamKeluarPelajaran = item['jam_keluar_pelajaran'];
                final jamKembaliPelajaran = item['jam_kembali_pelajaran'];
                final isValidGuru =
                    item['is_valid_guru'] == '1' || item['is_valid_guru'] == 1;
                final isValidBk =
                    item['is_valid_bk'] == '1' || item['is_valid_bk'] == 1;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () async {
                      final refreshed = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (_) => IjinSiswaDetailView(id: id),
                        ),
                      );
                      if (refreshed == true) {
                        setState(() {
                          _dataFuture = IjinSiswaService.getDaftarIjinSiswa();
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  namaSiswa.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Jenis: $jenisIjin',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Keperluan: $keperluan',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tanggal: $tanggal',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Jam Pelajaran: $jamKeluarPelajaran - $jamKembaliPelajaran',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isValidGuru
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Guru: ${isValidGuru ? 'Disetujui' : 'Menunggu'}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isValidGuru
                                          ? Colors.green[700]
                                          : Colors.red[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isValidBk
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'BK: ${isValidBk ? 'Disetujui' : 'Menunggu'}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isValidBk
                                          ? Colors.green[700]
                                          : Colors.red[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
