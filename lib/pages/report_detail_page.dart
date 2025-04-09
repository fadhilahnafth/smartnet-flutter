import 'package:flutter/material.dart';

class ReportDetailPage extends StatelessWidget {
  final DateTime selectedDate;

  ReportDetailPage({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDE1D6),
      appBar: AppBar(
        title: Text("REPORT"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Table(
              border: TableBorder.all(),
              children: [
                _buildTableRow(
                    ["#", "Time", "Temp", "Humidity", "Pressure", "Moisture"],
                    isHeader: true),
                _buildTableRow(
                    ["1", "00:30", "30.50", "40.50", "1000.8", "55.50"]),
                _buildTableRow(
                    ["2", "01:00", "30.80", "40.49", "1008.3", "52.50"]),
                _buildTableRow(
                    ["3", "01:30", "30.90", "40.45", "1007.5", "53.40"]),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Tambahkan logika untuk download report di sini
            },
            child: Text("GET REPORT FILE"),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            cell,
            style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  String _getMonthName(int month) {
    List<String> months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return months[month - 1];
  }
}
