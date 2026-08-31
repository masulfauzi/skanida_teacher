import 'package:flutter/material.dart';
import '../models/kelas_model.dart';
import '../services/jurnal_service.dart';
import 'presensi_kelas_view.dart';

class PresensiView extends StatefulWidget {
  const PresensiView({super.key});

  @override
  State<PresensiView> createState() => _PresensiViewState();
}

class _PresensiViewState extends State<PresensiView> {
  late Future<List<KelasModel>> _kelasFuture;

  @override
  void initState() {
    super.initState();
    _kelasFuture = JurnalService.getKelas();
  }

  void _reload() {
    setState(() {
      _kelasFuture = JurnalService.getKelas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presensi'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<KelasModel>>(
        future: _kelasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final kelasList = snapshot.data ?? [];

          if (kelasList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Tidak ada data kelas'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _reload,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.builder(
              itemCount: kelasList.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                final kelas = kelasList[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PresensiKelasView(
                            idKelas: kelas.id,
                            namaKelas: kelas.nama,
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.15),
                      child: Icon(
                        Icons.how_to_reg,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(
                      kelas.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: kelas.konsentrasiKeahlian.isNotEmpty
                        ? Text(kelas.konsentrasiKeahlian)
                        : null,
                    trailing: const Icon(Icons.chevron_right),
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
