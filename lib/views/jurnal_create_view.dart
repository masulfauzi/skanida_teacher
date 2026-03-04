import 'package:flutter/material.dart';
import '../models/kelas_model.dart';
import '../models/mapel_model.dart';
import '../services/jurnal_service.dart';

class JurnalCreateView extends StatefulWidget {
  const JurnalCreateView({super.key});

  @override
  State<JurnalCreateView> createState() => _JurnalCreateViewState();
}

class _JurnalCreateViewState extends State<JurnalCreateView> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedHari;
  List<KelasModel> _kelasList = [];
  KelasModel? _selectedKelas;
  bool _isLoadingKelas = true;
  List<MapelModel> _mapelList = [];
  MapelModel? _selectedMapel;
  bool _isLoadingMapel = true;
  final _materiController = TextEditingController();
  final _catatanController = TextEditingController();
  int? _jamMulai;
  int? _jamSelesai;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadKelas();
    _loadMapel();
  }

  Future<void> _loadKelas() async {
    final kelas = await JurnalService.getKelas();
    if (mounted) {
      setState(() {
        _kelasList = kelas;
        _isLoadingKelas = false;
      });
    }
  }

  Future<void> _loadMapel() async {
    final mapel = await JurnalService.getMapel();
    if (mounted) {
      setState(() {
        _mapelList = mapel;
        _isLoadingMapel = false;
      });
    }
  }

  @override
  void dispose() {
    _materiController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMapel == null) {
      setState(() {}); // trigger rebuild to show error
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await JurnalService.createJurnal(
      hari: _selectedHari!,
      kelas: _selectedKelas!.id,
      jamMulai: _jamMulai.toString(),
      jamSelesai: _jamSelesai.toString(),
      mapel: _selectedMapel!.id,
      tglPembelajaran: _selectedDate.toIso8601String().split('T').first,
      materi: _materiController.text,
      catatan: _catatanController.text,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] as String),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] as String),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${_selectedDate.day.toString().padLeft(2, '0')}/'
        '${_selectedDate.month.toString().padLeft(2, '0')}/'
        '${_selectedDate.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Jurnal'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedHari,
                decoration: const InputDecoration(
                  labelText: 'Hari',
                  prefixIcon: Icon(Icons.today),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Senin', child: Text('Senin')),
                  DropdownMenuItem(value: 'Selasa', child: Text('Selasa')),
                  DropdownMenuItem(value: 'Rabu', child: Text('Rabu')),
                  DropdownMenuItem(value: 'Kamis', child: Text('Kamis')),
                  DropdownMenuItem(value: 'Jumat', child: Text('Jumat')),
                ],
                onChanged: (value) {
                  setState(() => _selectedHari = value);
                },
                validator: (v) => v == null ? 'Hari wajib dipilih' : null,
              ),
              const SizedBox(height: 16),
              _isLoadingKelas
                  ? const InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Kelas',
                        prefixIcon: Icon(Icons.class_),
                        border: OutlineInputBorder(),
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : DropdownButtonFormField<KelasModel>(
                      value: _selectedKelas,
                      decoration: const InputDecoration(
                        labelText: 'Kelas',
                        prefixIcon: Icon(Icons.class_),
                        border: OutlineInputBorder(),
                      ),
                      items: _kelasList
                          .map(
                            (kelas) => DropdownMenuItem(
                              value: kelas,
                              child: Text(kelas.nama),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedKelas = value);
                      },
                      validator: (v) =>
                          v == null ? 'Kelas wajib dipilih' : null,
                    ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _jamMulai,
                      decoration: const InputDecoration(
                        labelText: 'Jam Mulai',
                        prefixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(
                        11,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('${i + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _jamMulai = value;
                          if (_jamSelesai != null &&
                              value != null &&
                              _jamSelesai! <= value) {
                            _jamSelesai = null;
                          }
                        });
                      },
                      validator: (v) =>
                          v == null ? 'Jam mulai wajib dipilih' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _jamSelesai,
                      decoration: const InputDecoration(
                        labelText: 'Jam Selesai',
                        prefixIcon: Icon(Icons.access_time_filled),
                        border: OutlineInputBorder(),
                      ),
                      items: _jamMulai != null && _jamMulai! < 11
                          ? List.generate(
                              11 - _jamMulai!,
                              (i) => DropdownMenuItem(
                                value: _jamMulai! + 1 + i,
                                child: Text('${_jamMulai! + 1 + i}'),
                              ),
                            )
                          : [],
                      onChanged: (value) {
                        setState(() => _jamSelesai = value);
                      },
                      validator: (v) =>
                          v == null ? 'Jam selesai wajib dipilih' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _isLoadingMapel
                  ? const InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Mata Pelajaran',
                        prefixIcon: Icon(Icons.book),
                        border: OutlineInputBorder(),
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        final selected = await showDialog<MapelModel>(
                          context: context,
                          builder: (ctx) =>
                              _MapelSearchDialog(mapelList: _mapelList),
                        );
                        if (selected != null) {
                          setState(() => _selectedMapel = selected);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Mata Pelajaran',
                          prefixIcon: const Icon(Icons.book),
                          suffixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(),
                          errorText: _selectedMapel == null && _isSubmitting
                              ? 'Mapel wajib dipilih'
                              : null,
                        ),
                        child: Text(
                          _selectedMapel?.nama ?? 'Pilih Mata Pelajaran',
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedMapel != null
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Pembelajaran',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(dateStr, style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _materiController,
                decoration: const InputDecoration(
                  labelText: 'Materi',
                  prefixIcon: Icon(Icons.subject),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Materi wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _catatanController,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Simpan', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapelSearchDialog extends StatefulWidget {
  final List<MapelModel> mapelList;

  const _MapelSearchDialog({required this.mapelList});

  @override
  State<_MapelSearchDialog> createState() => _MapelSearchDialogState();
}

class _MapelSearchDialogState extends State<_MapelSearchDialog> {
  final _searchController = TextEditingController();
  List<MapelModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.mapelList;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = widget.mapelList;
      } else {
        _filtered = widget.mapelList
            .where((m) => m.nama.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Mata Pelajaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari mata pelajaran...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filter,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: _filtered.isEmpty
                  ? const Center(child: Text('Tidak ditemukan'))
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final mapel = _filtered[index];
                        return ListTile(
                          title: Text(mapel.nama),
                          onTap: () => Navigator.of(context).pop(mapel),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
