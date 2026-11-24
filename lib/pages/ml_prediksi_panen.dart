import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// class MlPrediksiPanenPage extends StatelessWidget {
//   const MlPrediksiPanenPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F0),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.deepPurple[50],
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.psychology_rounded,
//                   size: 56,
//                   color: Colors.deepPurple[400],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'AI Prediksi Panen',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Halaman ini sedang dalam pengembangan',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MlPrediksiPanenPage extends StatefulWidget {
//   const MlPrediksiPanenPage({super.key});

//   @override
//   State<MlPrediksiPanenPage> createState() => _MlPrediksiPanenPageState();
// }

// class _MlPrediksiPanenPageState extends State<MlPrediksiPanenPage> {
//   static const String _apiUrl =
//       'https://api.fadhilahnaf.com/api/lahan/1/terbaru';

//   bool _isLoading = true;
//   String? _errorMessage;
//   Map<String, dynamic>? _data;

//   @override
//   void initState() {
//     super.initState();
//     _fetchPrediksiPanen();
//   }

//   Future<void> _fetchPrediksiPanen() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final response = await http
//           .get(Uri.parse(_apiUrl))
//           .timeout(const Duration(seconds: 12));

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body) as Map<String, dynamic>;
//         setState(() {
//           _data = decoded;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Gagal memuat data (HTTP ${response.statusCode})';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage =
//             'Koneksi ke server terputus.\nTarik ke bawah untuk mencoba lagi.';
//         _isLoading = false;
//       });
//     }
//   }

//   ({String label, IconData icon, Color iconColor}) _getInfoCuaca(
//     double suhu,
//     double curahHujan,
//   ) {
//     if (curahHujan > 0.5) {
//       return (
//         label: 'Hujan',
//         icon: Icons.thunderstorm_rounded,
//         iconColor: const Color(0xFF3B82F6),
//       );
//     } else if (suhu >= 30.0) {
//       return (
//         label: 'Cerah',
//         icon: Icons.wb_sunny_rounded,
//         iconColor: const Color(0xFFF59E0B),
//       );
//     } else {
//       return (
//         label: 'Berawan',
//         icon: Icons.cloud_rounded,
//         iconColor: const Color(0xFF94A3B8),
//       );
//     }
//   }

//   String _formatWaktu(String? isoString) {
//     if (isoString == null || isoString.isEmpty) return '-';
//     try {
//       final dt = DateTime.parse(isoString);
//       final tgl = dt.day.toString().padLeft(2, '0');
//       final bln = dt.month.toString().padLeft(2, '0');
//       final jam = dt.hour.toString().padLeft(2, '0');
//       final menit = dt.minute.toString().padLeft(2, '0');
//       return '$tgl/$bln/${dt.year} • $jam:$menit WIB';
//     } catch (_) {
//       return isoString;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F0),
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: _fetchPrediksiPanen,
//           color: const Color(0xFF2E7D32),
//           child: _buildBody(),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircularProgressIndicator(color: Color(0xFF2E7D32)),
//             SizedBox(height: 16),
//             Text(
//               'Menganalisis data lahan & cuaca BMKG...',
//               style: TextStyle(fontSize: 13, color: Colors.black54),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_errorMessage != null || _data == null) {
//       return ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.all(24),
//         children: [
//           const SizedBox(height: 120),
//           Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             _errorMessage ?? 'Data tidak tersedia',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//           ),
//           const SizedBox(height: 20),
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: _fetchPrediksiPanen,
//               icon: const Icon(Icons.refresh_rounded),
//               label: const Text('Muat Ulang'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2E7D32),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     final lahan = _data!['lahan'] as Map<String, dynamic>? ?? {};
//     final sensor = _data!['sensor_terbaru'] as Map<String, dynamic>? ?? {};
//     final prediksi = _data!['prediksi_terbaru'] as Map<String, dynamic>? ?? {};

//     final int prediksiLabel = (prediksi['prediksi_label'] ?? 0) as int;
//     final bool isSiapPanen = prediksiLabel == 1;

