import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'message_detail_page.dart';
import 'dart:async';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MessagePage extends StatefulWidget {
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  // --- Theme ---
  static const _darkGreen = Color(0xFF2E7D32);
  static const _bg = Color(0xFFF5F5F0);

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupNotificationListeners();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      const NotificationDetails(
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
    final sensorName = msg.data['sensorName'];
    if (sensorName != null) _goToDetailById(sensorName);
  }

  Future<void> _checkInitialMessage() async {
    final msg = await FirebaseMessaging.instance.getInitialMessage();
    if (msg != null && msg.data['sensorName'] != null) {
      _goToDetailById(msg.data['sensorName']);
    }
  }

  void _goToDetailById(String sensorName) async {
    // Find latest message for this sensor
    final snap = await FirebaseFirestore.instance
        .collection('messages')
        .where('sensorName', isEqualTo: sensorName)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) {
      final doc = snap.docs.first;
      _openDetail(doc.id, doc.data());
    }
  }

  void _openDetail(String docId, Map<String, dynamic> data) {
    final timestamp = data['timestamp'] is Timestamp
        ? (data['timestamp'] as Timestamp).toDate()
        : DateTime.now();

    // Mark as read
    FirebaseFirestore.instance.collection('messages').doc(docId).update({
      'isRead': true,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageDetailPage(
          docId: docId,
          sensorName: data['sensorName'] ?? '-',
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

  // --- Sensor icon & color helpers ---
  IconData _sensorIcon(String name) {
    switch (name) {
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

  Color _sensorColor(String name) {
    switch (name) {
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

  Color _statusColor(String status) {
    switch (status) {
      case 'Tidak Subur':
        return Colors.red;
      case 'Kurang Subur':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _fmtTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inHours < 1) return '${diff.inMinutes} mnt';
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    if (diff.inDays < 7) return '${diff.inDays} hari';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  // ======== BUILD ========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMessageList(filter: 'all'),
                  _buildMessageList(filter: 'unread'),
                  _buildMessageList(filter: 'read'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======== HEADER ========
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Top row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.mail_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Pesan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Unread badge
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .where('isRead', isEqualTo: false)
                      .snapshots(),
                  builder: (_, snap) {
                    final count = snap.data?.docs.length ?? 0;
                    if (count == 0) return const SizedBox();
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '$count belum dibaca',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Tab bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: _darkGreen,
              unselectedLabelColor: Colors.white70,
              labelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              dividerHeight: 0,
              tabs: const [
                Tab(text: 'Semua'),
                Tab(text: 'Belum Dibaca'),
                Tab(text: 'Sudah Dibaca'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======== MESSAGE LIST ========
  Widget _buildMessageList({required String filter}) {
    Stream<QuerySnapshot> stream;

    if (filter == 'unread') {
      stream = FirebaseFirestore.instance
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else if (filter == 'read') {
      stream = FirebaseFirestore.instance
          .collection('messages')
          .where('isRead', isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      stream = FirebaseFirestore.instance
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Terjadi kesalahan',
                style: TextStyle(color: Colors.grey[500])),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs;
        if (messages.isEmpty) {
          return _buildEmptyState(filter);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          physics: const BouncingScrollPhysics(),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final doc = messages[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildMessageTile(doc.id, data);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String filter) {
    final icon = filter == 'unread'
        ? Icons.mark_email_read_rounded
        : filter == 'read'
            ? Icons.drafts_rounded
            : Icons.inbox_rounded;
    final text = filter == 'unread'
        ? 'Semua pesan sudah dibaca'
        : filter == 'read'
            ? 'Belum ada pesan yang dibaca'
            : 'Belum ada pesan peringatan';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 44, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Text(text,
              style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  // ======== MESSAGE TILE (Gmail-like) ========
  Widget _buildMessageTile(String docId, Map<String, dynamic> data) {
    final sensorName = data['sensorName'] ?? '-';
    final message = data['message'] ?? '-';
    final status = data['status'] ?? 'Tidak Subur';
    final isRead = data['isRead'] ?? true; // existing messages = read
    final timestamp = data['timestamp'] is Timestamp
        ? (data['timestamp'] as Timestamp).toDate()
        : DateTime.now();

    final color = _sensorColor(sensorName);
    final stColor = _statusColor(status);

    return Dismissible(
      key: Key(docId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: Colors.red[400],
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        FirebaseFirestore.instance.collection('messages').doc(docId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pesan dihapus'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
      },
      child: Material(
        color: isRead ? Colors.white : const Color(0xFFF0F7F0),
        child: InkWell(
          onTap: () => _openDetail(docId, data),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_sensorIcon(sensorName), size: 22, color: color),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              sensorName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    isRead ? FontWeight.w500 : FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            _fmtTime(timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  isRead ? FontWeight.w400 : FontWeight.w600,
                              color:
                                  isRead ? Colors.grey[500] : _darkGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isRead ? Colors.grey[500] : Colors.grey[700],
                          fontWeight:
                              isRead ? FontWeight.w400 : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Status badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: stColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: stColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
