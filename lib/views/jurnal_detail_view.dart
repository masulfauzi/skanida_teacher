import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../helpers/date_helper.dart';
import '../models/jurnal_detail_model.dart';
import '../services/jurnal_service.dart';

class JurnalDetailView extends StatefulWidget {
  final String jurnalId;

  const JurnalDetailView({super.key, required this.jurnalId});

  @override
  State<JurnalDetailView> createState() => _JurnalDetailViewState();
}

class _JurnalDetailViewState extends State<JurnalDetailView> {
  JurnalDetailModel? _detail;
  bool _isLoading = true;
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

    final result = await JurnalService.getJurnalDetail(widget.jurnalId);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success'] == true) {
          _detail = result['data'] as JurnalDetailModel;
        } else {
          _errorMessage = result['message'] as String?;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Jurnal'),
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
                  // ── Jurnal Detail Card ──
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
                            _detail?.mapel ?? '-',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(height: 24),
                          _detailRow(
                            Icons.calendar_today,
                            'Tanggal',
                            DateHelper.formatTanggal(_detail?.tglPembelajaran),
                          ),
                          _detailRow(
                            Icons.class_,
                            'Kelas',
                            _detail?.kelas ?? '-',
                          ),
                          _detailRow(
                            Icons.access_time,
                            'Jam',
                            'Jam ke-${_detail?.jamMulai ?? '-'} s/d ${_detail?.jamSelesai ?? '-'}',
                          ),
                          _htmlDetailRow(
                            Icons.subject,
                            'Materi',
                            _detail?.materi ?? '-',
                          ),
                          if (_detail?.catatan != null &&
                              _detail!.catatan!.isNotEmpty)
                            _htmlDetailRow(
                              Icons.note,
                              'Catatan',
                              _detail!.catatan!,
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Students Section ──
                  Row(
                    children: [
                      Icon(Icons.people, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Daftar Siswa (${_detail?.siswaList.length ?? 0})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_detail == null || _detail!.siswaList.isEmpty)
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
                    ...List.generate(_detail!.siswaList.length, (index) {
                      final siswa = _detail!.siswaList[index];
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
                            siswa.nama ?? '-',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: GestureDetector(
                            onTap: () => _showStatusDialog(index),
                            child: Chip(
                              label: Text(
                                siswa.statusKehadiran ?? '-',
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: _keteranganColor(
                                siswa.statusKehadiran,
                              ),
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

  void _showStatusDialog(int index) {
    final siswa = _detail!.siswaList[index];
    final statusOptions = [
      {'value': 'H', 'label': 'Hadir', 'color': Colors.green[100]!},
      {'value': 'S', 'label': 'Sakit', 'color': Colors.orange[100]!},
      {'value': 'I', 'label': 'Izin', 'color': Colors.blue[100]!},
      {'value': 'A', 'label': 'Alpha', 'color': Colors.red[100]!},
    ];

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Ubah Status Kehadiran'),
        children: statusOptions.map((option) {
          return SimpleDialogOption(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final newStatus = option['value'] as String;
              final oldStatus = siswa.statusKehadiran;

              // Update UI immediately
              setState(() {
                siswa.statusKehadiran = newStatus;
              });

              // Call API
              final result = await JurnalService.ubahStatusPresensi(
                idPresensi: siswa.idPresensi ?? '',
                status: newStatus,
              );

              if (mounted) {
                if (result['success'] == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message'] as String),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Revert on failure
                  setState(() {
                    siswa.statusKehadiran = oldStatus;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message'] as String),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: option['color'] as Color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    option['value'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  option['label'] as String,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }).toList(),
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
            width: 80,
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

  Widget _htmlDetailRow(IconData icon, String label, String value) {
    final hasHtml = RegExp(r'<[^>]+>').hasMatch(value);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: hasHtml
                ? Html(
                    data: value,
                    style: {
                      'body': Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(14),
                      ),
                    },
                  )
                : Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Color _keteranganColor(String? keterangan) {
    switch (keterangan?.toUpperCase()) {
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
        return Colors.red[100]!;
      default:
        return Colors.grey[200]!;
    }
  }
}
