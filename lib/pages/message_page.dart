import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'message_detail_page.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Atur tinggi AppBar
        child: Container(
          width: double.infinity, // Sesuai lebar layar, bisa diubah
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 30), // Atur padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "MESSAGE",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                // CircleAvatar(
                //   backgroundColor: Colors.blue.shade100,
                //   child: Icon(Icons.person, color: Colors.red),
                // ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.menu, color: Colors.black),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(Icons.person, color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            MessageTile(
              icon: Icons.water_drop,
              title: "HUMIDITY",
              message:
                  "[DANGER] Humidity level is danger. Please immediately water your plants.",
              color: Colors.blue,
            ),
            Divider(),
            MessageTile(
              icon: Icons.terrain,
              title: "SOIL MOISTURE",
              message:
                  "[WARNING] Humidity level is warning. Please check your plants.",
              color: Colors.brown,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  MessageTile({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(message),
    );
  }
}

// class MessagePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(80),
//         child: Container(
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
//             ],
//           ),
//           child: SafeArea(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("MESSAGE",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20)),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("messages")
//               .orderBy("timestamp", descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) return CircularProgressIndicator();

//             final docs = snapshot.data!.docs;
//             return ListView.separated(
//               itemCount: docs.length,
//               separatorBuilder: (_, __) => Divider(),
//               itemBuilder: (context, index) {
//                 final data = docs[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.blue.shade100,
//                     child: Icon(Icons.warning, color: Colors.red),
//                   ),
//                   title: Text(
//                     data['sensor'],
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(data['message'] ?? ""),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => MessageDetailPage(
//                           sensor: data['sensor'],
//                           message: data['message'],
//                           timestamp: (data['timestamp'] as Timestamp).toDate(),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


// class MessagePage extends StatelessWidget {
//   const MessagePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(80),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 5,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: const SafeArea(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "MESSAGE",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("Tidak ada pesan saat ini."));
//           }

//           final messages = snapshot.data!.docs;

//           return ListView.separated(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: messages.length,
//             separatorBuilder: (context, index) => const Divider(),
//             itemBuilder: (context, index) {
//               final msg = messages[index].data() as Map<String, dynamic>;
//               final id = messages[index].id;
//               return MessageTile(
//                 icon: Icons.warning,
//                 title: msg['sensor'] ?? 'Unknown',
//                 message: msg['message'] ?? '-',
//                 color: Colors.red,
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => MessageDetailPage(
//                         sensorName: msg['sensor'] ?? 'Unknown',
//                         message: msg['message'] ?? '-',
//                         timestamp: msg['timestamp']?.toDate(),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class MessageTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String message;
//   final Color color;
//   final VoidCallback onTap;

//   const MessageTile({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.message,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: color.withOpacity(0.2),
//         child: Icon(icon, color: color),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(message),
//       onTap: onTap,
//     );
//   }
// }
