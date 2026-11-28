import 'dart:convert';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_agriculture_jadi/pages/home_page.dart';

// class SensorPhosporPage extends StatefulWidget {
//   @override
//   _SensorPhosporPageState createState() => _SensorPhosporPageState();
// }

// class _SensorPhosporPageState extends State<SensorPhosporPage> {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplink-p2p');

//   DateTime? _selectedDate;
//   double xAxisFontSize = 12;
//   double yAxisFontSize = 12;

//   @override
//   Widget build(BuildContext context) {
//     DateTime startOfDay;
//     DateTime endOfDay;

//     if (_selectedDate != null) {
//       startOfDay = DateTime(
//           _selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
//       endOfDay = startOfDay.add(Duration(days: 1));
//     } else {
//       endOfDay = DateTime.now();
//       startOfDay = endOfDay.subtract(Duration(hours: 24));
//     }

//     final startEpoch = startOfDay.millisecondsSinceEpoch;
//     final endEpoch = endOfDay.millisecondsSinceEpoch;

//     return Scaffold(
//       backgroundColor: const Color(0xFFEAEAE3),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text("Detail Sensor Phospor",
//             style: TextStyle(color: Colors.black)),
//         iconTheme: const IconThemeData(color: Colors.black),
//         elevation: 0,
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: uplinksRef
//             .orderBy('timestamp', descending: true)
//             .where('timestamp', isGreaterThanOrEqualTo: startEpoch)
//             .where('timestamp', isLessThan: endEpoch)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Terjadi error: ${snapshot.error}'));
//           }

//           final docs = snapshot.data?.docs ?? [];
//           final hasData = docs.isNotEmpty;

//           List<FlSpot> phossporusPoints = [];

//           for (int i = 0; i < docs.length; i++) {
//             final data = docs[i].data() as Map<String, dynamic>;
//             final timestamp = data['timestamp'] ?? 0;
//             final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
//             final hour = time.hour.toDouble();

//             final uplink = data['uplink'] ?? {};
//             final phossporusValue =
//                 double.tryParse(uplink['phossporus']?.toString() ?? '') ?? 0.0;

//             phossporusPoints.add(FlSpot(hour, phossporusValue));
//           }

