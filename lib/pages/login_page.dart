// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:smart_agriculture_jadi/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_agriculture_jadi/pages/main_page.dart';
import 'signup_page.dart';

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

//
//
//
//
//
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
//         MaterialPageRoute(builder: (context) => MainPage()),
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
//       body: Stack(
//         children: [
//           // Gambar bebas atur posisi dan ukuran
//           Positioned(
//             top: 200, // Ubah sesuai keinginan
//             left: 25, // Ubah sesuai keinginan
//             child: Image.asset(
//               'images/lambangnew1.png', // Ganti dengan nama file gambar
//               width: 350, // Atur ukuran lebar gambar
//               height: 210, // Atur tinggi gambar
//               fit: BoxFit.contain,
//             ),
//           ),

//           // Tombol login Google bebas posisi
//           Positioned(
//             top: 550, // Ubah posisi vertikal tombol
//             left: 100, // Ubah posisi horizontal tombol
//             child: isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton.icon(
//                     icon: Icon(Icons.login),
//                     label: Text("Sign in with Google"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.green[700],
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
//
//
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> signInWithGoogle() async {
//     setState(() => isLoading = true);
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         setState(() => isLoading = false);
//         return;
//       }
//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => MainPage()));
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Login gagal: $e")));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> signInWithEmail() async {
//     setState(() => isLoading = true);
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => MainPage()));
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Login gagal: $e")));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFDDE1D6),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Text("Login",
//                     style:
//                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     hintText: "Email",
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     hintText: "Password",
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: signInWithEmail,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     minimumSize: Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30)),
//                   ),
//                   child: Text("Login"),
//                 ),
//                 SizedBox(height: 10),
//                 OutlinedButton.icon(
//                   icon: Icon(Icons.login),
//                   label: Text("Sign in with Google"),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.green,
//                     minimumSize: Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30)),
//                   ),
//                   onPressed: signInWithGoogle,
//                 ),
//                 SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (_) => SignUpPage()));
//                   },
//                   child: Text("Doesn't Have An Account? Sign Up"),
//                 ),
//                 if (isLoading) SizedBox(height: 20),
//                 if (isLoading) CircularProgressIndicator(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> signInWithGoogle() async {
//     setState(() => isLoading = true);
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         setState(() => isLoading = false);
//         return;
//       }
//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => MainPage()));
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Login gagal: $e")));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> signInWithEmail() async {
//     setState(() => isLoading = true);
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => MainPage()));
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Login gagal: $e")));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFDDE1D6),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Login",
//                     style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87)),
//                 SizedBox(height: 20),
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey.shade300,
//                           blurRadius: 10,
//                           spreadRadius: 2)
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           hintText: "Email",
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.green),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: Colors.green, width: 2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       TextField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           hintText: "Password",
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.green),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: Colors.green, width: 2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: signInWithEmail,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF79A96B),
//                     foregroundColor: Colors.white,
//                     minimumSize: Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text("Login"),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton.icon(
//                   onPressed: signInWithGoogle,
//                   icon: Icon(Icons.login, color: Colors.green),
//                   label: Text("Sign in with Google",
//                       style: TextStyle(color: Colors.green)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     minimumSize: Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       side: BorderSide(color: Colors.green),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (_) => SignUpPage()));
//                   },
//                   child: Text(
//                     "Doesn’t Have An Account? Sign Up",
//                     style: TextStyle(color: Colors.black87),
//                   ),
//                 ),
//                 if (isLoading) SizedBox(height: 20),
//                 if (isLoading) CircularProgressIndicator(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool isLoading = false;
//   bool _obscurePassword = true;

//   Future<void> signInWithGoogle() async {
//     setState(() => isLoading = true);
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return;
//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => MainPage()));
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Login gagal: $e")));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> signInWithEmail() async {
//     setState(() => isLoading = true);
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => MainPage()));
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Login gagal: $e")));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFE6F0FF),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header
//             Container(
//               height: 270,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Color(0xFF1666F0),
//                 borderRadius:
//                     BorderRadius.vertical(bottom: Radius.circular(30)),
//               ),
//               padding: EdgeInsets.only(top: 100),
//               child: Column(
//                 children: [
//                   Icon(Icons.security, size: 60, color: Colors.white),
//                   SizedBox(height: 10),
//                   Text("Sign in to your\nAccount",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 8),
//                   Text("Enter your email and password to log in",
//                       style: TextStyle(color: Colors.white70, fontSize: 14)),
//                 ],
//               ),
//             ),

