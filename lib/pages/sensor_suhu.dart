import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:smart_agriculture_jadi/home.dart';
import 'package:smart_agriculture_jadi/pages/home_page.dart';
// class SensorSuhuPage extends StatefulWidget {
//   @override
//   _SensorSuhuPageState createState() => _SensorSuhuPageState();
// }

// class _SensorSuhuPageState extends State<SensorSuhuPage> {
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
//         title: const Text("Detail Sensor Suhu",
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

//           final double latestTemp =
//               docs.first['temperature']?.toDouble() ?? 0.0;

//           List<FlSpot> suhuPoints = [];
//           for (int i = 0; i < docs.length; i++) {
//             final temp = docs[i]['temperature']?.toDouble() ?? 0.0;
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
//                             Text("Temperature",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold)),
//                             Text("${latestTemp.toStringAsFixed(2)} °C",
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
//                                 title: Text("Indikator Suhu"),

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
//                                                 child: Text('Rentang Suhu (°C)',
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
//                                         _buildRow("Tidak Subur", "< 17"),
//                                         _buildRow("Kurang Subur", "17 - 22"),
//                                         _buildRow("Subur", "22 - 27"),
//                                         _buildRow("Kurang Subur", "27 - 32"),
//                                         _buildRow("Tidak Subur", "> 32"),
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
//                             const Text("Grafik Sensor Suhu",
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
//                               maxY: 50,
//                               backgroundColor: Colors.white,
//                               lineTouchData: LineTouchData(
//                                 touchTooltipData: LineTouchTooltipData(
//                                   tooltipBgColor:
//                                       Colors.blueGrey.withOpacity(0.7),
//                                   getTooltipItems: (touchedSpots) {
//                                     return touchedSpots.map((spot) {
//                                       return LineTooltipItem(
//                                         '${spot.y.toStringAsFixed(1)} °C',
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
//                                     interval: 5,
//                                     getTitlesWidget: (value, meta) => Text(
//                                       '${value.toInt()}°',
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
//
//
// //
// class SensorSuhuPage extends StatefulWidget {
//   @override
//   _SensorSuhuPageState createState() => _SensorSuhuPageState();
// }

// class _SensorSuhuPageState extends State<SensorSuhuPage> {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplink-p2p');

//   IO.Socket? socket;
//   double latestTemperature = 0.0;
//   DateTime? _selectedDate;
//   double xAxisFontSize = 12;
//   double yAxisFontSize = 12;
//   // List<FlSpot> _realtimeData = [];

//   @override
//   void initState() {
//     super.initState();
//     connectToSocket();
//   }

//   void connectToSocket() {
//     print("Trying to connect to socket.io...");
//     socket = IO.io("https://webhook.ktyudha.site", <String, dynamic>{
//       'transports': ['websocket'],
//       'secure': true,
//     });

//     socket!.onConnect((_) {
//       print("\u2705 Connected to socket.io");
//     });

//     socket!.onDisconnect((_) => print("Socket disconnected"));
//     socket!.onConnectError((err) => print("Socket connect error: $err"));
//     socket!.onError((err) => print("Socket error: $err"));

//     socket!.on('send-uplink-p2p', (data) {
//       final temperatureValue =
//           double.tryParse(data['uplink']['temperature']) ?? 0.0;
//       setState(() {
//         latestTemperature = temperatureValue;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     socket?.disconnect();
//     super.dispose();
//   }

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

//     print('Selected date: $_selectedDate');
//     print('Start epoch: $startEpoch');
//     print('End epoch: $endEpoch');

//     return Scaffold(
//       backgroundColor: const Color(0xFFEAEAE3),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text("Detail Sensor Suhu",
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

//           List<FlSpot> temperaturePoints = [];

//           for (int i = 0; i < docs.length; i++) {
//             final data = docs[i].data() as Map<String, dynamic>;
//             final timestamp = data['timestamp'] ?? 0.0;
//             final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
//             final hour = time.hour.toDouble();

