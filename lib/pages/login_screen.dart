import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
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
              child: Expanded(
                flex: 2,
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
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    
                      children: <Widget>[
                        Text('Halaman Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        Container(
                          margin: const EdgeInsets.only(top: 35, bottom: 15),
                          child:
                            TextField(
                            // obscureText: true, 
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15.00))),
                              prefixIcon: Icon(MdiIcons.account),
                              labelText: 'Username',
                            ),
                            onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 15),
                          child:
                            TextField(
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
                            onSubmitted: (_) => FocusScope.of(context).unfocus(),
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

                            },
                            child: Text('Sign In'),
                          ),
                        )
                      ]
                    )
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Easy PEL - Versi 1.0.0', 
                    style: TextStyle(fontSize: 16)
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
