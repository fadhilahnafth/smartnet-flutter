import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class SensorKelembapanPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Detail Sensor kalium")),
//       body: Center(child: Text("Halaman detail kalium")),
//     );
//   }
// }

// class SensorKelembabanPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sensor Kelembaban"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Center(
//         child: Text(
//           "Ini adalah halaman Sensor Kelembaban",
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }

class SensorKelembabanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CollectionReference uplinksRef =
        FirebaseFirestore.instance.collection('uplinks');

    return Scaffold(
      appBar: AppBar(title: Text("Detail Sensor Kelembaban")),
      body: FutureBuilder<QuerySnapshot>(
        future:
            uplinksRef.orderBy('createdAt', descending: true).limit(1).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }

          final data = snapshot.data?.docs ?? [];

          if (data.isEmpty) {
            return Center(child: Text('Data tidak ditemukan'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];

              // final temperature = doc['temperature'] ?? 'N/A';
              //final ph = doc['ph'] ?? 'N/A';
              final humidity = doc['humidity'] ?? 'N/A';

              return ListTile(
                title: Text("Kelembababn"),
                subtitle: Text("$humidity "),
              );
            },
          );
        },
      ),
    );
  }
}