//             final uplink = data['uplink'] ?? {};
//             final temperatureValue =
//                 double.tryParse(uplink['temperature']) ?? 0.0;

//             temperaturePoints.add(FlSpot(hour, temperatureValue));
//           }

//           if (!hasData) {
//             temperaturePoints = [const FlSpot(0, 0)];
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
//                             const Text("Temperature",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold)),
//                             Text("${latestTemperature.toStringAsFixed(2)} °C",
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
//                                 title: const Text("Indikator Suhu"),
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
//                                         _buildRow("Indikator", "Suhu",
//                                             isHeader: true),
//                                         _buildRow("Tidak Subur", "<18"),
//                                         _buildRow("Kurang Subur", "18 - 24"),
//                                         _buildRow("Subur", "24 - 32"),
//                                         _buildRow("Kurang Subur", "32 - 35"),
//                                         _buildRow("Tidak Subur", ">35"),
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
//                             const Text("Grafik Sensor Suhu",
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
//                               maxY: 50,
//                               backgroundColor: Colors.white,
//                               lineTouchData: LineTouchData(
//                                 touchTooltipData: LineTouchTooltipData(
//                                   tooltipBgColor:
//                                       Colors.blueGrey.withOpacity(0.7),
//                                   getTooltipItems: (spots) => spots
//                                       .map((spot) => LineTooltipItem(
//                                             '${spot.y.toStringAsFixed(1)} ppm',
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
//                                   spots: temperaturePoints,
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
//
//
//
//
//
//
// class SensorSuhuPage extends StatefulWidget {
//   @override
//   _SensorSuhuPageState createState() => _SensorSuhuPageState();
// }

// class _SensorSuhuPageState extends State<SensorSuhuPage> {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplink-p2p');

//   IO.Socket? socket;
//   double latestTemperature = 0.0;
//   DateTime? _selectedDate;
//   double xAxisFontSize = 12;
//   double yAxisFontSize = 12;
//   // List<FlSpot> _realtimeData = [];

//   @override
//   void initState() {
//     super.initState();
//     connectToSocket();
//   }

//   void connectToSocket() {
//     print("Trying to connect to socket.io...");
//     socket = IO.io("https://webhook.ktyudha.site", <String, dynamic>{
//       'transports': ['websocket'],
//       'secure': true,
//     });

//     socket!.onConnect((_) {
//       print("\u2705 Connected to socket.io");
//     });

//     socket!.onDisconnect((_) => print("Socket disconnected"));
//     socket!.onConnectError((err) => print("Socket connect error: $err"));
//     socket!.onError((err) => print("Socket error: $err"));

//     socket!.on('send-uplink-p2p', (data) {
//       final temperatureValue =
//           double.tryParse(data['uplink']['temperature']) ?? 0.0;
//       setState(() {
//         latestTemperature = temperatureValue;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     socket?.disconnect();
//     super.dispose();
//   }

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

//     print('Selected date: $_selectedDate');
//     print('Start epoch: $startEpoch');
//     print('End epoch: $endEpoch');

//     return Scaffold(
//       backgroundColor: const Color(0xFFEAEAE3),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text("Detail Sensor Suhu",
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

//           List<FlSpot> temperaturePoints = [];

//           for (int i = 0; i < docs.length; i++) {
//             final data = docs[i].data() as Map<String, dynamic>;
//             final timestamp = data['timestamp'] ?? 0;
//             final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
//             final hour = time.hour.toDouble();

//             final uplink = data['uplink'] ?? {};
//             final temperatureValue =
//                 double.tryParse(uplink['temperature']?.toString() ?? '') ?? 0.0;

//             temperaturePoints.add(FlSpot(hour, temperatureValue));
//           }

