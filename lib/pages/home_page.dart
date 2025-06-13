import 'package:flutter/material.dart';
// import 'package:smart_agriculture_jadi/main.dart';
import 'package:smart_agriculture_jadi/pages/sensor_kalium.dart';
import 'package:smart_agriculture_jadi/pages/sensor_kelembaban.dart';
import 'package:smart_agriculture_jadi/pages/sensor_nitrogen.dart';
import 'package:smart_agriculture_jadi/pages/sensor_ph.dart';
import 'package:smart_agriculture_jadi/pages/sensor_phospor.dart';
import 'package:smart_agriculture_jadi/pages/sensor_suhu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:overlay_support/overlay_support.dart'; // Untuk notifikasi lokal

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Map<String, dynamic>? latestData;

//   @override
//   void initState() {
//     super.initState();
//     fetchLatestSensorData();
//   }

//   Future<void> fetchLatestSensorData() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('uplink-p2p')
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .get();

//     if (snapshot.docs.isNotEmpty) {
//       final data = snapshot.docs.first.data();

//       final double temperature =
//           (data['uplink']['temperature'] ?? 0).toDouble();
//       final double soilMoisture = (data['uplink']['humidity'] ?? 0).toDouble();
//       final double ph = (data['uplink']['ph'] ?? 0).toDouble();
//       final double nitrogen = (data['uplink']['nitrogen'] ?? 0).toDouble();
//       final double kalium = (data['uplink']['potassium'] ?? 0).toDouble();
//       final double phospor = (data['uplink']['phossporus'] ?? 0).toDouble();

//       final String tempStatus = getStatus("Temperature", temperature);
//       final String moistStatus = getStatus("Soil Moisture", soilMoisture);
//       final String phStatus = getStatus("pH", ph);
//       final String nitrogenStatus = getStatus("Nitrogen", nitrogen);
//       final String kaliumStatus = getStatus("Kalium", kalium);
//       final String phosporStatus = getStatus("Phospor", phospor);

//       setState(() {
//         latestData = data;

//         sensorData[0]['value'] = '${temperature.toStringAsFixed(1)}°C';
//         sensorData[0]['status'] = tempStatus;
//         sensorData[0]['statusColor'] = getStatusColor(tempStatus);

//         sensorData[1]['value'] = '${ph.toStringAsFixed(1)}';
//         sensorData[1]['status'] = phStatus;
//         sensorData[1]['statusColor'] = getStatusColor(phStatus);

//         sensorData[2]['value'] = '${data['uplink']['nitrogen'] ?? '-'} ppm';
//         sensorData[2]['status'] = nitrogenStatus;
//         sensorData[2]['statusColor'] = getStatusColor(nitrogenStatus);

//         sensorData[3]['value'] = '${soilMoisture.toStringAsFixed(1)}%';
//         sensorData[3]['status'] = moistStatus;
//         sensorData[3]['statusColor'] = getStatusColor(moistStatus);

//         sensorData[4]['value'] = '${data['uplink']['potassium'] ?? '-'} ppm';
//         sensorData[4]['status'] = kaliumStatus;
//         sensorData[4]['statusColor'] = getStatusColor(kaliumStatus);

