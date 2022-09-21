import 'dart:async';
import 'dart:io';

import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/pages/main/presensi/detail_screen.dart';
import 'package:easy_pel/pages/main/sip/imgview_screen.dart';
import 'package:easy_pel/pdf/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:easy_pel/pages/main/sip/dokview_screen.dart';


Widget listDokumen(dynamic data, dynamic context, Future<void> refresh()){
  Future<File> createFileOfPdfUrl(url) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    // pr.show();
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      // pr.hide();
      throw Exception('Error parsing asset file!');
    }
    // pr.hide();
    return completer.future;
  }
  
  MaterialColor _color = Colors.green;

  if(int.parse(data['TOTAL_VIEW_USER']) > 0){
    _color = Colors.green;
  }else if(data['COLOR'] == 'danger'){
    _color = Colors.red;
  }else if(int.parse(data['TOTAL_VIEW_USER']) == 0){
    _color = Colors.yellow;
  }
  return InkWell(
    onTap: ()async {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => 
        DokviewScreen(data: data)
        // ImgviewScreen(path: file.path, data: data)
        )
      ).then((value) => refresh());
    },
    child: Container(
      width  : double.infinity,
      margin : EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HexColor('#FFFFFF'),
        // borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border(
          left: BorderSide(color: _color, width: 4),
  
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data['NAMA'], 
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child:  Text(data['TANGGAL'])
                  )
                ],
              )
            )
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Column(children: [
                Text(data['TOTAL_VIEW'],textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.remove_red_eye_outlined),
              ])
            )
          ),
        ],
      )
    ),
  );
}                

class DokumenScreen extends StatefulWidget {
  dynamic tipe;

  DokumenScreen({required this.tipe});
  @override
  _DokumenScreenState createState() => _DokumenScreenState(tipe);
}

class _DokumenScreenState extends State<DokumenScreen> {

  _DokumenScreenState(dynamic tipe);

  bool _isLoading = true;
  List data = [];
  ScrollController _scrollController = ScrollController();
  double potongan = 0;

  TextEditingController valueJenis        = TextEditingController(text: '-');
  List optionJenisIjin = [{'value': '-', 'name': '- Semua -'}, {'value': '1', 'name': 'Sudah Dilihat'}, {'value': '0', 'name': 'Belum Dilihat'}];
  late ProgressDialog pr;
  
  Future<void> getData() async {
    if(!mounted) return;
    var pegawaiId = await Services().getSession('pegawai_id');
    // print(pegawai_id);
    // print(periode);
    // return;
    setState(() {
      _isLoading = true;
    });
    Services().getApi('getDokumen', "pegawai_id=${pegawaiId}&tipe=${widget.tipe}&status=${valueJenis.text}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          data = val['list'];
          _isLoading =false;
        });
        print(data);
      }else{
        setState(() {
          data = [];
          _isLoading =false;
        });
      }
    });
    print("running $mounted");
  }

  @override
  void initState() {
    getData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.minScrollExtent ==
          _scrollController.position.pixels) {
        getData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var title = 'Dokumen';
    if(widget.tipe == '1'){
      title = 'Safety Campaign';
    }else if(widget.tipe == '2'){
      title = 'Penghargaan & Sertifikasi';
    }else if(widget.tipe == '3'){
      title = 'Emergency Respone Plan';
    }else if(widget.tipe == '4'){
      title = 'Event';
    }

    return Scaffold(
      appBar: appBar(title),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child : Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: FormSelect(
                label          : 'Status',
                option         : optionJenisIjin,
                valueController: valueJenis,
                refreshData: (){
                  setState(() {
                    valueJenis.text = valueJenis.text;
                  });
                  getData();
                  print(valueJenis.text);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child:Center(
                  child: _isLoading ? CircularProgressIndicator() : RefreshIndicator(
                    onRefresh: () async{
                      getData();
                    },
                    child: ListView.builder(
                      itemCount: data.length,
                      // controller: _scrollController,
                        itemBuilder: (context, i){
                          // print(data[i]);
                          return listDokumen(data[i], context, getData);
                        },
                    ),
                  ),
              )
            )
          ]
        ),
      )
    );
  }
}