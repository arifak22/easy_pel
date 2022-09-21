
import 'dart:async';

import 'package:easy_pel/helpers/services.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/pages/main/presensi/add_screen.dart';
import 'package:easy_pel/models/menu.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/widgets.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> images = [];
  int countImages = 0;

  int laki      = 0;
  int perempuan = 0;
  int all       = 0;

  int _currentPage = 0;
  late Timer _timer;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  late String nama = '';

  Future<void> getData() async {
    if(!mounted) return;
    var pegawai_id = await Services().getSession('pegawai_id');
    var namaa      = await Services().getSession('name');
    namaa = namaa.toLowerCase();
    setState(() {
      nama = namaa.substring(0, 1).toUpperCase() + namaa.substring(1);
    });
    Services().getApi('getPegawai',"pegawai_id=${pegawai_id}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          laki        = val['laki'];
          perempuan   = val['perempuan'];
          all         = val['all'];
          images      = val['event'];
          countImages = val['event'].length;
        });
        _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
          if (_currentPage < val['event'].length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }

          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        });
        print( val['event']);
      }else{
        setState(() {
          laki      = 0;
          perempuan = 0;
          all       = 0;
        });
      }
    });
    // print("running $mounted");
  }

  @override
  void initState() {
    getData();
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    
    List<Menu> menuData = menuList.toList();
    return Scaffold(
      // appBar: appBar('Beranda'),
        body: Stack(
          children: [
            ListView(
              children: [
                //CONTAINER HEADER
                Container(
                  width : double.infinity,
                  height: MediaQuery.of(context).size.width / 16 * 9,
                  color: Colors.white,
                  margin: EdgeInsets.all(0),
                  child: 
                  images.length > 0 ?
                  PageView.builder(
                    controller: _pageController,
                    itemCount: countImages,
                    pageSnapping: true,
                    itemBuilder: (context,pagePosition){
                      return Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:NetworkImage(images[pagePosition]),
                            fit: BoxFit.cover
                          ),
                        )
                      );
                    }
                  ) :Center(child: CircularProgressIndicator(),) 
                ),
                //CONTAINER TOTAL PEGAWAI
                Container(
                  // height: 80,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: MyColor('default'),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                  ),
                  child: Text('Selamat datang ' + nama, style: TextStyle(fontWeight: FontWeight.bold),),
                  
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text('Total Pegawai', style: TextStyle(fontWeight: FontWeight.bold),),
                  //     Expanded(
                  //       flex: 1,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         // crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Expanded(
                  //             flex: 1,
                  //             child: Container(alignment: Alignment.center, child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               children: [
                  //                 Image.asset("lib/assets/icon/namja.png", height: 35),
                  //                 AnimatedFlipCounter(
                  //                   duration: Duration(milliseconds: 500),
                  //                   value: laki,
                  //                   prefix: "  ",
                  //                   textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  //                 )
                  //               ],
                  //               )
                  //             )
                  //           ),
                  //           Expanded(
                  //             flex: 1,
                  //             child: Container(alignment: Alignment.center, child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               children: [
                  //                 Image.asset("lib/assets/icon/yoja.png", height: 35),
                  //                 AnimatedFlipCounter(
                  //                   duration: Duration(milliseconds: 500),
                  //                   value: perempuan,
                  //                   prefix: "  ",
                  //                   textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  //                 )
                  //                 ],
                  //               )
                  //             )
                  //           ),
                  //           Expanded(
                  //             flex: 1,
                  //             child: Container(alignment: Alignment.center, child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               crossAxisAlignment: CrossAxisAlignment.center,
                  //               children: [
                  //                 Image.asset("lib/assets/icon/lavatory.png", height: 35),
                  //                 AnimatedFlipCounter(
                  //                   duration: Duration(milliseconds: 500),
                  //                   value: all,
                  //                   prefix: "  ",
                  //                   textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  //                 )
                  //                 ],
                  //               )
                  //             )
                  //           )
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  height: 170,
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: menuData.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120,
                          childAspectRatio  : 0.7,
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
                                      child: Image.asset(menu.imageAsset, height: 35),
                                  ),
                                ),
                                Text(menu.name, style: TextStyle(fontSize: 12, color: Colors.black),)
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ),
                
              ],
          ),
          Positioned(
            right: 2,
            bottom: 0,
            child:  Container(
              margin: EdgeInsets.only(bottom: 5, right: 20),
              child: Text('Versi ${appVersion()}')
            )
          )
        ]
      )
    );
  }
}