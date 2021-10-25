import 'package:easy_pel/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class LoginSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SplashScreen(
      seconds: 1,
      navigateAfterSeconds: new MainScreen(),
      photoSize: 100,
      image: Image.asset('lib/assets/images/logo.png'),
    );
  }
}