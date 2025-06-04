import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

// class SensorSuhuPage extends StatelessWidget {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplinks');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEAEAE3),
//       appBar: AppBar(title: Text("Detail Sensor suhu")),
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

//           final latestTemp = docs.first['temperature'] ?? 'N/A';

//           List<FlSpot> suhuPoints = [];
//           for (int i = 0; i < docs.length; i++) {
//             final data = docs[i];
//             double hour = i.toDouble(); // Asumsi satu data per jam
//             double temp = (data['temperature'] ?? 0).toDouble();
//             suhuPoints.add(FlSpot(hour, temp));
//           }

//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 10),
//                 Text("Temperature",
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
//                         _buildCell("Rentang Suhu (°C)", isHeader: true),
//                       ]),
//                       _buildRow("Tidak Subur", "< 17"),
//                       _buildRow("Kurang Subur", "17 - 22"),
//                       _buildRow("Subur", "22 - 27"),
//                       _buildRow("Kurang Subur", "27 - 32"),
//                       _buildRow("Tidak Subur", "> 32"),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30),

//                 SizedBox(height: 15),
//                 Text("Grafik Sensor Suhu",
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
//                         maxY: 50,
//                         gridData: FlGridData(show: true),
//                         titlesData: FlTitlesData(
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               interval: 1,
//                               getTitlesWidget: (value, meta) {
//                                 return Text(
//                                   "${value.toInt().toString().padLeft(2, '0')}C",
//                                   style: TextStyle(fontSize: 6),
//                                 );
//                               },
//                             ),
//                           ),
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               interval: 10,
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

//FIx
//FIX 2
//new fix
// class SensorSuhuPage extends StatelessWidget {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplinks');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEAEAE3),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title:
//             Text("Detail Sensor Suhu", style: TextStyle(color: Colors.black)),
//         iconTheme: IconThemeData(color: Colors.black),
//         elevation: 0,
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future:
//             uplinksRef.orderBy('createdAt', descending: true).limit(24).get(),
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

//           final latestTemp = docs.first['temperature']?.toDouble() ?? 0.0;
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
//                 Text("Temperature",
//                     style:
//                         TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 Text("${latestTemp.toStringAsFixed(2)} °C",
//                     style: TextStyle(fontSize: 20, color: Colors.teal)),
//                 SizedBox(height: 20),

//                 // CARD TABEL
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Table(
//                       border: TableBorder.all(color: Colors.grey.shade300),
//                       columnWidths: {
//                         0: FlexColumnWidth(2),
//                         1: FlexColumnWidth(2),
//                       },
//                       children: [
//                         _buildRow("Indikator", "Rentang Suhu (°C)",
//                             isHeader: true),
//                         _buildRow("Tidak Subur", "< 17"),
//                         _buildRow("Kurang Subur", "17 - 22"),
//                         _buildRow("Subur", "22 - 27"),
//                         _buildRow("Kurang Subur", "27 - 32"),
//                         _buildRow("Tidak Subur", "> 32"),
//                       ],
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 30),
//                 Text("Grafik Sensor Suhu",
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                 SizedBox(height: 12),