//     final int sisaHari = (prediksi['estimasi_sisa_hari'] ?? 0) as int;
//     final String estimasiTanggal =
//         (prediksi['estimasi_tanggal'] ?? '-') as String;
//     final String namaLahan =
//         (lahan['nama_lahan'] ?? 'Lahan Uji Coba 1') as String;
//     final String varietas = (lahan['varietas'] ?? 'Inpari 32') as String;

//     final double suhuUdara = (sensor['suhu_udara'] as num?)?.toDouble() ?? 28.0;
//     final double curahHujan =
//         (sensor['curah_hujan'] as num?)?.toDouble() ?? 0.0;

//     final cuaca = _getInfoCuaca(suhuUdara, curahHujan);

//     final List<Color> gradientColors = isSiapPanen
//         ? const [Color(0xFF1B7A43), Color(0xFF56AB2F)]
//         : const [Color(0xFFE53935), Color(0xFFFB8C00)];

//     final Color shadowColor = isSiapPanen
//         ? const Color(0xFF2E7D32).withValues(alpha: 0.30)
//         : const Color(0xFFE53935).withValues(alpha: 0.30);

//     final String judulStatus = isSiapPanen ? 'SIAP PANEN' : 'BELUM SIAP PANEN';
//     final String teksEstimasi = isSiapPanen
//         ? (sisaHari <= 0
//             ? 'Estimasi: 0-3 Hari Lagi\n(Segera)'
//             : 'Estimasi: $sisaHari Hari Lagi\n(Segera)')
//         : 'Estimasi: $sisaHari Hari Lagi\n(Target: $estimasiTanggal)';

//     return ListView(
//       physics: const AlwaysScrollableScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
//       children: [
//         // Header Sapaan & Refresh
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Hallo, Fadhil Ahnaf',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w800,
//                     color: Color(0xFF1E293B),
//                     letterSpacing: -0.3,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   '$namaLahan • Padi $varietas',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//             Material(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               child: InkWell(
//                 onTap: _fetchPrediksiPanen,
//                 borderRadius: BorderRadius.circular(12),
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: const Icon(
//                     Icons.refresh_rounded,
//                     size: 20,
//                     color: Color(0xFF334155),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 22),

//         // Kartu Utama Status AI Prediksi Panen
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: gradientColors,
//             ),
//             borderRadius: BorderRadius.circular(22),
//             boxShadow: [
//               BoxShadow(
//                 color: shadowColor,
//                 blurRadius: 18,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.14),
//                   borderRadius: BorderRadius.circular(18),
//                   border: Border.all(
//                     color: Colors.white.withValues(alpha: 0.85),
//                     width: 2.2,
//                   ),
//                 ),
//                 child: const Icon(
//                   Icons.psychology_rounded,
//                   size: 52,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 18),
//               Text(
//                 judulStatus,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 23,
//                   fontWeight: FontWeight.w900,
//                   color: Colors.white,
//                   letterSpacing: 0.8,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 teksEstimasi,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   height: 1.4,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white.withValues(alpha: 0.92),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 20),

//         // Kartu Cuaca (BMKG) di Tengah
//         Center(
//           child: Container(
//             width: 175,
//             padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.06),
//                   blurRadius: 14,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 const Text(
//                   'CUACA\n(BMKG)',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 13,
//                     height: 1.25,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF334155),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Icon(
//                   cuaca.icon,
//                   size: 46,
//                   color: cuaca.iconColor,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   cuaca.label,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF475569),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   '${suhuUdara.toStringAsFixed(1)}°C',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     color: Color(0xFF1E293B),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(height: 22),

//         // Kotak Parameter Sensor Lahan (isi item di dalamnya dikosongkan)
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Parameter Sensor Lahan',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF334155),
//                 ),
//               ),
//               Text(
//                 _formatWaktu(prediksi['waktu_prediksi'] as String?),
//                 style: TextStyle(fontSize: 11, color: Colors.grey[500]),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class MlPrediksiPanenPage extends StatefulWidget {
  const MlPrediksiPanenPage({super.key});

  @override
  State<MlPrediksiPanenPage> createState() => _MlPrediksiPanenPageState();
}

