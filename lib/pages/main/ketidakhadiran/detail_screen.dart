import 'dart:async';
import 'dart:io';

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:easy_pel/pdf/view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:timeline_tile/timeline_tile.dart';

class DetailScreen extends StatefulWidget {
  String id;
  String pegawai_id;
  DetailScreen({required this.id, required this.pegawai_id});
  @override
  State<DetailScreen> createState() => DetailScreenState(id, pegawai_id);
}

class DetailScreenState extends State<DetailScreen> {
  DetailScreenState(String id, String pegawai_id);
  bool    _isLoading         = true;
  dynamic data               = [];
  dynamic lampiran           = [];
  dynamic history            = [];
  String  sisa_cuti          = '-';
  String  sisa_cuti_setengah = '-';
  String  _color             = '#FFFFFF';
  late ProgressDialog pr;

  Future<void> getData() async {
    if(!mounted) return;
    // print(pegawai_id);
    // print(periode);
    // return;
    setState(() {
      _isLoading = true;
    });
    Services().getApi('getKetidakhadiranDetail', "pegawai_id=${widget.pegawai_id}&id=${widget.id}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          data               = val['data'];
          sisa_cuti          = val['data']['SISA_CUTI_TAHUNAN'];
          sisa_cuti_setengah = val['data']['SISA_CUTI_SETENGAH'];
          _color             = data['VALIDATE_COLOR2'];
          history            = val['history'];
          _isLoading         = false;
        });
        print(val['history']);
      }else{
        setState(() {
          data = [];
          _isLoading =false;
        });
      }
    });

    Services().getApi('getLampiran', "pegawai_id=${widget.pegawai_id}&id=${widget.id}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          lampiran = val['data'];
          // _isLoading =false;
        });
        print(val['data']);
      }else{
        setState(() {
          lampiran = [];
          // _isLoading =false;
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

  Future<File> createFileOfPdfUrl(url) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    pr.show();
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
      pr.hide();
      throw Exception('Error parsing asset file!');
    }
    pr.hide();
    return completer.future;
  }

  
  
  @override
  Widget build(BuildContext context) {
    // var periode = value_months[_selectedMonth] + years[_selectedYear];
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
    return new Scaffold(
      appBar: appBar('Detil Ketidakhadiran'),
      body: !_isLoading ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15, bottom: 10, right: 10, top: 15),
            alignment: Alignment.topLeft,
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
          Container(
            width  : double.infinity,
            margin : EdgeInsets.only(bottom: 15, left: 20, right: 20, top: 5),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: HexColor('#FFFFFF'),
              // borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border(
                top: BorderSide(color: HexColor(_color), width: 4),
              ),
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['NAMA'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                Text(data['JENIS_IJIN']),
                Text(''),
                Text('Permohonan: \n' + data['TANGGAL_PERMOHONAN_INDO']),
                Text('Waktu : \n' + data['TANGGAL_AWAL_INDO'] + ' s/d ' + data['TANGGAL_AKHIR_INDO']),
              ],
            )
          ),
          Container(
            margin : EdgeInsets.only(bottom: 5, left: 25, right: 25),
            alignment: Alignment.topLeft,
            child: Text('Lampiran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          ),
          Container(
            // margin : EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 5),
            height:  lampiran.length > 0 ? 150 : null,
            child: lampiran.length > 0 ? ListView.builder(
              itemCount: lampiran.length,
              // controller: _scrollController,
              itemBuilder: (context, i){
                return InkWell(
                  onTap: () async {
                    File file = await createFileOfPdfUrl(lampiran[i]['NAMA_FILE']);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PDFScreen(path: file.path))
                    );
                  },
                  child:Container(
                    width  : double.infinity,
                    margin : EdgeInsets.only(bottom: 5, left: 20, right: 20, top: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: HexColor('#FFFFFF'),
                      // borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border(
                        left: BorderSide(color: HexColor(_color), width: 4),
                      ),
                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
                    ),
                    child:  Row(
                      children: [
                        Icon(MdiIcons.pdfBox),
                        Text(lampiran[i]['KETERANGAN']),
                      ],
                    )
                  )
                );
              }
            ) : Container(
                  width  : double.infinity,
                  margin : EdgeInsets.only(bottom: 15, left: 20, right: 20, top: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: HexColor('#FFFFFF'),
                    // borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border(
                      // left: BorderSide(color: HexColor(_color), width: 4),
                    ),
                    // borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
                  ),
                  child: Center(child: Text(' - Tidak ada Lampiran - '))
            )
          ),
          Container(
            margin : EdgeInsets.only(bottom: 5, left: 25, right: 25),
            alignment: Alignment.topLeft,
            child: Text('History Approval', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width  : double.infinity,
              margin : EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: HexColor('#FFFFFF'),
                // borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border(
                  // bottom: BorderSide(color: HexColor(_color), width: 4),
                  top: BorderSide(color: HexColor(_color), width: 4),
                ),
                // borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
              ),
              child: history.length > 0 ? ListView.builder(
                itemCount: history.length,
                // controller: _scrollController,
                itemBuilder: (context, i){
                  return TimelineTile(
                    lineXY: 0.1,
                    indicatorStyle: IndicatorStyle(
                      width: 20,
                      height: 20,
                      padding: EdgeInsets.all(6),
                      color: Colors.green,
                      drawGap: false,
                    ),
                    beforeLineStyle: LineStyle(
                      color: Colors.green,
                    ),
                    endChild: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(history[i]['NAMA'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(history[i]['TANGGAL'], style: TextStyle(fontSize: 13)),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(history[i]['KETERANGAN'], style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                    // isFirst: true,
                  );
                }
              ) : Container()
            )
          )
        ],
      ) : Center(child: CircularProgressIndicator() )
    );
  }
}