//                 // CARD GRAFIK
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: SizedBox(
//                       height: 250,
//                       child: LineChart(
//                         LineChartData(
//                           minX: 0,
//                           maxX: 23,
//                           minY: 0,
//                           maxY: 50,
//                           backgroundColor: Colors.white,
//                           gridData:
//                               FlGridData(show: false, horizontalInterval: 5),
//                           titlesData: FlTitlesData(
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 interval: 4,
//                                 getTitlesWidget: (value, meta) {
//                                   return Text('${value.toInt()}');
//                                 },
//                               ),
//                             ),
//                             leftTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 interval: 10,
//                                 getTitlesWidget: (value, meta) {
//                                   return Text('${value.toInt()}°');
//                                 },
//                               ),
//                             ),
//                             topTitles: AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                             ),
//                             rightTitles: AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                             ),
//                           ),
//                           borderData: FlBorderData(show: true),
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: suhuPoints,
//                               isCurved: true,
//                               barWidth: 3,
//                               color: Colors.teal,
//                               belowBarData: BarAreaData(
//                                 show: true,
//                                 color: Colors.teal.withOpacity(0.15),
//                               ),
//                               dotData: FlDotData(show: true),
//                             ),
//                           ],
//                         ),
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

//New Ga jadi FIX
// class SensorSuhuPage extends StatelessWidget {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplinks');

//   final List<Color> gradientColors = [
//     Color(0xff23b6e6),
//     Color(0xff02d39a),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEAEAE3),
//       appBar: AppBar(
//         title: Text("Detail Sensor Suhu"),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future:
//             uplinksRef.orderBy('createdAt', descending: true).limit(24).get(),
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

//           final latestTemp = docs.first['temperature'] ?? 'N/A';

//           List<FlSpot> suhuPoints = [];
//           for (int i = 0; i < docs.length; i++) {
//             final data = docs[i];
//             double hour = (23 - i).toDouble(); // urut dari 0 ke 23
//             double temp = (data['temperature'] ?? 0).toDouble();
//             suhuPoints.add(FlSpot(hour, temp));
//           }

//           suhuPoints = suhuPoints.reversed.toList();

//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 16),
//                 Text("Temperature",
//                     style:
//                         TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 Text("$latestTemp °C", style: TextStyle(fontSize: 18)),
//                 SizedBox(height: 20),

//                 // Tabel Rentang
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 16),
//                   color: Colors.white,
//                   child: Table(
//                     border: TableBorder.all(),
//                     columnWidths: {
//                       0: FlexColumnWidth(2),
//                       1: FlexColumnWidth(2),
//                     },
//                     children: [
//                       TableRow(
//                         decoration: BoxDecoration(color: Colors.grey[300]),
//                         children: [
//                           _buildCell("Indikator", isHeader: true),
//                           _buildCell("Rentang Suhu (°C)", isHeader: true),
//                         ],
//                       ),
//                       _buildRow("Tidak Subur", "< 17"),
//                       _buildRow("Kurang Subur", "17 - 22"),
//                       _buildRow("Subur", "22 - 27"),
//                       _buildRow("Kurang Subur", "27 - 32"),
//                       _buildRow("Tidak Subur", "> 32"),
//                     ],
//                   ),
//                 ),

