import 'package:flutter/material.dart';
import '../helpers/date_helper.dart';
import '../models/jurnal_model.dart';
import '../services/jurnal_service.dart';

class JurnalView extends StatefulWidget {
  const JurnalView({super.key});

  @override
  State<JurnalView> createState() => _JurnalViewState();
}

class _JurnalViewState extends State<JurnalView> {
  List<JurnalModel> _jurnalList = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _loadJurnal();
  }

  Future<void> _loadJurnal({int page = 1}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await JurnalService.getJurnal(page: page);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success'] == true) {
          _jurnalList = result['data'] as List<JurnalModel>;
          _currentPage = result['currentPage'] as int;
          _lastPage = result['lastPage'] as int;
          _total = result['total'] as int;
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
        title: const Text('Jurnal'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/jurnal/create').then((result) {
            if (result == true) {
              _loadJurnal(page: 1);
            }
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
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
                    onPressed: _loadJurnal,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : _jurnalList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada data jurnal',
                style: TextStyle(fontSize: 16),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _loadJurnal(page: _currentPage),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _jurnalList.length,
                      itemBuilder: (context, index) {
                        final item = _jurnalList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.class_,
                                      size: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item.kelas ?? '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateHelper.formatTanggal(item.tanggal),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.book,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item.mapel ?? '-',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Pagination controls
                  if (_lastPage > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _currentPage > 1
                                ? () => _loadJurnal(page: _currentPage - 1)
                                : null,
                            icon: const Icon(Icons.chevron_left, size: 20),
                            label: const Text('Prev'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey[300],
                            ),
                          ),
                          Text(
                            'Hal $_currentPage / $_lastPage  ($_total data)',
                            style: const TextStyle(fontSize: 14),
                          ),
                          ElevatedButton.icon(
                            onPressed: _currentPage < _lastPage
                                ? () => _loadJurnal(page: _currentPage + 1)
                                : null,
                            icon: const Icon(Icons.chevron_right, size: 20),
                            label: const Text('Next'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
