import 'package:flutter/material.dart';
import 'package:smart_agriculture_jadi/pages/sensor_kalium.dart';
import 'package:smart_agriculture_jadi/pages/sensor_kelembaban.dart';
import 'package:smart_agriculture_jadi/pages/sensor_nitrogen.dart';
import 'package:smart_agriculture_jadi/pages/sensor_ph.dart';
import 'package:smart_agriculture_jadi/pages/sensor_phospor.dart';
import 'package:smart_agriculture_jadi/pages/sensor_suhu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEAEAE3),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             // Ambil user Google yang sedang login
//             Builder(
//               builder: (context) {
//                 final user = FirebaseAuth.instance.currentUser;
//                 return CircleAvatar(
//                   backgroundImage: user?.photoURL != null
//                       ? NetworkImage(user!.photoURL!)
//                       : null,
//                   backgroundColor: Colors.grey[300],
//                   child: user?.photoURL == null
//                       ? Icon(Icons.person, color: Colors.black)
//                       : null,
//                 );
//               },
//             ),
//             SizedBox(width: 20),
//             Builder(
//               builder: (context) {
//                 final user = FirebaseAuth.instance.currentUser;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Selamat Datang",
//                         style: TextStyle(color: Colors.black, fontSize: 14)),
//                     Text(user?.displayName ?? "Pengguna",
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold)),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: GridView.builder(
//           itemCount: 6, // hanya tampilkan 4 sensor pertama
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (_) => SensorSuhuPage()));
//                 } else if (title == "pH") {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (_) => SensorPhPage()));
//                 } else if (title == "Kalium") {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (_) => SensorKaliumPage()));
//                 } else if (title == "Soil Moisture") {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => SensorKelembabanPage()));
//                 } else if (title == "Phospor") {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (_) => SensorPhosporPage()));
//                 } else if (title == "Nitrogen") {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (_) => SensorNitrogenPage()));
//                 }
//                 // Tambah routing lainnya di sini
//               },
//             );
//           },
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
  Map<String, dynamic>? latestData;

  @override
  void initState() {
    super.initState();
    fetchLatestSensorData();
  }

  // Future<void> fetchLatestSensorData() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('uplinks')
  //       .orderBy('createdAt', descending: true)
  //       .limit(1)
  //       .get();

  //   if (snapshot.docs.isNotEmpty) {
  //     final data = snapshot.docs.first.data();

  //     setState(() {
  //       latestData = data;

  //       // // Update sensorData dengan data dari Firestore
  //       sensorData[0]['value'] = '${data['temperature'] ?? '-'}°C';
  //       sensorData[1]['value'] = '${data['ph'] ?? '-'}';
  //       sensorData[2]['value'] = '${data['nitrogen'] ?? '-'} ppm';
  //       sensorData[3]['value'] = '${data['humidity'] ?? '-'}%';
  //       sensorData[4]['value'] = '${data['potassium'] ?? '-'} ppm';
  //       sensorData[5]['value'] = '${data['phosphorus'] ?? '-'} ppm';
  //     });
  //   }
  // }

  Future<void> fetchLatestSensorData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('uplinks')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();

      final double temperature = (data['temperature'] ?? 0).toDouble();
      final double soilMoisture = (data['humidity'] ?? 0).toDouble();
      final double ph = (data['ph'] ?? 0).toDouble();

      final String tempStatus = getStatus("Temperature", temperature);
      final String moistStatus = getStatus("Soil Moisture", soilMoisture);
      final String phStatus = getStatus("pH", ph);

      setState(() {
        latestData = data;

        sensorData[0]['value'] = '${temperature.toStringAsFixed(1)}°C';
        sensorData[0]['status'] = tempStatus;
        sensorData[0]['statusColor'] = getStatusColor(tempStatus);

        sensorData[1]['value'] = '${ph.toStringAsFixed(1)}';
        sensorData[1]['status'] = phStatus;
        sensorData[1]['statusColor'] = getStatusColor(phStatus);

        sensorData[2]['value'] = '${data['nitrogen'] ?? '-'} ppm';
        sensorData[2]['status'] = '-';
        sensorData[2]['statusColor'] = Colors.grey;

        sensorData[3]['value'] = '${soilMoisture.toStringAsFixed(1)}%';
        sensorData[3]['status'] = moistStatus;
        sensorData[3]['statusColor'] = getStatusColor(moistStatus);

        sensorData[4]['value'] = '${data['potassium'] ?? '-'} ppm';
        sensorData[4]['status'] = '-';
        sensorData[4]['statusColor'] = Colors.grey;

        sensorData[5]['value'] = '${data['phosphorus'] ?? '-'} ppm';
        sensorData[5]['status'] = '-';
        sensorData[5]['statusColor'] = Colors.grey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEAE3),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: Row(
      //     children: [
      //       CircleAvatar(
      //         backgroundImage: FirebaseAuth.instance.currentUser?.photoURL !=
      //                 null
      //             ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
      //             : null,
      //         backgroundColor: Colors.grey[300],
      //         child: FirebaseAuth.instance.currentUser?.photoURL == null
      //             ? Icon(Icons.person, color: Colors.black)
      //             : null,
      //       ),
      //       SizedBox(width: 25),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text("Selamat Datang",
      //               style: TextStyle(color: Colors.black, fontSize: 14)),
      //           Text(
      //               FirebaseAuth.instance.currentUser?.displayName ??
      //                   "Pengguna",
      //               style: TextStyle(
      //                   color: Colors.black,
      //                   fontSize: 16,
      //                   fontWeight: FontWeight.bold)),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75), // UBAH tinggi sesuai keinginan
        child: SafeArea(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16),
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
                      ? Icon(Icons.person, color: Colors.black)
                      : null,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Tengah vertikal
                  children: [
                    Text("Selamat Datang",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                    Text(
                      FirebaseAuth.instance.currentUser?.displayName ??
                          "Pengguna",
                      style: TextStyle(
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

      body: Padding(
        // padding: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 30), // JARAK ANTARA HEADER DENGAN GRID
            Expanded(
              child: GridView.builder(
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return SensorCard(
                    sensor: sensorData[index],
                    onTap: () {
                      String title = sensorData[index]["title"];
                      if (title == "Temperature") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SensorSuhuPage()));
                      } else if (title == "pH") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SensorPhPage()));
                      } else if (title == "Kalium") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SensorKaliumPage()));
                      } else if (title == "Soil Moisture") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SensorKelembabanPage()));
                      } else if (title == "Phospor") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SensorPhosporPage()));
                      } else if (title == "Nitrogen") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SensorNitrogenPage()));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SensorCard extends StatelessWidget {
//   final Map<String, dynamic> sensor;
//   final VoidCallback? onTap;

//   SensorCard({required this.sensor, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(
//             color: sensor['borderColor'] ?? Colors.transparent,
//             width: 2,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 5,
//               offset: Offset(2, 2),
//             ),
//           ],
//         ),
//         child: Stack(
//           children: [
//             // Icon
//             Positioned(
//               left: sensor['iconOffsetX'] ?? 0.0,
//               top: sensor['iconOffsetY'] ?? 0.0,
//               child: Icon(
//                 sensor['icon'],
//                 color: sensor['iconColor'] ?? Colors.orange,
//                 size: sensor['iconSize']?.toDouble() ?? 32.0,
//               ),
//             ),
//             // Value
//             Positioned(
//               left: sensor['valueOffsetX'] ?? 0.0,
//               top: sensor['valueOffsetY'] ?? 0.0,
//               child: Text(
//                 sensor['value'] ?? '-',
//                 style: TextStyle(
//                   fontSize: sensor['valueFontSize']?.toDouble() ?? 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             // Title
//             Positioned(
//               left: sensor['titleOffsetX'] ?? 0.0,
//               top: sensor['titleOffsetY'] ?? 0.0,
//               child: Text(
//                 sensor['title'] ?? '',
//                 style: TextStyle(
//                   fontSize: sensor['titleFontSize']?.toDouble() ?? 13.0,
//                   fontWeight: FontWeight.bold,
//                   color: sensor['titleColor'] ?? Colors.green,
//                   decoration: (sensor['underline'] ?? false)
//                       ? TextDecoration.underline
//                       : TextDecoration.none,
//                 ),
//               ),
//             ),
//             // Status
//             Positioned(
//               left: sensor['statusOffsetX'] ?? 0.0,
//               top: sensor['statusOffsetY'] ?? 0.0,
//               child: Text(
//                 sensor['status'] ?? '',
//                 style: TextStyle(
//                   fontSize: sensor['statusFontSize']?.toDouble() ?? 10.0,
//                   color: sensor['statusColor'] ?? Colors.green,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Positioned(
//               left: sensor['detailOffsetX'] ?? 0.0,
//               top: sensor['detailOffsetY'] ?? 0.0,
//               child: Text(
//                 sensor['detail'] ?? '',
//                 style: TextStyle(
//                   fontSize: sensor['detailFontSize']?.toDouble() ?? 10.0,
//                   color: Colors.green,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Revisi Ke 2
// class SensorCard extends StatelessWidget {
//   final Map<String, dynamic> sensor;
//   final VoidCallback? onTap;

//   const SensorCard({required this.sensor, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 5,
//             offset: Offset(2, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           // Title
//           Padding(
//             padding: const EdgeInsets.only(top: 12),
//             child: Text(
//               sensor['title'] ?? '',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: sensor['titleColor'] ?? Colors.black,
//               ),
//             ),
//           ),

//           // Icon
//           Icon(
//             sensor['icon'],
//             size: sensor['iconSize']?.toDouble() ?? 40,
//             color: sensor['iconColor'] ?? Colors.grey,
//           ),

//           // Value
//           Text(
//             sensor['value'] ?? '-',
//             style: TextStyle(
//               fontSize: sensor['valueFontSize']?.toDouble() ?? 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),

//           // Status in pill button style
//           if (sensor['status'] != null && sensor['status'] != '-')
//             Container(
//               margin: EdgeInsets.only(top: 4),
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//               decoration: BoxDecoration(
//                 color: sensor['statusColor'] ?? Colors.green,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 sensor['status'],
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//             ),

//           Spacer(),

//           // Detail bar (bottom full width)
//           InkWell(
//             onTap: onTap,
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 color: sensor['statusColor'] ?? Colors.grey,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 "Detail",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
                    color: sensor['statusColor'] ?? Colors.green),
              ),
            ),

            // Icon
            Positioned(
              left: sensor['iconOffsetX'] ?? 0.0,
              top: sensor['iconOffsetY'] ?? 0.0,
              child: Icon(
                sensor['icon'],
                // color: sensor['iconColor'],
                color: sensor['statusColor'] ?? Colors.green,
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
                    color: sensor['statusColor'] ?? Colors.green),
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
                      (sensor['statusColor'] ?? Colors.green).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  sensor['status'] ?? '',
                  style: TextStyle(
                    fontSize: sensor['statusFontSize']?.toDouble() ?? 13.0,
                    color: sensor['statusColor'] ?? Colors.green,
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
                    color: sensor['statusColor'] ?? Colors.green,
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
      if (value < 17) return "Tidak Subur";
      if (value < 22) return "Kurang Subur";
      if (value <= 31) return "Subur";
      if (value <= 35) return "Kurang Subur";
      return "Tidak Subur";
    case "Soil Moisture":
      if (value < 50) return "Tidak Subur";
      if (value <= 70) return "Kurang Subur";
      if (value <= 90) return "Subur";
      return "Kurang Subur";
    case "pH":
      if (value < 5.5) return "Tidak Subur";
      if (value < 6) return "Kurang Subur";
      if (value <= 7.5) return "Subur";
      if (value <= 8) return "Kurang Subur";
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
    "iconColor": Colors.orange,
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
    "status": "status",
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
    "iconColor": Colors.blue,
    "iconSize": 45.0,
    "iconOffsetX": 5.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 80.0,
    "valueOffsetY": 50.0,
    "valueFontSize": 20.0,
    "title": "pH",
    "titleColor": Colors.blue,
    "titleFontSize": 12.0,
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "status": "status",
    "statusColor": Colors.orange,
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 105.0,
    "detailOffsetY": 120.0,
    "underline": false,
  },
  {
    "icon": Icons.air,
    "iconColor": Colors.purple,
    "iconSize": 45.0,
    "iconOffsetX": 15.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 75.0,
    "valueOffsetY": 50.0,
    "valueFontSize": 20.0,
    "title": "Nitrogen",
    "titleFontSize": 15.0,
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "titleColor": Colors.purple,
    "status": "SUBUR",
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 105.0,
    "detailOffsetY": 120.0,
    "underline": false,
  },
  {
    "icon": Icons.grass,
    "iconColor": Colors.brown,
    "iconSize": 45.0,
    "iconOffsetX": 15.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 80.0,
    "valueOffsetY": 50.0,
    "title": "Soil Moisture",
    "titleFontSize": 12.0,
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "titleColor": Colors.brown,
    "status": "status",
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 105.0,
    "detailOffsetY": 120.0,
    "underline": false,
  },
  {
    "icon": Icons.eco,
    "iconColor": Colors.green,
    "iconSize": 45.0,
    "iconOffsetX": 10.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 70.0,
    "valueOffsetY": 50.0,
    "valueFontSize": 20.0,
    "title": "Kalium",
    "titleFontSize": 12.0,
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "titleColor": Colors.green,
    "value": "115 ppm",
    "status": "KURANG\nSUBUR",
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 105.0,
    "detailOffsetY": 120.0,
    "underline": false,
  },
  {
    "icon": Icons.science_outlined,
    "iconColor": Colors.purple,
    "iconSize": 45.0,
    "iconOffsetX": 10.0,
    "iconOffsetY": 40.0,
    "valueOffsetX": 70.0,
    "valueOffsetY": 50.0,
    "valueFontSize": 20.0,
    "title": "Phospor",
    "titleOffsetX": 15.0,
    "titleOffsetY": 10.0,
    "titleFontSize": 15.0,
    "titleColor": Colors.purple,
    "status": "SUBUR",
    "statusFontSize": 15.0,
    "statusOffsetX": 30.0,
    "statusOffsetY": 95.0,
    "detail": "detail",
    "detailFontSize": 13.0,
    "detailOffsetX": 105.0,
    "detailOffsetY": 120.0,
    "underline": false,
  },
];
