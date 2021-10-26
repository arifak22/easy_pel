

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:easy_pel/pages/main/check/selfcheck/add_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ViewScreen extends StatefulWidget {
  @override
  State<ViewScreen> createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {
  int  _selectedMonth = months.indexWhere((element) => element == DateFormat('MMMM', 'id_ID').format(DateTime.now()));
  int  _selectedYear  = years.indexWhere((element) => element == DateFormat('y').format(DateTime.now()));
  bool _isLoading     = false;
  List data           = [];
  bool showTambah = false;
  late ProgressDialog pr;

  @override
  void initState() {
    getData();
    super.initState();
  }


  Widget listSelfchek(dynamic data){
    MaterialColor _color = Colors.green;

    if(data['COLOR'] == 'success'){
      _color = Colors.green;
    }else if(data['COLOR'] == 'danger'){
      _color = Colors.red;
    }else if(data['COLOR'] == 'warning'){
      _color = Colors.yellow;
    }
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
                  Text(data['TANGGAL'], 
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child:  Text(data['JAM'])
                  )
                ],
              )
            )
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(data['SKOR'] + '/' + data['TOTAL_SOAL'], 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15, 
                  color: _color, 
                  background: Paint()..color = MyColor('bg')
                  ..strokeWidth = 10
                  ..style = PaintingStyle.stroke,
                ),
              ),
            )
          ),
        ],
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
    Services().getApi('getSelfcheck', "pegawai_id=${pegawai_id}&periode=${periode}").then((val) {
      if (val['api_status'] == 1) {
        print(val['found']);
        setState(() {
          data = val['item'];
          showTambah = val['found'] == 0 ? true : false;
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
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
      message: 'Menunggu...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    var periode = value_months[_selectedMonth] + years[_selectedYear];
    return new Scaffold(
      appBar: appBar('Selfcheck'),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(showTambah){
            pr.show();
            Services().getApi('getSoal', "").then((val) {
              pr.hide();
              if (val['api_status'] == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddScreen(data: val)),
                ).then((value) => 
                  {
                    getData()
                  }
                );
              }else{

              }
            });
          }else{
            showDialog(context: context, builder: (_) =>AlertDialog(
              title: Text('Something wrong'),
              content: Text('Anda Sudah mengisi hari ini'),
              actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
            ));
          }
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
        // backgroundColor: MyColor('primary'),
        // focusColor: MyColor('default'),
        elevation: 4.0,
      ),
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
                      return listSelfchek(data[i]);
                    },
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}