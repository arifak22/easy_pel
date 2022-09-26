
import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class AddScreen extends StatefulWidget {
  final String? id;
  AddScreen({this.id});
  @override
  State<AddScreen> createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  TextEditingController valueJenis        = TextEditingController();
  TextEditingController valueIjinPenting  = TextEditingController();
  TextEditingController valuePeriode      = TextEditingController();
  TextEditingController valueAtasan       = TextEditingController();
  TextEditingController valueKeterangan   = TextEditingController();
  TextEditingController valueTglAwal      = TextEditingController(text: DateFormat('y-MM-dd').format(DateTime.now()));
  TextEditingController valueTglAkhir     = TextEditingController(text: DateFormat('y-MM-dd').format(DateTime.now()));
  TextEditingController valueJam          = TextEditingController();
  dynamic               optionAtasan      = [];
  dynamic               optionJenisIjin   = [];
  dynamic               optionIjinPenting = [];
  dynamic               optionPeriode     = [];
  bool                  _isLoadingSubmit  = false;
  dynamic               data              = [];
  bool                  _isReady          = false;

  final _formKey = GlobalKey<FormState>();

  getListAtasan() async {
    // print(widget.id);
    var pegawai_id = await Services().getSession('pegawai_id');
    Services().getApi('getListAtasan', "pegawai_id=${pegawai_id}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          optionAtasan = val['data'];
        });
      }else{
        setState(() {
          optionAtasan = [];
        });
      }
    });
  }

  getListJenisIjin() async {
    var pegawai_id = await Services().getSession('pegawai_id');
    await Services().getApi('getListJenisIjin', "pegawai_id=${pegawai_id}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          optionJenisIjin = val['data'];
        });
        print(val['data']);
      }else{
        setState(() {
          optionJenisIjin = [];
        });
      }
    });

    Services().getApi('getListIjinPenting', "pegawai_id=${pegawai_id}").then((val) {
      print(val);
      if (val['api_status'] == 1) {
        setState(() {
          optionIjinPenting = val['data'];
          optionPeriode     = val['periode'];
          valuePeriode.text = val['periode_selected'];
        });

      }else{
        setState(() {
          optionIjinPenting = [];
          optionPeriode     = [];
        });
      }
    });
  }

  // getListIjinPenting() async {
  //   var pegawai_id = await Services().getSession('pegawai_id');
  //   Services().getApi('getListIjinPenting', "pegawai_id=${pegawai_id}").then((val) {
  //     if (val['api_status'] == 1) {
  //       setState(() {
  //         optionIjinPenting = val['data'];
  //       });
  //     }else{
  //       setState(() {
  //         optionIjinPenting = [];
  //       });
  //     }
  //   });
  // }

  submitForm() async{
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoadingSubmit = true;
      });
      print(valueTglAkhir.text);
      if((dateToDouble(valueTglAwal.text) > dateToDouble(valueTglAkhir.text)) && valueJenis.text != '31'){
          return showDialog(context: context, builder: (_) =>AlertDialog(
            title: Text('Something wrong'),
            content: Text('Pemilihan Tanggal Tidak Valid'),
            actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
          ));
      }
      var pegawai_id    = await Services().getSession('pegawai_id');
      String? id = widget.id ?? '';
      var data = {
        'id'             : id,
        'pegawai_id'     : pegawai_id,
        'alasan_cuti'    : valueIjinPenting.text,
        'periode'        : valuePeriode.text,
        'jenis_ijin'     : valueJenis.text,
        'tanggal_awal'   : valueTglAwal.text,
        'tanggal_akhir'  : valueTglAkhir.text,
        'keterangan'     : valueKeterangan.text,
        'validate_atasan': valueAtasan.text,
        'jam'            : valueJam.text,
      };
      Services().postApi('postKetidakhadiran', data).then((val) async {
        setState(() {
          _isLoadingSubmit = false;
        });
        // print(val);
        if (val['api_status'] == 1) {
          setState(() {
            _isLoadingSubmit = false;
          });
          // print('sukses');
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

  getData() async {
    if(!mounted) return;
    if(widget.id == null){
      setState(() {
        _isReady = true;
      });
      return;
    }
    var pegawai_id = await Services().getSession('pegawai_id');
    await Services().getApi('getKetidakhadiranDetail', "pegawai_id=${pegawai_id}&id=${widget.id}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          valueJenis.text       = val['data']['IJIN_ID'];
          valueIjinPenting.text = val['data']['CUTI_PENTING'];
          valueKeterangan.text  = val['data']['KETERANGAN'];
          valueTglAwal.text     = val['data']['TGL_AWAL'];
          valueTglAkhir.text    = val['data']['TGL_AKHIR'];
          valueAtasan.text      = val['data']['VALIDATE_PEJABAT'];
          valueJam.text         = val['data']['JAM'];
          _isReady              = true;
        });
      }
    });
    // print("running $mounted");
  }

  @override
  void initState() {
    getData().then((value) => 
      {
        getListJenisIjin(),
        getListAtasan(),
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar(widget.id == null ? 'Tambah Ketidakhadiran' : 'Ubah Ketidakhadiran'),
      body: Container(
        margin: EdgeInsets.only(right: 15, left: 15, top: 10, bottom: 30),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
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
                          label       : 'Tanggal Permohonan',
                          initialValue: DateFormat('d MMMM y', 'id_ID').format(DateTime.now()),
                          disabled    : true,
                        ),
                        FormSelect(
                          label          : 'Jenis Ijin',
                          option         : optionJenisIjin,
                          valueController: valueJenis,
                          refreshData: (){
                            setState(() {
                              valueJenis.text = valueJenis.text;
                            });
                          },
                        ),
                        valueJenis.text == '11' ? 
                        FormSelect(
                          label          : 'Alasan',
                          option         : optionIjinPenting,
                          valueController: valueIjinPenting,
                        ) : Container(),
                        valueJenis.text == '10' ? 
                        Column(
                          children: [
                            FormSelect(
                              label          : 'Periode',
                              option         : optionPeriode,
                              valueController: valuePeriode,
                              refreshData: (){
                                setState(() {
                                  valuePeriode.text = valuePeriode.text;
                                });
                              },
                            ),
                            Text('Sisa Cuti: ' + optionPeriode.firstWhere((value) => value['value'] == valuePeriode.text)['cuti'])
                          ],
                        ) : Container(),
                        valueJenis.text == '26' || valueJenis.text == '27' ? 
                        Column(
                          children: [
                            FormSelect(
                              label          : 'Periode',
                              option         : optionPeriode,
                              valueController: valuePeriode,
                              refreshData: (){
                                setState(() {
                                  valuePeriode.text = valuePeriode.text;
                                });
                              },
                            ),
                            Text('Sisa Cuti: ' + optionPeriode.firstWhere((value) => value['value'] == valuePeriode.text)['setengah'])
                          ],
                        ) : Container(),
                        FormDate(
                          label          : 'Tanggal Awal',
                          valueController: valueTglAwal,
                          isLoading      : !_isReady,
                        ),
                        valueJenis.text != '31' ? 
                        FormDate(
                          label          : 'Tanggal Akhir',
                          valueController: valueTglAkhir,
                          isLoading: !_isReady,
                        ) : Container(),
                        valueJenis.text == '31' ? 
                        Container(
                          margin: FormMargin,
                          child: new TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Jam',
                              contentPadding: EdgeInsets.all(5),
                              suffixIcon: Icon(MdiIcons.clock)
                            ),
                            readOnly: true,
                            enabled: true,
                            validator: (val){
                              if (val!.isEmpty && valueJenis.text == '31') {
                                return 'Jam is empty';
                              }
                            },
                            controller: valueJam,
                            onTap: () async{
                              FocusScope.of(context).requestFocus(new FocusNode());
                              TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: const TimeOfDay(hour: 8, minute: 0),
                              );
                              if (picked != null) {
                              valueJam.text = picked.to24hours();
                            }
                            },
                            onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          ),
                        ) : Container(),
                        FormText(
                          label          : 'Keterangan',
                          valueController: valueKeterangan,
                          isLoading      : !_isReady,
                        ),
                        FormSelect(
                          label          : 'Persetujuan Atasan',
                          option         : optionAtasan,
                          valueController: valueAtasan,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                    submitForm();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    child: widget.id == null ? Text('SIMPAN') : Text('UBAH')
                  ),
                )
            )
          ],
        ),
      )
    );
  }
}