import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';

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
