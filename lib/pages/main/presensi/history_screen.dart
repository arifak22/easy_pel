import 'dart:convert';

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = false;
  List data = [];
  Future<void> getData() async {
    var temp = await Services().getSession('temp');
    // print(json.decode(temp));
    setState(() {
      data = json.decode(temp);
    });
  }
  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget listPresensi(dynamic data, int i){
    MaterialColor _color = Colors.blue;
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");
    return Container(
      width  : double.infinity,
      margin : EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HexColor('#FFFFFF'),
        // borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border(
          left: BorderSide(color: _color, width: 4),

        ),
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text(DateFormat('d MMMM y', 'id_ID').format(format.parse(data['waktu'])), 
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child:  Text(DateFormat('hh:mm:ss', 'id_ID').format(format.parse(data['waktu'])))
                  )
                ],
              )
            )
          ),
          Expanded(
            flex: 1,

            child: Container(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                icon: Text('Kirim'),
                label: Icon(MdiIcons.send, size: 16),
                onPressed: () => {
                  showDialog(context: context, builder: (_) =>AlertDialog(
                    title: Text('Info'),
                    content: Text('Apakah anda yakin?'),
                    actions: <Widget>[
                        OutlinedButton(
                          onPressed: ()=>Navigator.pop(context), child: Text('Tidak')
                        ),
                        ElevatedButton(
                          onPressed: ()=> {
                            Navigator.pop(context),
                            submitKirim(data, i)
                          }, child: Text('Ya'),
                        ),
                      ],
                  ))
                },
              ),
            )
            
          ),
        ],
      )
    );
  }  
  Future<void> refreshData(i) async {
    var temp = await Services().getSession('temp');
    var tempResult = json.decode(temp);
    tempResult.removeAt(i);   
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('temp', json.encode(tempResult));
    // print(tempResult);
  }
  void submitKirim(data, i){
    print(data);

    setState(() {
      _isLoading = true;
    });
    Services().postApi('postTempPresensi', data).then((val) async {
      if (val['api_status'] == 1) {
        refreshData(i);
        setState(() {
          _isLoading = false;
        });
        showDialog(context: context, builder: (_) =>AlertDialog(
          title: Text('Berhasil'),
          content: Text('${val['api_message']}'),
          actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
        )).then((value) => {
          getData()
        });
      }else{
        print(val);
        setState(() {
          _isLoading = false;
        });
        showDialog(context: context, builder: (_) =>AlertDialog(
          title: Text('Something wrong'),
          content: Text(val['api_message']),
          actions: <Widget>[ElevatedButton(onPressed: ()=>{Navigator.pop(context)}, child: Text('Ok'))],
        ));
      }
    });
  }

  Future<void> hapusRiwayat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('temp', json.encode([]));
    setState(() {
      _isLoading = true;
    });
    showDialog(context: context, builder: (_) =>AlertDialog(
      title: Text('Berhasil'),
      content: Text('Riwayat berhasil di hapus'),
      actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
    )).then((value) => {
      getData(),

      setState(() {
        _isLoading = false;
      })
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Riwayat Gagal Presensi'),
      body: Container(
        // margin: EdgeInsets.only(right: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10, right: 20, bottom: 10),
              child: OutlinedButton.icon(
                onPressed: ()=>{
                  showDialog(context: context, builder: (_) =>AlertDialog(
                    title: Text('Info'),
                    content: Text('Apakah anda yakin, menghapus semua riwayat?'),
                    actions: <Widget>[
                        OutlinedButton(
                          onPressed: ()=>Navigator.pop(context), child: Text('Tidak')
                        ),
                        ElevatedButton(
                          onPressed: ()=> {
                            Navigator.pop(context),
                            hapusRiwayat()
                          }, child: Text('Ya'),
                        ),
                      ],
                  ))
                },
                label: Text('Hapus Semua'),
                icon: Icon(MdiIcons.trashCan, size: 16),
                style: OutlinedButton.styleFrom(
                  primary: Colors.red,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: _isLoading ? CircularProgressIndicator() : ListView.builder(
                  itemCount: data.length,
                  // controller: _scrollController,
                  itemBuilder: (context, i){
                    // print(data[i]);
                    return listPresensi(data[i], i);
                  },
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}