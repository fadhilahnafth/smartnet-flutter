import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'dart:math';

class SensorSuhuPage extends StatelessWidget {
  final CollectionReference uplinksRef =
      FirebaseFirestore.instance.collection('uplinks');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEAE3),
      appBar: AppBar(title: Text("Detail Sensor Suhu")),
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

          final latestTemp = docs.first['temperature'] ?? 'N/A';

          List<FlSpot> suhuPoints = [];
          for (int i = 0; i < docs.length; i++) {
            final data = docs[i];
            double hour = i.toDouble(); // Asumsi satu data per jam
            double temp = (data['temperature'] ?? 0).toDouble();
            suhuPoints.add(FlSpot(hour, temp));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text("Temperature",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("$latestTemp °C", style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),

                // Tabel Rentang Suhu
                Padding(
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
                        _buildCell("Rentang Suhu (°C)", isHeader: true),
                      ]),
                      _buildRow("Tidak Subur", "< 17"),
                      _buildRow("Kurang Subur", "17 - 22"),
                      _buildRow("Subur", "22 - 27"),
                      _buildRow("Kurang Subur", "27 - 32"),
                      _buildRow("Tidak Subur", "> 32"),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                Text("Grafik Sensor Suhu",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 300,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          // LineChart(
                          //   LineChartData(
                          //     minX: 0,
                          //     maxX: 23,
                          //     minY: 15,
                          //     maxY: 35,
                          //     gridData: FlGridData(show: true),
                          //     titlesData: FlTitlesData(
                          //       leftTitles: AxisTitles(
                          //         sideTitles: SideTitles(showTitles: true),
                          //       ),
                          //       bottomTitles: AxisTitles(
                          //         sideTitles: SideTitles(
                          //           showTitles: true,
                          //           interval: 3,
                          //           getTitlesWidget: (value, _) =>
                          //               Text("${value.toInt()}:00"),
                          //         ),
                          //       ),
                          //     ),
                          //     lineBarsData: [
                          //       LineChartBarData(
                          //         spots: suhuPoints,
                          //         isCurved: true,
                          //         barWidth: 2,
                          //         dotData: FlDotData(show: false),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 23,
                          minY: 5,
                          maxY: 40,
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
                                interval: 5,
                                getTitlesWidget: (value, meta) {
                                  return Text("${value.toInt()}°");
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
                              // colors: [Colors.teal],
                              dotData: FlDotData(show: false),
                            )
                          ],
                        ),
                      )),
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
