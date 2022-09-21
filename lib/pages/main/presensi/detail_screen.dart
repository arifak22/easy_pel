import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget{
  dynamic data;

  DetailScreen({required this.data});
  @override
  State<DetailScreen> createState() => _DetailScreenState(data);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(dynamic data);
  String pegawai_id = '0';
  String periode    = '';
  String tipeIn     = '';
  String tipeOut    = '';
  
  @override
  initState() {
    print(widget.data);
    var partPeriode = widget.data['PERIODE'].split('-');
    setState(() {
      tipeIn = 'IN_' + int.parse(partPeriode[0]).toString();
      tipeOut = 'OUT_' + int.parse(partPeriode[0]).toString();
      periode = partPeriode[1];
    });
    this.getPegawaiId();
    // TODO: implement initState
    super.initState();
  }

  getPegawaiId() async {
    var pegawaiId = await Services().getSession('pegawai_id');
    setState(() {
      pegawai_id = pegawaiId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Detail Presensi'),
      body: Container(
        width  : double.infinity,
        margin : EdgeInsets.all(15),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: HexColor('#FFFFFF'),
          // borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border(
            top: BorderSide(color: Colors.blue, width: 4),
          ),
          // borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Tepat', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15, 
                  color: Colors.green, 
                  background: Paint()..color = MyColor('bg')
                  ..strokeWidth = 10
                  ..style = PaintingStyle.stroke,
                ),
              ),
              Text(widget.data['TANGGAL_INDO'], 
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
              ),
              Divider(
                color: Colors.black
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(widget.data['IN'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              ),
              pegawai_id != '0' ? Image.network(
                urlAPi("getFotoPresensi", param: "?pegawai_id=${pegawai_id}&tipe=${tipeIn}&periode=${periode}"),
                fit: BoxFit.cover,
              ) : Container(),
              Divider(
                color: Colors.black
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(widget.data['OUT'], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              ),
              pegawai_id != '0'?
              Image.network(
                urlAPi("getFotoPresensi", param: "?pegawai_id=${pegawai_id}&tipe=${tipeOut}&periode=${periode}"),
                fit: BoxFit.cover,
              ) : Container()
            ],
          ),
        )
      )
    );
  }
}