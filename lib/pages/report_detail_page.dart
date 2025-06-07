import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(Duration(days: 1));

//     return FirebaseFirestore.instance
//         .collection('uplinks')
//         .where('createdAt', isGreaterThanOrEqualTo: start)
//         .where('createdAt', isLessThan: end)
//         .orderBy('createdAt')
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList());
//   }

//   TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
//     return TableRow(
//       decoration:
//           BoxDecoration(color: isHeader ? Colors.green[100] : Colors.white),
//       children: cells.map((cell) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             cell,
//             style: TextStyle(
//                 fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Future<void> _exportCSV(BuildContext context) async {
//     final start =
//         DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
//     final end = start.add(Duration(days: 1));

//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplinks')
//         .where('createdAt', isGreaterThanOrEqualTo: start)
//         .where('createdAt', isLessThan: end)
//         .orderBy('createdAt')
//         .get();

//     final rows = [
//       [
//         "#",
//         "Time",
//         "Temperature",
//         "Humidity",
//         "pH",
//         "Nitrogen",
//         "Phosphorus",
//         "Potassium"
//       ]
//     ];

//     int index = 1;
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final createdAt = (data['createdAt'] as Timestamp).toDate();
//       rows.add([
//         "$index",
//         "${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}",
//         data['temperature'].toString(),
//         data['humidity'].toString(),
//         data['ph'].toString(),
//         data['nitrogen'].toString(),
//         data['phosphorus'].toString(),
//         data['potassium'].toString(),
//       ]);
//       index++;
//     }

//     final csvData = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path =
//         "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
//     final file = File(path);
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Report disimpan di $path")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Report"),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _exportCSV(context),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: getSensorDataForDate(selectedDate),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());
//           final data = snapshot.data!;
//           if (data.isEmpty)
//             return Center(child: Text("Tidak ada data untuk tanggal ini"));
//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Table(
//                 border: TableBorder.all(),
//                 defaultColumnWidth: FixedColumnWidth(120),
//                 children: [
//                   _buildTableRow([
//                     "#",
//                     "Time",
//                     "Temperature",
//                     "Humidity",
//                     "pH",
//                     "Nitrogen",
//                     "Phosphorus",
//                     "Potassium"
//                   ], isHeader: true),
//                   ...data.asMap().entries.map((entry) {
//                     final i = entry.key + 1;
//                     final item = entry.value;
//                     final time = (item['createdAt'] as Timestamp).toDate();
//                     return _buildTableRow([
//                       "$i",
//                       "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
//                       item['temperature'].toString(),
//                       item['humidity'].toString(),
//                       item['ph'].toString(),
//                       item['nitrogen'].toString(),
//                       item['phosphorus'].toString(),
//                       item['potassium'].toString(),
//                     ]);
//                   })
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(Duration(days: 1));

//     return FirebaseFirestore.instance
//         .collection('uplinks')
//         .where('createdAt', isGreaterThanOrEqualTo: start)
//         .where('createdAt', isLessThan: end)
//         .orderBy('createdAt')
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList());
//   }

//   TableRow _buildTableRow(List<String> cells,
//       {bool isHeader = false, double fontSize = 14}) {
//     return TableRow(
//       decoration:
//           BoxDecoration(color: isHeader ? Colors.green[100] : Colors.white),
//       children: cells.map((cell) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             cell,
//             style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Future<void> _exportCSV(BuildContext context) async {
//     final start =
//         DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
//     final end = start.add(Duration(days: 1));

//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplinks')
//         .where('createdAt', isGreaterThanOrEqualTo: start)
//         .where('createdAt', isLessThan: end)
//         .orderBy('createdAt')
//         .get();

//     final rows = [
//       [
//         "#",
//         "Time",
//         "Temperature",
//         "Humidity",
//         "pH",
//         "Nitrogen",
//         "Phosphorus",
//         "Potassium"
//       ]
//     ];

//     int index = 1;
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final createdAt = (data['createdAt'] as Timestamp).toDate();
//       rows.add([
//         "$index",
//         "${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}",
//         data['temperature'].toString(),
//         data['humidity'].toString(),
//         data['ph'].toString(),
//         data['nitrogen'].toString(),
//         data['phosphorus'].toString(),
//         data['potassium'].toString(),
//       ]);
//       index++;
//     }

//     final csvData = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path =
//         "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
//     final file = File(path);
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Report disimpan di $path")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Report"),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _exportCSV(context),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: getSensorDataForDate(selectedDate),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());
//           final data = snapshot.data!;
//           if (data.isEmpty)
//             return Center(child: Text("Tidak ada data untuk tanggal ini"));

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Table(
//                 border: TableBorder.all(),
//                 defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                 columnWidths: const {
//                   0: FixedColumnWidth(40),
//                   1: FixedColumnWidth(70),
//                   2: FixedColumnWidth(100),
//                   3: FixedColumnWidth(100),
//                   4: FixedColumnWidth(70),
//                   5: FixedColumnWidth(100),
//                   6: FixedColumnWidth(100),
//                   7: FixedColumnWidth(100),
//                 },
//                 children: [
//                   _buildTableRow([
//                     "#",
//                     "Time",
//                     "Temperature",
//                     "Humidity",
//                     "pH",
//                     "Nitrogen",
//                     "Phosphorus",
//                     "Potassium"
//                   ], isHeader: true, fontSize: 16),
//                   ...data.asMap().entries.map((entry) {
//                     final i = entry.key + 1;
//                     final item = entry.value;
//                     final time = (item['createdAt'] as Timestamp).toDate();
//                     return _buildTableRow([
//                       "$i",
//                       "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
//                       item['temperature'].toString(),
//                       item['humidity'].toString(),
//                       item['ph'].toString(),
//                       item['nitrogen'].toString(),
//                       item['phosphorus'].toString(),
//                       item['potassium'].toString(),
//                     ], fontSize: 14);
//                   })
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(Duration(days: 1));

//     return FirebaseFirestore.instance
//         .collection('uplinks')
//         .where('createdAt', isGreaterThanOrEqualTo: start)
//         .where('createdAt', isLessThan: end)
//         .orderBy('createdAt')
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList());
//   }

