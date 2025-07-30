// // views/home/home_screen.dart
// import 'package:flutter/material.dart';
// import '../settings/settings_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home"),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const SettingsScreen()),
//               );
//             },
//           )
//         ],
//       ),
//       body: const Center(
//         child: Text("Welcome to the News App!", style: TextStyle(fontSize: 20)),
//       ),
//     );
//   }
// }
