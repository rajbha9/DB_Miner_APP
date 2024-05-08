import 'dart:async';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      // Get.offAllNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Lottie.asset('asset/json/logo.json'),
              Positioned(
                bottom: 0,
                right: 40,
                top: 275,
                child: AnimatedContainer(
                  duration: Duration(seconds: 3),
                  height: 200,
                  width: 350,
                  child: Image.asset(
                    'asset/img/quote-logo-png.png',
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
