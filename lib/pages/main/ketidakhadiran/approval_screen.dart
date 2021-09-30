

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:easy_pel/pages/main/ketidakhadiran/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ApprovalScreen extends StatefulWidget {
  final String status;
  ApprovalScreen({required this.status});
  @override
  State<ApprovalScreen> createState() => ApprovalScreenState(status);
}

class ApprovalScreenState extends State<ApprovalScreen> {
  ApprovalScreenState(String status);
  bool   _isLoading         = true;
  List   data               = [];
  ScrollController _scrollController = ScrollController();
  String user_group = '0';

  Widget listKetidakhadiran(dynamic data){

    return Container(
      width  : double.infinity,
      margin : EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HexColor('#FFFFFF'),
        // borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border(
          left: BorderSide(color: HexColor(data['VALIDATE_COLOR2']), width: 4),

        ),
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
      ),
      child: InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailScreen(id: data['ABSENSI_IJIN_ID'], pegawai_id: data['PEGAWAI_ID'],jenis: widget.status)),
            ).then((value) => {
              getData()
            });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(data['NAMA']),
                      Text(data['JENIS_IJIN']),
                      Text(''),
                      Text('Permohonan: \n' + data['TANGGAL_PERMOHONAN_INDO']),
                    ],
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(data['VALIDATE_MSG2'], 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15, 
                          color: HexColor(data['VALIDATE_COLOR2']), 
                          backgroundColor: MyColor('bg')
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
            Text('Waktu : \n' + data['TANGGAL_AWAL_INDO'] + ' s/d ' + data['TANGGAL_AKHIR_INDO'])
          ],
        ),
      )
    );
  }  
  Future<void> getData() async {
    if(!mounted) return;
    var pegawai_id = await Services().getSession('pegawai_id');
    // print(pegawai_id);
    // print(periode);
    // return;
    setState(() {
      _isLoading = true;
    });
    Services().getApi('getApprovalAtasan', "pegawai_id=${pegawai_id}&status=${widget.status}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          data = val['data'];
          _isLoading =false;
        });
      }else{
        setState(() {
          data = [];
          _isLoading =false;
        });
      }
        print(val);

    });
    // print("running $mounted");
  }

  getUserGroup() async {
     String ug = await Services().getSession('user_group');
     setState(() {
       user_group = ug;
     });
  }

  @override
  void initState() {
    getData();
    getUserGroup();
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
    return new Scaffold(
      appBar: appBar('Approval Ketidakhadiran'),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: _isLoading ? CircularProgressIndicator() : Container(
                margin: EdgeInsets.only(top: 20, bottom:20),
                child: RefreshIndicator(
                  onRefresh: () async{
                    getData();
                  },
                  child: ListView.builder(
                    itemCount: data.length,
                    // controller: _scrollController,
                      itemBuilder: (context, i){
                        // print(data[i]);
                        return listKetidakhadiran(data[i]);
                      },
                  ),
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}