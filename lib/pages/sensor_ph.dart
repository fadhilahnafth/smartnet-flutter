import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SensorPhPage extends StatelessWidget {
  final CollectionReference uplinksRef =
      FirebaseFirestore.instance.collection('uplinks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEAE3),
      appBar: AppBar(title: Text("Detail Sensor pH")),
      body: FutureBuilder<QuerySnapshot>(
        future: uplinksRef
            .orderBy('createdAt', descending: true)
            .limit(24)
            .get(), // Ambil 24 data terakhir untuk 24 jam
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(child: Text('Data tidak ditemukan'));
          }

          final latestTemp = docs.first['ph'] ?? 'N/A';

          List<FlSpot> suhuPoints = [];
          for (int i = 0; i < docs.length; i++) {
            final data = docs[i];
            double hour = i.toDouble(); // Asumsi satu data per jam
            double temp = (data['ph'] ?? 0).toDouble();
            suhuPoints.add(FlSpot(hour, temp));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text("Ph",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("$latestTemp ", style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),

                // Tabel Rentang Suhu
                Container(
                  color: Colors.white, // latar belakang putih
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(children: [
                        _buildCell("Indikator", isHeader: true),
                        _buildCell("Rentang pH ", isHeader: true),
                      ]),
                      _buildRow("Tidak Subur", "0 - 5"),
                      _buildRow("Kurang Subur", "5,5 - 6"),
                      _buildRow("Subur", "6 - 7,5"),
                      _buildRow("Kurang Subur", "7,6 - 8"),
                      _buildRow("Tidak Subur", "8 - 14"),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                SizedBox(height: 15),
                Text("Grafik Sensor pH",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // SizedBox(
                //   height: 300,
                //   child: Padding(
                //       padding: const EdgeInsets.all(16.0),
                //       child: LineChart(
                //         LineChartData(
                //           minX: 0,
                //           maxX: 23,
                //           minY: 0,
                //           maxY: 14,
                //           gridData: FlGridData(show: true),
                //           titlesData: FlTitlesData(
                //             bottomTitles: AxisTitles(
                //               sideTitles: SideTitles(
                //                 showTitles: true,
                //                 interval: 1,
                //                 getTitlesWidget: (value, meta) {
                //                   return Text(
                //                     "${value.toInt().toString().padLeft(2, '0')}",
                //                     style: TextStyle(fontSize: 6),
                //                   );
                //                 },
                //               ),
                //             ),
                //             leftTitles: AxisTitles(
                //               sideTitles: SideTitles(
                //                 showTitles: true,
                //                 interval: 2,
                //                 getTitlesWidget: (value, meta) {
                //                   return Text("${value.toInt()}°");
                //                 },
                //               ),
                //             ),
                //             topTitles: AxisTitles(
                //                 sideTitles: SideTitles(showTitles: false)),
                //             rightTitles: AxisTitles(
                //                 sideTitles: SideTitles(showTitles: false)),
                //           ),
                //           borderData: FlBorderData(show: true),
                //           lineBarsData: [
                //             LineChartBarData(
                //               spots: suhuPoints,
                //               isCurved: true,
                //               barWidth: 2,
                //               // colors: [Colors.teal],
                //               dotData: FlDotData(show: false),
                //             )
                //           ],
                //         ),
                //       )),
                // ),

                SizedBox(
                  height: 300,
                  child: Container(
                    color: Colors.white, // latar belakang putih untuk grafik
                    padding: const EdgeInsets.all(16.0),
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: 23,
                        minY: 0,
                        maxY: 14,
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  "${value.toInt().toString().padLeft(2, '0')}",
                                  style: TextStyle(fontSize: 6),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 2,
                              getTitlesWidget: (value, meta) {
                                return Text("${value.toInt()}");
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: suhuPoints,
                            isCurved: true,
                            barWidth: 2,
                            color: Colors.teal,
                            dotData: FlDotData(show: false),
                          )
                        ],
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

  TableRow _buildRow(String indikator, String rentang) {
    return TableRow(children: [
      _buildCell(indikator),
      _buildCell(rentang),
    ]);
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: isHeader
            ? TextStyle(fontWeight: FontWeight.bold)
            : TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
