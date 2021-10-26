

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/pages/main/check/selfcheck/view_screen.dart' as Selfcheck;
import 'package:easy_pel/pages/main/check/location/view_screen.dart' as Location;

class ViewScreen extends StatefulWidget {
  @override
  State<ViewScreen> createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar('Checking App'),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width  : double.infinity,
              margin : EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: HexColor('#FFFFFF'),
                border: Border(
                  left: BorderSide(color: Colors.blue, width: 4),

                ),
              ),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Selfcheck.ViewScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Image.asset('lib/assets/icon/selfcheck.png', height: 50),
                     Container(
                       margin: EdgeInsets.only(left: 20),
                       child: Text('SELFCHECK', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                     )
                  ],
                ),
              ),
            ),

            Container(
              width  : double.infinity,
              margin : EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: HexColor('#FFFFFF'),
                border: Border(
                  left: BorderSide(color: Colors.blue, width: 4),

                ),
              ),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Location.ViewScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Image.asset('lib/assets/icon/location.png', height: 50),
                     Container(
                       margin: EdgeInsets.only(left: 20),
                       child: Text('LOCATION', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                     )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}