//           if (!hasData) {
//             phossporusPoints = [const FlSpot(0, 0)];
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Stack(
//                     children: [
//                       Align(
//                         alignment: Alignment.center,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Text("Phospor",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold)),
//                             Text(
//                                 "${SensorValueService().phospor.toStringAsFixed(2)} ppm",
//                                 style: const TextStyle(
//                                     fontSize: 18, color: Colors.teal)),
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: IconButton(
//                           icon: const Icon(Icons.info_outline,
//                               color: Colors.teal),
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (_) => AlertDialog(
//                                 title: const Text("Indikator Phospor"),
//                                 content: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Table(
//                                       border: TableBorder.all(
//                                           color: Colors.grey.shade300),
//                                       columnWidths: const {
//                                         0: FlexColumnWidth(2),
//                                         1: FlexColumnWidth(2),
//                                       },
//                                       children: [
//                                         _buildRow("Indikator", "Phospor",
//                                             isHeader: true),
//                                         _buildRow("Tidak Subur", "< 21"),
//                                         _buildRow("Kurang Subur", "21 - 39"),
//                                         _buildRow("Subur", "40 - 60"),
//                                         _buildRow("Kurang Subur", "61 - 100"),
//                                         _buildRow("Tidak Subur", "> 100"),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     child: const Text("Tutup"),
//                                     onPressed: () => Navigator.pop(context),
//                                   )
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 2,
//                   color: Colors.white,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text("Grafik Sensor Phospor",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16)),
//                             IconButton(
//                               icon: const Icon(Icons.calendar_month,
//                                   color: Colors.teal),
//                               onPressed: () async {
//                                 DateTime? picked = await showDatePicker(
//                                   context: context,
//                                   initialDate: _selectedDate ?? DateTime.now(),
//                                   firstDate: DateTime(2025),
//                                   lastDate: DateTime.now(),
//                                 );
//                                 if (picked != null) {
//                                   setState(() {
//                                     _selectedDate = picked;
//                                   });
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         if (!hasData)
//                           const Center(
//                               child: Text("Tidak ada data pada tanggal ini.")),
//                         SizedBox(
//                           height: 300,
//                           child: LineChart(
//                             LineChartData(
//                               minX: 0,
//                               maxX: 23,
//                               minY: 0,
//                               maxY: 100,
//                               backgroundColor: Colors.white,
//                               lineTouchData: LineTouchData(
//                                 touchTooltipData: LineTouchTooltipData(
//                                   tooltipBgColor:
//                                       Colors.blueGrey.withOpacity(0.7),
//                                   getTooltipItems: (spots) => spots
//                                       .map((spot) => LineTooltipItem(
//                                             '${spot.y.toStringAsFixed(1)} mg/kg',
//                                             const TextStyle(
//                                                 color: Colors.white),
//                                           ))
//                                       .toList(),
//                                 ),
//                                 handleBuiltInTouches: true,
//                                 enabled: true,
//                               ),
//                               gridData: FlGridData(show: false),
//                               titlesData: FlTitlesData(
//                                 bottomTitles: AxisTitles(
//                                   sideTitles: SideTitles(
//                                     showTitles: true,
//                                     interval: 2,
//                                     getTitlesWidget: (value, meta) => Text(
//                                       '${value.toInt()}',
//                                       style: TextStyle(fontSize: xAxisFontSize),
//                                     ),
//                                   ),
//                                 ),
//                                 leftTitles: AxisTitles(
//                                   sideTitles: SideTitles(
//                                     showTitles: true,
//                                     interval: 10,
//                                     getTitlesWidget: (value, meta) => Text(
//                                       '${value.toInt()}',
//                                       style: TextStyle(fontSize: yAxisFontSize),
//                                     ),
//                                   ),
//                                 ),
//                                 topTitles: AxisTitles(
//                                     sideTitles: SideTitles(showTitles: false)),
//                                 rightTitles: AxisTitles(
//                                     sideTitles: SideTitles(showTitles: false)),
//                               ),
//                               borderData: FlBorderData(show: false),
//                               lineBarsData: [
//                                 LineChartBarData(
//                                   spots: phossporusPoints,
//                                   isCurved: true,
//                                   isStrokeCapRound: true,
//                                   barWidth: 4,
//                                   gradient: const LinearGradient(
//                                       colors: [Colors.teal, Colors.green]),
//                                   dotData: FlDotData(show: true),
//                                   belowBarData: BarAreaData(
//                                     show: true,
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         Colors.teal.withOpacity(0.3),
//                                         Colors.green.withOpacity(0.2),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                               clipData: FlClipData.all(),
//                               showingTooltipIndicators: [],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   TableRow _buildRow(String indikator, String rentang,
//       {bool isHeader = false}) {
//     return TableRow(
//       children: [
//         _buildCell(indikator, isHeader: isHeader),
//         _buildCell(rentang, isHeader: isHeader),
//       ],
//     );
//   }

//   Widget _buildCell(String text, {bool isHeader = false}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//           color: isHeader ? Colors.black : Colors.grey[800],
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }

class SensorPhosporPage extends StatefulWidget {
  @override
  _SensorPhosporPageState createState() => _SensorPhosporPageState();
}

class _SensorPhosporPageState extends State<SensorPhosporPage> {
  // --- Theme ---
  static const _bg = Color(0xFFF5F5F0);
  static const _green = Color(0xFF4CAF50);
  static const _darkGreen = Color(0xFF2E7D32);
  static const _lightGreen = Color(0xFFE8F5E9);

  static const String _apiUrl = 'https://api.fadhilahnaf.com/api/sensor-data';

  DateTime? _selectedDate;
  bool _isLoading = true;
  String? _error;

  // Raw data points: x = millisecondsSinceEpoch as double, y = phospor
  List<FlSpot> _allSpots = [];

  // Zoom / pan state
  double _minX = 0;
  double _maxX = 1;
  double _baseMinX = 0;
  double _baseMaxX = 1;
  // For gesture tracking
  double? _gestureStartMinX;
  double? _gestureStartMaxX;
  double? _gestureStartFocalX;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      DateTime startOfDay, endOfDay;
      if (_selectedDate != null) {
        startOfDay = DateTime(
            _selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
        endOfDay = startOfDay.add(const Duration(days: 1));
      } else {
        endOfDay = DateTime.now();
        startOfDay = endOfDay.subtract(const Duration(hours: 24));
      }

      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> dataList = decoded['data'] ?? [];

      final spots = <FlSpot>[];
      for (final item in dataList) {
        final waktuStr = item['waktu_rekam'] as String?;
        if (waktuStr == null) continue;
        final dt = DateTime.tryParse(waktuStr);
        if (dt == null) continue;
        if (dt.isBefore(startOfDay) || dt.isAfter(endOfDay)) continue;

        final ts = dt.millisecondsSinceEpoch.toDouble();
        final val = (item['fosfor'] as num?)?.toDouble() ?? 0.0;
        spots.add(FlSpot(ts, val));
      }

      spots.sort((a, b) => a.x.compareTo(b.x));

      setState(() {
        _allSpots = spots;
        _isLoading = false;
        if (spots.isNotEmpty) {
          _baseMinX = spots.first.x;
          _baseMaxX = spots.last.x;
          final range = _baseMaxX - _baseMinX;
          final pad = range * 0.02;
          _baseMinX -= pad;
          _baseMaxX += pad;
        } else {
          _baseMinX = startOfDay.millisecondsSinceEpoch.toDouble();
          _baseMaxX = endOfDay.millisecondsSinceEpoch.toDouble();
        }
        _minX = _baseMinX;
        _maxX = _baseMaxX;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = '$e';
      });
    }
  }

  // ====== Y-axis auto range ======
  double get _dataMinY {
    if (_allSpots.isEmpty) return 0;
    final visible =
        _allSpots.where((s) => s.x >= _minX && s.x <= _maxX).toList();
    if (visible.isEmpty) return 0;
    return visible.map((s) => s.y).reduce(math.min);
  }

  double get _dataMaxY {
    if (_allSpots.isEmpty) return 50;
    final visible =
        _allSpots.where((s) => s.x >= _minX && s.x <= _maxX).toList();
    if (visible.isEmpty) return 50;
    return visible.map((s) => s.y).reduce(math.max);
  }

  // ====== BUILD ======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? _buildLoading()
                  : _error != null
                      ? _buildError()
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                          child: Column(
                            children: [
                              _buildTempCard(),
                              const SizedBox(height: 16),
                              _buildChartCard(),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // ======== HEADER ========
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 12, 16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
              splashRadius: 22,
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sensor Phospor',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  SizedBox(height: 2),
                  Text('Phospor Monitoring',
                      style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.thermostat_rounded,
                  color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  // ======== PHOSPOR CARD ========
  Widget _buildTempCard() {
    final temp = SensorValueService().phospor;
    final status = getStatus('phossporus', temp);
    final statusColor = getStatusColor(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Temp icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _lightGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.thermostat_rounded, size: 30, color: _darkGreen),
          ),
          const SizedBox(width: 16),
          // Temp value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Phospor',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54)),
                const SizedBox(height: 4),
                Text(
                  '${temp.toStringAsFixed(2)} ppm',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          // Status badge + info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _showIndicatorDialog(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.info_outline_rounded,
                      size: 20, color: _darkGreen),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ======== INDICATOR DIALOG ========
  void _showIndicatorDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _lightGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.thermostat_rounded,
                        size: 20, color: _darkGreen),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Indikator Phospor',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Table
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    // Header
                    Container(
                      color: _lightGreen,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Indikator',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: _darkGreen)),
                          ),
                          Expanded(
                            child: Text('Phospor (ppm)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: _darkGreen)),
                          ),
                        ],
                      ),
                    ),
                    // Rows
                    _indicatorRow('Tidak Subur', '< 10', Colors.red),
                    _indicatorRow('Kurang Subur', '10 – 20', Colors.orange),
                    _indicatorRow('Subur', '21 – 50', _green),
                    _indicatorRow('Kurang Subur', '51 – 100', Colors.orange),
                    _indicatorRow('Tidak Subur', '> 100', Colors.red),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: _darkGreen,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Tutup',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _indicatorRow(String label, String range, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          Expanded(
            child: Text(range,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  // ======== CHART CARD ========
  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              const Expanded(
                child: Text('Grafik Suhu',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              // Date chip
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: _lightGreen,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedDate != null
                            ? _fmtDateShort(_selectedDate!)
                            : _fmtDateShort(DateTime.now()),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _darkGreen),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.calendar_today_rounded,
                          size: 14, color: _darkGreen),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Zoom hint
          Text(
            'Pinch untuk zoom • Geser untuk pindah waktu',
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
          ),
          const SizedBox(height: 14),
          // Chart with zoom gesture
          SizedBox(
            height: 280,
            child: _allSpots.isEmpty
                ? Center(
                    child: Text('Tidak ada data pada tanggal ini.',
                        style: TextStyle(color: Colors.grey[500])))
                : _buildZoomableChart(),
          ),
          const SizedBox(height: 10),
          // Reset zoom button
          if (_allSpots.isNotEmpty)
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _minX = _baseMinX;
                    _maxX = _baseMaxX;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_out_map_rounded,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text('Reset Zoom',
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ======== ZOOMABLE CHART ========
  Widget _buildZoomableChart() {
    // Compute Y range with padding
    final yMin = _dataMinY;
    final yMax = _dataMaxY;
    final yRange = yMax - yMin;
    final chartMinY = (yMin - yRange * 0.15).clamp(0.0, double.infinity);
    final chartMaxY = yMax + yRange * 0.15;
    // Y interval
    final yInterval = _niceInterval(chartMaxY - chartMinY, 5);

    // X interval for labels
    final xRange = _maxX - _minX;
    final xInterval = _niceTimeInterval(xRange);

    return GestureDetector(
      onScaleStart: (details) {
        _gestureStartMinX = _minX;
        _gestureStartMaxX = _maxX;
        _gestureStartFocalX = details.localFocalPoint.dx;
      },
      onScaleUpdate: (details) {
        if (_gestureStartMinX == null || _gestureStartMaxX == null) return;
        final chartWidth =
            MediaQuery.of(context).size.width - 72; // approx chart area

        final currentRange = _gestureStartMaxX! - _gestureStartMinX!;

        if (details.scale != 1.0) {
          // ZOOM
          final newRange = (currentRange / details.scale)
              .clamp(60000.0, _baseMaxX - _baseMinX);
          final focalRatio = (_gestureStartFocalX! - 40) /
              chartWidth; // 40 = left padding estimate
          final focalX = _gestureStartMinX! + currentRange * focalRatio;

          var newMin = focalX - newRange * focalRatio;
          var newMax = focalX + newRange * (1 - focalRatio);

          // Clamp to base range
          if (newMin < _baseMinX) {
            newMin = _baseMinX;
            newMax = newMin + newRange;
          }
          if (newMax > _baseMaxX) {
            newMax = _baseMaxX;
            newMin = newMax - newRange;
          }

          setState(() {
            _minX = newMin;
            _maxX = newMax;
          });
        } else {
          // PAN
          final dx = details.localFocalPoint.dx - _gestureStartFocalX!;
          final panAmount = -dx / chartWidth * currentRange;

          var newMin = _gestureStartMinX! + panAmount;
          var newMax = _gestureStartMaxX! + panAmount;

          if (newMin < _baseMinX) {
            newMin = _baseMinX;
            newMax = newMin + currentRange;
          }
          if (newMax > _baseMaxX) {
            newMax = _baseMaxX;
            newMin = newMax - currentRange;
          }

          setState(() {
            _minX = newMin;
            _maxX = newMax;
          });
        }
      },
      child: LineChart(
        LineChartData(
          minX: _minX,
          maxX: _maxX,
          minY: chartMinY,
          maxY: chartMaxY,
          clipData: const FlClipData.all(),
          backgroundColor: Colors.white,
          // Grid
          gridData: FlGridData(
            show: false,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 0.8,
            ),
          ),
          // Border
          borderData: FlBorderData(show: false),
          // Titles
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: xInterval,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  // Don't show label at exact edges
                  if (value <= _minX || value >= _maxX) return const SizedBox();
                  final dt = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  String label;
                  if (xRange < 300000) {
                    // < 5 min — show HH:MM:SS
                    label =
                        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
                  } else if (xRange < 7200000) {
                    // < 2 hours — show HH:MM
                    label =
                        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  } else {
                    // Show HH:MM
                    label =
                        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(label,
                        style:
                            TextStyle(fontSize: 10, color: Colors.grey[500])),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: yInterval,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(
                        value == value.roundToDouble() ? 0 : 1),
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  );
                },
              ),
            ),
          ),
          // Touch
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: const Color(0xFF2E7D32),
              tooltipRoundedRadius: 10,
              tooltipPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final dt =
                      DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                  final timeStr =
                      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  return LineTooltipItem(
                    '$timeStr\n',
                    const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                    children: [
                      const TextSpan(
                        text: '● ',
                        style:
                            TextStyle(color: Color(0xFF81C784), fontSize: 10),
                      ),
                      TextSpan(
                        text: 'Suhu: ${spot.y.toStringAsFixed(2)} °C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((i) {
                return TouchedSpotIndicatorData(
                  FlLine(
                      color: Colors.grey.shade400,
                      strokeWidth: 1,
                      dashArray: [4, 4]),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: _green,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                );
              }).toList();
            },
          ),
          // Line
          lineBarsData: [
            LineChartBarData(
              spots: _allSpots,
              isCurved: true,
              curveSmoothness: 0.25,
              preventCurveOverShooting: true,
              isStrokeCapRound: true,
              barWidth: 2.5,
              color: _green,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  // Show dots only when zoomed in enough (< 500 visible points)
                  final visibleCount = _allSpots
                      .where((s) => s.x >= _minX && s.x <= _maxX)
                      .length;
                  return visibleCount < 60;
                },
                getDotPainter: (spot, xPercentage, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: _green,
                    strokeWidth: 1.5,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _green.withOpacity(0.25),
                    _green.withOpacity(0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======== HELPERS ========
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.light(
              primary: _darkGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      _fetchData();
    }
  }

  String _fmtDateShort(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${d.day}-${m[d.month - 1]}-${d.year}';
  }

  /// Pick a "nice" interval for Y axis
  double _niceInterval(double range, int targetTicks) {
    if (range <= 0) return 1;
    final rough = range / targetTicks;
    final mag = math.pow(10, (math.log(rough) / math.ln10).floor()).toDouble();
    final residual = rough / mag;
    double nice;
    if (residual <= 1.5) {
      nice = 1;
    } else if (residual <= 3) {
      nice = 2;
    } else if (residual <= 7) {
      nice = 5;
    } else {
      nice = 10;
    }
    return nice * mag;
  }

  /// Pick a "nice" time interval for X axis (in milliseconds)
  double _niceTimeInterval(double rangeMs) {
    // Possible intervals: 10s, 30s, 1m, 5m, 10m, 15m, 30m, 1h, 2h, 4h, 6h
    const intervals = [
      10000.0,
      30000.0,
      60000.0,
      300000.0,
      600000.0,
      900000.0,
      1800000.0,
      3600000.0,
      7200000.0,
      14400000.0,
      21600000.0,
    ];
    final target = rangeMs / 5; // aim for ~5 labels
    for (final iv in intervals) {
      if (iv >= target) return iv;
    }
    return intervals.last;
  }

  Widget _buildLoading() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          width: 44,
          height: 44,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation(_green),
          ),
        ),
        const SizedBox(height: 18),
        Text('Memuat data suhu...',
            style: TextStyle(fontSize: 14, color: Colors.grey[500])),
      ]),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration:
                BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
            child:
                Icon(Icons.wifi_off_rounded, size: 44, color: Colors.red[400]),
          ),
          const SizedBox(height: 18),
          Text('Gagal Memuat Data',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700])),
          const SizedBox(height: 6),
          Text(_error!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchData,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
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
}
