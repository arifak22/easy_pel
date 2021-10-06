
import 'dart:io';

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LampiranScreen extends StatefulWidget {
  final String id;
  LampiranScreen({required this.id});
  @override
  State<LampiranScreen> createState() => LampiranScreenState();
}

class LampiranScreenState extends State<LampiranScreen> {
  TextEditingController valueKeterangan = TextEditingController();
  TextEditingController valueLampiran   = TextEditingController();
  File? valueFile;

  final _formKey = GlobalKey<FormState>();

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path ?? '');
      String basename = file.path.split('/').last;
      setState(() {
        valueLampiran.text = basename;
        valueFile          = file;
      });
    } else {
      setState(() {
        valueLampiran.text = '';
        valueFile          = null;
      });
    }
  }

  tambahLampiran() async {
    if(_formKey.currentState!.validate()) {
      var pegawai_id    = await Services().getSession('pegawai_id');
      String? id = widget.id;
      // print(valueFile);
      // return;
      var data = {
        'id'             : id,
        'pegawai_id'     : pegawai_id,
        'keterangan'     : valueKeterangan.text,
      };
      Services().postApiFile('postLampiran', data, {'file' : valueFile!.path}).then((val) async {
        if (val['api_status'] == 1) {
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
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar('Tambah Lampiran'),
      body: Container(
        margin: EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 30),
        child: Column(
          children: [
            Container(
              width  : double.infinity,
              // margin : EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: HexColor('#FFFFFF'),
                // borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border(
                  // bottom: BorderSide(color: HexColor(_color), width: 4),
                  top: BorderSide(color: widget.id == null ? Colors.blue : Colors.orange, width: 4),
                ),
                // borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Informasi Detil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: HexColor('#1d608a'))),
                      FormText(
                        label          : 'Keterangan',
                        valueController: valueKeterangan,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'File Lampiran',
                          contentPadding: EdgeInsets.all(10),
                          suffixIcon: Icon(MdiIcons.attachment)
                        ),
                        readOnly: true,
                        controller: valueLampiran,
                        validator: (val){
                          if (val!.isEmpty) {
                            return 'Lampiran is empty';
                          }
                          return null;
                        },
                        // enabled: false,
                        onTap: (){
                          pickFile();
                        }
                      )
                    ]
                  )
                )
              )
            ),
            Container(
              width  : double.infinity,
                // margin : EdgeInsets.only(bottom: 5),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: HexColor('#FFFFFF'),
                  // borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border(
                    // bottom: BorderSide(color: HexColor(_color), width: 4),
                    top: BorderSide(color: MyColor('line'), width: 1),
                  ),
                  // borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
                ),
                child: ElevatedButton(
                  onPressed: (){
                    tambahLampiran();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text('TAMBAH')
                  ),
                )
            )
          ]
        )
      )
    );
  }
}