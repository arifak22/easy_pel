

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/pages/main/presensi/list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:easy_pel/camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_pel/helpers/widget.dart';

class ViewScreen extends StatefulWidget {
  @override
  State<ViewScreen> createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {

  int     _selectedMonth   = months.indexWhere((element) => element == DateFormat('MMMM', 'id_ID').format(DateTime.now()));
  int     _selectedYear    = years.indexWhere((element) => element == DateFormat('y').format(DateTime.now()));
  bool    isOpenPenerimaan = false;
  bool    isOpenWajib      = false;
  bool    isOpenLain       = false;
  bool    _isLoading       = true;
  dynamic data             = null;
  double  total_akhir      = 0;
  bool    _dontshow        = false;

  Widget listPresensi(String type, dynamic data){
    if(data == null || _isLoading == true)
    return Container(
      width  : double.infinity,
      margin : EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: HexColor('#FFFFFF'),
        border: Border(
          left: BorderSide(color: Colors.grey, width: 4),
        ),
      ),
      child: Text('Loading....')
    );

    String title = 'A. Penerimaan';
    MaterialColor _color = Colors.blue;
    bool isOpen = isOpenPenerimaan;
    List listDetail = [];
    if(type == 'penerimaan'){
      title = 'A. Penerimaan';
      _color = Colors.blue;
      isOpen = isOpenPenerimaan;
    }else if(type == 'potongan_wajib'){
      title = 'B. Potongan Wajib';
      _color = Colors.yellow;
      isOpen = isOpenWajib;
    }else{
      title = 'C. Potongan Lain-lain';
      _color = Colors.yellow;
      isOpen = isOpenLain;
    }
    for(String key in data[type].keys){
      listDetail.add({
        'name' : key,
        'value' : data[type][key]
      });
    }
    if(type =='penerimaan'){
      listDetail.add({
        'name' : 'Bantuan Transport \n(' + data['penerimaan_transport']['hari_kerja'] + ' Hari Kerja)',
        'value' : data['penerimaan_transport']['bantuan_transport']
      });
    }
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");
    return Container(
      width  : double.infinity,
      margin : EdgeInsets.only(bottom: 20, left: 20, right: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: HexColor('#FFFFFF'),
        border: Border(
          left: BorderSide(color: _color, width: 4),

        ),
      ),
      child: InkWell(
      onTap: (){
        setState(() {
          if(type == 'penerimaan'){
            isOpenPenerimaan = !isOpenPenerimaan;
          }else if(type == 'potongan_wajib'){
            isOpenWajib = !isOpenWajib;
          }else{
            isOpenLain = !isOpenLain;
          }
          isOpen = !isOpen;
        });
      },
      splashColor: Colors.red,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Text(title, 
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                        ),
                        !isOpen ? 
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child:  Text( toNumberRupiah(data['total'][type]))
                        ) : Container(child: null,)
                      ],
                    )
                  )
                ),
                Expanded(
                  flex: 1,

                  child: Container(
                    alignment: Alignment.center,
                    child: IconButton(
                          icon: Icon(isOpen ? MdiIcons.chevronUp : MdiIcons.chevronDown),
                          onPressed: (){
                            setState(() {
                              isOpen = !isOpen;
                            });
                          },
                        ),
                  )
                  
                ),
              ],
            ),
            isOpen ? 
            Container(
              width  : double.infinity,
              margin : EdgeInsets.only(left: 5, bottom: 5),
              // decoration: BoxDecoration(
              //   color: HexColor('#FFFFFF'),
              //   border: Border(
              //     left: BorderSide(color: _color, width: 4),
              //   ),
              // ),
              child: 
              Column(
                children: <Widget>[
                    ListView.builder(
                      itemCount: listDetail.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i){
                        return Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: MyColor('line'), width: 2),
                              left:  BorderSide(color: _color, width: 4),
                            )
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(listDetail[i]['name'])
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(': '+ toNumberRupiah(double.parse(listDetail[i]['value'])))
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    Text(
                      'Total : ' + toNumberRupiah(data['total'][type]),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: _color,
                        backgroundColor: type == 'penerimaan' ? MyColor('bg') : Colors.grey
                      ),
                    )
                ],
              ),
            ) : Container(child: null,),
          ],
        )
      )
    );
  }

 Future<void> getData() async {
    if(!mounted) return;
    var pegawai_id = await Services().getSession('pegawai_id');
    var periode = value_months[_selectedMonth] + years[_selectedYear];
    // print(pegawai_id);
    // print(periode);
    // return;
    setState(() {
      _isLoading = true;
    });
    Services().getApi('getPenghasilan', "pegawai_id=${pegawai_id}&periode=${periode}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          _isLoading =false;
          data = val['list'];
          total_akhir = val['list']['total']['akhir'].toDouble();
          _dontshow = val['dontshow'];
        });
        // print(data);
      }else{
        setState(() {
          _isLoading =false;
          total_akhir = 0;
          _dontshow = true;
        });
      }
    });
    // print("running $mounted");
  }
  @override
  void initState() {
    getData();
    super.initState();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.minScrollExtent ==
    //       _scrollController.position.pixels) {
    //     getData();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar('Penghasilan'),
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
                          getData()
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
                  child: Text('Jumlah Diterima (A-B-C) \n ${toNumberRupiah(total_akhir)}'),
                ),
              ]
            )
          ),
          _dontshow ? 
          Container(
            width  : double.infinity,
            margin : EdgeInsets.only(bottom: 20, left: 20, right: 20),
            padding: EdgeInsets.all(10),
            // height: 200,
            decoration: BoxDecoration(
              color: HexColor('#FFFFFF'),
              border: Border(
                left: BorderSide(color: Colors.grey, width: 4),
              ),
            ),
            child: Text('Data Tidak Ditemukan')
          )
          :
          Expanded(
            flex: 1,
            child:Center(
              child:ListView(
                children: <Widget>[
                  listPresensi('penerimaan', data),
                  listPresensi('potongan_wajib', data),
                  listPresensi('potongan_lain', data),
                ],
              ),
            )
          ),
        ]
      )
    );
  }
}