//             // Form
//             Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: signInWithGoogle,
//                     icon: Icon(Icons.login, color: Colors.black),
//                     label: Text("Continue with Google",
//                         style: TextStyle(color: Colors.black)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       minimumSize: Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       elevation: 2,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text("OR", style: TextStyle(color: Colors.grey)),
//                   SizedBox(height: 20),
//                   TextField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       hintText: "Email",
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: _obscurePassword,
//                     decoration: InputDecoration(
//                       hintText: "Password",
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                       suffixIcon: IconButton(
//                         icon: Icon(_obscurePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility),
//                         onPressed: () => setState(
//                             () => _obscurePassword = !_obscurePassword),
//                       ),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Checkbox(value: false, onChanged: (_) {}),
//                       Text("Remember me"),
//                       Spacer(),
//                       TextButton(
//                         onPressed: () {},
//                         child: Text("Forgot Password?",
//                             style: TextStyle(color: Colors.blue)),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: signInWithEmail,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF1666F0),
//                       foregroundColor: Colors.white,
//                       minimumSize: Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: Text("Log In", style: TextStyle(fontSize: 16)),
//                   ),
//                   SizedBox(height: 20),
//                   Text("Don’t have an account?"),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (_) => SignUpPage()));
//                     },
//                     child: Text("Sign Up",
//                         style: TextStyle(
//                             color: Colors.blue, fontWeight: FontWeight.bold)),
//                   ),
//                   if (isLoading) SizedBox(height: 20),
//                   if (isLoading) CircularProgressIndicator(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  Future<void> signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainPage()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login gagal: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> signInWithEmail() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainPage()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login gagal: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           Container(
  //             height: 280,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               color: Color(0xFF1666F0),
  //               borderRadius:
  //                   BorderRadius.vertical(bottom: Radius.circular(30)),
  //             ),
  //             padding: EdgeInsets.only(top: 100),
  //             child: Column(
  //               children: [
  //                 Icon(Icons.security, size: 60, color: Colors.white),
  //                 SizedBox(height: 10),
  //                 Text("Sign in to your\nAccount",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 24,
  //                         fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 8),
  //                 Text("Enter your email and password to log in",
  //                     style: TextStyle(color: Colors.white70, fontSize: 14)),
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(24),
  //             child: Column(
  //               children: [
  //                 ElevatedButton.icon(
  //                   onPressed: signInWithGoogle,
  //                   icon: Icon(Icons.login, color: Colors.black),
  //                   label: Text("Continue with Google",
  //                       style: TextStyle(color: Colors.black)),
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.white,
  //                     minimumSize: Size(double.infinity, 50),
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12)),
  //                     elevation: 2,
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Text("OR", style: TextStyle(color: Colors.grey)),
  //                 SizedBox(height: 20),
  //                 TextField(
  //                   controller: _emailController,
  //                   decoration: InputDecoration(
  //                     hintText: "Email",
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     contentPadding:
  //                         EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //                     border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12)),
  //                   ),
  //                 ),
  //                 SizedBox(height: 16),
  //                 TextField(
  //                   controller: _passwordController,
  //                   obscureText: _obscurePassword,
  //                   decoration: InputDecoration(
  //                     hintText: "Password",
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     contentPadding:
  //                         EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //                     suffixIcon: IconButton(
  //                       icon: Icon(_obscurePassword
  //                           ? Icons.visibility_off
  //                           : Icons.visibility),
  //                       onPressed: () => setState(
  //                           () => _obscurePassword = !_obscurePassword),
  //                     ),
  //                     border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12)),
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Row(
  //                   children: [
  //                     Checkbox(
  //                       value: _rememberMe,
  //                       onChanged: (value) {
  //                         setState(() => _rememberMe = value!);
  //                       },
  //                     ),
  //                     Text("Remember me"),
  //                     Spacer(),
  //                     TextButton(
  //                       onPressed: () {},
  //                       child: Text("Forgot Password?",
  //                           style: TextStyle(color: Color(0xFF1666F0))),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 10),
  //                 ElevatedButton(
  //                   onPressed: signInWithEmail,
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Color(0xFF1666F0),
  //                     foregroundColor: Colors.white,
  //                     minimumSize: Size(double.infinity, 50),
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12)),
  //                   ),
  //                   child: Text("Log In", style: TextStyle(fontSize: 16)),
  //                 ),
  //                 SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text("Don’t have an account? "),
  //                     GestureDetector(
  //                       onTap: () {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(builder: (_) => SignUpPage()),
  //                         );
  //                       },
  //                       child: Text("Sign Up",
  //                           style: TextStyle(
  //                               color: Color(0xFF1666F0),
  //                               fontWeight: FontWeight.bold)),
  //                     ),
  //                   ],
  //                 ),
  //                 if (isLoading) SizedBox(height: 20),
  //                 if (isLoading) CircularProgressIndicator(),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Color(0xFFF8FAFC),
  //     body: SingleChildScrollView(
  //       padding: EdgeInsets.symmetric(horizontal: 24),
  //       child: Column(
  //         children: [
  //           SizedBox(height: 100),
  //           // Logo Shield
  //           Container(
  //             width: 60,
  //             height: 60,
  //             decoration: BoxDecoration(
  //               color: Color(0xFF1666F0),
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: Icon(Icons.security, color: Colors.white, size: 36),
  //           ),
  //           SizedBox(height: 20),
  //           Text(
  //             "Sign in to your\nAccount",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 8),
  //           Text(
  //             "Enter your email and password to log in",
  //             style: TextStyle(color: Colors.grey[600], fontSize: 14),
  //           ),
  //           SizedBox(height: 30),
  //           Container(
  //             padding: EdgeInsets.all(20),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(16),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black12,
  //                   blurRadius: 10,
  //                   offset: Offset(0, 4),
  //                 ),
  //               ],
  //             ),
  //             child: Column(
  //               children: [
  //                 // Google Sign-In Button
  //                 ElevatedButton.icon(
  //                   onPressed: signInWithGoogle,
  //                   icon: Image.asset(
  //                     'images/icon_google_fix.png', // Letakkan ikon Google asli di folder assets
  //                     height: 24,
  //                   ),
  //                   label: Text("Continue with Google",
  //                       style: TextStyle(color: Colors.black)),
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.white,
  //                     minimumSize: Size(double.infinity, 50),
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12)),
  //                     elevation: 1,
  //                     side: BorderSide(color: Colors.grey.shade300),
  //                   ),
  //                 ),
  //                 SizedBox(height: 20),
  //                 Text("Or", style: TextStyle(color: Colors.grey)),
  //                 SizedBox(height: 16),
  //                 // Email
  //                 TextField(
  //                   controller: _emailController,
  //                   decoration: InputDecoration(
  //                     hintText: "Email",
  //                     contentPadding:
  //                         EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 16),
  //                 // Password
  //                 TextField(
  //                   controller: _passwordController,
  //                   obscureText: _obscurePassword,
  //                   decoration: InputDecoration(
  //                     hintText: "Password",
  //                     suffixIcon: IconButton(
  //                       icon: Icon(_obscurePassword
  //                           ? Icons.visibility_off
  //                           : Icons.visibility),
  //                       onPressed: () {
  //                         setState(() {
  //                           _obscurePassword = !_obscurePassword;
  //                         });
  //                       },
  //                     ),
  //                     contentPadding:
  //                         EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Row(
  //                   children: [
  //                     Checkbox(
  //                       value: _rememberMe,
  //                       onChanged: (value) {
  //                         setState(() => _rememberMe = value!);
  //                       },
  //                     ),
  //                     Text("Remember me"),
  //                     Spacer(),
  //                     TextButton(
  //                       onPressed: () {},
  //                       child: Text("Forgot Password ?",
  //                           style: TextStyle(color: Color(0xFF1666F0))),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 10),
  //                 ElevatedButton(
  //                   onPressed: signInWithEmail,
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Color(0xFF1666F0),
  //                     foregroundColor: Colors.white,
  //                     minimumSize: Size(double.infinity, 50),
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12)),
  //                   ),
  //                   child: Text("Log In", style: TextStyle(fontSize: 16)),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text("Don’t have an account? "),
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(context,
  //                       MaterialPageRoute(builder: (_) => SignUpPage()));
  //                 },
  //                 child: Text("Sign Up",
  //                     style: TextStyle(
  //                         color: Color(0xFF1666F0),
  //                         fontWeight: FontWeight.bold)),
  //               ),
  //             ],
  //           ),
  //           if (isLoading) SizedBox(height: 20),
  //           if (isLoading) CircularProgressIndicator(),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Color(0xFFF6F9FF), // warna abu muda
  //     body: SingleChildScrollView(
  //       child: Column(
  //         children: [
  //           Container(
  //             width: double.infinity,
  //             height: 260,
  //             decoration: BoxDecoration(
  //               color: Color(0xFF1666F0),
  //               borderRadius: BorderRadius.vertical(
  //                 bottom: Radius.circular(30),
  //               ),
  //             ),
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     height: 60,
  //                     width: 60,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(16),
  //                     ),
  //                     child: Icon(Icons.security,
  //                         color: Color(0xFF1666F0), size: 40),
  //                   ),
  //                   SizedBox(height: 16),
  //                   Text(
  //                     "Sign in to your\nAccount",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 24,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   SizedBox(height: 8),
  //                   Text(
  //                     "Enter your email and password to log in",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //             child: Container(
  //               padding: EdgeInsets.all(20),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(20),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     blurRadius: 15,
  //                     color: Colors.black12,
  //                     offset: Offset(0, 5),
  //                   ),
  //                 ],
  //               ),
  //               child: Column(
  //                 children: [
  //                   ElevatedButton.icon(
  //                     onPressed: signInWithGoogle,
  //                     icon: Image.asset(
  //                       'images/icon_google_fix.png',
  //                       height: 20,
  //                     ),
  //                     label: Text(
  //                       "Continue with Google",
  //                       style: TextStyle(color: Colors.black),
  //                     ),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.white,
  //                       elevation: 2,
  //                       minimumSize: Size(double.infinity, 50),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                         side: BorderSide(color: Colors.grey.shade300),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 16),
  //                   Text("Or", style: TextStyle(color: Colors.grey)),
  //                   SizedBox(height: 16),
  //                   TextField(
  //                     controller: _emailController,
  //                     decoration: InputDecoration(
  //                       hintText: "Email",
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       contentPadding:
  //                           EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //                     ),
  //                   ),
  //                   SizedBox(height: 16),
  //                   TextField(
  //                     controller: _passwordController,
  //                     obscureText: _obscurePassword,
  //                     decoration: InputDecoration(
  //                       hintText: "Password",
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       suffixIcon: IconButton(
  //                         icon: Icon(_obscurePassword
  //                             ? Icons.visibility_off
  //                             : Icons.visibility),
  //                         onPressed: () {
  //                           setState(() {
  //                             _obscurePassword = !_obscurePassword;
  //                           });
  //                         },
  //                       ),
  //                       contentPadding:
  //                           EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //                     ),
  //                   ),
  //                   SizedBox(height: 10),
  //                   Row(
  //                     children: [
  //                       Checkbox(
  //                         value: _rememberMe,
  //                         onChanged: (value) {
  //                           setState(() => _rememberMe = value!);
  //                         },
  //                       ),
  //                       Text("Remember me"),
  //                       Spacer(),
  //                       TextButton(
  //                         onPressed: () {},
  //                         child: Text(
  //                           "Forgot Password ?",
  //                           style: TextStyle(color: Color(0xFF1666F0)),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 10),
  //                   ElevatedButton(
  //                     onPressed: signInWithEmail,
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Color(0xFF1666F0),
  //                       minimumSize: Size(double.infinity, 50),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                     child: Text("Log In", style: TextStyle(fontSize: 16)),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text("Don’t have an account? "),
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (_) => SignUpPage()),
  //                   );
  //                 },
  //                 child: Text(
  //                   "Sign Up",
  //                   style: TextStyle(
  //                     color: Color(0xFF1666F0),
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           if (isLoading) SizedBox(height: 20),
  //           if (isLoading) CircularProgressIndicator(),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  //
  //
  //  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         // Latar belakang biru setengah atas
  //         Container(
  //           height: MediaQuery.of(context).size.height * 0.45,
  //           width: double.infinity,
  //           decoration: BoxDecoration(
  //             color: Color(0xFF1666F0),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(Icons.security, size: 60, color: Colors.white),
  //               SizedBox(height: 10),
  //               Text(
  //                 "Sign in to your\nAccount",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               SizedBox(height: 8),
  //               Text(
  //                 "Enter your email and password to log in",
  //                 style: TextStyle(color: Colors.white70, fontSize: 14),
  //               ),
  //             ],
  //           ),
  //         ),

  //         // Form Login melayang
  //         Positioned(
  //           top: MediaQuery.of(context).size.height * 0.35,
  //           left: 20,
  //           right: 20,
  //           child: Material(
  //             elevation: 4,
  //             borderRadius: BorderRadius.circular(20),
  //             child: Container(
  //               padding: EdgeInsets.all(24),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   ElevatedButton.icon(
  //                     onPressed: signInWithGoogle,
  //                     icon: Image.asset(
  //                       'images/icon_google_fix.png', // atau gunakan Icon(Icons.g_mobiledata)
  //                       height: 24,
  //                     ),
  //                     label: Text(
  //                       "Continue with Google",
  //                       style: TextStyle(color: Colors.black),
  //                     ),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.white,
  //                       minimumSize: Size(double.infinity, 50),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                         side: BorderSide(color: Colors.grey.shade300),
  //                       ),
  //                       elevation: 2,
  //                     ),
  //                   ),
  //                   SizedBox(height: 16),
  //                   Text("Or", style: TextStyle(color: Colors.grey)),
  //                   SizedBox(height: 16),
  //                   TextField(
  //                     controller: _emailController,
  //                     decoration: InputDecoration(
  //                       hintText: "Email",
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 12),
  //                   TextField(
  //                     controller: _passwordController,
  //                     obscureText: _obscurePassword,
  //                     decoration: InputDecoration(
  //                       hintText: "Password",
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       suffixIcon: IconButton(
  //                         icon: Icon(_obscurePassword
  //                             ? Icons.visibility_off
  //                             : Icons.visibility),
  //                         onPressed: () {
  //                           setState(
  //                               () => _obscurePassword = !_obscurePassword);
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 10),
  //                   Row(
  //                     children: [
  //                       Checkbox(
  //                         value: _rememberMe,
  //                         onChanged: (value) {
  //                           setState(() => _rememberMe = value!);
  //                         },
  //                       ),
  //                       Text("Remember me"),
  //                       Spacer(),
  //                       TextButton(
  //                         onPressed: () {},
  //                         child: Text(
  //                           "Forgot Password ?",
  //                           style: TextStyle(color: Color(0xFF1666F0)),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 10),
  //                   ElevatedButton(
  //                     onPressed: signInWithEmail,
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Color(0xFF1666F0),
  //                       minimumSize: Size(double.infinity, 50),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                     child: Text("Log In", style: TextStyle(fontSize: 16)),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),

  //         // Bagian bawah untuk SignUp
  //         Positioned(
  //           bottom: 20,
  //           left: 0,
  //           right: 0,
  //           child: Center(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text("Don’t have an account? "),
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (_) => SignUpPage()),
  //                     );
  //                   },
  //                   child: Text(
  //                     "Sign Up",
  //                     style: TextStyle(
  //                       color: Color(0xFF1666F0),
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
//
//
//

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              // Latar belakang biru atas
              Container(
                height: screenHeight * 0.45,
                width: double.infinity,
                color: Color.fromARGB(255, 106, 170, 69),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.security, size: 60, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      "Sign in to your\nAccount",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Enter your email and password to log in",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Form login
              Positioned(
                top: screenHeight * 0.35,
                left: 20,
                right: 20,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton.icon(
                          onPressed: signInWithGoogle,
                          icon: Image.asset(
                            'images/icon_google_fix.png',
                            height: 24,
                          ),
                          label: Text(
                            "Continue with Google",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            elevation: 2,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("Or", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(
                                    () => _obscurePassword = !_obscurePassword);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() => _rememberMe = value!);
                              },
                            ),
                            Text("Remember me"),
                            Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forgot Password ?",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 106, 170, 69)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: signInWithEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 106, 170, 69),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Log In",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don’t have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SignUpPage()),
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 106, 170, 69),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
