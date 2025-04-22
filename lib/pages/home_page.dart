import 'package:flutter/material.dart';
import 'package:smart_agriculture_jadi/pages/sensor_kalium.dart';
import 'package:smart_agriculture_jadi/pages/sensor_kelembaban.dart';
// import 'package:smart_agriculture_jadi/pages/sensor_kelembaban.dart';
import 'package:smart_agriculture_jadi/pages/sensor_ph.dart';
import 'package:smart_agriculture_jadi/pages/sensor_phospor.dart';
import 'package:smart_agriculture_jadi/pages/sensor_suhu.dart';

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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAEAE3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.black),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Selamat Datang",
                    style: TextStyle(color: Colors.black, fontSize: 14)),
                Text("FADHIL AHNAF",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: 6, // hanya tampilkan 4 sensor pertama
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SensorSuhuPage()));
                } else if (title == "pH") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SensorPhPage()));
                } else if (title == "Kalium") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SensorKaliumPage()));
                } else if (title == "Soil Moisture") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SensorKelembabanPage()));
                } else if (title == "Phospor") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SensorPhosporPage()));
                }
                // Tambah routing lainnya di sini
              },
            );
          },
        ),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final Map<String, dynamic> sensor;
  final VoidCallback? onTap; // tambahkan ini

  SensorCard({required this.sensor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // atau pakai InkWell kalau pakai Material widget
      onTap: onTap, // panggil fungsi onTap dari parameter
      child: Container(
        padding: EdgeInsets.all(12),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(sensor['icon'], color: Colors.orange, size: 32),
            SizedBox(height: 8),
            Text('${sensor['value']} ${sensor['unit']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(sensor['title'], style: TextStyle(color: Colors.green)),
            SizedBox(height: 4),
            Text(sensor['status'],
                style: TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
// class SensorCard extends StatelessWidget {
//   final Map<String, dynamic> sensor;
//   final VoidCallback? onTap;

//   const SensorCard({super.key, required this.sensor, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.all(8),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: sensor['borderColor'], width: 2),
//           color: Colors.white,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Positioned(
//                   left: sensor['iconOffsetX'],
//                   top: sensor['iconOffsetY'],
//                   child: Icon(
//                     sensor['icon'],
//                     color: sensor['iconColor'],
//                     size: sensor['iconSize'],
//                   ),
//                 ),
//                 Positioned(
//                   left: sensor['valueOffsetX'],
//                   top: sensor['valueOffsetY'],
//                   child: Text(
//                     sensor['value'],
//                     style: TextStyle(
//                       fontSize: sensor['valueFontSize'],
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 55),
//             Text(
//               sensor['title'],
//               style: TextStyle(
//                 fontSize: sensor['titleFontSize'],
//                 color: sensor['titleColor'],
//                 decoration:
//                     sensor['underline'] ? TextDecoration.underline : null,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: sensor['borderColor'],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 sensor['status'],
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: sensor['statusFontSize'],
//                   color: Colors.white,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// Data Sensor tetap sama
List<Map<String, dynamic>> sensorData = [
  {
    "icon": Icons.thermostat,
    // "iconColor": Colors.blue,
    "iconSize": 45.0,
    "iconOffsetX": 2.5,
    "iconOffsetY": 7.0,
    "value": "24.5 °C",
    "valueOffsetX": 60.0,
    "valueOffsetY": 15.0,
    "valueFontSize": 20.0,
    "title": "Temperature",
    "titleFontSize": 13.0,
    "titleColor": Colors.green,
    "statusFontSize": 10.0,
    "underline": false,
    "status": "SUBUR",
    "borderColor": Colors.green,
    "page": SensorSuhuPage(),
  },
  {
    "icon": Icons.opacity,
    "iconColor": Colors.blue,
    "iconOffsetX": 3.0,
    "iconOffsetY": 16.0,
    "title": "pH",
    "titleColor": Colors.blue,
    "value": "3.5",
    "valueFontSize": 20.0,
    "valueOffsetX": 60.0,
    "valueOffsetY": 15.0,
    "status": "TIDAK SUBUR",
    "borderColor": Colors.red,
    "iconSize": 36.0,
    "titleFontSize": 12.0,
    "statusFontSize": 10.0,
    "underline": false,
  },
  {
    "icon": Icons.air,
    "iconColor": Colors.purple,
    "iconOffsetX": 3.0,
    "iconOffsetY": 16.0,
    "title": "Nitrogen",
    "titleColor": Colors.purple,
    "value": "160.5 ppm",
    "valueOffsetX": 50.0,
    "valueOffsetY": 20.0,
    "status": "SUBUR",
    "borderColor": Colors.green,
    "iconSize": 40.0,
    "valueFontSize": 20.0,
    "titleFontSize": 15.0,
    "statusFontSize": 10.0,
    "underline": false,
  },
  {
    "icon": Icons.grass,
    "iconColor": Colors.brown,
    "iconOffsetX": 3.0,
    "iconOffsetY": 10.0,
    "title": "Soil Moisture",
    "titleColor": Colors.brown,
    "value": "65.5%",
    "valueFontSize": 20.0,
    "valueOffsetX": 60.0,
    "valueOffsetY": 15.0,
    "status": "KURANG\nSUBUR",
    "borderColor": Colors.orange,
    "iconSize": 36.0,
    "titleFontSize": 12.0,
    "statusFontSize": 10.0,
    "underline": false,
  },
  {
    "icon": Icons.eco,
    "iconColor": Colors.green,
    "iconOffsetX": 3.0,
    "iconOffsetY": 16.0,
    "title": "Kalium",
    "titleColor": Colors.green,
    "value": "115 ppm",
    "valueFontSize": 20.0,
    "valueOffsetX": 60.0,
    "valueOffsetY": 15.0,
    "status": "KURANG\nSUBUR",
    "borderColor": Colors.orange,
    "iconSize": 36.0,
    "titleFontSize": 12.0,
    "statusFontSize": 10.0,
    "underline": false,
  },
  {
    "icon": Icons.science_outlined,
    "iconColor": Colors.purple,
    "iconOffsetX": 3.0,
    "iconOffsetY": 12.0,
    "title": "Phospor",
    "titleColor": Colors.purple,
    "value": "160.5 ppm",
    "valueOffsetX": 52.0,
    "valueOffsetY": 15.0,
    "status": "SUBUR",
    "borderColor": Colors.green,
    "iconSize": 40.0,
    "valueFontSize": 20.0,
    "titleFontSize": 15.0,
    "statusFontSize": 10.0,
    "underline": false,
  },
];
