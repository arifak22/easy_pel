

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:easy_pel/pages/main/ketidakhadiran/approval_screen.dart';
import 'package:easy_pel/pages/main/ketidakhadiran/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ViewScreen extends StatefulWidget {
  @override
  State<ViewScreen> createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {
  int    _selectedMonth     = months.indexWhere((element) => element == DateFormat('MMMM', 'id_ID').format(DateTime.now()));
  int    _selectedYear      = years.indexWhere((element) => element == DateFormat('y').format(DateTime.now()));
  bool   _isLoading         = true;
  List   data               = [];
  String sisa_cuti          = '-';
  String sisa_cuti_setengah = '-';
  String user_group         = '0';
  ScrollController _scrollController = ScrollController();

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
              MaterialPageRoute(builder: (context) => DetailScreen(id: data['ABSENSI_IJIN_ID'], pegawai_id: data['PEGAWAI_ID'], jenis: '10',)),
            );
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
    var periode = years[_selectedYear] + value_months[_selectedMonth] ;
    // print(pegawai_id);
    // print(periode);
    // return;
    setState(() {
      _isLoading = true;
    });
    Services().getApi('getKetidakhadiran', "pegawai_id=${pegawai_id}&periode=${periode}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          data = val['data'];
          sisa_cuti = val['sisa_cuti'];
          sisa_cuti_setengah = val['sisa_cuti_setengah'];
          _isLoading =false;
        });
      }else{
        setState(() {
          data = [];
          _isLoading =false;
        });
      }
    });
    // print("running $mounted");
  }

  getUserGroup() async {
     String ug = await Services().getSession('user_group');
     print(ug);
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
    var periode = value_months[_selectedMonth] + years[_selectedYear];
    return new Scaffold(
      appBar: appBar('Ketidakhadiran'),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CupertinoButton(
                child: Text("Pilih Periode:"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200.0,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              // Text('Pilih'),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: CupertinoPicker(
                                          scrollController:
                                              new FixedExtentScrollController(
                                            initialItem: _selectedMonth,
                                          ),
                                          itemExtent: 32.0,
                                          backgroundColor: Colors.white,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              _selectedMonth = index;
                                            });
                                          },
                                          children: new List<Widget>.generate(
                                            months.length, (int index) {
                                          return new Center(
                                            child: new Text(months[index]),
                                          );
                                        })
                                      ),
                                    ),
                                    Expanded(
                                      child: CupertinoPicker(
                                          scrollController:
                                              new FixedExtentScrollController(
                                            initialItem: _selectedYear,
                                          ),
                                          itemExtent: 32.0,
                                          backgroundColor: Colors.white,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              _selectedYear = index;
                                            });
                                          },
                                        children: new List<Widget>.generate(
                                            years.length, (int index) {
                                          return new Center(
                                            child: new Text(years[index]),
                                          );
                                        })
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              
                            ],
                          )
                        );
                      }).whenComplete(() => 
                        {
                          // getData()
                        }
                      );
                  }),
              Text(
                '${months[_selectedMonth]} - ${years[_selectedYear]}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 15, bottom: 10, right: 10),
            child: Wrap(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5, bottom: 5),
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: HexColor('#FFFFFF'),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: MyColor('line'))
                  ),
                  child: Text('Sisa Cuti Tahunan: ' + sisa_cuti),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5, bottom: 5),
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: HexColor('#FFFFFF'),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: MyColor('line'))
                  ),
                  child: Text('Sisa Cuti Setengah Hari: ' + sisa_cuti_setengah),
                ),
              ]
            )
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: _isLoading ? CircularProgressIndicator() : RefreshIndicator(
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
          )
        ]
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.more_vert_outlined,
        backgroundColor: Colors.blue,
        children: [
          user_group == '9' || user_group == '10' ? 
          SpeedDialChild(
            child: Icon(MdiIcons.checkAll),
            label: 'Approval SDM',
            backgroundColor: Colors.lightBlue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApprovalScreen(status: user_group == '9' ? '1' : '2')),
              );
            },
          ) : SpeedDialChild(),
          SpeedDialChild(
            child: Icon(Icons.check),
            label: 'Approval Atasan',
            backgroundColor: Colors.lightBlue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApprovalScreen(status: '0')),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(MdiIcons.plus),
            label: 'Tambah',
            backgroundColor: Colors.lightBlue,
            onTap: () {/* Do something */},
          ),
        ]
      ),
    );
  }
}