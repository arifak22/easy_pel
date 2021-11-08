
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:flutter/material.dart';

class HukumanScreen extends StatefulWidget{
  @override
  State<HukumanScreen> createState() => _HukumanScreenState();
}

class _HukumanScreenState extends State<HukumanScreen> {

  bool    _isLoading = true;
  dynamic data       = [];
  Future<void> getData() async {
    if(!mounted) return;
    var pegawai_id = await Services().getSession('pegawai_id');
    setState(() {
      _isLoading = true;
    });
    Services().getApi('getHukuman', "pegawai_id=${pegawai_id}").then((val) {
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
    });
    // print("running $mounted");
  }

  Widget listData(dynamic data){
    return Container(
        width  : double.infinity,
        margin : EdgeInsets.only(bottom: 20, left: 20, right: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: HexColor('#FFFFFF'),
          // borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border(
            left: BorderSide(color: Colors.blue, width: 4),

          ),
          // borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
        ),
        child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(data['KATEGORI_HUKUMAN'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                Text(data['JENIS_HUKUMAN']),
                // Text(''),
                Text('Tanggal SK: \n' + data['TANGGAL_SK']),
                Text('Kasus : \n' + data['KASUS'])
              ],
            )
          ),
        ],
      ),
    );
  }
  
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color background = MyColor('primary');
    final Color fill = MyColor('bg');
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    final double fillPercent = 80.00; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    
     return new Scaffold(
      appBar: AppBar(
        title          : Text('Hukuman', style: TextStyle(color: Colors.white)),
        elevation      : 0,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: MyColor('primary'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            stops: stops,
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: _isLoading ? CircularProgressIndicator() : RefreshIndicator(
              onRefresh: () async{
                getData();
              },
              child: data.length > 0 ? ListView.builder(
                itemCount: data.length,
                // controller: _scrollController,
                  itemBuilder: (context, i){
                    // print(data[i]);
                    return listData(data[i]);
                  },
              ) : Text(' -- Kosong --', style: TextStyle(fontStyle: FontStyle.italic)),
            ),
          )
        )
      )
     );
  }
}