import 'package:flutter/material.dart';
import '../services/ijin_siswa_service.dart';

class IjinSiswaDetailView extends StatefulWidget {
  final String id;

  const IjinSiswaDetailView({super.key, required this.id});

  @override
  State<IjinSiswaDetailView> createState() => _IjinSiswaDetailViewState();
}

class _IjinSiswaDetailViewState extends State<IjinSiswaDetailView> {
  Map<String, dynamic>? _detail;
  bool _isLoading = true;
  bool _isApproving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await IjinSiswaService.getDetailIjinSiswa(widget.id);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success'] == true) {
          _detail = result['data'] as Map<String, dynamic>?;
        } else {
          _errorMessage = result['message'] as String?;
        }
      });
    }
  }

  Future<void> _confirmApprove() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Setujui Ijin'),
        content: const Text('Apakah Anda yakin ingin menyetujui ijin ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Setujui'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _approve();
    }
  }

  Future<void> _approve() async {
    setState(() => _isApproving = true);

    final result = await IjinSiswaService.approveIjinSiswa(widget.id);

    if (!mounted) return;
    setState(() => _isApproving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] as String),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );

    if (result['success'] == true) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValidGuru =
        _detail != null &&
        (_detail!['is_valid_guru'] == '1' || _detail!['is_valid_guru'] == 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Ijin Siswa'),
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
                    onPressed: _loadDetail,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadDetail,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _detail?['nama_siswa']?.toString() ?? '-',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(height: 24),
                          _detailRow(
                            Icons.assignment,
                            'Jenis Ijin',
                            _detail?['jenis_ijin_keluar_kelas']?.toString() ??
                                '-',
                          ),
                          _detailRow(
                            Icons.calendar_today,
                            'Tanggal',
                            _detail?['tanggal']?.toString() ?? '-',
                          ),
                          _detailRow(
                            Icons.access_time,
                            'Jam',
                            'Jam ke-${_detail?['jam_keluar_pelajaran'] ?? '-'} s/d ${_detail?['jam_kembali_pelajaran'] ?? '-'}',
                          ),
                          _detailRow(
                            Icons.notes,
                            'Keperluan',
                            _detail?['keperluan']?.toString() ?? '-',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _statusBadge('Guru', isValidGuru)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _statusBadge(
                          'BK',
                          _detail?['is_valid_bk'] == '1' ||
                              _detail?['is_valid_bk'] == 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isApproving
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (_isApproving || isValidGuru)
                              ? null
                              : _confirmApprove,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: _isApproving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  isValidGuru ? 'Sudah Disetujui' : 'Setujui',
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _statusBadge(String label, bool isValid) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isValid ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: ${isValid ? 'Disetujui' : 'Menunggu'}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isValid ? Colors.green[700] : Colors.red[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
