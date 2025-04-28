import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Chart
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase

class Coba extends StatefulWidget {
  const Coba({super.key});

  @override
  State<Coba> createState() => _CobaState();
}

class _CobaState extends State<Coba> {
  List<FlSpot> spots = [];

  @override
  Widget build(BuildContext context) {
    final CollectionReference uplinksRef =
        FirebaseFirestore.instance.collection('uplinks');

    final dummyData = [
      {'createdAt': 12.00, 'temperature': 40},
      {'createdAt': 12.10, 'temperature': 41},
      {'createdAt': 12.20, 'temperature': 40},
      {'createdAt': 12.25, 'temperature': 42},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart Contoh'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: uplinksRef.orderBy('createdAt').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data'));
            }

            // Convert data to FlSpot
            // final data = snapshot.data!.docs;
            // spots = data.map((doc) {
            //   Timestamp timestamp = doc['createdAt'] as Timestamp;
            //   double x = timestamp.toDate().millisecondsSinceEpoch.toDouble();
            //   double y = (doc['temperature'] as num).toDouble();
            //   return FlSpot(x, y);
            // }).toList();

            final List<FlSpot> spots = dummyData.map((data) {
              double x = data['createdAt'] as double;
              double y = (data['temperature'] as num).toDouble();
              return FlSpot(x, y);
            }).toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.3, // 30% dari tinggi layar
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  borderData: FlBorderData(show: false),
                  // titlesData: FlTitlesData(show: true),
                  // gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles:
                            true, // Menampilkan label pada sumbu kiri (Y-axis)
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0), // Format angka bulat
                            style: TextStyle(fontSize: 10), // Ukuran font
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles:
                            true, // Menampilkan label pada sumbu bawah (X-axis)
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toString(), // Format angka bulat
                            style: TextStyle(fontSize: 10), // Ukuran font
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: false), // Menonaktifkan label sumbu atas
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: false), // Menonaktifkan label sumbu kanan
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
