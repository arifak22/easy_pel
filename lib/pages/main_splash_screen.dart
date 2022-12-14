import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MainSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: '/login',
      photoSize: 100,
      image: Image.asset('lib/assets/images/logo.png'),
    );
  }
}