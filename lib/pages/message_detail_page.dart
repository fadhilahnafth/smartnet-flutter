import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageDetailPage extends StatelessWidget {
  final String docId;
  final String sensorName;
  final String message;
  final String status;
  final double sensorValue;
  final String unit;
  final String idealRange;
  final DateTime timestamp;

  const MessageDetailPage({
    required this.docId,
    required this.sensorName,
    required this.message,
    required this.status,
    required this.sensorValue,
    required this.unit,
    required this.idealRange,
    required this.timestamp,
    super.key,
  });

  // --- Theme ---
  static const _darkGreen = Color(0xFF2E7D32);
  static const _lightGreen = Color(0xFFE8F5E9);
  static const _bg = Color(0xFFF5F5F0);

  Color get _statusColor {
    switch (status) {
      case 'Tidak Subur':
        return Colors.red;
      case 'Kurang Subur':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData get _sensorIcon {
    switch (sensorName) {
      case 'Temperature':
        return Icons.thermostat_rounded;
      case 'pH':
        return Icons.opacity_rounded;
      case 'Nitrogen':
        return Icons.air_rounded;
      case 'Soil Moisture':
        return Icons.grass_rounded;
      case 'Kalium':
        return Icons.eco_rounded;
      case 'Phospor':
        return Icons.science_outlined;
      default:
        return Icons.sensors_rounded;
    }
  }

  Color get _sensorColor {
    switch (sensorName) {
      case 'Temperature':
        return Colors.orange;
      case 'pH':
        return Colors.blue;
      case 'Nitrogen':
        return Colors.purple;
      case 'Soil Moisture':
        return Colors.brown;
      case 'Kalium':
        return Colors.green;
      case 'Phospor':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  String get _causeExplanation {
    final val = sensorValue.toStringAsFixed(2);
    switch (sensorName) {
      case 'Temperature':
        if (sensorValue < 18) {
          return 'Suhu terlalu rendah ($val °C). Tanaman membutuhkan suhu minimal 24 °C untuk pertumbuhan optimal. Suhu rendah dapat menghambat metabolisme dan penyerapan nutrisi.';
        } else if (sensorValue > 32) {
          return 'Suhu terlalu tinggi ($val °C). Suhu di atas 32 °C dapat menyebabkan stres panas pada tanaman, mengurangi fotosintesis, dan mempercepat penguapan air.';
        }
        return 'Suhu berada di luar rentang ideal ($val °C).';

      case 'pH':
        if (sensorValue < 5.5) {
          return 'pH tanah terlalu asam ($val). Kondisi asam berlebih menghambat ketersediaan nutrisi seperti Fosfor, Kalsium, dan Magnesium bagi tanaman.';
        } else if (sensorValue > 8.2) {
          return 'pH tanah terlalu basa ($val). Kondisi basa berlebih menyebabkan defisiensi Zat Besi, Mangan, dan Zinc pada tanaman.';
        }
        return 'pH tanah di luar rentang ideal ($val).';

      case 'Nitrogen':
        if (sensorValue < 20) {
          return 'Kadar Nitrogen rendah ($val mg/kg). Nitrogen penting untuk pertumbuhan daun dan batang. Kekurangan nitrogen menyebabkan daun menguning dan pertumbuhan terhambat.';
        } else if (sensorValue > 50) {
          return 'Kadar Nitrogen terlalu tinggi ($val mg/kg). Kelebihan nitrogen menyebabkan pertumbuhan vegetatif berlebihan dan tanaman rentan terhadap penyakit.';
        }
        return 'Kadar Nitrogen di luar rentang ideal ($val mg/kg).';

      case 'Soil Moisture':
        if (sensorValue < 33) {
          return 'Kelembaban tanah terlalu rendah ($val%). Tanaman kekurangan air sehingga penyerapan nutrisi terganggu dan daun bisa layu.';
        } else if (sensorValue > 90) {
          return 'Kelembaban tanah terlalu tinggi ($val%). Kelembaban berlebih dapat menyebabkan akar membusuk dan pertumbuhan jamur.';
        }
        return 'Kelembaban tanah di luar rentang ideal ($val%).';

      case 'Kalium':
        if (sensorValue < 20) {
          return 'Kadar Kalium rendah ($val mg/kg). Kalium berperan penting dalam pembentukan buah dan ketahanan terhadap penyakit. Kekurangan kalium menyebabkan tepi daun mengering.';
        } else if (sensorValue > 50) {
          return 'Kadar Kalium terlalu tinggi ($val mg/kg). Kelebihan kalium dapat menghambat penyerapan Magnesium dan Kalsium.';
        }
        return 'Kadar Kalium di luar rentang ideal ($val mg/kg).';

      case 'Phospor':
        if (sensorValue < 40) {
          return 'Kadar Fosfor rendah ($val mg/kg). Fosfor penting untuk perkembangan akar dan pembungaan. Kekurangan fosfor menyebabkan daun berwarna keunguan dan pertumbuhan lambat.';
        } else if (sensorValue > 60) {
          return 'Kadar Fosfor terlalu tinggi ($val mg/kg). Kelebihan fosfor dapat menghambat penyerapan Zinc dan Zat Besi.';
        }
        return 'Kadar Fosfor di luar rentang ideal ($val mg/kg).';

      default:
        return 'Parameter sensor berada di luar rentang ideal.';
    }
  }

  String _fmtDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} • '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Mark as read
    FirebaseFirestore.instance
        .collection('messages')
        .doc(docId)
        .update({'isRead': true});

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  children: [
                    _buildSensorCard(),
                    const SizedBox(height: 14),
                    _buildCauseCard(),
                    const SizedBox(height: 14),
                    _buildInfoCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======== HEADER ========
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 16, 16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
              splashRadius: 22,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sensorName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _fmtDateTime(timestamp),
                    style: const TextStyle(
                        fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======== SENSOR VALUE CARD ========
  Widget _buildSensorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _sensorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(_sensorIcon, size: 30, color: _sensorColor),
          ),
          const SizedBox(width: 16),
          // Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nilai Terdeteksi',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500]),
                ),
                const SizedBox(height: 4),
                Text(
                  '${sensorValue.toStringAsFixed(2)} $unit',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: _statusColor,
                  ),
                ),
              ],
            ),
          ),
          // Ideal range
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Ideal',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _darkGreen),
                ),
                const SizedBox(height: 2),
                Text(
                  idealRange,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _darkGreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======== CAUSE EXPLANATION CARD ========
  Widget _buildCauseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _statusColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.warning_amber_rounded,
                    size: 18, color: _statusColor),
              ),
              const SizedBox(width: 10),
              Text(
                'Penyebab Peringatan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _causeExplanation,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // ======== INFO CARD ========
  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow(Icons.access_time_rounded, 'Waktu Terdeteksi',
              _fmtDateTime(timestamp)),
          const Divider(height: 20),
          _infoRow(Icons.sensors_rounded, 'Sensor', sensorName),
          const Divider(height: 20),
          _infoRow(Icons.speed_rounded, 'Nilai',
              '${sensorValue.toStringAsFixed(2)} $unit'),
          const Divider(height: 20),
          _infoRow(Icons.check_circle_outline_rounded, 'Rentang Ideal',
              idealRange),
          const Divider(height: 20),
          _infoRow(Icons.info_outline_rounded, 'Status', status),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[400]),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
