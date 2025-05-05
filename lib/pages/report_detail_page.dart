import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

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

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration:
          BoxDecoration(color: isHeader ? Colors.green[100] : Colors.white),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
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
      rows.add([
        "$index",
        "${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}",
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
        backgroundColor: Colors.green,
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
              child: Table(
                border: TableBorder.all(),
                defaultColumnWidth: FixedColumnWidth(120),
                children: [
                  _buildTableRow([
                    "#",
                    "Time",
                    "Temperature",
                    "Humidity",
                    "pH",
                    "Nitrogen",
                    "Phosphorus",
                    "Potassium"
                  ], isHeader: true),
                  ...data.asMap().entries.map((entry) {
                    final i = entry.key + 1;
                    final item = entry.value;
                    final time = (item['createdAt'] as Timestamp).toDate();
                    return _buildTableRow([
                      "$i",
                      "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
                      item['temperature'].toString(),
                      item['humidity'].toString(),
                      item['ph'].toString(),
                      item['nitrogen'].toString(),
                      item['phosphorus'].toString(),
                      item['potassium'].toString(),
                    ]);
                  })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// class ReportDetailPage extends StatelessWidget {
//   final DateTime selectedDate;

//   ReportDetailPage({required this.selectedDate});

//   @override
//   Widget build(BuildContext context) {
//     String selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Report'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('uplinks')
//             .where('createdAt',
//                 isGreaterThanOrEqualTo: DateTime(
//                   selectedDate.year,
//                   selectedDate.month,
//                   selectedDate.day,
//                   0,
//                   0,
//                   0,
//                 ))
//             .where('createdAt',
//                 isLessThan: DateTime(
//                   selectedDate.year,
//                   selectedDate.month,
//                   selectedDate.day + 1,
//                   0,
//                   0,
//                   0,
//                 ))
//             .orderBy('createdAt', descending: false)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError)
//             return Center(child: Text('Error: ${snapshot.error}'));
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           final docs = snapshot.data!.docs;

//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Table(
//                 border: TableBorder.all(),
//                 defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                 children: [
//                   _buildTableRow([
//                     "#",
//                     "Time",
//                     "Temp",
//                     "Humidity",
//                     "pH",
//                     "Nitrogen",
//                     "Phosphorus",
//                     "Potassium",
//                   ], isHeader: true),
//                   ...List.generate(docs.length, (index) {
//                     final data = docs[index].data() as Map<String, dynamic>;
//                     DateTime createdAt =
//                         (data['createdAt'] as Timestamp).toDate();
//                     String timeStr = DateFormat.Hm().format(createdAt);

//                     return _buildTableRow([
//                       (index + 1).toString(),
//                       timeStr,
//                       data['temperature'].toString(),
//                       data['humidity'].toString(),
//                       data['ph'].toString(),
//                       data['nitrogen'].toString(),
//                       data['phosphorus'].toString(),
//                       data['potassium'].toString(),
//                     ]);
//                   }),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
//     List<double> columnWidths = [30, 60, 60, 60, 50, 70, 80, 80];

//     return TableRow(
//       children: List.generate(cells.length, (index) {
//         return SizedBox(
//           width: columnWidths[index],
//           child: Padding(
//             padding: EdgeInsets.all(4),
//             child: Text(
//               cells[index],
//               style: TextStyle(
//                 fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//                 fontSize: 12,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
