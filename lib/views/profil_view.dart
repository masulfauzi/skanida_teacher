import 'package:flutter/material.dart';
import '../controllers/profil_controller.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  final ProfilController _controller = ProfilController();

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    setState(() {});
    await _controller.fetchProfil();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Guru'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _controller.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProfil,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final guru = _controller.guru;
    if (guru == null) {
      return const Center(child: Text('Data tidak ditemukan'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: guru.foto != null
                ? NetworkImage(guru.foto!)
                : null,
            child: guru.foto == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            guru.nama,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            guru.nip ?? '-',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Data Pribadi'),
          _buildInfoCard(context, [
            _buildInfoRow('NIP', guru.nip ?? '-'),
            _buildInfoRow('NIK', guru.nik ?? '-'),
            _buildInfoRow('Email', guru.email ?? '-'),
            _buildInfoRow('No. HP', guru.no_hp ?? '-'),
            _buildInfoRow('Tempat Lahir', guru.tempat_lahir ?? '-'),
            _buildInfoRow('Tgl. Lahir', guru.tgl_lahir ?? '-'),
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle('Alamat'),
          _buildInfoCard(context, [
            _buildInfoRow('Alamat', guru.alamatLengkap),
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle('Kepegawaian'),
          _buildInfoCard(context, [
            _buildInfoRow('Mapel', guru.mapel ?? '-'),
            _buildInfoRow('Pangkat', guru.pangkat ?? '-'),
            _buildInfoRow('Golongan', guru.golongan ?? '-'),
            _buildInfoRow('TMT CPNS', guru.tmt_cpns ?? '-'),
            _buildInfoRow('TMT PNS', guru.tmt_pns ?? '-'),
            _buildInfoRow(
              'Status',
              guru.is_aktif == '1' ? 'Aktif' : 'Tidak Aktif',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
