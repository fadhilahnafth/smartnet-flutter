import 'package:flutter/material.dart';
import 'package:smart_agriculture_jadi/pages/report_detail_page.dart';
import 'package:table_calendar/table_calendar.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDE1D6),
      body: Column(
        children: [
          // Header REPORT
          Container(
            color: Colors.white,
            width: double.infinity,
            height: 100, // Sesuaikan tinggi header
            child: Stack(
              children: [
                Positioned(
                  left: 16, // Koordinat X (Geser ke kanan)
                  top: 37, // Koordinat Y (Geser ke bawah)
                  child: Text(
                    "REPORT",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  left: 16, // Sama dengan REPORT agar sejajar
                  top: 70, // Geser ke bawah dari REPORT
                  child: Text(
                    "${_focusedDay.day} ${_getMonthName(_focusedDay.month)} ${_focusedDay.year}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          // Kalender
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                // Navigasi ke halaman detail report
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReportDetailPage(selectedDate: selectedDay),
                  ),
                );
              },
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    List<String> months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return months[month - 1];
  }
}
