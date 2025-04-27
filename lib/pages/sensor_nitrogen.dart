import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SensorNitrogenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor pH"),
        backgroundColor: Color(0xFFEAEAE3),
      ),
      body: Center(
        child: Text(
          "Ini adalah halaman Sensor Nitrogen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
