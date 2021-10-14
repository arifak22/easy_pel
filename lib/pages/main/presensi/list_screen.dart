import 'package:easy_pel/helpers/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



Widget listPresensi(dynamic data){
  MaterialColor _color = Colors.green;

  if(data['COLOR'] == 'primary'){
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
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: Text(data['STATUS'], 
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
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(data['TANGGAL_INDO'], 
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child:  Text('${data["IN"]} s/d ${data["OUT"]}')
                )
              ],
            )
          )
        ),
      ],
    )
  );
}                
class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool _isLoading = true;
  int _selectedMonth = months.indexWhere((element) => element == DateFormat('MMMM', 'id_ID').format(DateTime.now()));
  int _selectedYear = years.indexWhere((element) => element == DateFormat('y').format(DateTime.now()));
  List data = [];
  ScrollController _scrollController = ScrollController();
  String total_hari   = '0';
  String hari_sebulan = '0';
  double potongan = 0;

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
    Services().getApi('getPresensi', "pegawai_id=${pegawai_id}&periode=${periode}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          data = val['data'];
          total_hari = val['kerja'] != null ? val['kerja']['TOTAL_HARI'].toString() : '0';
          hari_sebulan = val['kerja'] != null ? val['kerja']['HARI_SEBULAN'].toString() : '0';
          potongan = val['kerja'] != null ? double.parse(val['kerja']['POTONGAN']) : 0;
          _isLoading =false;
        });
        // print(data);
      }else{
        setState(() {
          data = [];
          total_hari   = '0';
          hari_sebulan = '0';
          potongan = 0.00;
          _isLoading =false;
        });
      }
    });
    // print("running $mounted");
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
    return Scaffold(
      appBar: appBar('Daftar Presensi'),
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
                  child: Text('Total Hari: ${total_hari} / ${hari_sebulan}'),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: HexColor('#FFFFFF'),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: MyColor('line'))
                  ),
                  child: Text('Potongan: Rp. ${NumberFormat.decimalPattern('id_ID').format(potongan)}'),
                ),
              ],
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
                        return listPresensi(data[i]);
                      },
                  ),
                ),
            )
          )
      ]
    ),
        
    );
  }
}