import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

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

class ReportDetailPage extends StatelessWidget {
  final DateTime selectedDate;

  ReportDetailPage({required this.selectedDate});

  Stream<List<Map<String, dynamic>>> getSensorDataForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('uplinks')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThan: end)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  TableRow _buildTableRow(List<String> cells,
      {bool isHeader = false, double fontSize = 12}) {
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
              fontSize: 11,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  Future<void> _exportCSV(BuildContext context) async {
    final start =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final end = start.add(Duration(days: 1));

    final snapshot = await FirebaseFirestore.instance
        .collection('uplinks')
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThan: end)
        .orderBy('createdAt')
        .get();

    final rows = [
      [
        "#",
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
      final createdAt = (data['createdAt'] as Timestamp).toDate();
      final timeStr =
          "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";

      rows.add([
        "$index",
        timeStr,
        data['temperature'].toString(),
        data['humidity'].toString(),
        data['ph'].toString(),
        data['nitrogen'].toString(),
        data['phosphorus'].toString(),
        data['potassium'].toString(),
      ]);
      index++;
    }

    final csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path =
        "${directory.path}/report-${selectedDate.toIso8601String()}.csv";
    final file = File(path);
    await file.writeAsString(csvData);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Report disimpan di $path")));
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
                borderRadius: BorderRadius.circular(12), // sudut melengkung
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    // border: TableBorder.all(color: Colors.grey.shade400),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FixedColumnWidth(30),
                      1: FixedColumnWidth(50),
                      2: FixedColumnWidth(88),
                      3: FixedColumnWidth(68),
                      4: FixedColumnWidth(35),
                      5: FixedColumnWidth(65),
                      6: FixedColumnWidth(72),
                      7: FixedColumnWidth(56),
                    },
                    children: [
                      _buildTableRow([
                        "#",
                        "Time",
                        "Temperature",
                        "Humidity",
                        "pH",
                        "Nitrogen",
                        "Phosphor",
                        "Kalium"
                      ], isHeader: true, fontSize: 12),
                      ...data.asMap().entries.map((entry) {
                        final i = entry.key + 1;
                        final item = entry.value;
                        final time = (item['createdAt'] as Timestamp).toDate();
                        final timeStr =
                            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

                        return _buildTableRow([
                          "$i",
                          timeStr,
                          item['temperature'].toString(),
                          item['humidity'].toString(),
                          item['ph'].toString(),
                          item['nitrogen'].toString(),
                          item['phosphorus'].toString(),
                          item['potassium'].toString(),
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
