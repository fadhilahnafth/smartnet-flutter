import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'message_detail_page.dart';
import 'dart:async';
// class MessagePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(80), // Atur tinggi AppBar
//         child: Container(
//           width: double.infinity, // Sesuai lebar layar, bisa diubah
//           padding: EdgeInsets.symmetric(
//               horizontal: 16, vertical: 30), // Atur padding
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(0),
//               bottomRight: Radius.circular(0),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 5,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: SafeArea(
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
//                 // CircleAvatar(
//                 //   backgroundColor: Colors.blue.shade100,
//                 //   child: Icon(Icons.person, color: Colors.red),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.menu, color: Colors.black),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Container(),
//                   ),
//                   CircleAvatar(
//                     backgroundColor: Colors.blue.shade100,
//                     child: Icon(Icons.person, color: Colors.red),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             MessageTile(
//               icon: Icons.water_drop,
//               title: "HUMIDITY",
//               message:
//                   "[DANGER] Humidity level is danger. Please immediately water your plants.",
//               color: Colors.blue,
//             ),
//             Divider(),
//             MessageTile(
//               icon: Icons.terrain,
//               title: "SOIL MOISTURE",
//               message:
//                   "[WARNING] Humidity level is warning. Please check your plants.",
//               color: Colors.brown,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MessageTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String message;
//   final Color color;

//   MessageTile({
//     required this.icon,
//     required this.title,
//     required this.message,
//     required this.color,
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
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(message),
//     );
//   }
// }
//
//
//
//
//
// class MessagePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("MESSAGE", style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Terjadi kesalahan'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           final messages = snapshot.data!.docs;

//           if (messages.isEmpty) {
//             return Center(child: Text("Belum ada pesan."));
//           }

//           return ListView.builder(
//             itemCount: messages.length,
//             itemBuilder: (context, index) {
//               final data = messages[index].data() as Map<String, dynamic>;
//               final sensorName = data['sensorName'] ?? '-';
//               final message = data['message'] ?? '-';
//               final timestamp = (data['timestamp'] as Timestamp).toDate();

//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.grey.shade200,
//                   child: Icon(Icons.warning_amber, color: Colors.red),
//                 ),
//                 title: Text(sensorName.toUpperCase(),
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 subtitle: Text(message),
//                 trailing: Text(
//                   "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => MessageDetailPage(
//                         sensorName: sensorName,
//                         message: message,
//                         timestamp: timestamp,
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MessagePage extends StatefulWidget {
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int unreadCount = 0;
  late StreamSubscription badgeSub;

  @override
  void initState() {
    super.initState();
    _setupBadgeListener();
    _setupNotificationListeners();
  }

  void _setupBadgeListener() {
    badgeSub = FirebaseFirestore.instance
        .collection('messages')
        .where('read', isEqualTo: false)
        .snapshots()
        .listen((snap) {
      setState(() => unreadCount = snap.docs.length);
    });
  }

  void _setupNotificationListeners() {
    FirebaseMessaging.onMessage.listen(_showLocalNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);
    _checkInitialMessage();
  }

  void _showLocalNotification(RemoteMessage msg) {
    final data = msg.notification;
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    flutterLocalNotificationsPlugin.show(
      id,
      data?.title ?? 'Pesan Baru',
      data?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'msg_channel',
          'Messages',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: msg.data['sensorName'],
    );
  }

  void _handleMessageTap(RemoteMessage msg) {
    _goToDetail(msg.data['sensorName']);
  }

  Future<void> _checkInitialMessage() async {
    final msg = await FirebaseMessaging.instance.getInitialMessage();
    if (msg != null) _goToDetail(msg.data['sensorName']);
  }

  void _goToDetail(String sensorName) {
    final doc = FirebaseFirestore.instance
        .collection('messages')
        .where('sensorName', isEqualTo: sensorName)
        .orderBy('timestamp', descending: true)
        .limit(1);
    doc.get().then((snap) {
      if (snap.docs.isNotEmpty) {
        final data = snap.docs.first.data();
        final ts = (data['timestamp'] as Timestamp).toDate();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MessageDetailPage(
              sensorName: sensorName,
              message: data['message'],
              timestamp: ts,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    badgeSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MESSAGE", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.message),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data!.docs;

          if (messages.isEmpty) {
            return Center(child: Text("Belum ada pesan."));
          }

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final data = messages[index].data() as Map<String, dynamic>;
              final sensorName = data['sensorName'] ?? '-';
              final message = data['message'] ?? '-';
              final timestamp = (data['timestamp'] as Timestamp).toDate();

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(Icons.warning_amber, color: Colors.red),
                ),
                title: Text(sensorName.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(message),
                trailing: Text(
                  "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(fontSize: 12),
                ),
                onTap: () => _goToDetail(sensorName),
              );
            },
          );
        },
      ),
    );
  }
}
