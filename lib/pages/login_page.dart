import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_agriculture_jadi/pages/main_page.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool isLoading = false;

//   Future<void> signInWithGoogle() async {
//     setState(() => isLoading = true);

//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         setState(() => isLoading = false);
//         return; // User cancel
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);
//       setState(() => isLoading = false);

//       // Navigasi ke halaman utama
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//             builder: (context) => MainPage()), // Ganti sesuai halaman utamamu
//       );
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Login gagal: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFDDE1D6),
//       body: Center(
//         child: isLoading
//             ? CircularProgressIndicator()
//             : ElevatedButton.icon(
//                 icon: Icon(Icons.login),
//                 label: Text("Sign in with Google"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green[700],
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 ),
//                 onPressed: signInWithGoogle,
//               ),
//       ),
//     );
//   }
// }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  Future<void> signInWithGoogle() async {
    setState(() => isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => isLoading = false);
        return; // User cancel
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() => isLoading = false);

      // Navigasi ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal: $e")),
      );
    }
  }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     final buttonPosX = screenWidth * 0.25;
//     final buttonPosY = screenHeight * 0.75;

//     return Scaffold(
//       backgroundColor: Color(0xFFDDE1D6),
//       body: Stack(
//         children: [
//           // Gambar di atas tombol
//           Positioned(
//             top: buttonPosY - 300, // posisi gambar (di atas tombol)
//             left: screenWidth * 0.2,
//             child: Image.asset(
//               'images/lambangnew1.png', // Ganti sesuai nama file gambarmu
//               width: screenWidth * 0.6, // Atur ukuran gambar
//               height: 150,
//               fit: BoxFit.contain,
//             ),
//           ),

//           // Tombol login
//           Positioned(
//             left: buttonPosX,
//             top: buttonPosY,
//             child: isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton.icon(
//                     icon: Icon(Icons.login),
//                     label: Text("Sign in with Google"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green[700],
//                       foregroundColor: Colors.white,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     ),
//                     onPressed: signInWithGoogle,
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDE1D6),
      body: Stack(
        children: [
          // Gambar bebas atur posisi dan ukuran
          Positioned(
            top: 200, // Ubah sesuai keinginan
            left: 25, // Ubah sesuai keinginan
            child: Image.asset(
              'images/lambangnew1.png', // Ganti dengan nama file gambar
              width: 350, // Atur ukuran lebar gambar
              height: 210, // Atur tinggi gambar
              fit: BoxFit.contain,
            ),
          ),

          // Tombol login Google bebas posisi
          Positioned(
            top: 550, // Ubah posisi vertikal tombol
            left: 100, // Ubah posisi horizontal tombol
            child: isLoading
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    label: Text("Sign in with Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: signInWithGoogle,
                  ),
          ),
        ],
      ),
    );
  }
}