//         sensorData[5]['value'] = '${data['uplink']['phossporus'] ?? '-'} ppm';
//         sensorData[5]['status'] = phosporStatus;
//         sensorData[5]['statusColor'] = getStatusColor(phosporStatus);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEAEAE3),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(75), // UBAH tinggi sesuai keinginan
//         child: SafeArea(
//           child: Container(
//             color: Colors.white,
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 24,
//                   backgroundImage:
//                       FirebaseAuth.instance.currentUser?.photoURL != null
//                           ? NetworkImage(
//                               FirebaseAuth.instance.currentUser!.photoURL!)
//                           : null,
//                   backgroundColor: Colors.grey[300],
//                   child: FirebaseAuth.instance.currentUser?.photoURL == null
//                       ? Icon(Icons.person, color: Colors.black)
//                       : null,
//                 ),
//                 SizedBox(width: 16),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment:
//                       MainAxisAlignment.center, // Tengah vertikal
//                   children: [
//                     Text("Selamat Datang",
//                         style: TextStyle(color: Colors.black, fontSize: 14)),
//                     Text(
//                       FirebaseAuth.instance.currentUser?.displayName ??
//                           "Pengguna",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         // padding: EdgeInsets.all(16),
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             SizedBox(height: 30), // JARAK ANTARA HEADER DENGAN GRID
//             Expanded(
//               child: GridView.builder(
//                 itemCount: 6,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 1,
//                 ),
//                 itemBuilder: (context, index) {
//                   return SensorCard(
//                     sensor: sensorData[index],
//                     onTap: () {
//                       String title = sensorData[index]["title"];
//                       if (title == "Temperature") {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => SensorSuhuPage()));
//                       } else if (title == "pH") {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => SensorPhPage()));
//                       } else if (title == "Nitrogen") {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => SensorNitrogenPage()));
//                       } else if (title == "Soil Moisture") {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => SensorKelembabanPage()));
//                       } else if (title == "Kalium") {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => SensorKaliumPage()));
//                       } else if (title == "Phospor") {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => SensorPhosporPage()));
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IO.Socket? socket;

  @override
  void initState() {
    super.initState();
    connectToSocket();
    // setupFCM();/
  }

  // void connectToSocket() {
  //   socket = IO.io("https://webhook.ktyudha.site", <String, dynamic>{
  //     'transports': ['websocket'],
  //     'secure': true,
  //   });

  //   socket!.onConnect((_) {
  //     print("Connected to socket.io");
  //   });

  //   socket!.on('sensor_data', (data) {
  //     if (data is Map<String, dynamic>) {
  //       updateSensorData(data);
  //     }
  //   });

  //   socket!.onDisconnect((_) {
  //     print("Socket disconnected");
  //   });
  // }

  // void connectToSocket() {
  //   print("Trying to connect to socket.io...");

  //   socket = IO.io("https://webhook.ktyudha.site", <String, dynamic>{
  //     'transports': ['websocket'],
  //     'secure': true,
  //   });

  //   socket!.onConnect((_) {
  //     print("✅ Connected to socket.io");
  //   });

  //   socket!.onConnectError((err) {
  //     print("❌ Socket connect error: $err");
  //   });

  //   socket!.onError((err) {
  //     print("❌ Socket error: $err");
  //   });

  //   socket!.onDisconnect((_) {
  //     print("⚠️ Socket disconnected");
  //   });

  //   socket!.on('stream-uplink-p2p', (data) {
  //     print("📡 Received send-uplink-p2p: $data");
  //     if (data is Map<String, dynamic>) {
  //       updateSensorData(data);
  //     }
  //   });
  // }

  void connectToSocket() {
    print("Trying to connect to socket.io...");

    socket = IO.io("https://webhook.ktyudha.site", <String, dynamic>{
      'transports': ['websocket'],
      'secure': true,
    });

    socket!.onConnect((_) {
      print("✅ Connected to socket.io");
      Fluttertoast.showToast(
        msg: " Perangkat tersambung",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });

    socket!.onDisconnect((_) {
      print("Socket disconnected");
      Fluttertoast.showToast(
        msg: "Perangkat terputus",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });

    socket!.onConnectError((err) {
      print("Socket connect error: $err");
    });

    socket!.onError((err) {
      print("Socket error: $err");
    });

    socket!.on('send-uplink-p2p', (data) {
      print("Received send-uplink-p2p: $data");
      if (data is Map<String, dynamic>) {
        updateSensorData(data);
        Fluttertoast.showToast(
          msg: "Menerima Data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  void updateSensorData(Map<String, dynamic> data) {
    final uplink = data['uplink'] ?? {};

    final double temperature = parseToDouble(uplink['temperature']);
    final double soilMoisture = parseToDouble(uplink['humidity']);
    final double ph = parseToDouble(uplink['ph']);
    final double nitrogen = parseToDouble(uplink['nitrogen']);
    final double kalium = parseToDouble(uplink['potassium']);
    final double phospor = parseToDouble(
        uplink['phossporus']); // pastikan key-nya memang "phossporus"

    setState(() {
      sensorData[0]['value'] = '${temperature.toStringAsFixed(1)}°C';
      sensorData[0]['status'] = getStatus("Temperature", temperature);
      sensorData[0]['statusColor'] = getStatusColor(sensorData[0]['status']);

      sensorData[1]['value'] = '${ph.toStringAsFixed(1)}';
      sensorData[1]['status'] = getStatus("pH", ph);
      sensorData[1]['statusColor'] = getStatusColor(sensorData[1]['status']);

      sensorData[2]['value'] = '${nitrogen.toStringAsFixed(1)}';
      sensorData[2]['status'] = getStatus("Nitrogen", nitrogen);
      sensorData[2]['statusColor'] = getStatusColor(sensorData[2]['status']);

      sensorData[3]['value'] = '${soilMoisture.toStringAsFixed(1)}%';
      sensorData[3]['status'] = getStatus("Soil Moisture", soilMoisture);
      sensorData[3]['statusColor'] = getStatusColor(sensorData[3]['status']);

      sensorData[4]['value'] = '$kalium ppm';
      sensorData[4]['status'] = getStatus("Kalium", kalium);
      sensorData[4]['statusColor'] = getStatusColor(sensorData[4]['status']);

      sensorData[5]['value'] = '$phospor ppm';
      sensorData[5]['status'] = getStatus("Phospor", phospor);
      sensorData[5]['statusColor'] = getStatusColor(sensorData[5]['status']);
    });
    checkAndSendMessage("Temperature", sensorData[0]['status']);
    checkAndSendMessage("pH", sensorData[1]['status']);
    checkAndSendMessage("Nitrogen", sensorData[2]['status']);
    checkAndSendMessage("Soil Moisture", sensorData[3]['status']);
    checkAndSendMessage("Kalium", sensorData[4]['status']);
    checkAndSendMessage("Phospor", sensorData[5]['status']);
  }

  Future<void> checkAndSendMessage(String sensorName, String status) async {
    if (status != "Tidak Subur") return;

    final now = DateTime.now();
    final docRef =
        FirebaseFirestore.instance.collection('messages').doc(sensorName);
    final doc = await docRef.get();

    final lastSent =
        doc.exists ? (doc['lastSent'] as Timestamp).toDate() : DateTime(2000);
    final difference = now.difference(lastSent);

    if (difference.inMinutes >= 1) {
      await docRef.set({
        'sensorName': sensorName,
        'message': 'Sensor $sensorName tidak subur.',
        'timestamp': Timestamp.now(),
        'lastSent': Timestamp.now(),
      }, SetOptions(merge: true));
      print("Pesan dikirim untuk sensor $sensorName");
    }
  }

  void resetSensorData() {
    setState(() {
      sensorData[0]['value'] = '0°C';
      sensorData[1]['value'] = '0';
      sensorData[2]['value'] = '0';
      sensorData[3]['value'] = '0%';
      sensorData[4]['value'] = '0 ppm';
      sensorData[5]['value'] = '0 ppm';

      for (var item in sensorData) {
        item['status'] = '-';
        item['statusColor'] = Colors.grey;
      }
    });
  }

  // void updateSensorData(Map<String, dynamic> data) {
  //   final uplink = data['uplink'] ?? {};

  //   final double temperature = parseToDouble(uplink['temperature']);
  //   final double soilMoisture = parseToDouble(uplink['humidity']);
  //   final double ph = parseToDouble(uplink['ph']);
  //   final double nitrogen = parseToDouble(uplink['nitrogen']);
  //   final double kalium = parseToDouble(uplink['potassium']);
  //   final double phospor = parseToDouble(
  //       uplink['phossporus']); // pastikan key-nya memang "phossporus"

  //   setState(() {
  //     sensorData[0]['value'] = '${temperature.toStringAsFixed(1)}°C';
  //     sensorData[0]['status'] = getStatus("Temperature", temperature);
  //     sensorData[0]['statusColor'] = getStatusColor(sensorData[0]['status']);

  //     sensorData[1]['value'] = '${ph.toStringAsFixed(1)}';
  //     sensorData[1]['status'] = getStatus("pH", ph);
  //     sensorData[1]['statusColor'] = getStatusColor(sensorData[1]['status']);

  //     sensorData[2]['value'] = '${nitrogen.toStringAsFixed(1)}';
  //     sensorData[2]['status'] = getStatus("Nitrogen", nitrogen);
  //     sensorData[2]['statusColor'] = getStatusColor(sensorData[2]['status']);

  //     sensorData[3]['value'] = '${soilMoisture.toStringAsFixed(1)}%';
  //     sensorData[3]['status'] = getStatus("Soil Moisture", soilMoisture);
  //     sensorData[3]['statusColor'] = getStatusColor(sensorData[3]['status']);

  //     sensorData[4]['value'] = '$kalium ppm';
  //     sensorData[4]['status'] = getStatus("Kalium", kalium);
  //     sensorData[4]['statusColor'] = getStatusColor(sensorData[4]['status']);

  //     sensorData[5]['value'] = '$phospor ppm';
  //     sensorData[5]['status'] = getStatus("Phospor", phospor);
  //     sensorData[5]['statusColor'] = getStatusColor(sensorData[5]['status']);
  //   });
  // }

  double parseToDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Future<void> _handleRefresh() async {
    print('Refreshing socket connection...');

    // Disconnect if already connected
    if (socket != null) {
      socket!.disconnect();
      socket!.clearListeners();
    }

    // Reconnect
    connectToSocket();
    resetSensorData();

    Fluttertoast.showToast(
      msg: "Memuat ulang data...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    await Future.delayed(Duration(seconds: 1)); // untuk animasi refresh
  }

  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEAE3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      FirebaseAuth.instance.currentUser?.photoURL != null
                          ? NetworkImage(
                              FirebaseAuth.instance.currentUser!.photoURL!)
                          : null,
                  backgroundColor: Colors.grey[300],
                  child: FirebaseAuth.instance.currentUser?.photoURL == null
                      ? const Icon(Icons.person, color: Colors.black)
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Selamat Datang",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                    Text(
                      FirebaseAuth.instance.currentUser?.displayName ??
                          "Pengguna",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 16),
      //   child: Column(
      //     children: [
      //       const SizedBox(height: 30),
      //       Expanded(
      //         child: GridView.builder(
      //           itemCount: 6,
      //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //             crossAxisCount: 2,
      //             crossAxisSpacing: 12,
      //             mainAxisSpacing: 12,
      //             childAspectRatio: 1,
      //           ),
      //           itemBuilder: (context, index) {
      //             return SensorCard(
      //               sensor: sensorData[index],
      //               onTap: () {
      //                 String title = sensorData[index]["title"];
      //                 if (title == "Temperature") {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(builder: (_) => SensorSuhuPage()),
      //                   );
      //                 } else if (title == "pH") {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(builder: (_) => SensorPhPage()),
      //                   );
      //                 } else if (title == "Nitrogen") {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (_) => SensorNitrogenPage()),
      //                   );
      //                 } else if (title == "Soil Moisture") {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (_) => SensorKelembabanPage()),
      //                   );
      //                 } else if (title == "Kalium") {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(builder: (_) => SensorKaliumPage()),
      //                   );
      //                 } else if (title == "Phospor") {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (_) => SensorPhosporPage()),
      //                   );
      //                 }
      //               },
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return SensorCard(
                      sensor: sensorData[index],
                      onTap: () {
                        // halaman detail
                        String title = sensorData[index]["title"];
                        if (title == "Temperature") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SensorSuhuPage()));
                        } else if (title == "pH") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SensorPhPage()));
                        } else if (title == "Nitrogen") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SensorNitrogenPage()));
                        } else if (title == "Soil Moisture") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SensorKelembabanPage()));
                        } else if (title == "Kalium") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SensorKaliumPage()));
                        } else if (title == "Phospor") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SensorPhosporPage()));
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final Map<String, dynamic> sensor;
  final VoidCallback? onTap;

  const SensorCard({required this.sensor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Title
            Positioned(
              left: sensor['titleOffsetX'] ?? 0.0,
              top: sensor['titleOffsetY'] ?? 0.0,
              child: Text(
                sensor['title'] ?? '',
                style: TextStyle(
                    fontSize: sensor['titleFontSize']?.toDouble() ?? 13.0,
                    fontWeight: FontWeight.bold,
                    // color: sensor['titleColor'] ?? Colors.black,
                    color: sensor['statusColor'] ?? Colors.grey),
              ),
            ),

            // Icon
            Positioned(
              left: sensor['iconOffsetX'] ?? 0.0,
              top: sensor['iconOffsetY'] ?? 0.0,
              child: Icon(
                sensor['icon'],
                // color: sensor['iconColor'],
                color: sensor['statusColor'] ?? Colors.grey,
                size: sensor['iconSize']?.toDouble() ?? 32.0,
              ),
            ),

            // Value
            Positioned(
              left: sensor['valueOffsetX'] ?? 0.0,
              top: sensor['valueOffsetY'] ?? 0.0,
              child: Text(
                sensor['value'] ?? '-',
                style: TextStyle(
                    fontSize: sensor['valueFontSize']?.toDouble() ?? 20.0,
                    fontWeight: FontWeight.bold,
                    // color: sensor['iconColor'],
                    color: sensor['statusColor'] ?? Colors.grey),
              ),
            ),

            // Status Button (SUBUR/KURANG SUBUR)
            Positioned(
              left: sensor['statusOffsetX'] ?? 0.0,
              top: sensor['statusOffsetY'] ?? 0.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      (sensor['statusColor'] ?? Colors.grey).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  sensor['status'] ?? '',
                  style: TextStyle(
                    fontSize: sensor['statusFontSize']?.toDouble() ?? 13.0,
                    color: sensor['statusColor'] ?? Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // // Detail Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: sensor['statusColor'] ?? Colors.grey,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    sensor['detail'] ?? 'Detail',
                    style: TextStyle(
                      fontSize: sensor['detailFontSize']?.toDouble() ?? 13.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getStatus(String type, double value) {
  switch (type) {
    case "Temperature":
      if (value < 18) return "Tidak Subur";
      if (value < 24) return "Kurang Subur";
      if (value <= 29) return "Subur";
      if (value <= 35) return "Kurang Subur";
      return "Tidak Subur";
    case "Soil Moisture":
      if (value < 30) return "Tidak Subur";
      if (value <= 33) return "Kurang Subur";
      if (value <= 90) return "Subur";
      return "Kurang Subur";
    case "pH":
      if (value < 5.0) return "Tidak Subur";
      if (value < 5.5) return "Kurang Subur";
      if (value <= 8.2) return "Subur";
      if (value <= 8.5) return "Kurang Subur";
      return "Tidak Subur";
    case "Nitrogen":
      if (value < 75) return "Tidak Subur";
      if (value < 155) return "Kurang Subur";
      if (value <= 249) return "Subur";
      if (value <= 250) return "Kurang Subur";
      return "Tidak Subur";
    case "Phospor":
      if (value < 3) return "Tidak Subur";
      if (value < 6) return "Kurang Subur";
      if (value <= 12) return "Subur";
      if (value <= 12.1) return "Kurang Subur";
      return "Tidak Subur";
    case "Kalium":
      if (value < 30.5) return "Tidak Subur";
      if (value < 65.5) return "Kurang Subur";
      if (value <= 155.5) return "Subur";
      if (value <= 156) return "Kurang Subur";
      return "Tidak Subur";
    default:
      return "-";
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case "Subur":
      return Colors.green;
    case "Kurang Subur":
      return Colors.orange;
    case "Tidak Subur":
      return Colors.red;
    default:
      return Colors.grey;
  }
}

// Data Sensor tetap sama
List<Map<String, dynamic>> sensorData = [
  {
    "icon": Icons.thermostat,
    "iconSize": 45.0,
    "iconOffsetX": 5.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 70.0,
    "valueOffsetY": 50.0,
    "valueFontSize": 20.0,
    "title": "Temperature",
    "titleFontSize": 13.0,
    "titleColor": Colors.orange,
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "underline": false,
    "status": "-",
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 5.0,
    "detailOffsetY": 100.0,
    "page": SensorSuhuPage(),
  },
  {
    "icon": Icons.opacity,
    "iconSize": 45.0,
    "iconOffsetX": 5.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 80.0,
    "valueOffsetY": 50.0,
    "valueFontSize": 20.0,
    "title": "pH",
    "titleFontSize": 13.0,
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "status": "-",
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 105.0,
    "detailOffsetY": 120.0,
  },
  {
    "icon": Icons.air,
    "iconSize": 45.0,
    "iconOffsetX": 15.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 75.0,
    "valueOffsetY": 50.0,
    "valueFontSize": 20.0,
    "title": "Nitrogen",
    "titleFontSize": 13.0,
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "titleColor": Colors.purple,
    "status": "-",
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 105.0,
    "detailOffsetY": 120.0,
  },
  {
    "icon": Icons.grass,
    "iconSize": 45.0,
    "iconOffsetX": 15.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 80.0,
    "valueOffsetY": 50.0,
    "title": "Soil Moisture",
    "titleFontSize": 13.0,
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "titleColor": Colors.brown,
    "status": "-",
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 105.0,
    "detailOffsetY": 120.0,
  },
  {
    "icon": Icons.eco,
    "iconSize": 45.0,
    "iconOffsetX": 10.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 70.0,
    "valueOffsetY": 50.0,
    "valueFontSize": 20.0,
    "title": "Kalium",
    "titleFontSize": 13.0,
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "titleColor": Colors.green,
    "status": "-",
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 105.0,
    "detailOffsetY": 120.0,
  },
  {
    "icon": Icons.science_outlined,
    "iconSize": 45.0,
    "iconOffsetX": 10.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 70.0,
    "valueOffsetY": 50.0,
    "valueFontSize": 20.0,
    "title": "Phospor",
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "titleFontSize": 13.0,
    "titleColor": Colors.purple,
    "status": "-",
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 105.0,
    "detailOffsetY": 120.0,
  },
];
