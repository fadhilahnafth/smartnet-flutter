import 'package:flutter/material.dart';

// class SensorKelembapanPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Detail Sensor kalium")),
//       body: Center(child: Text("Halaman detail kalium")),
//     );
//   }
// }

class SensorKelembabanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor Kelembaban"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "Ini adalah halaman Sensor Kelembaban",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