class _MlPrediksiPanenPageState extends State<MlPrediksiPanenPage> {
  static const String _apiUrl =
      'https://api.fadhilahnaf.com/api/lahan/1/terbaru';

  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _fetchPrediksiPanen();
  }

  Future<void> _fetchPrediksiPanen() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _data = decoded;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data (HTTP ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Koneksi ke server terputus.\nTarik ke bawah untuk mencoba lagi.';
        _isLoading = false;
      });
    }
  }

  ({String label, IconData icon, Color iconColor}) _getInfoCuaca(
    double suhu,
    double curahHujan,
  ) {
    if (curahHujan > 0.5) {
      return (
        label: 'Hujan',
        icon: Icons.thunderstorm_rounded,
        iconColor: const Color(0xFF3B82F6),
      );
    } else if (suhu >= 30.0) {
      return (
        label: 'Cerah',
        icon: Icons.wb_sunny_rounded,
        iconColor: const Color(0xFFF59E0B),
      );
    } else {
      return (
        label: 'Berawan',
        icon: Icons.cloud_rounded,
        iconColor: const Color(0xFF94A3B8),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchPrediksiPanen,
          color: const Color(0xFF2E7D32),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF2E7D32)),
            SizedBox(height: 16),
            Text(
              'Menganalisis data lahan & cuaca BMKG...',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null || _data == null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 120),
          Icon(Icons.cloud_off_rounded, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Data tidak tersedia',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: _fetchPrediksiPanen,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Muat Ulang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final lahan = _data!['lahan'] as Map<String, dynamic>? ?? {};
    final sensor = _data!['sensor_terbaru'] as Map<String, dynamic>? ?? {};
    final prediksi = _data!['prediksi_terbaru'] as Map<String, dynamic>? ?? {};

    final int prediksiLabel = (prediksi['prediksi_label'] ?? 0) as int;
    final bool isSiapPanen = prediksiLabel == 1;

    final int sisaHari = (prediksi['estimasi_sisa_hari'] ?? 0) as int;
    final String estimasiTanggal =
        (prediksi['estimasi_tanggal'] ?? '-') as String;
    final String namaLahan =
        (lahan['nama_lahan'] ?? 'Lahan Uji Coba 1') as String;
    final String varietas = (lahan['varietas'] ?? 'Inpari 32') as String;

    final double suhuUdara = (sensor['suhu_udara'] as num?)?.toDouble() ?? 28.0;
    final double curahHujan =
        (sensor['curah_hujan'] as num?)?.toDouble() ?? 0.0;

    final cuaca = _getInfoCuaca(suhuUdara, curahHujan);

    final List<Color> gradientColors = isSiapPanen
        ? const [Color(0xFF1B7A43), Color(0xFF56AB2F)]
        : const [Color(0xFFE53935), Color(0xFFFB8C00)];

    final Color shadowColor = isSiapPanen
        ? const Color(0xFF2E7D32).withValues(alpha: 0.30)
        : const Color(0xFFE53935).withValues(alpha: 0.30);

    final String judulStatus = isSiapPanen ? 'SIAP PANEN' : 'BELUM SIAP PANEN';
    final String teksEstimasi = isSiapPanen
        ? (sisaHari <= 0
            ? 'Estimasi: 0-3 Hari Lagi\n(Segera)'
            : 'Estimasi: $sisaHari Hari Lagi\n(Segera)')
        : 'Estimasi: $sisaHari Hari Lagi\n(Perkiraaan: $estimasiTanggal)';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      children: [
        // Header Sapaan & Refresh
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Prediksi Panen',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$namaLahan • Padi $varietas',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _fetchPrediksiPanen,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 20,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // Kartu Utama Status AI Prediksi Panen
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 2.2,
                  ),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  size: 52,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                judulStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                teksEstimasi,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Kartu Cuaca (BMKG) di Tengah
        Center(
          child: Container(
            width: 175,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'CUACA\n(BMKG)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 12),
                Icon(
                  cuaca.icon,
                  size: 46,
                  color: cuaca.iconColor,
                ),
                const SizedBox(height: 10),
                Text(
                  cuaca.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${suhuUdara.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
