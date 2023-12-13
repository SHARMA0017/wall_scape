import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/custom_route.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  static const id = "SplashPage";
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Duration splashTime = const Duration(seconds: 3);
    Timer(splashTime, () {
      Navigator.pushReplacement(context, customAnimation(const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "WALL ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.deepPurpleAccent,
                      fontSize: 35.sp),
                ),
                Text(
                  "SCAPE",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.white,
                      fontSize: 38.sp),
                ),
              ],
            ),
          
          ],
        ),
      ),
    );
  }
}
