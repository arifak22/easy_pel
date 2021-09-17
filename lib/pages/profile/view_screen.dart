

import 'package:flutter/material.dart';
// import 'package:easy_pel/camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_pel/helpers/services.dart';
class ViewScreen extends StatefulWidget {
  @override
  State<ViewScreen> createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<dynamic>(
                future: Services().getSession('name')!,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data);
                  }
                  return CircularProgressIndicator();
                }
              ),
              InkWell(
                onTap: () async{
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.clear();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (Route route)=>false);
                },
                child: new Text("Logout", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }
}