import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:progress_dialog/progress_dialog.dart';

Widget listInfo(String name, String value){
  return Container(
    padding: EdgeInsets.only(bottom: 10, top: 10),
    margin: EdgeInsets.only(left: 15, right: 15, bottom: 0, top:0),
    decoration: BoxDecoration(
      border: Border(bottom:BorderSide(color: Colors.black,width: 1)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          width: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(name), Text(':')],
          ),
        ),
        Flexible(child:Text(value)),
      ],
    ),
  );
}

class DokviewScreen extends StatefulWidget {
  final dynamic data;

  DokviewScreen({Key? key, this.data}) : super(key: key);

  _DokviewScreenState createState() => _DokviewScreenState();
}

class _DokviewScreenState extends State<DokviewScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  late ProgressDialog pr;
  late DateTime inTime;
  int addView = 0;
  late String path;
  bool img = true;
  bool _isLoading = true;

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
  Future<File> createFileOfPdfUrl(url) async {
    Completer<File> completer = Completer();
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    setState(() {
      _isLoading = false;
    });
    return completer.future;
  }
  @override
  void initState(){
    super.initState();
    print('Second in: ${DateTime.now()}');
    inTime = DateTime.now();
    
  }

  @override
  Widget build(BuildContext context) {
    // print(p.extension(widget.path));
    
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
      body: 
       FutureBuilder<File>(
          future: createFileOfPdfUrl(widget.data['DOKUMEN']),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(p.extension(snapshot.data!.path) != '.pdf' && p.extension(snapshot.data!.path) != '.PDF'){
                img     = true;
                isReady = true;
              }else{
                img = false;
              }
              return Stack(
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.all(20),
                    color: MyColor('bg'),
                    child: img ?  Container(
                      alignment: Alignment.center,
                      child: InteractiveViewer(
                        panEnabled: false, // Set it to false
                        boundaryMargin: EdgeInsets.all(100),
                        minScale: 0.5,
                        maxScale: 2,
                        child:
                        Image.network(widget.data['DOKUMEN'])
                        // Image.asset(snapshot.data!.path)
                      ) 
                    ): 
                    PDFView(
                      filePath       : snapshot.data!.path,
                      enableSwipe    : true,
                      swipeHorizontal: false,
                      autoSpacing    : true,
                      pageFling      : false,
                      pageSnap       : false,
                      defaultPage    : currentPage!,
                      fitPolicy      : FitPolicy.BOTH,
                      preventLinkNavigation:
                          false, // if set to true the link is handled in flutter
                      onRender: (_pages) {
                        setState(() {
                          pages = _pages;
                          isReady = true;
                        });
                      },
                      onError: (error) {
                        setState(() {
                          errorMessage = error.toString();
                        });
                        print(error.toString());
                      },
                      onPageError: (page, error) {
                        setState(() {
                          errorMessage = '$page: ${error.toString()}';
                        });
                        print('$page: ${error.toString()}');
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onLinkHandler: (String? uri) {
                        print('goto uri: $uri');
                      },
                      onPageChanged: (int? page, int? total) {
                        print('page change: $page/$total');
                        setState(() {
                          currentPage = page;
                        });
                      },
                    ),
                  ),
                  errorMessage.isEmpty
                      ? !isReady
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          :
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
                                Row(children: [
                                  GestureDetector(
                                    onTap: (){
                                      print("Container clicked");
                                      showDialog(context: context, builder: (_) =>
                                        Dialog(
                                          insetPadding: EdgeInsets.only(left: 10, right: 10),
                                          backgroundColor: Colors.white.withOpacity(0.8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)), //this right here
                                          child: Container(
                                            margin: EdgeInsets.only(top: 5, bottom: 15),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                listInfo('Nama', widget.data['NAMA']),
                                                listInfo('Tanggal', widget.data['TANGGAL']),
                                                listInfo('Keterangan',widget.data['KETERANGAN']),
                                              ],
                                            ),
                                          )
                                        )
                                      );
                                    }, 
                                    child: Container(
                                      // alignment: Alignment.topRight,
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.only(right: 5),
                                      // height: 100,
                                      // width : 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color:  Colors.blue.withOpacity(0.7),
                                      ),
                                      // color : Colors.blue.withOpacity(1),
                                      child : Icon(Icons.info_outline, color: Colors.white),
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
                                
                              ],
                            )
                          )
                      : Center(
                          child: Text(errorMessage),
                        )
                ],
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
       ),
      floatingActionButton: _isLoading ? Container() : img ? Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(left: 35),
        child :FloatingActionButton.extended(
          // heroTag: 3,
          backgroundColor: Colors.green,
          label: Icon(Icons.verified_user),
          onPressed: () async {
            // await snapshot.data!.setPage(currentPage! + 1);
            showDialog(context: context, builder: (_) =>AlertDialog(
              title: Text('Info'),
              content: Text('Saya Insan PT PEL telah membaca dan memahami isi dari file tersebut.'),
              actions: <Widget>[ElevatedButton(onPressed: ()=> {Navigator.pop(context),sendData()}, child: Text('Ya'))],
            ));
          },
        )): FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.only(left: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 1,
                    label: Text("Previous"),
                    onPressed: () async {
                      await snapshot.data!.setPage(currentPage! - 1);
                    },
                  ),
                  FloatingActionButton.extended(
                    heroTag: 2,
                    label: Text((currentPage! + 1).toString() + " / " + (pages).toString()),
                    onPressed: () async {
                      // await snapshot.data!.setPage(pages! ~/ 2);
                    },
                  ),
                  (currentPage!+1 != pages) ? 
                  FloatingActionButton.extended(
                    heroTag: 3,
                    label: Text("Next"),
                    onPressed: () async {
                      await snapshot.data!.setPage(currentPage! + 1);
                    },
                  ) : FloatingActionButton.extended(
                    heroTag: 3,
                    backgroundColor: Colors.green,
                    label: Icon(Icons.verified_user),
                    onPressed: () async {
                      // await snapshot.data!.setPage(currentPage! + 1);
                      showDialog(context: context, builder: (_) =>AlertDialog(
                        title: Text('Info'),
                        content: Text('Saya Insan PT PEL telah membaca dan memahami isi dari file tersebut.'),
                        actions: <Widget>[ElevatedButton(onPressed: ()=> {Navigator.pop(context),sendData()}, child: Text('Ya'))],
                      ));
                    },
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}