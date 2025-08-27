import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/wd-logo.png',
                  width: 200,
                  height: 200,
                ),
                Text(
                  "Warung data pinjam barang",
                  style: TextStyle(
                      color: Color(
                        0xFF004A99,
                      ),
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          )),
          Align(
            child: Text(
              "Copyright@2025 Warung Data. All right reserved",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
