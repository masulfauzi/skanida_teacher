import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../helpers/date_helper.dart';
import '../models/jurnal_kelas_model.dart';
import '../services/jurnal_service.dart';
import 'jurnal_detail_view.dart';

class JurnalKelasDetailView extends StatefulWidget {
  final String idKelas;
  final String namaKelas;

  const JurnalKelasDetailView({
    super.key,
    required this.idKelas,
    required this.namaKelas,
  });

  @override
  State<JurnalKelasDetailView> createState() => _JurnalKelasDetailViewState();
}

class _JurnalKelasDetailViewState extends State<JurnalKelasDetailView> {
  JurnalKelasModel? _data;
  bool _isLoading = true;
  String? _errorMessage;
  DateTime _selectedDate = DateTime.now();

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

    final tgl = _selectedDate.toIso8601String().split('T').first;
    final result = await JurnalService.getJurnalKelas(widget.idKelas, tgl: tgl);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success'] == true) {
          _data = result['data'] as JurnalKelasModel;
        } else {
          _errorMessage = result['message'] as String?;
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      _loadData();
    }
  }

  void _resetToToday() {
    setState(() => _selectedDate = DateTime.now());
    _loadData();
  }

  Widget _htmlText(String value, {bool italic = false}) {
    final hasHtml = RegExp(r'<[^>]+>').hasMatch(value);
    final baseStyle = TextStyle(
      fontSize: 13,
      color: Colors.grey[800],
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    );
    return hasHtml
        ? Html(
            data: value,
            style: {
              'body': Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(13),
              ),
            },
          )
        : Text(value, style: baseStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaKelas),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Hari Ini',
            onPressed: _resetToToday,
          ),
        ],
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
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateHelper.formatTanggal(
                              _data?.tgl ??
                                  _selectedDate.toIso8601String().split(
                                    'T',
                                  )[0],
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.edit_calendar,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Daftar Jurnal (${_data?.jurnalList.length ?? 0})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_data == null || _data!.jurnalList.isEmpty)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Belum ada jurnal untuk tanggal ini',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(_data!.jurnalList.length, (index) {
                      final entry = _data!.jurnalList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 8),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => JurnalDetailView(
                                  jurnalId: entry.id,
                                  readOnly: true,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.mapel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      entry.namaGuru,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Jam ke-${entry.jamMulai ?? '-'} s/d ${entry.jamSelesai ?? '-'}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                if (entry.materi != null &&
                                    entry.materi!.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  _htmlText(entry.materi!),
                                ],
                                if (entry.catatan != null &&
                                    entry.catatan!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  _htmlText(
                                    'Catatan: ${entry.catatan}',
                                    italic: true,
                                  ),
                                ],
                              ],
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
