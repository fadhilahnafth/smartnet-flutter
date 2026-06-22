import 'package:flutter/material.dart';
import 'package:smart_agriculture_jadi/pages/coba.dart';
import 'package:smart_agriculture_jadi/pages/home_page.dart';
import 'package:smart_agriculture_jadi/pages/message_page.dart';
import 'package:smart_agriculture_jadi/pages/report_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Smart Agriculture',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       // Menampilkan LoginPage sebagai halaman awal
//     );
//   }
// }

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   final List<Widget> _children = [
//     HomePage(),
//     ReportPage(),
//     MessagePage(),
//     Coba()
//   ];
//   int currentIndex = 0;
//   void onTapTapped(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _children[currentIndex],
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//                 onPressed: () {
//                   onTapTapped(0);
//                 },
//                 icon: Icon(Icons.home_filled)),
//             SizedBox(width: 5),
//             IconButton(
//                 onPressed: () {
//                   onTapTapped(1);
//                 },
//                 icon: Icon(Icons.paste_rounded)),
//             SizedBox(width: 5),
//             IconButton(
//                 onPressed: () {
//                   onTapTapped(2);
//                 },
//                 icon: Icon(Icons.mail)),
//             SizedBox(width: 5),
//             IconButton(
//                 onPressed: () {
//                   onTapTapped(3);
//                 },
//                 icon: Icon(Icons.supervised_user_circle_rounded)),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
      home: MainPage(),
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

  final List<String> titles = ["Home", "Report", "Message", "User"];
  final List<IconData> icons = [
    Icons.home_filled,
    Icons.paste_rounded,
    Icons.mail,
    Icons.supervised_user_circle_rounded
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            final bool isActive = index == currentIndex;
            return GestureDetector(
              onTap: () => onTapTapped(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: isActive
                    ? BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : null,
                child: Row(
                  children: [
                    Icon(
                      icons[index],
                      color: isActive ? Colors.green : Colors.grey[700],
                    ),
                    if (isActive) ...[
                      SizedBox(width: 8),
                      Text(
                        titles[index],
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
