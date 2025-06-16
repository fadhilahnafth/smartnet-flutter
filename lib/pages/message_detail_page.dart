import 'package:flutter/material.dart';

// import 'package:intl/intl.dart';
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
// class MessageDetailPage extends StatelessWidget {
//   final String sensorName;
//   final String message;
//   final DateTime timestamp;

//   const MessageDetailPage({
//     required this.sensorName,
//     required this.message,
//     required this.timestamp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final formattedTime = DateFormat('dd MMM yyyy • HH:mm').format(timestamp);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//         title:
//             Text("Detail Pesan", style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//       backgroundColor: Color(0xFFF5F5F5),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           elevation: 4,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   sensorName.toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.teal[800],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   message,
//                   style: TextStyle(fontSize: 16, height: 1.5),
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Icon(Icons.access_time, color: Colors.grey, size: 16),
//                     SizedBox(width: 6),
//                     Text(
//                       formattedTime,
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class MessageDetailPage extends StatelessWidget {
//   final String sensorName;
//   final String message;
//   final DateTime timestamp;

//   const MessageDetailPage({
//     required this.sensorName,
//     required this.message,
//     required this.timestamp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(color: Colors.black),
//         title: Text(
//           sensorName,
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         elevation: 1,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               sensorName.toUpperCase(),
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               message,
//               style: TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//             SizedBox(height: 16),
//             Text(
//               "Dikirim pada: ${timestamp.toLocal().toString().replaceFirst(":00.000", "")} WIB",
//               style: TextStyle(color: Colors.grey[700], fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
