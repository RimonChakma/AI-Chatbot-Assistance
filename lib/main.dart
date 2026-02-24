//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'home_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "AI Chat Assistant",
//       theme: ThemeData(
//         primaryColor: Colors.blue,
//         scaffoldBackgroundColor: const Color(0xFF0A0A0A),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           systemOverlayStyle: SystemUiOverlayStyle.light,
//         ),
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }


// getx version:

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'getx_vertion/bindings/home_binding.dart';
import 'getx_vertion/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: HomeBinding(),
      home: const HomeScreens(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
    );
  }
}