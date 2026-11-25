import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_agriculture_jadi/pages/main_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_agriculture_jadi/pages/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:smart_agriculture_jadi/pages/message_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: AuthGate(), // Gunakan AuthGate sebagai entry point
//     );
//   }
// }

// class AuthGate extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(body: Center(child: CircularProgressIndicator()));
//         }

//         if (snapshot.hasData) {
//           return MainPage(); // Jika user sudah login
//         } else {
//           return LoginPage(); // Jika belum login
//         }
//       },
//     );
//   }
// }

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("📬 Pesan diterima di background: ${message.messageId}");
// }

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📬 Pesan diterima di background: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup notification
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onDidReceiveNotificationResponse: (response) {
  //     final payload = response.payload;
  //     if (payload != null) {
  //       final parts = payload.split('|');
  //       if (parts.length == 3) {
  //         final sensorName = parts[0];
  //         final message = parts[1];
  //         final timestamp = DateTime.tryParse(parts[2]) ?? DateTime.now();

  //         navigatorKey.currentState?.push(
  //           MaterialPageRoute(
  //             builder: (_) => MessageDetailPage(
  //               sensorName: sensorName,
  //               message: message,
  //               timestamp: timestamp,
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //   },
  // );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) {
      final payload = response.payload;
      if (payload != null) {
        final parts = payload.split('|');
        if (parts.length >= 1) {
          final sensorName = parts[0];
          _openLatestMessageForSensor(sensorName);
        }
      }
    },
  );

  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> showLocalNotification(
    String title, String body, String payload) async {
  final int notificationId =
      DateTime.now().millisecondsSinceEpoch.remainder(100000);

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'sensor_channel_id',
    'Sensor Alerts',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    notificationId,
    title,
    body,
    platformDetails,
    payload: payload,
  );
}

/// Opens the latest message detail for a sensor from notification tap
Future<void> _openLatestMessageForSensor(String sensorName) async {
  try {
    final snap = await FirebaseFirestore.instance
        .collection('messages')
        .where('sensorName', isEqualTo: sensorName)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) {
      final doc = snap.docs.first;
      final data = doc.data();
      final timestamp = data['timestamp'] is Timestamp
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now();

      // Mark as read
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(doc.id)
          .update({'isRead': true});

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => MessageDetailPage(
            docId: doc.id,
            sensorName: data['sensorName'] ?? sensorName,
            message: data['message'] ?? 'Tidak ada pesan',
            status: data['status'] ?? 'Tidak Subur',
            sensorValue: (data['sensorValue'] ?? 0.0).toDouble(),
            unit: data['unit'] ?? '',
            idealRange: data['idealRange'] ?? '-',
            timestamp: timestamp,
          ),
        ),
      );
    }
  } catch (e) {
    print('Error opening message from notification: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // penting untuk navigasi dari notifikasi
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          return MainPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
