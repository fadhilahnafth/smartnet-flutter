import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';

class ReportDetailPage extends StatefulWidget {
  final DateTime selectedDate;

  const ReportDetailPage({required this.selectedDate, super.key});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage>
    with SingleTickerProviderStateMixin {
  // --- Theme colors ---
  static const _bgColor = Color(0xFFF5F5F0);
  static const _primaryGreen = Color(0xFF4CAF50);
  static const _darkGreen = Color(0xFF2E7D32);
  static const _lightGreen = Color(0xFFE8F5E9);
  static const String _apiUrl = 'https://api.fadhilahnaf.com/api/sensor-data';

  // --- Column definitions ---
  static const _columns = [
    _Col('No.', 44),
    _Col('Waktu', 82),
    _Col('Suhu', 60),
    _Col('Humid', 60),
    _Col('pH', 48),
    _Col('N', 48),
    _Col('P', 48),
    _Col('K', 48),
  ];
  static double get _tableWidth =>
      _columns.fold(0.0, (total, c) => total + c.width);

  // --- Data state ---
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;
  String? _errorMessage;

  // --- Pagination ---
  int _rowsPerPage = 25;
  int _currentPage = 1;
  final List<int> _rowsPerPageOptions = [10, 25, 100, 1000];

  // --- Animation ---
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  int get _totalPages =>
      (_allData.length / _rowsPerPage).ceil().clamp(1, 999999);

  List<Map<String, dynamic>> get _pageData {
    final s = (_currentPage - 1) * _rowsPerPage;
    final e = (s + _rowsPerPage).clamp(0, _allData.length);
    return _allData.sublist(s, e);
  }

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _fetchData();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final day = DateTime(
          widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day);
      final next = day.add(const Duration(days: 1));

      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> dataList = decoded['data'] ?? [];

      final mapped = <Map<String, dynamic>>[];
      for (final item in dataList) {
        final waktuStr = item['waktu_rekam'] as String?;
        if (waktuStr == null) continue;
        final dt = DateTime.tryParse(waktuStr);
        if (dt == null) continue;
        if (dt.isBefore(day) || !dt.isBefore(next)) continue;

        mapped.add({
          'timestamp': dt.millisecondsSinceEpoch,
          'uplink': {
            'temperature': item['suhu_udara'],
            'humidity': item['kelembapan_tanah'],
            'ph': item['ph_tanah'],
            'nitrogen': item['nitrogen'],
            'phossporus': item['fosfor'],
            'potassium': item['kalium'],
          },
        });
      }

      mapped.sort((a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int));

      if (!mounted) return;
      setState(() {
        _allData = mapped;
        _isLoading = false;
        _currentPage = 1;
      });
      _fadeCtrl.forward(from: 0);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = '$e';
      });
    }
  }

  String _fmtTime(int ts) {
    final t = DateTime.fromMillisecondsSinceEpoch(ts);
    return '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}:'
        '${t.second.toString().padLeft(2, '0')}';
  }

  String _fmtDateLong() {
    final d = widget.selectedDate;
    const m = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${d.day} ${m[d.month - 1]} ${d.year}';
  }

  // ======== BUILD ========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // -------- Header --------
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Top row: back + title + actions
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 8, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 22,
                ),
                const Expanded(
                  child: Text(
                    'Detail Report',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                _headerAction(Icons.refresh_rounded, 'Refresh', _fetchData),
                const SizedBox(width: 4),
                _headerAction(
                    Icons.file_download_outlined, 'Export CSV', _exportCSV),
              ],
            ),
          ),
          // Bottom row: date + data count chips
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 16, 14),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: Colors.white70, size: 15),
                const SizedBox(width: 6),
                Text(
                  _fmtDateLong(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (!_isLoading && _errorMessage == null && _allData.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.analytics_outlined,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${_allData.length} data',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerAction(IconData icon, String tip, VoidCallback onTap) {
    return Tooltip(
      message: tip,
      child: Material(
        color: Colors.white12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // -------- Body --------
  Widget _buildBody() {
    if (_isLoading) return _stateLoading();
    if (_errorMessage != null) return _stateError();
    if (_allData.isEmpty) return _stateEmpty();
    return _buildDataView();
  }

  Widget _stateLoading() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: 44,
          height: 44,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation(_primaryGreen),
          ),
        ),
        const SizedBox(height: 18),
        Text('Memuat data sensor...',
            style: TextStyle(fontSize: 14, color: Colors.grey[500])),
      ]),
    );
  }

  Widget _stateError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.red[50], shape: BoxShape.circle),
            child: Icon(Icons.wifi_off_rounded, size: 44, color: Colors.red[400]),
          ),
          const SizedBox(height: 18),
          Text('Gagal Memuat Data',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700])),
          const SizedBox(height: 6),
          Text(_errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchData,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _stateEmpty() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Colors.grey[100], shape: BoxShape.circle),
          child: Icon(Icons.inbox_rounded, size: 44, color: Colors.grey[400]),
        ),
        const SizedBox(height: 18),
        Text('Tidak Ada Data',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700])),
        const SizedBox(height: 4),
        Text('Belum ada data sensor\nuntuk ${_fmtDateLong()}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[500])),
      ]),
    );
  }

  // -------- Data table --------
  Widget _buildDataView() {
    final data = _pageData;
    final offset = (_currentPage - 1) * _rowsPerPage;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        children: [
          // Table card
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              // ONE horizontal scroll wrapping the entire table
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: _tableWidth,
                  child: Column(
                    children: [
                      // Sticky header
                      _tableHeaderRow(),
                      // Scrollable data rows
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (_, i) =>
                              _tableDataRow(offset + i, data[i], i.isEven),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Pagination
          _buildPagination(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ---- Table header ----
  Widget _tableHeaderRow() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_lightGreen, const Color(0xFFC8E6C9)],
        ),
      ),
      child: Row(
        children: _columns.map((col) {
          return Container(
            width: col.width,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            alignment: Alignment.center,
            child: Text(
              col.label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: _darkGreen,
                letterSpacing: 0.2,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---- Table data row ----
  Widget _tableDataRow(int globalIdx, Map<String, dynamic> item, bool even) {
    final ts = item['timestamp'] ?? 0;
    final u = item['uplink'] ?? {};
    final values = [
      '${globalIdx + 1}',
      _fmtTime(ts),
      u['temperature']?.toString() ?? '-',
      u['humidity']?.toString() ?? '-',
      u['ph']?.toString() ?? '-',
      u['nitrogen']?.toString() ?? '-',
      u['phossporus']?.toString() ?? '-',
      u['potassium']?.toString() ?? '-',
    ];

    return Container(
      decoration: BoxDecoration(
        color: even ? Colors.white : const Color(0xFFFAFAF7),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: Row(
        children: List.generate(_columns.length, (i) {
          final isNo = i == 0;
          return Container(
            width: _columns[i].width,
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
            alignment: Alignment.center,
            child: Text(
              values[i],
              style: TextStyle(
                fontSize: 12,
                fontWeight: isNo ? FontWeight.w600 : FontWeight.w400,
                color: isNo ? Colors.grey[500] : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }),
      ),
    );
  }

  // ======== PAGINATION ========
  Widget _buildPagination() {
    final start = (_currentPage - 1) * _rowsPerPage + 1;
    final end = (start + _rowsPerPage - 1).clamp(1, _allData.length);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Rows per page + range info
          Row(
            children: [
              Icon(Icons.table_rows_rounded, size: 15, color: Colors.grey[400]),
              const SizedBox(width: 6),
              ..._rowsPerPageOptions.map((opt) {
                final sel = _rowsPerPage == opt;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _rowsPerPage = opt;
                      _currentPage = 1;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 5),
                      decoration: BoxDecoration(
                        color: sel ? _primaryGreen : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$opt',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: sel ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              Text(
                '$start–$end / ${_allData.length}',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Page nav
          _buildPageNav(),
        ],
      ),
    );
  }

  Widget _buildPageNav() {
    const maxVis = 5;
    int s = (_currentPage - maxVis ~/ 2).clamp(1, _totalPages);
    int e = (s + maxVis - 1).clamp(1, _totalPages);
    if (e - s < maxVis - 1 && _totalPages >= maxVis) {
      s = (e - maxVis + 1).clamp(1, _totalPages);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _navBtn(Icons.first_page_rounded, _currentPage > 1,
            () => setState(() => _currentPage = 1)),
        _navBtn(Icons.chevron_left_rounded, _currentPage > 1,
            () => setState(() => _currentPage--)),
        const SizedBox(width: 2),
        ...List.generate(e - s + 1, (i) {
          final p = s + i;
          final act = p == _currentPage;
          return GestureDetector(
            onTap: () => setState(() => _currentPage = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 34,
              height: 34,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: act ? _primaryGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$p',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: act ? FontWeight.bold : FontWeight.w500,
                  color: act ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 2),
        _navBtn(Icons.chevron_right_rounded, _currentPage < _totalPages,
            () => setState(() => _currentPage++)),
        _navBtn(Icons.last_page_rounded, _currentPage < _totalPages,
            () => setState(() => _currentPage = _totalPages)),
      ],
    );
  }

  Widget _navBtn(IconData icon, bool on, VoidCallback tap) {
    return GestureDetector(
      onTap: on ? tap : null,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: on ? Colors.grey[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: on ? Colors.grey[700] : Colors.grey[300]),
      ),
    );
  }

  // ======== EXPORT CSV ========
  Future<void> _exportCSV() async {
    if (_allData.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada data untuk diekspor.")),
      );
      return;
    }

    final rows = <List<String>>[
      ["No", "Time", "Temperature", "Humidity", "pH", "Nitrogen", "Phosphorus", "Potassium"],
    ];
    for (int i = 0; i < _allData.length; i++) {
      final item = _allData[i];
      final u = item['uplink'] ?? {};
      rows.add([
        "${i + 1}",
        _fmtTime(item['timestamp'] ?? 0),
        u['temperature']?.toString() ?? '',
        u['humidity']?.toString() ?? '',
        u['ph']?.toString() ?? '',
        u['nitrogen']?.toString() ?? '',
        u['phossporus']?.toString() ?? '',
        u['potassium']?.toString() ?? '',
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);

    if (await Permission.storage.request().isGranted) {
      final dir = Directory('/storage/emulated/0/Download');
      final now = DateTime.now();
      final ts =
          "${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
      final name =
          "report-${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}-$ts.csv";
      final file = File("${dir.path}/$name");
      await file.writeAsString(csv);

      if (!mounted) return;
      final open = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(children: [
            Icon(Icons.check_circle, color: _primaryGreen, size: 26),
            const SizedBox(width: 8),
            const Text('Berhasil', style: TextStyle(fontSize: 17)),
          ]),
          content: Text("File disimpan:\n$name\n\nBuka sekarang?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Tidak')),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text('Buka'),
            ),
          ],
        ),
      );
      if (open == true) OpenFile.open(file.path);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Disimpan: $name"),
        backgroundColor: _darkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Izin penyimpanan ditolak."),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }
}

// Column definition helper
class _Col {
  final String label;
  final double width;
  const _Col(this.label, this.width);
}