//   Future<void> _exportCSV(BuildContext context) async {
//     final start =
//         DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
//     final end = start.add(Duration(days: 1));

//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplinks')
//         .where('createdAt', isGreaterThanOrEqualTo: start)
//         .where('createdAt', isLessThan: end)
//         .orderBy('createdAt')
//         .get();

//     final rows = [
//       [
//         "#",
//         "Time",
//         "Temperature",
//         "Humidity",
//         "pH",
//         "Nitrogen",
//         "Phosphorus",
//         "Potassium"
//       ]
//     ];

//     int index = 1;
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final createdAt = (data['createdAt'] as Timestamp).toDate();
//       rows.add([
//         "$index",
//         "${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}",
//         data['temperature'].toString(),
//         data['humidity'].toString(),
//         data['ph'].toString(),
//         data['nitrogen'].toString(),
//         data['phosphorus'].toString(),
//         data['potassium'].toString(),
//       ]);
//       index++;
//     }

//     final csvData = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path =
//         "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
//     final file = File(path);
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Report disimpan di $path")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Report"),
//         backgroundColor: Color(0xFFEAEAE3),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _exportCSV(context),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: getSensorDataForDate(selectedDate),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final data = snapshot.data!;
//           if (data.isEmpty)
//             return Center(child: Text("Tidak ada data untuk tanggal ini"));

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Table(
//                   border: TableBorder.symmetric(
//                       // inside: BorderSide(color: Colors.grey.shade300),
//                       // outside: BorderSide(color: Colors.grey.shade500),
//                       ),
//                   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                   columnWidths: const {
//                     0: FixedColumnWidth(45),
//                     1: FixedColumnWidth(180),
//                     2: FixedColumnWidth(112),
//                     3: FixedColumnWidth(85),
//                     4: FixedColumnWidth(45),
//                     5: FixedColumnWidth(100),
//                     6: FixedColumnWidth(100),
//                     7: FixedColumnWidth(100),
//                   },
//                   children: [
//                     TableRow(
//                       decoration: BoxDecoration(color: Colors.grey.shade300),
//                       children: [
//                         _headerCell("NO"),
//                         _headerCell("TIMESTAMP"),
//                         _headerCell("TEMPERATURE"),
//                         _headerCell("HUMIDITY"),
//                         _headerCell("PH"),
//                         _headerCell("NITROGEN"),
//                         _headerCell("FOSFOR"),
//                         _headerCell("KALIUM"),
//                       ],
//                     ),
//                     ...data.asMap().entries.map((entry) {
//                       final i = entry.key + 1;
//                       final item = entry.value;
//                       final time = (item['createdAt'] as Timestamp).toDate();
//                       return TableRow(
//                         decoration: BoxDecoration(
//                           color: i % 1 == 0 ? Colors.white : Colors.grey[100],
//                         ),
//                         children: [
//                           _dataCell("$i"),
//                           _dataCell(
//                               "${time.year}:${time.month.toString().padLeft(2, '0')}:${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}:${time.millisecond}"),
//                           _dataCell(
//                               "${item['temperature']?.toStringAsFixed(2) ?? '-'} °C"),
//                           _dataCell("${item['humidity'] ?? '-'} %"),
//                           _dataCell("${item['ph'] ?? '-'}"),
//                           _dataCell("${item['nitrogen'] ?? '-'}"),
//                           _dataCell("${item['phosphorus'] ?? '-'}"),
//                           _dataCell("${item['potassium'] ?? '-'}"),
//                         ],
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _headerCell(String text) => Padding(
//         padding: const EdgeInsets.all(12),
//         child: Text(
//           text,
//           style: TextStyle(
//               fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
//           textAlign: TextAlign.center,
//         ),
//       );

//   Widget _dataCell(String text) => Padding(
//         padding: const EdgeInsets.all(10),
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 12, color: Colors.black87),
//           textAlign: TextAlign.center,
//         ),
//       );
// }

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(Duration(days: 1));

//     return FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .where('timestamp', isGreaterThanOrEqualTo: start)
//         .where('timestamp', isLessThan: end)
//         .orderBy('timestamp')
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList());
//   }

//   TableRow _buildTableRow(List<String> cells,
//       {bool isHeader = false, double fontSize = 12}) {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: isHeader ? Colors.grey[300] : Colors.white,
//       ),
//       children: cells.map((cell) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//           child: Text(
//             cell,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Future<void> _exportCSV(BuildContext context) async {
//     final start =
//         DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
//     final end = start.add(Duration(days: 1));

//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .where('timestamp', isGreaterThanOrEqualTo: start)
//         .where('timestamp', isLessThan: end)
//         .orderBy('timestamp')
//         .get();

