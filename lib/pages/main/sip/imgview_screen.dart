import 'dart:async';
import 'dart:io';

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:progress_dialog/progress_dialog.dart';


class ImgviewScreen extends StatefulWidget {
  final String? path;
  final dynamic? data;

  ImgviewScreen({Key? key, this.path, this.data}) : super(key: key);

  _ImgviewScreenState createState() => _ImgviewScreenState();
}

class _ImgviewScreenState extends State<ImgviewScreen> with WidgetsBindingObserver {
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  late ProgressDialog pr;
  late DateTime inTime;
  int addView = 0;

  Future<void> sendData() async {
    pr.show();
    var timeView = DateTime.now().difference(inTime).inSeconds;
    var pegawaiId = await Services().getSession('pegawai_id');
    var data = {
      'id'             : widget.data['DOKUMEN_SIP_ID'],
      'pegawai_id'     : pegawaiId,
      'time_view'      : timeView.toString()
    };
    Services().postApi('postViewDokumen', data).then((val) {
      print(val);
      pr.hide();
      if (val['api_status'] == 1) {
        print('success');
        setState(() {
          addView++;
        });
      }else{
        showDialog(context: context, builder: (_) =>AlertDialog(
          title: Text('Something wrong'),
          content: Text('${val['api_message']}'),
          actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
        ));
        print('gagal');
      }
    });
  }
  
  @override
  void initState() {
    super.initState();
    print('Second in: ${DateTime.now()}');
    inTime = DateTime.now();
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
    int totalView = int.parse(widget.data['TOTAL_VIEW']) + addView;
    int totalViewUser = int.parse(widget.data['TOTAL_VIEW_USER']) + addView;

    return Scaffold(
      appBar: appBar(widget.data['NAMA']),
      body: Stack(
        children: <Widget>[
          Container(
            // padding: EdgeInsets.all(20),
            color: MyColor('bg'),
            child: Expanded(
              flex: 1,
              child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image:NetworkImage('https://royalplazasurabaya.com/storage/app/uploads/public/615/6b9/875/6156b9875ecf5776837748.jpg'),
                        // fit: BoxFit.fit,
                      ),
                    )
                  )
            )
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // alignment: Alignment.topRight,
                  padding: EdgeInsets.all(5),
                  // height: 100,
                  // width : 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:  Colors.blue.withOpacity(0.7),
                  ),
                  // color : Colors.blue.withOpacity(1),
                  child : Row(
                    children: [
                      Icon(Icons.remove_red_eye_outlined, color: Colors.white),
                      Text(" ${totalView.toString()}", style: TextStyle(color: Colors.white))
                    ],
                  )
                ),
                Container(
                  // alignment: Alignment.topRight,
                  padding: EdgeInsets.all(5),
                  // height: 100,
                  // width : 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:  Colors.blue.withOpacity(0.7),
                  ),
                  // color : Colors.blue.withOpacity(1),
                  child : Row(
                    children: [
                      Icon(Icons.beenhere, color: Colors.white),
                      Text(" ${totalViewUser.toString()}", style: TextStyle(color: Colors.white))
                    ],
                  )
                )
              ],
            )
          )
        ],
      ),
    );
  }
}