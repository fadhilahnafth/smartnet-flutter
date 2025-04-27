import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SensorSuhuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CollectionReference uplinksRef =
        FirebaseFirestore.instance.collection('uplinks');

    return Scaffold(
      appBar: AppBar(title: Text("Detail Sensor Suhu")),
      body: FutureBuilder<QuerySnapshot>(
        future: uplinksRef.get(),
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

              final temperature = doc['temperature'] ?? 'N/A';
              // final ph = doc['ph'] ?? 'N/A';
              // final humidity = doc['humidity'] ?? 'N/A';

              return ListTile(
                title: Text("Temperature"),
                subtitle: Text("$temperature °C"),
              );
            },
          );
        },
      ),
    );
  }
}

// class SensorSuhuPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final CollectionReference uplinksRef =
//         FirebaseFirestore.instance.collection('uplinks');

//     return Scaffold(
//       appBar: AppBar(title: Text("Detail Sensor Suhu")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: uplinksRef
//             .orderBy('timestamp',
//                 descending: true) // pastikan di Firestore ada field 'timestamp'
//             .limit(1) // hanya ambil 1 data terbaru
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Terjadi error: ${snapshot.error}'));
//           }

//           final data = snapshot.data?.docs ?? [];

//           if (data.isEmpty) {
//             return Center(child: Text('Data tidak ditemukan'));
//           }

//           final doc = data[0];
//           final temperature = doc['temperature'] ?? 'N/A';

//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Temperature", style: TextStyle(fontSize: 20)),
//                 SizedBox(height: 8),
//                 Text("$temperature °C",
//                     style:
//                         TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
