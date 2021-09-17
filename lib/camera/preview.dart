import 'dart:io';
import 'dart:typed_data';

// import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PreviewScreen extends StatefulWidget {
  final String imgPath;
  final String fileName;
  final bool isPreview;
  PreviewScreen({required this.imgPath, required this.fileName, required this.isPreview});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      // ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.file(File(widget.imgPath),fit: BoxFit.cover,),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60,
                color: Colors.black,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      !widget.isPreview ?
                      IconButton(
                        icon: Icon(MdiIcons.closeCircle,color: Colors.white,),
                        onPressed: (){
                          Navigator.pop(context, '');
                        },
                      ) : Text(''),
                      IconButton(
                        icon: Icon(MdiIcons.check,color: Colors.white,),
                        onPressed: (){
                          Navigator.pop(context, widget.imgPath);
                          // Navigator.pop(context, widget.imgPath);
                        },
                      ),
                    ],
                  )
                  
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Future getBytes () async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
//    print(ByteData.view(buffer))
    return ByteData.view(bytes.buffer);
  }
}