//           if (!hasData) {
//             temperaturePoints = [const FlSpot(0, 0)];
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
//                             const Text("Temperature",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold)),
//                             Text("${latestTemperature.toStringAsFixed(2)} ",
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
//                                 title: const Text("Indikator Temnpetaure"),
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
//                                         _buildRow("Indikator", "Suhu",
//                                             isHeader: true),
//                                         _buildRow("Tidak Subur", "<18"),
//                                         _buildRow("Kurang Subur", "18 - 24"),
//                                         _buildRow("Subur", "24 - 32"),
//                                         _buildRow("Kurang Subur", "32 - 35"),
//                                         _buildRow("Tidak Subur", ">35"),
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
//                             const Text("Grafik Sensor Suhu",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16)),
//                             IconButton(
//                               icon: const Icon(Icons.calendar_today,
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
//                                             '${spot.y.toStringAsFixed(1)} ppm',
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
//                                   spots: temperaturePoints,
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
//
//
//
//import 'package:f

// class SensorSuhuPage extends StatefulWidget {
//   @override
//   _SensorSuhuPageState createState() => _SensorSuhuPageState();
// }

// class _SensorSuhuPageState extends State<SensorSuhuPage> {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplink-p2p');

//   IO.Socket? socket;
//   double latestTemperature = 0.0;
//   DateTime? _selectedDate;
//   double xAxisFontSize = 12;
//   double yAxisFontSize = 12;

//   late Future<QuerySnapshot> _initialDataFuture;

//   @override
//   void initState() {
//     super.initState();
//     connectToSocket();

//     DateTime endOfDay = DateTime.now();
//     DateTime startOfDay = endOfDay.subtract(Duration(hours: 24));
//     final startEpoch = startOfDay.millisecondsSinceEpoch;
//     final endEpoch = endOfDay.millisecondsSinceEpoch;

//     _initialDataFuture = fetchData(startEpoch, endEpoch);
//   }

//   Future<QuerySnapshot> fetchData(int startEpoch, int endEpoch) {
//     return uplinksRef
//         .orderBy('timestamp', descending: true)
//         .where('timestamp', isGreaterThanOrEqualTo: startEpoch)
//         .where('timestamp', isLessThan: endEpoch)
//         .get();
//   }

//   void connectToSocket() {
//     print("Trying to connect to socket.io...");
//     socket = IO.io("https://webhook.ktyudha.site", <String, dynamic>{
//       'transports': ['websocket'],
//       'secure': true,
//     });

//     socket!.onConnect((_) {
//       print("\u2705 Connected to socket.io");
//     });

//     socket!.onDisconnect((_) => print("Socket disconnected"));
//     socket!.onConnectError((err) => print("Socket connect error: $err"));
//     socket!.onError((err) => print("Socket error: $err"));

//     socket!.on('send-uplink-p2p', (data) {
//       final temperatureValue =
//           double.tryParse(data['uplink']['temperature']) ?? 0.0;
//       setState(() {
//         latestTemperature = temperatureValue;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     socket?.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEAEAE3),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text("Detail Sensor Suhu",
//             style: TextStyle(color: Colors.black)),
//         iconTheme: const IconThemeData(color: Colors.black),
//         elevation: 0,
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: _initialDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Terjadi error: ${snapshot.error}'));
//           }

//           final docs = snapshot.data?.docs ?? [];
//           final hasData = docs.isNotEmpty;

//           List<FlSpot> temperaturePoints = [];

//           for (int i = 0; i < docs.length; i++) {
//             final data = docs[i].data() as Map<String, dynamic>;
//             final timestamp = data['timestamp'] ?? 0;
//             final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
//             final hour = time.hour.toDouble();

//             final uplink = data['uplink'] ?? {};
//             final temperatureValue =
//                 double.tryParse(uplink['temperature']?.toString() ?? '') ?? 0.0;

//             temperaturePoints.add(FlSpot(hour, temperatureValue));
//           }

