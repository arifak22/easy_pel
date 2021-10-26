import 'dart:async';
import 'dart:convert';

import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:easy_pel/pages/main/ketidakhadiran/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddScreen extends StatefulWidget {
  dynamic data;
  AddScreen({required this.data});
  @override
  AddScreenState createState() => AddScreenState(data);
}

class AddScreenState extends State<AddScreen> {
  AddScreenState(dynamic data);
  final   _formKey                         = GlobalKey<FormState>();
  List? selectedRole                    = [];
  final   TextEditingController _nameCtrl  = TextEditingController();
  final   TextEditingController _emailCtrl = TextEditingController();
  bool    _isLoading                       = false;
  bool isFirst = true;
  List<CoolStep> steps = [];
  String selectedValue = 'Ya';
  TextEditingController valueKeterangan   = TextEditingController();
  int _skor = 0;
  late ProgressDialog pr;

  var keyId;
  @override
  void initState() {
    super.initState();
  }

  submitData() async {
    pr.show();
    _skor = 0;
    selectedRole!.forEach((element) {
      _skor = _skor + int.parse(element['param']);
    });
    var pegawai_id    = await Services().getSession('pegawai_id');
    var data = {
      'pegawai_id': pegawai_id,
      'suhu'      : valueKeterangan.text,
      'jawaban'   : json.encode(selectedRole),
      'skor'      : _skor.toString(),
    };
    Services().postApi('postSelfcheck', data).then((val) async {
      pr.hide();
      print(val);
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
    var i        = 0;
    steps        = [CoolStep(
      title: 'SUHU BADAN HARI INI',
      subtitle: 'Pengisian wajib dilakukan kecuali di luar hari kerja (libur)',
      content: Form(
        key: _formKey,
        child: FormText(
          label          : 'Suhu Badan',
          valueController: valueKeterangan,
          keyboardType   : TextInputType.numberWithOptions(decimal: true,signed: false)
        ) 
      ),
      validation: () {
        if (!_formKey.currentState!.validate()) {
          return 'Fill form correctly';
        }
        return null;
      },
    )];
    widget.data['soal'].forEach((json){
      if(isFirst){
        keyId = {
          'id_soal'  : json['ID_SOAL'],
          'value': 'Ya',
          'param' : json['POIN_Y'],
        }; 
        selectedRole!.add(keyId);
      }
      steps.add(
        CoolStep(
          title: 'Pilih Ya/Tidak',
          subtitle: json['PERTANYAAN'],
          content: Container(
            child: Row(
              children: <Widget>[
                _buildSelector(
                  context: context,
                  name   : 'Ya',
                  uid    : json['ID_SOAL'],
                  i      : i,
                  skor   : json['POIN_Y']
                ),
                SizedBox(width: 5.0),
                _buildSelector(
                  context: context,
                  name   : 'Tidak',
                  uid    : json['ID_SOAL'],
                  i      : i,
                  skor   : json['POIN_T']
                ),
              ],
            ),
          ),
          validation: () {
            return null;
          },
        )
      );
      i++;
    });
    final stepper = CoolStepper(
      showErrorSnackbar: true,
      onCompleted: () {
        submitData();
      },
      steps: steps,
      config: CoolStepperConfig(
        backText: 'PREV',
      ),
    );

    return Scaffold(
      appBar: appBar('Tambah Selfcheck'),
      body: Container(
        alignment: Alignment.center,
        child: stepper,
      ),
    );
  }


  Widget _buildSelector({
    BuildContext? context,
    required String name,
    required String uid,
    required String skor,
    required int i
  }) {
    var isActive = name == selectedRole![i]['value'].toString();
    var keyId;
    return Expanded(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : null,
          border: Border.all(
            width: 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: RadioListTile(
          value: name,
          activeColor: Colors.white,
          groupValue: selectedRole![i]['value'].toString(),
          onChanged: (String? v) {
            keyId = {
              'id_soal'  : uid,
              'value': v,
              'param' :skor
            }; 
            setState(() {
              selectedRole![i] = keyId;
              selectedValue = 'Tidak';
              isFirst = false;
            });
          },
          title: Text(
            name,
            style: TextStyle(
              color: isActive ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}