import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  String _version = '-';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = '${info.version} (${info.buildNumber})';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Image(
              image: AssetImage('assets/images/skanida.png'),
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 16),
            const Text(
              'Skanida Teacher',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Versi $_version',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Tentang Aplikasi'),
            _buildInfoCard(context, [
              const Text(
                'Skanida Teacher adalah aplikasi untuk guru SMK Negeri 2 '
                'Semarang dalam mengelola jurnal mengajar, presensi siswa, '
                'jurnal kelas, dan persetujuan ijin siswa.',
                style: TextStyle(fontSize: 15),
              ),
            ]),
            const SizedBox(height: 16),
            _buildSectionTitle('Fitur'),
            _buildInfoCard(context, [
              _buildFeatureRow(context, Icons.person, 'Data Guru'),
              _buildFeatureRow(context, Icons.list_alt, 'Jurnal Mengajar'),
              _buildFeatureRow(context, Icons.assignment, 'Ijin Siswa'),
              _buildFeatureRow(context, Icons.how_to_reg, 'Presensi'),
              _buildFeatureRow(context, Icons.menu_book, 'Jurnal Kelas'),
            ]),
            const SizedBox(height: 16),
            _buildSectionTitle('Informasi'),
            _buildInfoCard(context, [
              _buildInfoRow('Sekolah', 'SMK Negeri 2 Semarang'),
              _buildInfoRow('Website', 'apps.smkn2semarang.sch.id'),
            ]),
            const SizedBox(height: 24),
            Text(
              '© ${DateTime.now().year} SMK Negeri 2 Semarang',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
          ],
        ),
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
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
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