//     final rows = [
//       [
//         "#",
//         "Time",
//         "Temperature",
//         "Humidity",
//         "pH",
//         "Nitrogen",
//         "Phosphorus",
//         "Potassium"
//       ]
//     ];

//     int index = 1;
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final createdAt = (data['timestamp'] as Timestamp).toDate();
//       final timeStr =
//           "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";

//       rows.add([
//         "$index",
//         timeStr,
//         data['temperature'].toString(),
//         data['humidity'].toString(),
//         data['ph'].toString(),
//         data['nitrogen'].toString(),
//         data['phosphorus'].toString(),
//         data['potassium'].toString(),
//       ]);
//       index++;
//     }

//     final csvData = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path =
//         "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
//     final file = File(path);
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Report disimpan di $path")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Report"),
//         backgroundColor: Color(0xFFEAEAE3),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _exportCSV(context),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: getSensorDataForDate(selectedDate),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final data = snapshot.data!;
//           if (data.isEmpty)
//             return Center(child: Text("Tidak ada data untuk tanggal ini"));

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12), // sudut melengkung
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Table(
//                     // border: TableBorder.all(color: Colors.grey.shade400),
//                     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                     columnWidths: const {
//                       0: FixedColumnWidth(30),
//                       1: FixedColumnWidth(50),
//                       2: FixedColumnWidth(88),
//                       3: FixedColumnWidth(68),
//                       4: FixedColumnWidth(35),
//                       5: FixedColumnWidth(65),
//                       6: FixedColumnWidth(72),
//                       7: FixedColumnWidth(56),
//                     },
//                     children: [
//                       _buildTableRow([
//                         "#",
//                         "Time",
//                         "Temperature",
//                         "Humidity",
//                         "pH",
//                         "Nitrogen",
//                         "Phosphor",
//                         "Kalium"
//                       ], isHeader: true, fontSize: 12),
//                       ...data.asMap().entries.map((entry) {
//                         final i = entry.key + 1;
//                         final item = entry.value;
//                         final time = (item['timestamp'] as Timestamp).toDate();
//                         final timeStr =
//                             "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//                         return _buildTableRow([
//                           "$i",
//                           timeStr,
//                           item['temperature'].toString(),
//                           item['humidity'].toString(),
//                           item['ph'].toString(),
//                           item['nitrogen'].toString(),
//                           item['phosphorus'].toString(),
//                           item['potassium'].toString(),
//                         ]);
//                       }).toList()
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// Widget _headerCell(String text) => Padding(
//       padding: const EdgeInsets.all(12),
//       child: Text(
//         text,
//         style: TextStyle(
//             fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
//         textAlign: TextAlign.center,
//       ),
//     );

// Widget _dataCell(String text) => Padding(
//       padding: const EdgeInsets.all(10),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 12, color: Colors.black87),
//         textAlign: TextAlign.center,
//       ),
//     );

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(Duration(days: 1));

//     return FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .orderBy('timestamp') // <-- PENTING: orderBy sebelum where
//         .where('timestamp', isGreaterThanOrEqualTo: start)
//         .where('timestamp', isLessThan: end)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList());
//   }

//   TableRow _buildTableRow(List<String> cells,
//       {bool isHeader = false, double fontSize = 12}) {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: isHeader ? Colors.grey[300] : Colors.white,
//       ),
//       children: cells.map((cell) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//           child: Text(
//             cell,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Future<void> _exportCSV(BuildContext context) async {
//     final start =
//         DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
//     final end = start.add(Duration(days: 1));

//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .orderBy('timestamp')
//         .where('timestamp', isGreaterThanOrEqualTo: start)
//         .where('timestamp', isLessThan: end)
//         .get();

//     final rows = [
//       [
//         "#",
//         "Time",
//         "Temperature",
//         "Humidity",
//         "pH",
//         "Nitrogen",
//         "Phosphorus",
//         "Potassium"
//       ]
//     ];

//     int index = 1;
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final createdAt = (data['timestamp'] as Timestamp).toDate();
//       final timeStr =
//           "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";

//       rows.add([
//         "$index",
//         timeStr,
//         data['temperature'].toString(),
//         data['humidity'].toString(),
//         data['ph'].toString(),
//         data['nitrogen'].toString(),
//         data['phosphorus'].toString(),
//         data['potassium'].toString(),
//       ]);
//       index++;
//     }

//     final csvData = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path =
//         "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
//     final file = File(path);
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Report disimpan di $path")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Report"),
//         backgroundColor: Color(0xFFEAEAE3),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _exportCSV(context),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: getSensorDataForDate(selectedDate),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final data = snapshot.data!;
//           if (data.isEmpty)
//             return Center(child: Text("Tidak ada data untuk tanggal ini"));

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Table(
//                     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                     columnWidths: const {
//                       0: FixedColumnWidth(30),
//                       1: FixedColumnWidth(50),
//                       2: FixedColumnWidth(88),
//                       3: FixedColumnWidth(68),
//                       4: FixedColumnWidth(35),
//                       5: FixedColumnWidth(65),
//                       6: FixedColumnWidth(72),
//                       7: FixedColumnWidth(56),
//                     },
//                     children: [
//                       _buildTableRow([
//                         "#",
//                         "Time",
//                         "Temperature",
//                         "Humidity",
//                         "pH",
//                         "Nitrogen",
//                         "Phosphor",
//                         "Kalium"
//                       ], isHeader: true, fontSize: 12),
//                       ...data.asMap().entries.map((entry) {
//                         final i = entry.key + 1;
//                         final item = entry.value;
//                         final time = (item['timestamp'] as Timestamp).toDate();
//                         final timeStr =
//                             "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//                         return _buildTableRow([
//                           "$i",
//                           timeStr,
//                           item['temperature'].toString(),
//                           item['humidity'].toString(),
//                           item['ph'].toString(),
//                           item['nitrogen'].toString(),
//                           item['phosphorus'].toString(),
//                           item['potassium'].toString(),
//                         ]);
//                       }).toList()
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(Duration(days: 1));

//     return FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .orderBy('timestamp')
//         .where('timestamp', isGreaterThanOrEqualTo: start)
//         .where('timestamp', isLessThan: end)
//         .snapshots()
//         .map((snapshot) {
//       final docs = snapshot.docs.map((doc) {
//         final data = doc.data();
//         print("🔥 Data Dokumen: $data"); // Debug untuk cek struktur data
//         return data as Map<String, dynamic>;
//       }).toList();
//       return docs;
//     });
//   }

//   TableRow _buildTableRow(List<String> cells,
//       {bool isHeader = false, double fontSize = 12}) {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: isHeader ? Colors.grey[300] : Colors.white,
//       ),
//       children: cells.map((cell) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//           child: Text(
//             cell,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Future<void> _exportCSV(BuildContext context) async {
//     final start =
//         DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
//     final end = start.add(Duration(days: 1));

//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .orderBy('timestamp')
//         .where('timestamp', isGreaterThanOrEqualTo: start)
//         .where('timestamp', isLessThan: end)
//         .get();

//     final rows = [
//       [
//         "#",
//         "Time",
//         "Temperature",
//         "Humidity",
//         "pH",
//         "Nitrogen",
//         "Phosphorus",
//         "Potassium"
//       ]
//     ];

//     int index = 1;
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       print("🔥 Data Dokumen (Export): $data"); // Debug untuk cek ekspor

//       final createdAt = (data['timestamp'] as Timestamp).toDate();
//       final timeStr =
//           "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";

//       rows.add([
//         "$index",
//         timeStr,
//         data['temperature'].toString(),
//         data['humidity'].toString(),
//         data['ph'].toString(),
//         data['nitrogen'].toString(),
//         data['phosphorus'].toString(),
//         data['potassium'].toString(),
//       ]);
//       index++;
//     }

//     final csvData = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path =
//         "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
//     final file = File(path);
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Report disimpan di $path")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Report"),
//         backgroundColor: Color(0xFFEAEAE3),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _exportCSV(context),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: getSensorDataForDate(selectedDate),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final data = snapshot.data!;
//           if (data.isEmpty)
//             return Center(child: Text("Tidak ada data untuk tanggal ini"));

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Table(
//                     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                     columnWidths: const {
//                       0: FixedColumnWidth(30),
//                       1: FixedColumnWidth(50),
//                       2: FixedColumnWidth(88),
//                       3: FixedColumnWidth(68),
//                       4: FixedColumnWidth(35),
//                       5: FixedColumnWidth(65),
//                       6: FixedColumnWidth(72),
//                       7: FixedColumnWidth(56),
//                     },
//                     children: [
//                       _buildTableRow([
//                         "#",
//                         "Time",
//                         "Temperature",
//                         "Humidity",
//                         "pH",
//                         "Nitrogen",
//                         "Phosphor",
//                         "Kalium"
//                       ], isHeader: true, fontSize: 12),
//                       ...data.asMap().entries.map((entry) {
//                         final i = entry.key + 1;
//                         final item = entry.value;
//                         final time = (item['timestamp'] as Timestamp).toDate();
//                         final timeStr =
//                             "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//                         return _buildTableRow([
//                           "$i",
//                           timeStr,
//                           item['temperature'].toString(),
//                           item['humidity'].toString(),
//                           item['ph'].toString(),
//                           item['nitrogen'].toString(),
//                           item['phosphorus'].toString(),
//                           item['potassium'].toString(),
//                         ]);
//                       }).toList()
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:csv/csv.dart';
// import 'package:path_provider/path_provider.dart';

//

// //

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(Duration(days: 1));
//     final startEpoch = start.millisecondsSinceEpoch;
//     final endEpoch = end.millisecondsSinceEpoch;

//     return FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .where('timestamp', isGreaterThanOrEqualTo: startEpoch.toString())
//         .where('timestamp', isLessThan: endEpoch.toString())
//         .orderBy('timestamp')
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
//   }

//   TableRow _buildTableRow(List<String> cells,
//       {bool isHeader = false, double fontSize = 14}) {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: isHeader ? Colors.grey[300] : Colors.white,
//       ),
//       children: cells.map((cell) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//           child: Text(
//             cell,
//             style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Future<void> _exportCSV(BuildContext context) async {
//     final start =
//         DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
//     final end = start.add(Duration(days: 1));
//     final startEpoch = start.millisecondsSinceEpoch;
//     final endEpoch = end.millisecondsSinceEpoch;

//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .where('timestamp', isGreaterThanOrEqualTo: startEpoch.toString())
//         .where('timestamp', isLessThan: endEpoch.toString())
//         .orderBy('timestamp')
//         .get();

//     final rows = [
//       [
//         "#",
//         "Time",
//         "Temperature",
//         "Humidity",
//         "pH",
//         "Nitrogen",
//         "Phosphorus",
//         "Potassium"
//       ]
//     ];

//     int index = 1;
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final timestamp = int.tryParse(data['timestamp'] ?? '') ?? 0;
//       final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
//       final timeStr =
//           "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//       rows.add([
//         "$index",
//         timeStr,
//         data['temperature'] ?? '',
//         data['humidity'] ?? '',
//         data['ph'] ?? '',
//         data['nitrogen'] ?? '',
//         data['phosphorus'] ?? '',
//         data['potassium'] ?? '',
//       ]);
//       index++;
//     }

//     final csvData = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path =
//         "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
//     final file = File(path);
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Report disimpan di $path")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Report"),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _exportCSV(context),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: getSensorDataForDate(selectedDate),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final data = snapshot.data!;
//           if (data.isEmpty)
//             return Center(child: Text("Tidak ada data untuk tanggal ini"));

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Table(
//                     border: TableBorder.all(color: Colors.grey.shade400),
//                     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                     columnWidths: const {
//                       0: FixedColumnWidth(50),
//                       1: FixedColumnWidth(80),
//                       2: FixedColumnWidth(110),
//                       3: FixedColumnWidth(110),
//                       4: FixedColumnWidth(70),
//                       5: FixedColumnWidth(100),
//                       6: FixedColumnWidth(100),
//                       7: FixedColumnWidth(100),
//                     },
//                     children: [
//                       _buildTableRow([
//                         "#",
//                         "Time",
//                         "Temperature",
//                         "Humidity",
//                         "pH",
//                         "Nitrogen",
//                         "Phosphorus",
//                         "Potassium"
//                       ], isHeader: true, fontSize: 16),
//                       ...data.asMap().entries.map((entry) {
//                         final i = entry.key + 1;
//                         final item = entry.value;
//                         final timestamp =
//                             int.tryParse(item['timestamp'] ?? '') ?? 0;
//                         final time =
//                             DateTime.fromMillisecondsSinceEpoch(timestamp);
//                         final timeStr =
//                             "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//                         return _buildTableRow([
//                           "$i",
//                           timeStr,
//                           item['temperature'] ?? '',
//                           item['humidity'] ?? '',
//                           item['ph'] ?? '',
//                           item['nitrogen'] ?? '',
//                           item['phosphorus'] ?? '',
//                           item['potassium'] ?? '',
//                         ]);
//                       }).toList()
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(Duration(days: 1));
//     final startEpoch = start.millisecondsSinceEpoch;
//     final endEpoch = end.millisecondsSinceEpoch;

//     return FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .where('timestamp', isGreaterThanOrEqualTo: startEpoch.toString())
//         .where('timestamp', isLessThan: endEpoch.toString())
//         .orderBy('timestamp')
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
//   }

//   TableRow _buildTableRow(List<String> cells,
//       {bool isHeader = false, double fontSize = 14}) {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: isHeader ? Colors.grey[300] : Colors.white,
//       ),
//       children: cells.map((cell) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//           child: Text(
//             cell,
//             style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Future<void> _exportCSV(BuildContext context) async {
//     final start =
//         DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
//     final end = start.add(Duration(days: 1));
//     final startEpoch = start.millisecondsSinceEpoch;
//     final endEpoch = end.millisecondsSinceEpoch;

//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .where('timestamp', isGreaterThanOrEqualTo: startEpoch.toString())
//         .where('timestamp', isLessThan: endEpoch.toString())
//         .orderBy('timestamp')
//         .get();

//     final rows = [
//       [
//         "#",
//         "Time",
//         "Temperature",
//         "Humidity",
//         "pH",
//         "Nitrogen",
//         "Phosphorus",
//         "Potassium"
//       ]
//     ];

//     int index = 1;
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final metadata = data['metadata'] ?? {};

//       final timestamp = int.tryParse(data['timestamp'] ?? '') ?? 0;
//       final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
//       final timeStr =
//           "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//       rows.add([
//         "$index",
//         timeStr,
//         metadata['temperature']?.toString() ?? '',
//         metadata['humidity']?.toString() ?? '',
//         metadata['ph']?.toString() ?? '',
//         metadata['nitrogen']?.toString() ?? '',
//         metadata['phosphorus']?.toString() ?? '',
//         metadata['potassium']?.toString() ?? '',
//       ]);
//       index++;
//     }

//     final csvData = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path =
//         "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
//     final file = File(path);
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Report disimpan di $path")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Report"),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _exportCSV(context),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: getSensorDataForDate(selectedDate),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final data = snapshot.data!;
//           if (data.isEmpty)
//             return Center(child: Text("Tidak ada data untuk tanggal ini"));

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Table(
//                     border: TableBorder.all(color: Colors.grey.shade400),
//                     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                     columnWidths: const {
//                       0: FixedColumnWidth(50),
//                       1: FixedColumnWidth(80),
//                       2: FixedColumnWidth(110),
//                       3: FixedColumnWidth(110),
//                       4: FixedColumnWidth(70),
//                       5: FixedColumnWidth(100),
//                       6: FixedColumnWidth(100),
//                       7: FixedColumnWidth(100),
//                     },
//                     children: [
//                       _buildTableRow([
//                         "#",
//                         "Time",
//                         "Temperature",
//                         "Humidity",
//                         "pH",
//                         "Nitrogen",
//                         "Phosphorus",
//                         "Potassium"
//                       ], isHeader: true, fontSize: 16),
//                       ...data.asMap().entries.map((entry) {
//                         final i = entry.key + 1;
//                         final item = entry.value;
//                         final metadata = item['metadata'] ?? {};

//                         final timestamp =
//                             int.tryParse(item['timestamp'] ?? '') ?? 0;
//                         final time =
//                             DateTime.fromMillisecondsSinceEpoch(timestamp);
//                         final timeStr =
//                             "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//                         return _buildTableRow([
//                           "$i",
//                           timeStr,
//                           metadata['temperature']?.toString() ?? '',
//                           metadata['humidity']?.toString() ?? '',
//                           metadata['ph']?.toString() ?? '',
//                           metadata['nitrogen']?.toString() ?? '',
//                           metadata['phosphorus']?.toString() ?? '',
//                           metadata['potassium']?.toString() ?? '',
//                         ]);
//                       }).toList()
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   /// Ambil data sesuai tanggal (bandingkan timestamp String -> int)
//   Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(Duration(days: 1));
//     final startEpoch = start.millisecondsSinceEpoch;
//     final endEpoch = end.millisecondsSinceEpoch;

//     return FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .orderBy('timestamp')
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) {
//               final data = doc.data();
//               final timestampStr = data['timestamp'];
//               final timestampInt = int.tryParse(timestampStr ?? '') ?? 0;

//               if (timestampInt >= startEpoch && timestampInt < endEpoch) {
//                 return {
//                   'time': timestampInt,
//                   'temperature': data['metadata']?['temperature'],
//                   'humidity': data['metadata']?['humidity'],
//                   'ph': data['metadata']?['ph'],
//                   'nitrogen': data['metadata']?['nitrogen'],
//                   'phosphorus': data['metadata']?['phosphorus'],
//                   'potassium': data['metadata']?['potassium'],
//                 };
//               }
//               return null;
//             })
//             .where((e) => e != null)
//             .cast<Map<String, dynamic>>()
//             .toList());
//   }

//   TableRow _buildTableRow(List<String> cells,
//       {bool isHeader = false, double fontSize = 14}) {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: isHeader ? Colors.grey[300] : Colors.white,
//       ),
//       children: cells.map((cell) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//           child: Text(
//             cell,
//             style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Future<void> _exportCSV(BuildContext context) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .orderBy('timestamp')
//         .get();

//     final start =
//         DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
//     final end = start.add(Duration(days: 1));
//     final startEpoch = start.millisecondsSinceEpoch;
//     final endEpoch = end.millisecondsSinceEpoch;

//     final filteredDocs = snapshot.docs.where((doc) {
//       final tsStr = doc['timestamp'];
//       final tsInt = int.tryParse(tsStr ?? '') ?? 0;
//       return tsInt >= startEpoch && tsInt < endEpoch;
//     });

//     final rows = [
//       [
//         "#",
//         "Time",
//         "Temperature",
//         "Humidity",
//         "pH",
//         "Nitrogen",
//         "Phosphorus",
//         "Potassium"
//       ]
//     ];

//     int index = 1;
//     for (var doc in filteredDocs) {
//       final data = doc.data();
//       final metadata = data['metadata'] ?? {};
//       final tsStr = data['timestamp'] ?? '';
//       final tsInt = int.tryParse(tsStr) ?? 0;
//       final time = DateTime.fromMillisecondsSinceEpoch(tsInt);
//       final timeStr =
//           "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//       rows.add([
//         "$index",
//         timeStr,
//         "${metadata['temperature'] ?? ''}",
//         "${metadata['humidity'] ?? ''}",
//         "${metadata['ph'] ?? ''}",
//         "${metadata['nitrogen'] ?? ''}",
//         "${metadata['phosphorus'] ?? ''}",
//         "${metadata['potassium'] ?? ''}",
//       ]);
//       index++;
//     }

//     final csvData = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path =
//         "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
//     final file = File(path);
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("CSV disimpan di $path")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Report"),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _exportCSV(context),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: getSensorDataForDate(selectedDate),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final data = snapshot.data!;
//           if (data.isEmpty)
//             return Center(child: Text("Tidak ada data untuk tanggal ini"));

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Table(
//                     border: TableBorder.all(color: Colors.grey.shade400),
//                     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                     columnWidths: const {
//                      0: FixedColumnWidth(30),
//                       1: FixedColumnWidth(50),
//                       2: FixedColumnWidth(88),
//                       3: FixedColumnWidth(68),
//                       4: FixedColumnWidth(35),
//                       5: FixedColumnWidth(65),
//                       6: FixedColumnWidth(72),
//                       7: FixedColumnWidth(56),
//                     },
//                     children: [
//                       _buildTableRow([
//                         "#",
//                         "Time",
//                         "Temperature",
//                         "Humidity",
//                         "pH",
//                         "Nitrogen",
//                         "Phosphorus",
//                         "Potassium"
//                       ], isHeader: true, fontSize: 16),
//                       ...data.asMap().entries.map((entry) {
//                         final i = entry.key + 1;
//                         final item = entry.value;
//                         final time =
//                             DateTime.fromMillisecondsSinceEpoch(item['time']);
//                         final timeStr =
//                             "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//                         return _buildTableRow([
//                           "$i",
//                           timeStr,
//                           "${item['temperature'] ?? ''}",
//                           "${item['humidity'] ?? ''}",
//                           "${item['ph'] ?? ''}",
//                           "${item['nitrogen'] ?? ''}",
//                           "${item['phosphorus'] ?? ''}",
//                           "${item['potassium'] ?? ''}",
//                         ]);
//                       }).toList()
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
//     final start = DateTime(date.year, date.month, date.day);
//     final end = start.add(Duration(days: 1));
//     final startEpoch = start.millisecondsSinceEpoch;
//     final endEpoch = end.millisecondsSinceEpoch;

//     return FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .where('timestamp', isGreaterThanOrEqualTo: startEpoch)
//         .where('timestamp', isLessThan: endEpoch)
//         .orderBy('timestamp')
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
//   }

//   TableRow _buildTableRow(List<String> cells,
//       {bool isHeader = false, double fontSize = 14}) {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: isHeader ? Colors.grey[300] : Colors.white,
//       ),
//       children: cells.map((cell) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//           child: Text(
//             cell,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.center,
//             // overflow: TextOverflow.ellipsis, // ⬅️ prevent wrap
//             softWrap: false,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Future<void> _exportCSV(BuildContext context) async {
//     final start =
//         DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
//     final end = start.add(Duration(days: 1));
//     final startEpoch = start.millisecondsSinceEpoch;
//     final endEpoch = end.millisecondsSinceEpoch;

//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .where('timestamp', isGreaterThanOrEqualTo: startEpoch)
//         .where('timestamp', isLessThan: endEpoch)
//         .orderBy('timestamp')
//         .get();

//     final rows = [
//       [
//         "#",
//         "Time",
//         "Temperature",
//         "Humidity",
//         "pH",
//         "Nitrogen",
//         "Phosphorus",
//         "Potassium"
//       ]
//     ];

//     int index = 1;
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       final timestamp = data['timestamp'] ?? 0;
//       final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
//       final timeStr =
//           "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//       final meta = data['metadata'] ?? {};
//       print(timestamp);
//       rows.add([
//         "$index",
//         timeStr,
//         data['uplink']['temperature']?.toString() ?? '',
//         data['humidity']?.toString() ?? '',
//         meta['ph']?.toString() ?? '',
//         meta['nitrogen']?.toString() ?? '',
//         meta['phosphorus']?.toString() ?? '',
//         meta['potassium']?.toString() ?? '',
//       ]);
//       // index++;
//     }

//     final csvData = const ListToCsvConverter().convert(rows);
//     final directory = await getApplicationDocumentsDirectory();
//     final path =
//         "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
//     final file = File(path);
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Report disimpan di $path")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detail Report"),
//         backgroundColor: Color(0xFFEAEAE3),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _exportCSV(context),
//           )
//         ],
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: getSensorDataForDate(selectedDate),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final data = snapshot.data!;
//           if (data.isEmpty)
//             return Center(child: Text("Tidak ada data untuk tanggal ini"));

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Table(
//                     border: TableBorder.all(color: Colors.grey.shade400),
//                     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                     columnWidths: const {
//                       0: FixedColumnWidth(45),
//                       1: FixedColumnWidth(50),
//                       2: FixedColumnWidth(88),
//                       3: FixedColumnWidth(68),
//                       4: FixedColumnWidth(50),
//                       5: FixedColumnWidth(65),
//                       6: FixedColumnWidth(88),
//                       7: FixedColumnWidth(88),
//                     },
//                     children: [
//                       _buildTableRow([
//                         "No.",
//                         "Time",
//                         "Temperature",
//                         "Humidity",
//                         "pH",
//                         "Nitrogen",
//                         "Phosphorus",
//                         "Potassium"
//                       ], isHeader: true, fontSize: 11),
//                       ...data.asMap().entries.map((entry) {
//                         final i = entry.key + 1;
//                         final item = entry.value;
//                         final timestamp = item['timestamp'] ?? 0;
//                         final time =
//                             DateTime.fromMillisecondsSinceEpoch(timestamp);
//                         final timeStr =
//                             "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

//                         final uplink = item['uplink'] ?? {};

//                         return _buildTableRow([
//                           "$i",
//                           timeStr,
//                           uplink['temperature']?.toString() ?? '',
//                           uplink['humidity']?.toString() ?? '',
//                           uplink['ph']?.toString() ?? '',
//                           uplink['nitrogen']?.toString() ?? '',
//                           uplink['phossporus']?.toString() ?? '',
//                           uplink['potassium']?.toString() ?? '',
//                         ]);
//                       }).toList()
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class ReportDetailPage extends StatelessWidget {
  final DateTime selectedDate;

  ReportDetailPage({required this.selectedDate});

  Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(Duration(days: 1));
    final startEpoch = start.millisecondsSinceEpoch;
    final endEpoch = end.millisecondsSinceEpoch;

    return FirebaseFirestore.instance
        .collection('uplink-p2p')
        .where('timestamp', isGreaterThanOrEqualTo: startEpoch)
        .where('timestamp', isLessThan: endEpoch)
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  TableRow _buildTableRow(List<String> cells,
      {bool isHeader = false, double fontSize = 14}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[300] : Colors.white,
      ),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Text(
            cell,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            softWrap: false,
          ),
        );
      }).toList(),
    );
  }

  // Future<void> _exportCSV(BuildContext context) async {
  //   final start =
  //       DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  //   final end = start.add(Duration(days: 1));
  //   final startEpoch = start.millisecondsSinceEpoch;
  //   final endEpoch = end.millisecondsSinceEpoch;

  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('uplink-p2p')
  //       .where('timestamp', isGreaterThanOrEqualTo: startEpoch)
  //       .where('timestamp', isLessThan: endEpoch)
  //       .orderBy('timestamp')
  //       .get();

  //   final rows = [
  //     [
  //       "No",
  //       "Time",
  //       "Temperature",
  //       "Humidity",
  //       "pH",
  //       "Nitrogen",
  //       "Phosphorus",
  //       "Potassium"
  //     ]
  //   ];

  //   int index = 1;
  //   for (var doc in snapshot.docs) {
  //     final data = doc.data();
  //     final timestamp = data['timestamp'] ?? 0;
  //     final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
  //     final timeStr =
  //         "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  //     final uplink = data['uplink'] ?? {};

  //     rows.add([
  //       "$index",
  //       timeStr,
  //       uplink['temperature']?.toString() ?? '',
  //       uplink['humidity']?.toString() ?? '',
  //       uplink['ph']?.toString() ?? '',
  //       uplink['nitrogen']?.toString() ?? '',
  //       uplink['phosphorus']?.toString() ?? '',
  //       uplink['potassium']?.toString() ?? '',
  //     ]);
  //     index++;
  //   }

  //   final csvData = const ListToCsvConverter().convert(rows);

  //   if (await Permission.storage.request().isGranted) {
  //     final downloads = Directory('/storage/emulated/0/Download');
  //     final fileName =
  //         "report-${DateFormat('yyyy-MM-dd').format(selectedDate)}.csv";
  //     final path = "${downloads.path}/$fileName";
  //     final file = File(path);
  //     await file.writeAsString(csvData);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text("Report disimpan di folder Download: $fileName")),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Izin akses penyimpanan ditolak.")),
  //     );
  //   }
  // }
  Future<void> _exportCSV(BuildContext context) async {
    final start =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final end = start.add(Duration(days: 1));
    final startEpoch = start.millisecondsSinceEpoch;
    final endEpoch = end.millisecondsSinceEpoch;

    final snapshot = await FirebaseFirestore.instance
        .collection('uplink-p2p')
        .where('timestamp', isGreaterThanOrEqualTo: startEpoch)
        .where('timestamp', isLessThan: endEpoch)
        .orderBy('timestamp')
        .get();

    final rows = [
      [
        "No",
        "Time",
        "Temperature",
        "Humidity",
        "pH",
        "Nitrogen",
        "Phosphorus",
        "Potassium"
      ]
    ];

    int index = 1;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final timestamp = data['timestamp'] ?? 0;
      final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final timeStr =
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

      final uplink = data['uplink'] ?? {};

      rows.add([
        "$index",
        timeStr,
        uplink['temperature']?.toString() ?? '',
        uplink['humidity']?.toString() ?? '',
        uplink['ph']?.toString() ?? '',
        uplink['nitrogen']?.toString() ?? '',
        uplink['phossporus']?.toString() ?? '',
        uplink['potassium']?.toString() ?? '',
      ]);
      index++;
    }

    final csvData = const ListToCsvConverter().convert(rows);

    if (await Permission.storage.request().isGranted) {
      final downloadsDir = Directory('/storage/emulated/0/Download');
      final now = DateTime.now();
      final timestamp =
          "${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}";
      final fileName =
          "report-${DateFormat('yyyy-MM-dd').format(selectedDate)}-$timestamp.csv";
      final filePath = "${downloadsDir.path}/$fileName";

      final file = File(filePath);
      await file.writeAsString(csvData);
      //final Open File
      final openFile = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Berhasil"),
          content:
              Text("File berhasil disimpan di $fileName\nIngin buka sekarang?"),
          actions: [
            TextButton(
              child: Text("Tidak"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text("Buka"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );

      if (openFile == true) {
        OpenFile.open(file.path); // menggunakan open_file package
      } //batas final open file

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Report disimpan di: $fileName")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Izin akses penyimpanan ditolak.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Report"),
        backgroundColor: Color(0xFFEAEAE3),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _exportCSV(context),
          )
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getSensorDataForDate(selectedDate),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final data = snapshot.data!;
          if (data.isEmpty)
            return Center(child: Text("Tidak ada data untuk tanggal ini"));

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade400),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FixedColumnWidth(45),
                      1: FixedColumnWidth(50),
                      2: FixedColumnWidth(88),
                      3: FixedColumnWidth(68),
                      4: FixedColumnWidth(50),
                      5: FixedColumnWidth(65),
                      6: FixedColumnWidth(88),
                      7: FixedColumnWidth(88),
                    },
                    children: [
                      _buildTableRow([
                        "No.",
                        "Time",
                        "Temperature",
                        "Humidity",
                        "pH",
                        "Nitrogen",
                        "Phosphorus",
                        "Potassium"
                      ], isHeader: true, fontSize: 11),
                      ...data.asMap().entries.map((entry) {
                        final i = entry.key + 1;
                        final item = entry.value;
                        final timestamp = item['timestamp'] ?? 0;
                        final time =
                            DateTime.fromMillisecondsSinceEpoch(timestamp);
                        final timeStr =
                            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

                        final uplink = item['uplink'] ?? {};

                        return _buildTableRow([
                          "$i",
                          timeStr,
                          uplink['temperature']?.toString() ?? '',
                          uplink['humidity']?.toString() ?? '',
                          uplink['ph']?.toString() ?? '',
                          uplink['nitrogen']?.toString() ?? '',
                          uplink['phossporus']?.toString() ?? '',
                          uplink['potassium']?.toString() ?? '',
                        ]);
                      }).toList()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
