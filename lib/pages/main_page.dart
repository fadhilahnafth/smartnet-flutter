import 'package:flutter/material.dart';
import 'package:smart_agriculture_jadi/pages/coba.dart';
import 'package:smart_agriculture_jadi/pages/home_page.dart';
import 'package:smart_agriculture_jadi/pages/message_page.dart';
import 'package:smart_agriculture_jadi/pages/report_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Agriculture',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Menampilkan LoginPage sebagai halaman awal
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _children = [
    HomePage(),
    ReportPage(),
    MessagePage(),
    Coba()
  ];
  int currentIndex = 0;
  void onTapTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  onTapTapped(0);
                },
                icon: Icon(Icons.home_filled)),
            SizedBox(width: 5),
            IconButton(
                onPressed: () {
                  onTapTapped(1);
                },
                icon: Icon(Icons.paste_rounded)),
            SizedBox(width: 5),
            IconButton(
                onPressed: () {
                  onTapTapped(2);
                },
                icon: Icon(Icons.mail)),
            SizedBox(width: 5),
            IconButton(
                onPressed: () {
                  onTapTapped(3);
                },
                icon: Icon(Icons.supervised_user_circle_rounded)),
          ],
        ),
      ),
    );
  }
}
