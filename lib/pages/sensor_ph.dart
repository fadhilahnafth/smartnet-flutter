import 'package:flutter/material.dart';

class SensorPhPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor pH"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "Ini adalah halaman Sensor pH",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
