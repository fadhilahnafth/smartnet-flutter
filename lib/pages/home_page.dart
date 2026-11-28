import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_agriculture_jadi/pages/sensor_kalium.dart';
import 'package:smart_agriculture_jadi/pages/sensor_kelembaban.dart';
import 'package:smart_agriculture_jadi/pages/sensor_nitrogen.dart';
import 'package:smart_agriculture_jadi/pages/sensor_ph.dart';
import 'package:smart_agriculture_jadi/pages/sensor_phospor.dart';
import 'package:smart_agriculture_jadi/pages/sensor_suhu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO; // Sementara dinonaktifkan
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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

class _HomePageState extends State<HomePage> {
  // IO.Socket? socket; // Sementara dinonaktifkan
  Timer? _pollingTimer;
  static const String _apiUrl =
      'https://api.fadhilahnaf.com/api/lahan/1/terbaru';

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // connectToSocket(); // Sementara dinonaktifkan, diganti ambil dari API
    fetchSensorFromApi();

    // Cek pembaruan data dari API secara berkala (misal tiap 1 menit)
    _pollingTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      fetchSensorFromApi();
    });

    FirebaseMessaging.instance.subscribeToTopic('sensor_alerts');
  }

  /// Mengambil data sensor terbaru dari API FastAPI pribadi
  Future<void> fetchSensorFromApi() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final sensorTerbaru =
            decoded['sensor_terbaru'] as Map<String, dynamic>?;

        if (sensorTerbaru != null) {
          // Mapping key dari API PostgreSQL ke format yang dipakai updateSensorData
          final mappedData = {
            'uplink': {
              'temperature': sensorTerbaru['suhu_udara'],
              'humidity': sensorTerbaru['kelembapan_tanah'],
              'ph': sensorTerbaru['ph_tanah'],
              'nitrogen': sensorTerbaru['nitrogen'],
              'potassium': sensorTerbaru['kalium'],
              'phossporus': sensorTerbaru['fosfor'],
            }
          };

          updateSensorData(mappedData);
        } else {
          if (mounted) setState(() => _errorMessage = 'Data sensor tidak ditemukan dari API.');
        }
      } else {
        if (mounted) setState(() => _errorMessage = 'Gagal memuat API: HTTP ${response.statusCode}');
        print("Gagal memuat API: HTTP ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Gagal terhubung ke server: $e');
      print("Error mengambil data dari API: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /* 
  // --- KODE SOCKET LAMA (DISIMPAN UNTUK NANTI JIKA DIPAKAI LAGI) ---
  void connectToSocket() {
    print("Trying to connect to socket.io...");

    socket = IO.io("https://api-smartnet.ktyudha.com", <String, dynamic>{
      'transports': ['websocket'],
      'secure': true,
    });

    socket!.onConnect((_) {
      print("✅ Connected to socket.io");
    });

    socket!.onDisconnect((_) {
      print("Socket disconnected");
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
      }
    });
  }
  */

  void updateSensorData(Map<String, dynamic> data) {
    final uplink = data['uplink'] ?? {};
    final service = SensorValueService();

    final double temperature = parseToDouble(uplink['temperature']);
    final double soilMoisture = parseToDouble(uplink['humidity']);
    final double ph = parseToDouble(uplink['ph']);
    final double nitrogen = parseToDouble(uplink['nitrogen']);
    final double kalium = parseToDouble(uplink['potassium']);
    final double phospor = parseToDouble(uplink['phossporus']);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _errorMessage = null;

      sensorData[0]['value'] = '${temperature.toStringAsFixed(1)}°C';
      final tempStatus = getStatus("Temperature", temperature);
      sensorData[0]['status'] = tempStatus;
      sensorData[0]['statusColor'] = getStatusColor(tempStatus);

      sensorData[1]['value'] = '${ph.toStringAsFixed(1)}';
      final phStatus = getStatus("pH", ph);
      sensorData[1]['status'] = phStatus;
      sensorData[1]['statusColor'] = getStatusColor(phStatus);

      sensorData[2]['value'] = '${nitrogen.toStringAsFixed(1)} mg/kg';
      final nitrogenStatus = getStatus("Nitrogen", nitrogen);
      sensorData[2]['status'] = nitrogenStatus;
      sensorData[2]['statusColor'] = getStatusColor(nitrogenStatus);

      sensorData[3]['value'] = '${soilMoisture.toStringAsFixed(1)}%';
      final moistureStatus = getStatus("Soil Moisture", soilMoisture);
      sensorData[3]['status'] = moistureStatus;
      sensorData[3]['statusColor'] = getStatusColor(moistureStatus);

      sensorData[4]['value'] = '${kalium.toStringAsFixed(1)} mg/kg';
      final kaliumStatus = getStatus("Kalium", kalium);
      sensorData[4]['status'] = kaliumStatus;
      sensorData[4]['statusColor'] = getStatusColor(kaliumStatus);

      sensorData[5]['value'] = '${phospor.toStringAsFixed(1)} mg/kg';
      final phosporStatus = getStatus("Phospor", phospor);
      sensorData[5]['status'] = phosporStatus;
      sensorData[5]['statusColor'] = getStatusColor(phosporStatus);
    });

    service.temperature = temperature;
    service.ph = ph;
    service.nitrogen = nitrogen;
    service.soilMoisture = soilMoisture;
    service.kalium = kalium;
    service.phospor = phospor;

    checkAndSendMessage("Temperature", sensorData[0]['status'] as String? ?? '-');
    checkAndSendMessage("pH", sensorData[1]['status'] as String? ?? '-');
    checkAndSendMessage("Nitrogen", sensorData[2]['status'] as String? ?? '-');
    checkAndSendMessage("Soil Moisture", sensorData[3]['status'] as String? ?? '-');
    checkAndSendMessage("Kalium", sensorData[4]['status'] as String? ?? '-');
    checkAndSendMessage("Phospor", sensorData[5]['status'] as String? ?? '-');
  }

  double _getSensorValue(String sensorName) {
    final service = SensorValueService();
    switch (sensorName) {
      case "Temperature":
        return service.temperature;
      case "pH":
        return service.ph;
      case "Nitrogen":
        return service.nitrogen;
      case "Soil Moisture":
        return service.soilMoisture;
      case "Kalium":
        return service.kalium;
      case "Phospor":
        return service.phospor;
      default:
        return 0.0;
    }
  }

  String _getIdealRange(String sensorName) {
    switch (sensorName) {
      case "Temperature":
        return "24 – 32 °C";
      case "pH":
        return "5.5 – 8.2";
      case "Nitrogen":
        return "20 – 50 mg/kg";
      case "Soil Moisture":
        return "33 – 90 %";
      case "Kalium":
        return "20 – 50 mg/kg";
      case "Phospor":
        return "40 – 60 mg/kg";
      default:
        return "-";
    }
  }

  String _getSensorUnit(String sensorName) {
    switch (sensorName) {
      case "Temperature":
        return "°C";
      case "pH":
        return "";
      case "Nitrogen":
      case "Kalium":
      case "Phospor":
        return "mg/kg";
      case "Soil Moisture":
        return "%";
      default:
        return "";
    }
  }

  Future<void> checkAndSendMessage(String sensorName, String status) async {
    if (status != "Tidak Subur" && status != "Kurang Subur") return;

    final now = DateTime.now();
    final trackerRef =
        FirebaseFirestore.instance.collection('message_tracker').doc(sensorName);
    final trackerDoc = await trackerRef.get();

    final lastSent = trackerDoc.exists
        ? (trackerDoc['lastSent'] as Timestamp).toDate()
        : DateTime(2000);
    final difference = now.difference(lastSent);

    if (difference.inMinutes >= 30) {
      final sensorValue = _getSensorValue(sensorName);
      final unit = _getSensorUnit(sensorName);
      final idealRange = _getIdealRange(sensorName);

      final messageText =
          'Sensor $sensorName $status. Nilai saat ini: ${sensorValue.toStringAsFixed(2)} $unit (Rentang ideal: $idealRange).';

      final payload = "$sensorName|$messageText|${now.toIso8601String()}";

      await FirebaseFirestore.instance.collection('messages').add({
        'sensorName': sensorName,
        'status': status,
        'message': messageText,
        'sensorValue': sensorValue,
        'idealRange': idealRange,
        'unit': unit,
        'timestamp': Timestamp.now(),
        'isRead': false,
      });

      await trackerRef.set({
        'sensorName': sensorName,
        'lastSent': Timestamp.now(),
      });

      await showLocalNotification(
        "Peringatan: $sensorName",
        messageText,
        payload,
      );
      print("📢 Notifikasi dikirim untuk sensor $sensorName");
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

  double parseToDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Future<void> _handleRefresh() async {
    print('Refreshing data from API...');

    Fluttertoast.showToast(
      msg: "Memuat ulang data dari API...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    await fetchSensorFromApi();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    // socket?.disconnect();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.green),
                      SizedBox(height: 16),
                      Text('Memuat data sensor...', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: fetchSensorFromApi,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
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
            Positioned(
              left: sensor['titleOffsetX'] ?? 0.0,
              top: sensor['titleOffsetY'] ?? 0.0,
              child: Text(
                sensor['title'] ?? '',
                style: TextStyle(
                    fontSize: sensor['titleFontSize']?.toDouble() ?? 13.0,
                    fontWeight: FontWeight.bold,
                    color: sensor['statusColor'] ?? Colors.grey),
              ),
            ),
            Positioned(
              left: sensor['iconOffsetX'] ?? 0.0,
              top: sensor['iconOffsetY'] ?? 0.0,
              child: Icon(
                sensor['icon'],
                color: sensor['statusColor'] ?? Colors.grey,
                size: sensor['iconSize']?.toDouble() ?? 32.0,
              ),
            ),
            Positioned(
              left: sensor['valueOffsetX'] ?? 0.0,
              top: sensor['valueOffsetY'] ?? 0.0,
              child: Text(
                sensor['value'] ?? '-',
                style: TextStyle(
                    fontSize: sensor['valueFontSize']?.toDouble() ?? 20.0,
                    fontWeight: FontWeight.bold,
                    color: sensor['statusColor'] ?? Colors.grey),
              ),
            ),
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
      if (value <= 32) return "Subur";
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
      if (value < 10) return "Tidak Subur";
      if (value < 20) return "Kurang Subur";
      if (value <= 50) return "Subur";
      if (value <= 75) return "Kurang Subur";
      return "Tidak Subur";
    case "Phospor":
      if (value < 21) return "Tidak Subur";
      if (value < 40) return "Kurang Subur";
      if (value <= 60) return "Subur";
      if (value <= 100) return "Kurang Subur";
      return "Tidak Subur";
    case "Kalium":
      if (value < 10) return "Tidak Subur";
      if (value < 20) return "Kurang Subur";
      if (value <= 50) return "Subur";
      if (value <= 100) return "Kurang Subur";
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
    "valueOffsetX": 65.0,
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
    "valueFontSize": 20.0,
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
    "valueOffsetX": 57.0,
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
    "valueOffsetX": 57.0,
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

class SensorValueService {
  static final SensorValueService _instance = SensorValueService._internal();

  factory SensorValueService() => _instance;

  SensorValueService._internal();

  double temperature = 0.0;
  double ph = 0.0;
  double nitrogen = 0.0;
  double soilMoisture = 0.0;
  double kalium = 0.0;
  double phospor = 0.0;
}