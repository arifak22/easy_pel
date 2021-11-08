
import 'package:easy_pel/helpers/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/pages/main/home_screen.dart';
import 'package:easy_pel/pages/main/presensi/add_screen.dart';
import 'package:easy_pel/pages/profile/view_screen.dart';
import'dart:io' show Platform;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // It is assumed that all messages contain a data field with the key 'type'
  

  final List<Widget> _children = [
    HomeScreen(),
    AddScreen(),
    ViewScreen(),
  ];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    // Use either of them. 
    Future(_showDialog);
  }
  String getPlatform() {
    if (Platform.isIOS) {
      return 'iOS_version';
    } else if (Platform.isAndroid) {
      return 'android_version';
    } else if (Platform.isFuchsia) {
      return 'Fuchsia';
    } else if (Platform.isLinux) {
      return 'Linux';
    } else if (Platform.isMacOS) {
      return 'MacOS';
    } else if (Platform.isWindows) {
      return 'Windows';
    }
    return '-';
  }
  void _showDialog() {
    // flutter defined function
    String platform = getPlatform();
    String version  = appVersion();
    Services().getApi('version', 'version=${version}&platform=${platform}').then((val) {
      if (val['api_status'] == 1) {
        if(val['update']){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Update ke Versi ${val['version']}"),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: val['update_message'].length,
                    itemBuilder: (context, i){
                      return Text('- ' + val['update_message'][i]);
                    },
                  ),
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }else{
        showDialog(context: context, builder: (_) =>AlertDialog(
          title: Text('Something wrong'),
          content: Text('${val['api_message']}'),
          actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
        ));
        print('gagal');
      }
      print(val);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          setState(() {
            _currentIndex = 1;
          });
        },
        tooltip: 'Increment',
        child: new Icon(Icons.alarm_add),
        backgroundColor: MyColor('primary'),
        // focusColor: MyColor('default'),
        elevation: 4.0,
      ),
      bottomNavigationBar: Container(                                             
        decoration: BoxDecoration(                                                   
          borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),    
          color: Colors.white                                                                    
        ),
        // margin: EdgeInsets.only(top: 20),
        child: ClipRRect(                                                            
          borderRadius: BorderRadius.only(                                           
            topLeft: Radius.circular(30.0),                                            
            topRight: Radius.circular(30.0),                                           
          ),
          child: BottomNavigationBar(             
            currentIndex: _currentIndex,
            onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                }
              );
            },
            type: BottomNavigationBarType.fixed,                                   
            items: <BottomNavigationBarItem>[                                        
              BottomNavigationBarItem(                                               
                icon: Icon(_currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined), title: Text('Beranda')
              ),
              BottomNavigationBarItem(                                               
                icon: Icon(_currentIndex == 1 ? Icons.favorite_rounded : Icons.favorite_border_outlined), title: Text('Presensi')
              ),
              BottomNavigationBarItem(                                               
                icon: Icon(_currentIndex == 2 ? Icons.account_circle_rounded : Icons.account_circle_outlined), title: Text('Profil')
              ),
            ],
            // showSelectedLabels: false,
            // showUnselectedLabels: false,    
            backgroundColor: Colors.white,  
            selectedItemColor: MyColor('primary'),                                                   
          ),
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
    );
  }
}