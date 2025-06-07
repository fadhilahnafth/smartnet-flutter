import 'package:flutter/material.dart';

class MessageDetailPage extends StatelessWidget {
  final String sensorName;
  final String message;
  final DateTime timestamp;

  const MessageDetailPage({
    required this.sensorName,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sensorName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sensorName.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black87)),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Dikirim pada: ${timestamp.toLocal()}",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
