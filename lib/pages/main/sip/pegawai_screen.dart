

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/services.dart';

Widget listMenu(dynamic title, dynamic laki, dynamic perempuan, dynamic all){
  
  return Container(
    width  : double.infinity,
    // height: 300,
    margin : EdgeInsets.only(bottom: 20),
    // padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: HexColor('#FFFFFF'),
      border: Border.all(color: Colors.lightBlue, width: 1)
    ),
    child: Column(
      children: [
        Container(
          color: Colors.lightBlue,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Text(title, style: TextStyle(color: Colors.white, fontSize: 18),),
        ),
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child: Column(
            children: [

              Container(
                margin: EdgeInsets.only(bottom: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Image.asset("lib/assets/icon/lavatory.png", height: 35),
                      AnimatedFlipCounter(
                        duration: Duration(milliseconds: 500),
                        value:  all,
                        prefix: "  ",
                        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                      )
                    ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Image.asset("lib/assets/icon/namja.png", height: 35),
                            AnimatedFlipCounter(
                              duration: Duration(milliseconds: 500),
                              value: laki,
                              prefix: "  ",
                              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                            )
                          ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Image.asset("lib/assets/icon/yoja.png", height: 35),
                            AnimatedFlipCounter(
                              duration: Duration(milliseconds: 500),
                              value:  perempuan,
                              prefix: "  ",
                              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                            )
                          ],
                      ),
                    ),
                ],
              ),
            ]
          ),
        ),
      ],
    )
  );
}   

class PegawaiScreen extends StatefulWidget {
  @override
  State<PegawaiScreen> createState() => PegawaiScreenState();
}

class PegawaiScreenState extends State<PegawaiScreen> {
  bool _isLoading = true;
  List<dynamic> list = [];
  String grandtotal = '0';

  Future<void> getData() async {
    if(!mounted) return;
    _isLoading = true;

    var pegawai_id = await Services().getSession('pegawai_id');
    Services().getApi('getTenagaKerja',"pegawai_id=${pegawai_id}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          list       = val['list'];
          _isLoading = false;
        });
        print( val);
      }else{
        setState(() {
          list       = [];
          grandtotal = '0';
          _isLoading = false;
        });
        print( val);
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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar('Tenaga Kerja'),
      body: 
      Container(
        margin: EdgeInsets.all(20),
        child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Center (
                child:
                _isLoading ? CircularProgressIndicator() : RefreshIndicator(
                  onRefresh: () async{
                    getData();
                  },
                  child: ListView.builder(
                    itemCount: list.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context,i){
                      // return Text(list[i]['nama'].toString());
                      return listMenu(list[i]['nama'], list[i]['laki'], list[i]['perempuan'],  list[i]['all']);
                    }
                  )
                )
              )
            )
          ],
        ),
      )
    );
  }
}