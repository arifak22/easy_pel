import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class LoginSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: '/main',
      photoSize: 100,
      image: Image.asset('lib/assets/images/logo.png'),
    );
  }
}