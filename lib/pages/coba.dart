import 'package:flutter/material.dart'; // Firebase
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Coba extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  void _logout(BuildContext context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    // Setelah logout, arahkan kembali ke halaman login
    Navigator.of(context).pushReplacementNamed('/');
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profil Saya'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () => _logout(context),
//           ),
//         ],
//       ),
//       body: Center(
//         child: user == null
//             ? Text("Tidak ada pengguna yang login.")
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (user!.photoURL != null)
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundImage: NetworkImage(user!.photoURL!),
//                     ),
//                   SizedBox(height: 10),
//                   Text(
//                     user!.displayName ?? 'Nama tidak tersedia',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   Text(
//                     user!.email ?? 'Email tidak tersedia',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Saya'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20, // valueSetY
            left: 105, // valueSetX
            child: user == null
                ? Text("Tidak ada pengguna yang login.")
                : Column(
                    children: [
                      if (user!.photoURL != null)
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user!.photoURL!),
                        ),
                      SizedBox(height: 10),
                      Text(
                        user!.displayName ?? 'Nama tidak tersedia',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        user!.email ?? 'Email tidak tersedia',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
