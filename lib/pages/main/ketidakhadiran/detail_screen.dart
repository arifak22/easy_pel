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
  String jenis;
  DetailScreen({required this.id, required this.pegawai_id, required this.jenis});
  @override
  State<DetailScreen> createState() => DetailScreenState(id, pegawai_id, jenis);
}

class DetailScreenState extends State<DetailScreen> {
  DetailScreenState(String id, String pegawai_id, String jenis);
  bool    _isLoading         = true;
  bool    _isLoadingSubmit   = false;
  dynamic data               = [];
  dynamic lampiran           = [];
  dynamic history            = [];
  String  sisa_cuti          = '-';
  String  sisa_cuti_setengah = '-';
  String  jenis              = '0';
  String  validate_status    = '0';
  String  _color             = '#FFFFFF';
  late ProgressDialog pr;
  TextEditingController catatanController = TextEditingController();

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
    if(widget.jenis == '0'){
      setState(() {
        jenis           = '1';
        validate_status = '-1';
      });
    }else if(widget.jenis == '1'){
      setState(() {
        jenis           = '2';
        validate_status = '1';
      });
    }else if(widget.jenis == '2'){
      setState(() {
        jenis           = '8';
        validate_status = '1';
      });
    }
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

  submitApproval(jenisvalidasi) async {
      setState(() {
        _isLoadingSubmit = true;
      });
      // var data;
      var pegawai_id    = await Services().getSession('pegawai_id');
      var id            = widget.id;
      var keterangan    = catatanController.text;
      var data = {
        'pegawai_id'   : pegawai_id,
        'id'           : id,
        'jenisvalidasi': jenisvalidasi,
        'keterangan'   : keterangan,
      };
      Services().postApi('postApproval', data).then((val) async {
        setState(() {
          _isLoadingSubmit = false;
        });
        print(val);
        if (val['api_status'] == 1) {
          setState(() {
            _isLoadingSubmit = false;
          });
          print('sukses');
          showDialog(context: context, builder: (_) =>AlertDialog(
            title  : Text('Berhasil'),
            content: Text('${val['api_message']}'),
            actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
          )).then((value) => {
            Navigator.pop(
              context
            )
          });
        }else{
          showDialog(context: context, builder: (_) =>AlertDialog(
            title: Text('Something wrong'),
            content: Text('${val['api_message']}'),
            actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
          ));
        }
      });
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
        children: <Widget>[
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 15),
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: HexColor('#FFFFFF'),
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                border: Border.all(color: MyColor('line'))
                            ),
                            child: Text('Sisa Cuti Tahunan: ' + sisa_cuti),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5),
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
                      margin : EdgeInsets.only(bottom: 15),
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
                      margin : EdgeInsets.only(bottom: 5),
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
                              margin : EdgeInsets.only(bottom: 7),
                              padding: EdgeInsets.all(8),
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
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left:15, right: 15, bottom: 30),
              child: Column(
                children: [
                  Container(
                    margin : EdgeInsets.only(bottom: 5),
                    alignment: Alignment.topLeft,
                    child: Text(widget.jenis == '10' ? 'History Approval' : 'Catatan Approval', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      // height: 300,
                      width  : double.infinity,
                      margin : EdgeInsets.only(bottom: 5),
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
                      child: 
                      widget.jenis == '10' ?
                      history.length > 0 ? ListView.builder(
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
                      : Container(
                        child: TextFormField(
                          // obscureText: true, 
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          minLines: null,
                          maxLines: null,  // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                          expands: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                            labelText: 'Catatan',
                          ),
                          controller: catatanController,
                          validator: (val){
                            if (val!.isEmpty) {
                              return 'Catatan is empty';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => {
                            FocusScope.of(context).unfocus()
                          },
                          // onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        ),
                      )
                    ),
                  ),
                  widget.jenis == '10' ? Container() :
                  validate_status != data['VALIDATE_STATUS'] ?  Container() :
                  Container(
                    // margin: EdgeInsets.only(bottom: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: !_isLoadingSubmit ? (){
                            if(catatanController.text == ''){
                              showDialog(context: context, builder: (_) =>AlertDialog(
                                title: Text('Info'),
                                content: Text('Wajib mengisi Catatan'),
                                actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
                              ));
                            }else{
                              showDialog(context: context, builder: (_) =>AlertDialog(
                                title: Text('Info'),
                                content: Text('Apakah anda yakin menolak ijin ini?'),
                                actions: <Widget>[
                                    OutlinedButton(
                                      onPressed: ()=>Navigator.pop(context), child: Text('Tidak')
                                    ),
                                    ElevatedButton(
                                      onPressed: ()=> {
                                        Navigator.pop(context),
                                        submitApproval('0')
                                      }, child: Text('Ya'),
                                    ),
                                  ],
                              ));
                            }
                          } : null,
                          child: _isLoadingSubmit
                          ? SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(color: Colors.white,),
                                  )
                          : Text('Tolak'),
                          style: ElevatedButton.styleFrom(
                            // elevation: 30,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(3),
                            ),
                            // shape: CircleBorder(),
                            padding: EdgeInsets.all(13),
                            primary: Colors.red,
                            onPrimary: Colors.white,
          
                          ),
                        ),
                        ElevatedButton(
                          onPressed: !_isLoadingSubmit ? (){
                            showDialog(context: context, builder: (_) =>AlertDialog(
                              title: Text('Info'),
                              content: Text('Apakah anda yakin menyetujui ijin ini?'),
                              actions: <Widget>[
                                  OutlinedButton(
                                    onPressed: ()=>Navigator.pop(context), child: Text('Tidak')
                                  ),
                                  ElevatedButton(
                                    onPressed: ()=> {
                                      Navigator.pop(context),
                                      submitApproval(jenis)
                                    }, child: Text('Ya'),
                                  ),
                                ],
                            ));
                          } : null,
                          child: _isLoadingSubmit
                          ? SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(color: Colors.white,),
                                  )
                          : Text('Setuju'),
                          style: ElevatedButton.styleFrom(
                            // elevation: 30,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(3),
                            ),
                            // shape: CircleBorder(),
                            padding: EdgeInsets.all(13),
                            primary: Colors.green.shade600,
                            onPrimary: Colors.white,
          
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ) : Center(child: CircularProgressIndicator() )
    );
  }
}