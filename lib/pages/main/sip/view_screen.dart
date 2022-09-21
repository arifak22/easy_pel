

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:easy_pel/pages/main/sip/subcriber_chart.dart';
import 'package:easy_pel/pages/main/sip/subscriber_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/pages/main/check/location/view_screen.dart' as Location;
import 'package:easy_pel/pages/main/sip/selamat_screen.dart';
import 'package:easy_pel/pages/main/sip/pegawai_screen.dart';
import 'package:easy_pel/pages/main/sip/dokumen_screen.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Widget listMenu(dynamic title, dynamic icon, dynamic context, dynamic url){

  return Container(
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
          MaterialPageRoute(builder: (context) => url),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Image.asset(icon, height: 50),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            )
        ],
      ),
    ),
  );
}   

class ViewScreen extends StatefulWidget {
  @override
  State<ViewScreen> createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {

  late List<SubscriberSeries> data = [];
  late List<SubscriberSeries> kecelakaan = [];
  late List<SubscriberSeries> kecelakaan_bln = [];

  Future<void> getData() async {
    if(!mounted) return;
    var list = data;
    var list2 = kecelakaan;
    var list3 = kecelakaan_bln;
    var pegawai_id = await Services().getSession('pegawai_id');
    Services().getApi('getDashboard',"pegawai_id=${pegawai_id}").then((val) {
      if (val['api_status'] == 1) {
        val['performa'].forEach((element){
          print(element['TOTAL']);
          list.add(SubscriberSeries(
            year: element['TAHUN'],
            // subscribers: element['TOTAL'].toDouble(),
            // subscribers: int.parse(element['TOTAL']),
            subscribers: element['TOTAL'].toInt(),
            barColor: charts.ColorUtil.fromDartColor(Colors.blue),
          ));
        });
        val['kecelakaan'].forEach((element){
          list2.add(SubscriberSeries(
            year: element['TAHUN'],
            subscribers: int.parse(element['JML']),
            // subscribers: element['JML'].toInt(),
            barColor: charts.ColorUtil.fromDartColor(Colors.blue),
          ));
        });

        val['kecelakaan_bln'].forEach((element){
          list3.add(SubscriberSeries(
            year: element['BLN'],
            // subscribers: element['JML'].toInt(),
            subscribers: int.parse(element['JML']),
            barColor: charts.ColorUtil.fromDartColor(Colors.blue),
          ));
        });
        print(val['kecelakaan_bln']);

        setState(() {
          data           = list;
          kecelakaan     = list2;
          kecelakaan_bln = list3;
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
      appBar: AppBar(
        // centerTitle: true,
        title          : Text('Safety Information & Performance', style: TextStyle(color: Colors.black, fontSize: 15)),
        elevation      : 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: HexColor('#FFFFFF'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: 
        Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: 
                PageView(
                  children: [
                    SubscriberChart(
                      title: "Performa Pencapaian Jam Kerja Tanpa Kecelakaan",
                      data: data,
                    ),
                    SubscriberChart(
                      title: "STATISTIK ANGKA KECELAKAAN KERJA - Tahun 2014 s/d " + DateTime.now().year.toString(),
                      data: kecelakaan,
                    ),
                    SubscriberChart(
                      title: "STATISTIK ANGKA KECELAKAAN KERJA - Tahun " + DateTime.now().year.toString(),
                      data: kecelakaan_bln,
                    ),
                  ],
                )
                
              )
            ),
            Expanded(
              flex: 2,
              child: ListView(
                children: [
                  listMenu('Jam Kerja Selamat', 'lib/assets/icon/time.png', context, SelamatScreen()),
                  listMenu('Tenaga Kerja', 'lib/assets/icon/workers.png', context, PegawaiScreen()),
                  listMenu('Safety Campaign', 'lib/assets/icon/marketing.png', context, DokumenScreen(tipe: '1')),
                  listMenu('Penghargaan & Sertifikasi', 'lib/assets/icon/rewards.png', context, DokumenScreen(tipe: '2')),
                  listMenu('Emergency Respone Plan', 'lib/assets/icon/siren.png', context, DokumenScreen(tipe: '3')),
                  listMenu('Event', 'lib/assets/icon/calendar.png', context, DokumenScreen(tipe: '4')),
                ],
              ),
            )
          ],
        )
      )
    );
  }
}