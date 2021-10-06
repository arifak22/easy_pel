import 'dart:io';

import 'package:easy_pel/helpers/services.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/pages/main_splash_screen.dart';
import 'package:easy_pel/pages/login_screen.dart';
import 'package:easy_pel/pages/login_splash_screen.dart';
import 'package:easy_pel/pages/main_screen.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
// import 'package:camera/camera.dart';

// List<CameraDescription>? cameras;


Future<void> main() async{
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  // cameras = await availableCameras();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
    
  }

  Future<void> _determinePosition() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title                     : 'Easy PEL',
      // debugShowMaterialGrid     : isDebug(),
      debugShowCheckedModeBanner: isDebug(),
      theme                     : ThemeData(
        scaffoldBackgroundColor: MyColor('bg'),
        buttonColor            : MyColor('primary'),
        primaryColor           : MyColor('default'),
      ),
      routes: <String, WidgetBuilder>{
         '/'            : (context) => MainSplashScreen(),
         '/login'       : (context) => LoginScreen(),
         '/splash-login': (context) => LoginSplashScreen(),
         '/main'        : (context) => MainScreen(),
      },
    );
  }
}