//           if (!hasData) {
//             temperaturePoints = [const FlSpot(0, 0)];
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
//                             const Text("Temperature",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold)),
//                             AnimatedSwitcher(
//                               duration: Duration(milliseconds: 300),
//                               child: Text(
//                                 "Suhu real-time: ${latestTemperature.toStringAsFixed(2)} °C",
//                                 key: ValueKey(latestTemperature),
//                                 style: const TextStyle(
//                                     fontSize: 18, color: Colors.teal),
//                               ),
//                             ),
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
//                                 title: const Text("Indikator Temperature"),
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
//                                         _buildRow("Indikator", "Suhu",
//                                             isHeader: true),
//                                         _buildRow("Tidak Subur", "<18"),
//                                         _buildRow("Kurang Subur", "18 - 24"),
//                                         _buildRow("Subur", "24 - 32"),
//                                         _buildRow("Kurang Subur", "32 - 35"),
//                                         _buildRow("Tidak Subur", ">35"),
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
//                             const Text("Grafik Sensor Suhu",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16)),
//                             IconButton(
//                               icon: const Icon(Icons.calendar_today,
//                                   color: Colors.teal),
//                               onPressed: () async {
//                                 DateTime? picked = await showDatePicker(
//                                   context: context,
//                                   initialDate: _selectedDate ?? DateTime.now(),
//                                   firstDate: DateTime(2025),
//                                   lastDate: DateTime.now(),
//                                 );
//                                 if (picked != null) {
//                                   final start = DateTime(
//                                       picked.year, picked.month, picked.day);
//                                   final end = start.add(Duration(days: 1));
//                                   final startEpoch =
//                                       start.millisecondsSinceEpoch;
//                                   final endEpoch = end.millisecondsSinceEpoch;

//                                   setState(() {
//                                     _selectedDate = picked;
//                                     _initialDataFuture =
//                                         fetchData(startEpoch, endEpoch);
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
//                                             '${spot.y.toStringAsFixed(1)} ppm',
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
//                                   spots: temperaturePoints,
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
//
//
// <- akses SensorValueService

class SensorSuhuPage extends StatefulWidget {
  @override
  _SensorSuhuPageState createState() => _SensorSuhuPageState();
}

class _SensorSuhuPageState extends State<SensorSuhuPage> {
  final CollectionReference uplinksRef =
      FirebaseFirestore.instance.collection('uplink-p2p');

  DateTime? _selectedDate;
  double xAxisFontSize = 12;
  double yAxisFontSize = 12;

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

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAE3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Detail Sensor Suhu",
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

          List<FlSpot> temperaturePoints = [];

          for (int i = 0; i < docs.length; i++) {
            final data = docs[i].data() as Map<String, dynamic>;
            final timestamp = data['timestamp'] ?? 0;
            final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
            final hour = time.hour.toDouble();

            final uplink = data['uplink'] ?? {};
            final temperatureValue =
                double.tryParse(uplink['temperature']?.toString() ?? '') ?? 0.0;

            temperaturePoints.add(FlSpot(hour, temperatureValue));
          }

          if (!hasData) {
            temperaturePoints = [const FlSpot(0, 0)];
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
                            const Text("Temperature",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(
                                "${SensorValueService().temperature.toStringAsFixed(2)} °C",
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
                                title: const Text("Indikator Temperature"),
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
                                        _buildRow("Indikator", "Suhu",
                                            isHeader: true),
                                        _buildRow("Tidak Subur", "<18"),
                                        _buildRow("Kurang Subur", "18 - 24"),
                                        _buildRow("Subur", "24 - 32"),
                                        _buildRow("Kurang Subur", "32 - 35"),
                                        _buildRow("Tidak Subur", ">35"),
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
                            const Text("Grafik Sensor Suhu",
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
                              maxY: 50,
                              backgroundColor: Colors.white,
                              lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipBgColor:
                                      Colors.blueGrey.withOpacity(0.7),
                                  getTooltipItems: (spots) => spots
                                      .map((spot) => LineTooltipItem(
                                            '${spot.y.toStringAsFixed(1)} °C',
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
                                    interval: 5,
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
                                  spots: temperaturePoints,
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
