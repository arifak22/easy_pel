
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:flutter/material.dart';

class JabatanScreen extends StatefulWidget{
  @override
  State<JabatanScreen> createState() => _JabatanScreenState();
}

class _JabatanScreenState extends State<JabatanScreen> {
  bool    _isLoading = true;
  dynamic data       = [];
  Future<void> getData() async {
    if(!mounted) return;
    var pegawai_id = await Services().getSession('pegawai_id');
    setState(() {
      _isLoading = true;
    });
    Services().getApi('getJabatan', "pegawai_id=${pegawai_id}").then((val) {
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
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(data['JABATAN_NAMA'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                Text(data['NO_SK']),
                Text(''),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tanggal SK: \n' + data['TANGGAL_SK']),
                          Text('TMT Jabatan: \n' + data['TMT_JABATAN']),
                        ],
                      ),
                    ),
                    // Text('Pejabat Penetap: '),
                    Expanded(
                      flex: 3,
                      child: Text('Penetap: \n' + data['PEJABAT_PENETAP'], 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15, 
                          color: Colors.blue, 
                          backgroundColor: MyColor('bg')
                        ),
                      ),
                    ),
                    // Text('Direktur Utama')
                ],
                )
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
        title          : Text('Histori Jabatan', style: TextStyle(color: Colors.white)),
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
              child: ListView.builder(
                itemCount: data.length,
                // controller: _scrollController,
                  itemBuilder: (context, i){
                    // print(data[i]);
                    return listData(data[i]);
                  },
              ),
            ),
          )
        )
      )
     );
  }
}