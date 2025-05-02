import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class SensorPhosporPage extends StatefulWidget {
//   const SensorPhosporPage({super.key});

//   @override
//   State<SensorPhosporPage> createState() => _SensorPhosporPageState();
// }

// class _SensorPhosporPageState extends State<SensorPhosporPage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class SensorPhosporPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CollectionReference uplinksRef =
        FirebaseFirestore.instance.collection('uplinks');

    return Scaffold(
      appBar: AppBar(title: Text("Detail Sensor Phospor")),
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
              // final humidity = doc['humidity'] ?? 'N/A';
              final phosphorus = doc['phosphorus'] ?? 'N/A';

              return ListTile(
                title: Text("phosphor"),
                subtitle: Text("$phosphorus ppm"),
              );
            },
          );
        },
      ),
    );
  }
}
