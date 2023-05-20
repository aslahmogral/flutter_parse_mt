import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_parse/screens/employee_screen.dart';
import 'package:flutter_parse/screens/login_screen.dart';
import 'package:flutter_parse/utils/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? user;
  Future checkLoggedin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('logged');
    setState(() {
      user = user;
    });
  }

  @override
  void initState() {
    checkLoggedin().whenComplete(() async {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => user != null
                      ? const EmployeeScreen()
                      : const LoginScreen())));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: WColors.dimWhiteColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Lottie.asset(
          'animation/astro.json',
        ));
  }
}
