
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';
import 'package:device_info/device_info.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
  late SharedPreferences preferences;
  late ProgressDialog pr;
  String _platformVersion = 'Unknown';
  String _device = 'Unknown';
  String force = '0';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void checkIsLoggedIn()async{
    preferences = await SharedPreferences.getInstance();
    if (preferences.getString('token') != null) {
      Navigator.pushNamedAndRemoveUntil(context, '/splash-login', (Route route)=>false);
    }
  }

  void submitLogin() async{
    if (_formKey.currentState!.validate()) {
      pr.show();
      print('executeed');
      String? token = await FirebaseMessaging.instance.getToken();
      Services().postLogin(usernameController.text, passwordController.text, _platformVersion, token, force).then((val) async {
        pr.hide();
        if (val['api_status'] == 1) {
          // userProvider.add(val['nama'], val['nama_privilege']);
          // Provider.of<InitProvider>(context).getTheData();
          Navigator.pushNamedAndRemoveUntil(context, '/splash-login', (Route route)=>false);
          // preferences = await SharedPreferences.getInstance();
          // var position = json.decode(preferences.getString('position'));
          // for(var pos in position){
          //   print(pos['LATITUDE']);
          // }
        }else if(val['api_status'] == 8){
          showDialog(context: context, builder: (_) =>AlertDialog(
            title: Text('Warning'),
            content: Text('${val['api_message']}'),
            actions: <Widget>[
                OutlinedButton(
                  onPressed: ()=>Navigator.pop(context), child: Text('Tidak')
                ),
                ElevatedButton(
                  onPressed: ()=> {
                    force = '1',
                    Navigator.pop(context),
                    submitLogin()
                  }, child: Text('Ya'),
                ),
              ],
          ));
          print('gagal');
        
        }else{
          print(val['api_status']);
          showDialog(context: context, builder: (_) =>AlertDialog(
            title: Text('Something wrong'),
            content: Text('${val['api_message']}'),
            actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
          ));
          print('gagal');
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIsLoggedIn();
    // initPlatformState();
    _getId();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     platformVersion = await GetMac.macAddress;
  //   } on PlatformException {
  //     platformVersion = 'Failed to get Device MAC Address.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }
  Future<void> _getId() async {
    var deviceID;
    var device;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor; // unique ID on iOS
      device = iosDeviceInfo.name; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.androidId; // unique ID on Android
      device= 'Android ' + androidDeviceInfo.brand; // unique ID on Android
    }
    // if (!mounted) return;
    print('runnning');
    setState(() {
      _platformVersion = deviceID;
      _device = device;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color background = MyColor('default');
    final Color fill = MyColor('bg');
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    final double fillPercent = 45.00; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
      message: 'Menunggu...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return Scaffold(
      body: Container(
        // margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            stops: stops,
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
          ),
        ),
        child:  Column(
          children:  <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('lib/assets/images/logo.png', height: 150)
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: MyColor('default'),
                    border: Border.all(
                      color: MyColor('line'),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    
                      children: <Widget>[
                        Text('Halaman Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        Container(
                          margin: const EdgeInsets.only(top: 35, bottom: 15),
                          child:
                            TextFormField(
                            // obscureText: true, 
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.00))),
                              prefixIcon: Icon(MdiIcons.account),
                              labelText: 'Username',
                            ),
                            controller: usernameController,
                            validator: (val){
                              if (val!.isEmpty) {
                                return 'Username is empty';
                              }
                              return null;
                            },
                            onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 15),
                          child: TextFormField(
                            controller: passwordController,
                            validator: (val){
                              if (val!.isEmpty) {
                                return 'Password is empty';
                              }
                                return null;
                            },
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.00))),
                              prefixIcon: Icon(MdiIcons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(showPassword ? MdiIcons.eye : MdiIcons.eyeOff),
                                onPressed: () async{
                                  this.setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              ),
                              // Icon(MdiIcons.eye),
                              labelText: 'Password',
                            ),
                            onFieldSubmitted: (_) => {
                              FocusScope.of(context).unfocus()
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            // style: raisedButtonStyle,
                            style: ElevatedButton.styleFrom(
                              primary: MyColor('primary'),
                              padding: EdgeInsets.only(top: 15, bottom: 15, left: 30, right: 30)
                            ),
                            onPressed: () { 
                              submitLogin();
                            },
                            child: Text('Sign In'),
                          ),
                        )
                      ]
                    )
                  ),
                ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(bottom: 25),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('Easy PEL - Versi 1.0.1', 
                        style: TextStyle(fontSize: 16)
                      ),
                      Text('Device - ' + _device, 
                        style: TextStyle(fontSize: 16)
                      ),
                    ]
                    ),
                  )
                ),
              ),
          ],
        ),
      ),
    );
  }
}