//                 SizedBox(height: 30),
//                 Text("Grafik Sensor Suhu",
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                 SizedBox(height: 15),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: AspectRatio(
//                     aspectRatio: 1.7,
//                     child: LineChart(
//                       LineChartData(
//                         minX: 0,
//                         maxX: 23,
//                         minY: 0,
//                         maxY: 50,
//                         gridData: FlGridData(
//                           show: true,
//                           drawVerticalLine: true,
//                           horizontalInterval: 10,
//                           verticalInterval: 4,
//                           getDrawingHorizontalLine: (value) => FlLine(
//                             color: Colors.grey[300],
//                             strokeWidth: 1,
//                           ),
//                           getDrawingVerticalLine: (value) => FlLine(
//                             color: Colors.grey[300],
//                             strokeWidth: 1,
//                           ),
//                         ),
//                         titlesData: FlTitlesData(
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               interval: 10,
//                               getTitlesWidget: (value, _) => Text(
//                                 '${value.toInt()}',
//                                 style: TextStyle(fontSize: 10),
//                               ),
//                               reservedSize: 30,
//                             ),
//                           ),
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               interval: 4,
//                               getTitlesWidget: (value, _) => Padding(
//                                 padding: const EdgeInsets.only(top: 6.0),
//                                 child: Text(
//                                   "${value.toInt()}",
//                                   style: TextStyle(fontSize: 10),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                           topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false),
//                           ),
//                         ),
//                         borderData: FlBorderData(
//                           show: true,
//                           border: Border.all(color: Colors.grey),
//                         ),
//                         lineBarsData: [
//                           LineChartBarData(
//                             spots: suhuPoints,
//                             isCurved: true,
//                             color: Colors.teal,
//                             gradient: LinearGradient(colors: gradientColors),
//                             barWidth: 4,
//                             isStrokeCapRound: true,
//                             dotData: FlDotData(show: false),
//                             belowBarData: BarAreaData(
//                               show: true,
//                               gradient: LinearGradient(
//                                 colors: gradientColors
//                                     .map((c) => c.withOpacity(0.2))
//                                     .toList(),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
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

// c

// class SensorSuhuPage extends StatefulWidget {
//   @override
//   _SensorSuhuPageState createState() => _SensorSuhuPageState();
// }

// class _SensorSuhuPageState extends State<SensorSuhuPage> {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplinks');

//   int _selectedHours = 24;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEAEAE3),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title:
//             Text("Detail Sensor Suhu", style: TextStyle(color: Colors.black)),
//         iconTheme: IconThemeData(color: Colors.black),
//         elevation: 0,
//       ),
//       body: FutureBuilder<QuerySnapshot>(
//         future: uplinksRef
//             .orderBy('createdAt', descending: true)
//             .limit(_selectedHours)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Terjadi error: \${snapshot.error}'));
//           }

//           final docs = snapshot.data?.docs ?? [];
//           if (docs.isEmpty) {
//             return Center(child: Text('Data tidak ditemukan'));
//           }

//           final latestTemp = docs.first['temperature']?.toDouble() ?? 0.0;
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
//                 Text("Temperature",
//                     style:
//                         TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 Text("\${latestTemp.toStringAsFixed(2)} °C",
//                     style: TextStyle(fontSize: 20, color: Colors.teal)),
//                 SizedBox(height: 20),

//                 // Dropdown filter
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Tampilkan data: ", style: TextStyle(fontSize: 16)),
//                     SizedBox(width: 10),
//                     DropdownButton<int>(
//                       value: _selectedHours,
//                       items: [
//                         DropdownMenuItem(value: 12, child: Text("12 Jam")),
//                         DropdownMenuItem(value: 24, child: Text("24 Jam")),
//                         DropdownMenuItem(value: 48, child: Text("2 Hari")),
//                       ],
//                       onChanged: (value) {
//                         if (value != null) {
//                           setState(() {
//                             _selectedHours = value;
//                           });
//                         }
//                       },
//                     )
//                   ],
//                 ),

//                 SizedBox(height: 20),
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Table(
//                       border: TableBorder.all(color: Colors.grey.shade300),
//                       columnWidths: {
//                         0: FlexColumnWidth(2),
//                         1: FlexColumnWidth(2),
//                       },
//                       children: [
//                         _buildRow("Indikator", "Rentang Suhu (°C)",
//                             isHeader: true),
//                         _buildRow("Tidak Subur", "< 17"),
//                         _buildRow("Kurang Subur", "17 - 22"),
//                         _buildRow("Subur", "22 - 27"),
//                         _buildRow("Kurang Subur", "27 - 32"),
//                         _buildRow("Tidak Subur", "> 32"),
//                       ],
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 30),
//                 Text("Grafik Sensor Suhu",
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                 SizedBox(height: 12),

//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: SizedBox(
//                       height: 250,
//                       child: LineChart(
//                         LineChartData(
//                           minX: 0,
//                           maxX: (_selectedHours - 1).toDouble(),
//                           minY: 0,
//                           maxY: 50,
//                           backgroundColor: Colors.white,
//                           gridData: FlGridData(show: false),
//                           titlesData: FlTitlesData(
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 interval: (_selectedHours / 6).toDouble(),
//                                 getTitlesWidget: (value, meta) {
//                                   return Text(value.toInt().toString());
//                                 },
//                               ),
//                             ),
//                             leftTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 interval: 10,
//                                 getTitlesWidget: (value, meta) {
//                                   return Text("\${value.toInt()}°");
//                                 },
//                               ),
//                             ),
//                             topTitles: AxisTitles(
//                                 sideTitles: SideTitles(showTitles: false)),
//                             rightTitles: AxisTitles(
//                                 sideTitles: SideTitles(showTitles: false)),
//                           ),
//                           borderData: FlBorderData(show: true),
//                           lineTouchData: LineTouchData(
//                             enabled: true,
//                             touchTooltipData: LineTouchTooltipData(
//                               tooltipBgColor: Colors.black87,
//                               getTooltipItems: (touchedSpots) {
//                                 return touchedSpots.map((spot) {
//                                   return LineTooltipItem(
//                                     '${spot.y.toStringAsFixed(1)} °C',
//                                     TextStyle(color: Colors.white),
//                                   );
//                                 }).toList();
//                               },
//                             ),
//                           ),
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: suhuPoints,
//                               isCurved: true,
//                               isStrokeCapRound: true,
//                               barWidth: 3,
//                               gradient: LinearGradient(
//                                 colors: [Colors.teal, Colors.blueAccent],
//                               ),
//                               belowBarData: BarAreaData(
//                                 show: true,
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.teal.withOpacity(0.3),
//                                     Colors.blueAccent.withOpacity(0.2),
//                                   ],
//                                 ),
//                               ),
//                               dotData: FlDotData(show: false),
//                             ),
//                           ],
//                         ),
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

// class SensorSuhuPage extends StatelessWidget {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplinks');

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
//         future:
//             uplinksRef.orderBy('createdAt', descending: true).limit(24).get(),
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
//                 const Text("Temperature",
//                     style:
//                         TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 Text("${latestTemp.toStringAsFixed(2)} °C",
//                     style: const TextStyle(fontSize: 20, color: Colors.teal)),
//                 const SizedBox(height: 20),

//                 // CARD TABEL
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Table(
//                       border: TableBorder.all(color: Colors.grey.shade300),
//                       columnWidths: const {
//                         0: FlexColumnWidth(2),
//                         1: FlexColumnWidth(2),
//                       },
//                       children: [
//                         _buildRow("Indikator", "Rentang Suhu (°C)",
//                             isHeader: true),
//                         _buildRow("Tidak Subur", "< 17"),
//                         _buildRow("Kurang Subur", "17 - 22"),
//                         _buildRow("Subur", "22 - 27"),
//                         _buildRow("Kurang Subur", "27 - 32"),
//                         _buildRow("Tidak Subur", "> 32"),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),
//                 const Text("Grafik Sensor Suhu",
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                 const SizedBox(height: 12),

//                 // CARD GRAFIK
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: SizedBox(
//                       height: 300,
//                       child: LineChart(
//                         LineChartData(
//                           minX: 0,
//                           maxX: 23,
//                           minY: 0,
//                           maxY: 50,
//                           backgroundColor: Colors.white,
//                           lineTouchData: LineTouchData(
//                             touchTooltipData: LineTouchTooltipData(
//                               tooltipBgColor: Colors.blueGrey.withOpacity(0.7),
//                               getTooltipItems: (touchedSpots) {
//                                 return touchedSpots.map((spot) {
//                                   return LineTooltipItem(
//                                     '${spot.y.toStringAsFixed(1)} °C',
//                                     const TextStyle(color: Colors.white),
//                                   );
//                                 }).toList();
//                               },
//                             ),
//                             handleBuiltInTouches: true,
//                             enabled: true,
//                           ),
//                           gridData: FlGridData(show: false),
//                           titlesData: FlTitlesData(
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 interval: 4,
//                                 getTitlesWidget: (value, meta) {
//                                   return Text('${value.toInt()}');
//                                 },
//                               ),
//                             ),
//                             leftTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 interval: 10,
//                                 getTitlesWidget: (value, meta) {
//                                   return Text('${value.toInt()}°');
//                                 },
//                               ),
//                             ),
//                             topTitles: AxisTitles(
//                                 sideTitles: SideTitles(showTitles: false)),
//                             rightTitles: AxisTitles(
//                                 sideTitles: SideTitles(showTitles: false)),
//                           ),
//                           borderData: FlBorderData(show: true),
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: suhuPoints,
//                               isCurved: true,
//                               isStrokeCapRound: true,
//                               barWidth: 4,
//                               gradient: LinearGradient(
//                                 colors: [Colors.teal, Colors.green],
//                               ),
//                               dotData: FlDotData(show: false),
//                               belowBarData: BarAreaData(
//                                 show: true,
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.teal.withOpacity(0.3),
//                                     Colors.green.withOpacity(0.2),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                           // Zoom dan pan support
//                           // lineTouchDataHandle: null, // null untuk default zoom/pan
//                           clipData: FlClipData
//                               .all(), // untuk menjaga grafik tetap dalam batas
//                           // Dragging support
//                           showingTooltipIndicators: [],
//                         ),
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

// class SensorSuhuPage extends StatefulWidget {
//   @override
//   _SensorSuhuPageState createState() => _SensorSuhuPageState();
// }

// class _SensorSuhuPageState extends State<SensorSuhuPage> {
//   final CollectionReference uplinksRef =
//       FirebaseFirestore.instance.collection('uplinks');

//   String selectedRange = '24.00';

//   List<FlSpot> _generateSuhuPoints(List<DocumentSnapshot> docs) {
//     return List<FlSpot>.generate(docs.length, (i) {
//       final temp = docs[i]['temperature']?.toDouble() ?? 0.0;
//       return FlSpot(i.toDouble(), temp);
//     });
//   }

//   int getLimitFromRange(String range) {
//     switch (range) {
//       case '12.00':
//         return 12;
//       case '2 Hari':
//         return 48;
//       default:
//         return 24;
//     }
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
//         future: uplinksRef
//             .orderBy('createdAt', descending: true)
//             .limit(getLimitFromRange(selectedRange))
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
//           final suhuPoints = _generateSuhuPoints(docs);

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Text("Temperature",
//                     style:
//                         TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 Text("${latestTemp.toStringAsFixed(2)} °C",
//                     style: const TextStyle(fontSize: 20, color: Colors.teal)),
//                 const SizedBox(height: 20),

//                 // CARD TABEL
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Table(
//                       border: TableBorder.all(color: Colors.grey.shade300),
//                       columnWidths: const {
//                         0: FlexColumnWidth(2),
//                         1: FlexColumnWidth(2),
//                       },
//                       children: [
//                         _buildRow("Indikator", "Rentang Suhu (°C)",
//                             isHeader: true),
//                         _buildRow("Tidak Subur", "< 17"),
//                         _buildRow("Kurang Subur", "17 - 22"),
//                         _buildRow("Subur", "22 - 27"),
//                         _buildRow("Kurang Subur", "27 - 32"),
//                         _buildRow("Tidak Subur", "> 32"),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),
//                 const Text("Grafik Sensor Suhu",
//                     style:
//                         TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

//                 const SizedBox(height: 8),
//                 // Data Range Selector
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     for (var range in ['12 Jam', '24 Jam', '2 Hari'])
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 6.0),
//                         child: ChoiceChip(
//                           label: Text(range),
//                           selected: selectedRange == range,
//                           onSelected: (selected) {
//                             setState(() => selectedRange = range);
//                           },
//                         ),
//                       ),
//                   ],
//                 ),

//                 const SizedBox(height: 12),

//                 // CARD GRAFIK
//                 Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: SizedBox(
//                       height: 300,
//                       child: LineChart(
//                         LineChartData(
//                           minX: 0,
//                           maxX: suhuPoints.length.toDouble() - 1,
//                           minY: 0,
//                           maxY: 50,
//                           backgroundColor: Colors.white,
//                           lineTouchData: LineTouchData(
//                             touchTooltipData: LineTouchTooltipData(
//                               tooltipBgColor: Colors.teal,
//                               getTooltipItems: (touchedSpots) => touchedSpots
//                                   .map(
//                                     (spot) => LineTooltipItem(
//                                       '${spot.y.toStringAsFixed(1)} °C',
//                                       const TextStyle(color: Colors.white),
//                                     ),
//                                   )
//                                   .toList(),
//                             ),
//                             handleBuiltInTouches: true,
//                             enabled: true,
//                           ),
//                           gridData: FlGridData(show: false),
//                           titlesData: FlTitlesData(
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 interval: 4,
//                                 getTitlesWidget: (value, meta) {
//                                   return Text(
//                                     value.toInt().toString(),
//                                     style: const TextStyle(fontSize: 10),
//                                   );
//                                 },
//                               ),
//                             ),
//                             leftTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 interval: 10,
//                                 getTitlesWidget: (value, meta) {
//                                   return Text(
//                                     '${value.toInt()}°',
//                                     style: const TextStyle(fontSize: 10),
//                                   );
//                                 },
//                               ),
//                             ),
//                             topTitles: AxisTitles(
//                                 sideTitles: SideTitles(showTitles: false)),
//                             rightTitles: AxisTitles(
//                                 sideTitles: SideTitles(showTitles: false)),
//                           ),
//                           borderData: FlBorderData(
//                               show: false), // menghilangkan garis tepi
//                           clipData: FlClipData.all(),
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: suhuPoints,
//                               isCurved: true,
//                               isStrokeCapRound: true,
//                               barWidth: 4,
//                               gradient: LinearGradient(
//                                 colors: [Colors.teal, Colors.green],
//                               ),
//                               dotData: FlDotData(show: false),
//                               belowBarData: BarAreaData(
//                                 show: true,
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.teal.withOpacity(0.3),
//                                     Colors.green.withOpacity(0.2),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
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

class SensorSuhuPage extends StatefulWidget {
  @override
  _SensorSuhuPageState createState() => _SensorSuhuPageState();
}

class _SensorSuhuPageState extends State<SensorSuhuPage> {
  final CollectionReference uplinksRef =
      FirebaseFirestore.instance.collection('uplinks');

  int _selectedHours = 24;

  @override
  Widget build(BuildContext context) {
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
            .orderBy('createdAt', descending: true)
            .limit(_selectedHours)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final double latestTemp =
              docs.first['temperature']?.toDouble() ?? 0.0;

          List<FlSpot> suhuPoints = [];
          for (int i = 0; i < docs.length; i++) {
            final temp = docs[i]['temperature']?.toDouble() ?? 0.0;
            suhuPoints.add(FlSpot(i.toDouble(), temp));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Temperature",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("${latestTemp.toStringAsFixed(2)} °C",
                    style: const TextStyle(fontSize: 20, color: Colors.teal)),
                const SizedBox(height: 20),

                const SizedBox(height: 20),

                // CARD TABEL
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Table(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                      },
                      children: [
                        _buildRow("Indikator", "Rentang Suhu (°C)",
                            isHeader: true),
                        _buildRow("Tidak Subur", "< 17"),
                        _buildRow("Kurang Subur", "17 - 22"),
                        _buildRow("Subur", "22 - 27"),
                        _buildRow("Kurang Subur", "27 - 32"),
                        _buildRow("Tidak Subur", "> 32"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const Text("Grafik Sensor Suhu",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),

                // Dropdown Range Selector
                DropdownButton<int>(
                  value: _selectedHours,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedHours = newValue;
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 12, child: Text("12 Jam")),
                    DropdownMenuItem(value: 24, child: Text("24 Jam")),
                    DropdownMenuItem(value: 48, child: Text("2 Hari")),
                  ],
                ),
                // CARD GRAFIK
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: _selectedHours.toDouble() - 1,
                          minY: 0,
                          maxY: 50,
                          backgroundColor: Colors.white,
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.blueGrey.withOpacity(0.7),
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  return LineTooltipItem(
                                    '${spot.y.toStringAsFixed(1)} °C',
                                    const TextStyle(color: Colors.white),
                                  );
                                }).toList();
                              },
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
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()}');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()}°');
                                },
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
                              spots: suhuPoints,
                              isCurved: true,
                              isStrokeCapRound: true,
                              barWidth: 4,
                              gradient: LinearGradient(
                                colors: [Colors.teal, Colors.green],
                              ),
                              dotData: FlDotData(show: false),
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
    return TableRow(children: [
      _buildCell(indikator, isHeader: isHeader),
      _buildCell(rentang, isHeader: isHeader),
    ]);
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
