import 'package:db_miner/views/dateil.dart';
import 'package:db_miner/views/fev_screen.dart';
import 'package:db_miner/views/homepage.dart';
import 'package:db_miner/views/splesh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/',
          page: () => Homepage(),
        ),
        GetPage(
          name: '/splash',
          page: () => Splash(),
        ),GetPage(
          name: '/favorite',
          page: () => FavoritesScreen(),
        ),
      ],
    );
  }
}
