import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SensorPhosporPage extends StatelessWidget {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplinks');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEAEAE3),
//       appBar: AppBar(title: Text("Detail Sensor Phospor")),
//       body: FutureBuilder<QuerySnapshot>(
//         future: uplinksRef
//             .orderBy('createdAt', descending: true)
//             .limit(24)
//             .get(), // Ambil 24 data terakhir untuk 24 jam
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Terjadi error: ${snapshot.error}'));
//           }

//           final docs = snapshot.data?.docs ?? [];

//           if (docs.isEmpty) {
//             return Center(child: Text('Data tidak ditemukan'));
//           }

//           final latestTemp = docs.first['phosphorus'] ?? 'N/A';

//           List<FlSpot> suhuPoints = [];
//           for (int i = 0; i < docs.length; i++) {
//             final data = docs[i];
//             double hour = i.toDouble(); // Asumsi satu data per jam
//             double temp = (data['phosphorus'] ?? 0).toDouble();
//             suhuPoints.add(FlSpot(hour, temp));
//           }

//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 10),
//                 Text("Phosphor",
//                     style:
//                         TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 Text("$latestTemp ", style: TextStyle(fontSize: 18)),
//                 SizedBox(height: 20),

//                 // Tabel Rentang Suhu
//                 Container(
//                   color: Colors.white, // latar belakang putih
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Table(
//                     border: TableBorder.all(),
//                     columnWidths: {
//                       0: FlexColumnWidth(2),
//                       1: FlexColumnWidth(2),
//                     },
//                     children: [
//                       TableRow(children: [
//                         _buildCell("Indikator", isHeader: true),
//                         _buildCell("Rentang Phospor", isHeader: true),
//                       ]),
//                       _buildRow("Tidak Subur", "0 - 5"),
//                       _buildRow("Kurang Subur", "5,5 - 6"),
//                       _buildRow("Subur", "6 - 7,5"),
//                       _buildRow("Kurang Subur", "7,6 - 8"),
//                       _buildRow("Tidak Subur", "8 - 14"),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30),

//                 SizedBox(height: 15),
//                 Text("Grafik Sensor nitrogen",
//                     style: TextStyle(fontWeight: FontWeight.bold)),

//                 SizedBox(
//                   height: 300,
//                   child: Container(
//                     color: Colors.white, // latar belakang putih untuk grafik
//                     padding: const EdgeInsets.all(16.0),
//                     child: LineChart(
//                       LineChartData(
//                         minX: 0,
//                         maxX: 23,
//                         minY: 0,
//                         maxY: 250,
//                         gridData: FlGridData(show: true),
//                         titlesData: FlTitlesData(
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               interval: 1,
//                               getTitlesWidget: (value, meta) {
//                                 return Text(
//                                   "${value.toInt().toString().padLeft(2, '0')}",
//                                   style: TextStyle(fontSize: 6),
//                                 );
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               interval: 50,
//                               getTitlesWidget: (value, meta) {
//                                 return Text("${value.toInt()}");
//                               },
//                             ),
//                           ),
//                           topTitles: AxisTitles(
//                               sideTitles: SideTitles(showTitles: false)),
//                           rightTitles: AxisTitles(
//                               sideTitles: SideTitles(showTitles: false)),
//                         ),
//                         borderData: FlBorderData(show: true),
//                         lineBarsData: [
//                           LineChartBarData(
//                             spots: suhuPoints,
//                             isCurved: true,
//                             barWidth: 2,
//                             color: Colors.teal,
//                             dotData: FlDotData(show: false),
//                           )
//                         ],
//                       ),
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

//   TableRow _buildRow(String indikator, String rentang) {
//     return TableRow(children: [
//       _buildCell(indikator),
//       _buildCell(rentang),
//     ]);
//   }

//   Widget _buildCell(String text, {bool isHeader = false}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         text,
//         style: isHeader
//             ? TextStyle(fontWeight: FontWeight.bold)
//             : TextStyle(color: Colors.black),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }

// class SensorPhosporPage extends StatefulWidget {
//   @override
//   _SensorPhosporPageState createState() => _SensorPhosporPageState();
// }

// class _SensorPhosporPageState extends State<SensorPhosporPage> {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplinks');

//   int _selectedHours = 24;
//   double xAxisFontSize = 12;
//   double yAxisFontSize = 12;

//   @override
//   Widget build(BuildContext context) {
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
//             .orderBy('createdAt', descending: true)
//             .limit(_selectedHours)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Terjadi error: ${snapshot.error}'));
//           }

//           final docs = snapshot.data?.docs ?? [];
//           if (docs.isEmpty) {
//             return const Center(child: Text('Data tidak ditemukan'));
//           }

//           final double latestTemp = docs.first['phosphorus']?.toDouble() ?? 0.0;

//           List<FlSpot> suhuPoints = [];
//           for (int i = 0; i < docs.length; i++) {
//             final temp = docs[i]['phosphorus']?.toDouble() ?? 0.0;
//             suhuPoints.add(FlSpot(i.toDouble(), temp));
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Temperature box with info icon and centered text
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
//                             Text("Phospor",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold)),
//                             Text("${latestTemp.toStringAsFixed(2)} ppm",
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.teal)),
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: IconButton(
//                           icon: Icon(Icons.info_outline, color: Colors.teal),
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (_) => AlertDialog(
//                                 title: Text("Indikator Phospor"),
//                                 content: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[300],
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(50),
//                                           topRight: Radius.circular(50),
//                                         ),
//                                       ),
//                                       child: Table(
//                                         columnWidths: const {
//                                           0: FlexColumnWidth(2),
//                                           1: FlexColumnWidth(2),
//                                         },
//                                         children: [
//                                           TableRow(
//                                             decoration: BoxDecoration(
//                                                 color: Colors.grey[300]),
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Text('Indikator',
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.black)),
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Text('Phospor',
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.black)),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Table(
//                                       border: TableBorder.symmetric(
//                                         inside: BorderSide(
//                                             color: Colors.grey.shade300),
//                                         outside: BorderSide(
//                                             color: Colors.grey.shade400),
//                                       ),
//                                       columnWidths: const {
//                                         0: FlexColumnWidth(2),
//                                         1: FlexColumnWidth(2),
//                                       },
//                                       children: [
//                                         _buildRow("Tidak Subur", "0 - 5"),
//                                         _buildRow("Kurang Subur", "5,5 - 6"),
//                                         _buildRow("Subur", "6 - 7,5"),
//                                         _buildRow("Kurang Subur", "7,6 - 8"),
//                                         _buildRow("Tidak Subur", "8 - 14"),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     child: Text("Tutup"),
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
//                 // Grafik Sensor Suhu Title and Dropdown inside box
//                 // Grafik Box
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
//                             const Text("Grafik Sensor phospor",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16)),
//                             DropdownButton<int>(
//                               value: _selectedHours,
//                               onChanged: (int? newValue) {
//                                 if (newValue != null) {
//                                   setState(() {
//                                     _selectedHours = newValue;
//                                   });
//                                 }
//                               },
//                               items: const [
//                                 DropdownMenuItem(
//                                     value: 12, child: Text("12 Jam")),
//                                 DropdownMenuItem(
//                                     value: 24, child: Text("24 Jam")),
//                                 DropdownMenuItem(
//                                     value: 48, child: Text("2 Hari")),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         SizedBox(
//                           height: 300,
//                           child: LineChart(
//                             LineChartData(
//                               minX: 0,
//                               maxX: _selectedHours.toDouble() - 1,
//                               minY: 0,
//                               maxY: 200,
//                               backgroundColor: Colors.white,
//                               lineTouchData: LineTouchData(
//                                 touchTooltipData: LineTouchTooltipData(
//                                   tooltipBgColor:
//                                       Colors.blueGrey.withOpacity(0.7),
//                                   getTooltipItems: (touchedSpots) {
//                                     return touchedSpots.map((spot) {
//                                       return LineTooltipItem(
//                                         '${spot.y.toStringAsFixed(1)}',
//                                         const TextStyle(color: Colors.white),
//                                       );
//                                     }).toList();
//                                   },
//                                 ),
//                                 handleBuiltInTouches: true,
//                                 enabled: true,
//                               ),
//                               gridData: FlGridData(
//                                 show: false,
//                                 drawVerticalLine: true,
//                                 drawHorizontalLine: true,
//                                 getDrawingHorizontalLine: (value) => FlLine(
//                                   color: Colors.grey.shade300,
//                                   strokeWidth: 1,
//                                 ),
//                                 getDrawingVerticalLine: (value) => FlLine(
//                                   color: Colors.grey.shade300,
//                                   strokeWidth: 1,
//                                 ),
//                               ),
//                               titlesData: FlTitlesData(
//                                 bottomTitles: AxisTitles(
//                                   sideTitles: SideTitles(
//                                     showTitles: true,
//                                     interval: 4,
//                                     getTitlesWidget: (value, meta) => Text(
//                                       '${value.toInt()}',
//                                       style: TextStyle(fontSize: xAxisFontSize),
//                                     ),
//                                   ),
//                                 ),
//                                 leftTitles: AxisTitles(
//                                   sideTitles: SideTitles(
//                                     showTitles: true,
//                                     interval: 20,
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
//                                   spots: suhuPoints,
//                                   isCurved: true,
//                                   isStrokeCapRound: true,
//                                   barWidth: 4,
//                                   gradient: const LinearGradient(
//                                     colors: [Colors.teal, Colors.green],
//                                   ),
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
//     return TableRow(children: [
//       _buildCell(indikator, isHeader: isHeader),
//       _buildCell(rentang, isHeader: isHeader),
//     ]);
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

_SensorPhosporPageState createState() => _SensorPhosporPageState();

class _SensorPhosporPageState extends State<SensorPhosporPage> {
  final CollectionReference uplinksRef =
      FirebaseFirestore.instance.collection('uplink-p2p');

  IO.Socket? socket;
  double latestPhossporus = 0.0;
  DateTime? _selectedDate;
  double xAxisFontSize = 12;
  double yAxisFontSize = 12;
  // List<FlSpot> _realtimeData = [];

  @override
  void initState() {
    super.initState();
    connectToSocket();
  }

  void connectToSocket() {
    print("Trying to connect to socket.io...");
    socket = IO.io("https://webhook.ktyudha.site", <String, dynamic>{
      'transports': ['websocket'],
      'secure': true,
    });

    socket!.onConnect((_) {
      print("\u2705 Connected to socket.io");
    });

    socket!.onDisconnect((_) => print("Socket disconnected"));
    socket!.onConnectError((err) => print("Socket connect error: $err"));
    socket!.onError((err) => print("Socket error: $err"));

    socket!.on('send-uplink-p2p', (data) {
      final phossporusValue =
          double.tryParse(data['uplink']['phossporus']) ?? 0.0;
      setState(() {
        latestPhossporus = phossporusValue;
      });
    });
  }

  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startOfDay;
    DateTime endOfDay;

    if (_selectedDate != null) {
      startOfDay = DateTime(
          _selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
      endOfDay = startOfDay.add(Duration(days: 1));
    } else {
      endOfDay = DateTime.now();
      startOfDay = endOfDay.subtract(Duration(hours: 24));
    }
    final startEpoch = startOfDay.millisecondsSinceEpoch;
    final endEpoch = endOfDay.millisecondsSinceEpoch;

    print('Selected date: $_selectedDate');
    print('Start epoch: $startEpoch');
    print('End epoch: $endEpoch');

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAE3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Detail Sensor Kalium",
            style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: uplinksRef
            .orderBy('timestamp', descending: true)
            .where('timestamp', isGreaterThanOrEqualTo: startEpoch)
            .where('timestamp', isLessThan: endEpoch)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];
          final hasData = docs.isNotEmpty;

          List<FlSpot> phossporusPoints = [];

          for (int i = 0; i < docs.length; i++) {
            final data = docs[i].data() as Map<String, dynamic>;
            final timestamp = data['timestamp'] ?? 0;
            final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
            final hour = time.hour.toDouble();

            final uplink = data['uplink'] ?? {};
            final phossporusValue =
                double.tryParse(uplink['phossporus']?.toString() ?? '') ?? 0.0;

            phossporusPoints.add(FlSpot(hour, phossporusValue));
          }

          if (!hasData) {
            phossporusPoints = [const FlSpot(0, 0)];
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Kalium",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("${latestPhossporus.toStringAsFixed(2)} ppm",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.teal)),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.info_outline,
                              color: Colors.teal),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Indikator Phospor"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Table(
                                      border: TableBorder.all(
                                          color: Colors.grey.shade300),
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(2),
                                      },
                                      children: [
                                        _buildRow("Indikator", "Kelembaban",
                                            isHeader: true),
                                        _buildRow("Tidak Subur", "0 - 5"),
                                        _buildRow("Kurang Subur", "5,5 - 6"),
                                        _buildRow("Subur", "6 - 7,5"),
                                        _buildRow("Kurang Subur", "7,6 - 8"),
                                        _buildRow("Tidak Subur", "8 - 14"),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Tutup"),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Grafik Sensor Phospor",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.calendar_today,
                                  color: Colors.teal),
                              onPressed: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(2025),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    _selectedDate = picked;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (!hasData)
                          const Center(
                              child: Text("Tidak ada data pada tanggal ini.")),
                        SizedBox(
                          height: 300,
                          child: LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: 23,
                              minY: 0,
                              maxY: 100,
                              backgroundColor: Colors.white,
                              lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipBgColor:
                                      Colors.blueGrey.withOpacity(0.7),
                                  getTooltipItems: (spots) => spots
                                      .map((spot) => LineTooltipItem(
                                            '${spot.y.toStringAsFixed(1)} ppm',
                                            const TextStyle(
                                                color: Colors.white),
                                          ))
                                      .toList(),
                                ),
                                handleBuiltInTouches: true,
                                enabled: true,
                              ),
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 4,
                                    getTitlesWidget: (value, meta) => Text(
                                      '${value.toInt()}',
                                      style: TextStyle(fontSize: xAxisFontSize),
                                    ),
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 10,
                                    getTitlesWidget: (value, meta) => Text(
                                      '${value.toInt()}',
                                      style: TextStyle(fontSize: yAxisFontSize),
                                    ),
                                  ),
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: phossporusPoints,
                                  isCurved: true,
                                  isStrokeCapRound: true,
                                  barWidth: 4,
                                  gradient: const LinearGradient(
                                      colors: [Colors.teal, Colors.green]),
                                  dotData: FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.teal.withOpacity(0.3),
                                        Colors.green.withOpacity(0.2),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              clipData: FlClipData.all(),
                              showingTooltipIndicators: [],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  TableRow _buildRow(String indikator, String rentang,
      {bool isHeader = false}) {
    return TableRow(
      children: [
        _buildCell(indikator, isHeader: isHeader),
        _buildCell(rentang, isHeader: isHeader),
      ],
    );
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.black : Colors.grey[800],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
