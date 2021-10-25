
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/pages/main/presensi/add_screen.dart';
import 'package:easy_pel/models/menu.dart';
import 'package:easy_pel/helpers/widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    
    List<Menu> menuData = menuList.toList();
    return Scaffold(
      appBar: appBar('Beranda'),
      body: Container(
        child: Column(

          children:  <Widget>[
            Expanded(
              flex: 1,
              child: Container()
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(20),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: menuData.length,

                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final menu = menuList[index];
                        return GridTile(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                InkWell(
                                  highlightColor: Colors.grey,
                                  onTap: () async{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => menu.screen),
                                    );
                                    
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 3),
                                    decoration: BoxDecoration(
                                      color: MyColor('default'),
                                      border: Border.all(
                                        color: MyColor('line'),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(menu.imageAsset, height: 50),
                                ),
                              ),
                              
                              Text(menu.name, style: TextStyle(fontWeight: FontWeight.bold, color: MyColor('font-bg')),)
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Text('')
            // ),
          ]
        ),
      )
    );
  }
}