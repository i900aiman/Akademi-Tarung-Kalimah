import 'package:flutter/material.dart';
import 'package:saderi_silat/models/yuran_model.dart';
import 'package:saderi_silat/service/yuran_service.dart';

class YuranSearchPage extends StatefulWidget {
  const YuranSearchPage({super.key});

  @override
  State<YuranSearchPage> createState() => _YuranSearchPageState();
}

class _YuranSearchPageState extends State<YuranSearchPage> {
  // static const _purple = Color(0xFF3D0E63);
  static const Color textMuted = Color(0xFF7CA038); 
  static const _bg = Color(0xFFF6F3FB);

  static const _bulanList = [
    'Januari',
    'Februari',
    'Mac',
    'April',
    'Mei',
    'Jun',
    'Julai',
    'Ogos',
    'September',
    'Oktober',
    'November',
    'Disember',
  ];

  static const _statusOptions = [
    {'value': 'Semua', 'label': 'Semua Status'},
    {'value': 'paid', 'label': 'Sudah Bayar'},
    {'value': 'partial', 'label': 'Bayaran Sebahagian'},
    {'value': 'unpaid', 'label': 'Belum Bayar'},
    {'value': 'exempted', 'label': 'Dikecualikan'},
  ];

  final _service = YuranService();
  final _searchController = TextEditingController();

  bool _loading = false;
  bool _hasSearched = false;
  String? _error;
  YuranPage? _result;

  int? _filterYear;
  int? _filterMonth;
  String _filterStatus = 'Semua';
  int _currentPage = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search({int page = 1}) async {
    final query = _searchController.text.trim();

    if (query.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
      _hasSearched = true;
      _currentPage = page;
    });

    try {
      final result = await _service.searchYuran(
        studentName: query,
        status: _filterStatus,
        page: page,
        year: _filterYear,
        month: _filterMonth,
      );

      setState(() {
        _result = result;
      });
    } catch (e) {
      print('YURAN ERROR: $e');

      setState(() {
        _error = 'Gagal cari rekod yuran. Cuba lagi.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasSearched = false;
      _result = null;
      _error = null;
    });
  }

  Future<void> _pickMonthYear() async {
    int? tempMonth = _filterMonth;
    int tempYear = _filterYear ?? DateTime.now().year;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Bulan & Tahun',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: textMuted)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          value: tempMonth,
                          decoration: const InputDecoration(labelText: 'Bulan'),
                          items: [
                            const DropdownMenuItem(
                                value: null, child: Text('Semua Bulan')),
                            ...List.generate(
                              12,
                              (i) => DropdownMenuItem(
                                  value: i + 1, child: Text(_bulanList[i])),
                            ),
                          ],
                          onChanged: (v) => setSheetState(() => tempMonth = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: tempYear,
                          decoration: const InputDecoration(labelText: 'Tahun'),
                          items: List.generate(5, (i) {
                            final y = DateTime.now().year - 2 + i;
                            return DropdownMenuItem(
                                value: y, child: Text('$y'));
                          }),
                          onChanged: (v) =>
                              setSheetState(() => tempYear = v ?? tempYear),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: textMuted,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          _filterMonth = tempMonth;
                          _filterYear = tempYear;
                        });
                        Navigator.pop(ctx);
                        if (_hasSearched) _search();
                      },
                      child: const Text('Guna',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(title: const Text('Yuran')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            const Text(
              'Semakan Yuran',
              style: TextStyle(
                  color: textMuted, fontWeight: FontWeight.w800, fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              'Cari nama anak untuk semak status dan sejarah pembayaran yuran.',
              style: TextStyle(
                  color: Colors.grey.shade600, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),

            // Card filter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: 'Taip nama anak...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: _clearSearch,
                            ),
                      filled: true,
                      fillColor: _bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    onChanged: (_) =>
                        setState(() {}), // refresh clear-icon visibility
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _pickMonthYear,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _filterMonth == null && _filterYear == null
                                  ? 'Semua Bulan & Tahun'
                                  : '${_filterMonth != null ? _bulanList[_filterMonth! - 1] : 'Semua Bulan'} ${_filterYear ?? ''}',
                            ),
                          ),
                          const Icon(Icons.calendar_today_outlined, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _filterStatus,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    items: _statusOptions
                        .map((s) => DropdownMenuItem(
                            value: s['value'], child: Text(s['label']!)))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        _filterStatus = v ?? 'Semua';
                      });

                      if (_hasSearched) {
                        _search();
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _loading || !_hasSearched
                              ? null
                              : () => _search(page: _currentPage),
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Muat Semula'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _loading ? null : () => _search(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: textMuted,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cari',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: CircularProgressIndicator(color: textMuted)),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
            child: Text(_error!, style: const TextStyle(color: Colors.red))),
      );
    }
    if (!_hasSearched) {
      return const SizedBox.shrink();
    }
    if ((_result?.data.isEmpty ?? true)) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: Text('Tiada rekod dijumpai.')),
      );
    }

    return Column(
      children: [
        ..._result!.data.map((r) => _YuranCard(record: r)),
        const SizedBox(height: 12),
        _buildPagination(),
      ],
    );
  }

  Widget _buildPagination() {
    final r = _result!;
    final start = (r.page - 1) * r.perPage + 1;
    final end = start + r.data.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Menunjukkan $start-$end daripada ${r.total} rekod bayaran',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: r.page > 1 ? () => _search(page: r.page - 1) : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed:
                r.page < r.lastPage ? () => _search(page: r.page + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _YuranCard extends StatelessWidget {
  final YuranRecord record;
  const _YuranCard({required this.record});

  static const _purple = Color(0xFF3D0E63);

  Color get _statusColor {
    switch (record.status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'unpaid':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.studentName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: _purple),
                    ),
                    if (record.className.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(record.className,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12)),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      'Resit: ${record.receiptNo ?? '–'}',
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  record.status.toUpperCase(),
                  style: TextStyle(
                      color: _statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(record.periodLabel,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              _AmountBlock(label: 'Perlu Bayar', value: record.amountDue),
              _AmountBlock(label: 'Telah Bayar', value: record.amountPaid),
              _AmountBlock(
                  label: 'Baki',
                  value: record.balance,
                  highlight: record.balance > 0),
            ],
          ),
          if (record.paidAt != null) ...[
            const SizedBox(height: 8),
            Text(
              'Dibayar pada: ${record.paidAt!.day}/${record.paidAt!.month}/${record.paidAt!.year}',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _AmountBlock extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;
  const _AmountBlock(
      {required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            'RM${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: highlight ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
