

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/services.dart';

Widget listMenu(dynamic title, dynamic total){

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
              Text(total, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),), 
              Text('Jam Kerja Selamat', style: TextStyle(fontSize: 25),), 
            ]
          ),
        ),
      ],
    )
  );
}   

class SelamatScreen extends StatefulWidget {
  @override
  State<SelamatScreen> createState() => SelamatScreenState();
}

class SelamatScreenState extends State<SelamatScreen> {
  bool _isLoading = true;
  List<dynamic> list = [];
  String grandtotal = '0';
  Future<void> getData() async {
    if(!mounted) return;
    _isLoading = true;
    var pegawai_id = await Services().getSession('pegawai_id');
    Services().getApi('getJamSelamat',"pegawai_id=${pegawai_id}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          list       = val['list'];
          grandtotal = val['grand_total'];
          _isLoading = false;
        });
        print( val);
      }else{
        setState(() {
          list       = [];
          grandtotal = '0';
          _isLoading = false;
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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar('Jam Kerja Selamat'),
      body: 
      Container(
        margin: EdgeInsets.all(20),
        child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width  : double.infinity,
              margin : EdgeInsets.only(bottom: 20),
              // padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: HexColor('#FFFFFF'),
                border: Border.all(color: Colors.lightBlue, width: 1)
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: Colors.green,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),),
                  ),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text(grandtotal, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),), 
                        Text('Jam Kerja Selamat', style: TextStyle(fontSize: 25),), 
                      ]
                    ),
                  ),
                ],
              )
            ),
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
                      return listMenu(list[i]['nama'], list[i]['total']);
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