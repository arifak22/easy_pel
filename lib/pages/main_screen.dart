
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/pages/main/home_screen.dart';
import 'package:easy_pel/pages/main/presensi/add_screen.dart';
import 'package:easy_pel/pages/profile/view_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _children = [
    HomeScreen(),
    AddScreen(),
    ViewScreen(),
  ];
  int _currentIndex = 0;
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