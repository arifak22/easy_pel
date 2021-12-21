import 'dart:io';
import 'dart:math';

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget{
  final dynamic data;
  final int status;
  final int statusPengajuan;
  DetailScreen({required this.data, required this.status, required this.statusPengajuan});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController valueNrp           = TextEditingController();
  TextEditingController valueNama          = TextEditingController();
  TextEditingController valueUnit          = TextEditingController();
  TextEditingController valueAgama         = TextEditingController();
  TextEditingController valueJenisKelamin  = TextEditingController();
  TextEditingController valueStatusPegawai = TextEditingController();
  TextEditingController valueNoKtp         = TextEditingController();
  TextEditingController valueTempatLahir   = TextEditingController();
  TextEditingController valueTanggalLahir  = TextEditingController();
  TextEditingController valueGolDarah      = TextEditingController();
  TextEditingController valueTinggiBadan   = TextEditingController();
  TextEditingController valueBeratBadan    = TextEditingController();
  TextEditingController valueHobi          = TextEditingController();
  TextEditingController valueStatusNikah   = TextEditingController();
  TextEditingController valueAlamat        = TextEditingController();
  TextEditingController valueNoTelepon     = TextEditingController();
  TextEditingController valueEmail         = TextEditingController();
  TextEditingController valueBank          = TextEditingController();
  TextEditingController valueNoRekening    = TextEditingController();
  TextEditingController valueNamaRekening  = TextEditingController();
  TextEditingController valueNoNpwp        = TextEditingController();
  TextEditingController valueTglNpwp       = TextEditingController();
  TextEditingController valueNoBpjs        = TextEditingController();
  // TextEditingController valueTglBpjs         = TextEditingController();
  TextEditingController valueNoBpjsKesehatan = TextEditingController();
  String                pId                  = '0';
  bool                  loadingData          = true;
  int                   activePage           = 0;
  dynamic               optionBank           = [];
  bool                  isUpdated            = true;
  bool                  _isLoading           = false;
  String                randomFoto           = '';
  File? valueFile;

  late ProgressDialog pr;

  late SharedPreferences preferences;


  final _formKey = GlobalKey<FormState>();


  getListBank() async {
    var pegawai_id = await Services().getSession('pegawai_id');
    await Services().getApi('getBank', "pegawai_id=${pegawai_id}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          optionBank = val['data'];
        });
      }else{
        setState(() {
          optionBank = [];
        });
      }
    });
  }
  Future<void> getData() async {
    var rand = await Services().getSession('foto');

    setState(() {
      loadingData               = false;
      valueNrp.text             = widget.data['NRP'];
      valueNama.text            = widget.data['NAMA'];
      valueUnit.text            = widget.data['DEPARTEMEN'];
      valueAgama.text           = widget.data['AGAMA'];
      valueJenisKelamin.text    = widget.data['JENIS_KELAMIN'] == 'L' ? 'Laki-laki' : 'Perempuan';
      valueStatusPegawai.text   = widget.data['STATUS_PEGAWAI'];
      valueNoKtp.text           = widget.data['NO_KTP'];
      valueTempatLahir.text     = widget.data['TEMPAT_LAHIR'];
      valueTanggalLahir.text    = widget.data['TGL_LAHIR'];
      valueGolDarah.text        = widget.data['GOLONGAN_DARAH'];
      valueTinggiBadan.text     = widget.data['TINGGI'];
      valueBeratBadan.text      = widget.data['BERAT_BADAN'];
      valueHobi.text            = widget.data['HOBI'];
      valueStatusNikah.text     = widget.data['TANGGUNGAN'];
      valueAlamat.text          = widget.data['ALAMAT'];
      valueNoTelepon.text       = widget.data['TELEPON'];
      valueEmail.text           = widget.data['EMAIL'];
      valueBank.text            = widget.data['BANK_ID'];
      valueNoRekening.text      = widget.data['REKENING_NO'];
      valueNamaRekening.text    = widget.data['REKENING_NAMA'];
      valueNoNpwp.text          = widget.data['NPWP'];
      valueTglNpwp.text         = widget.data['TGL_NPWP'];
      valueNoBpjs.text          = widget.data['BPJS_NO'];
      valueNoBpjsKesehatan.text = widget.data['JAMSOSTEK_NO'];
      randomFoto                = rand;
    });
  }

  Widget TabMenuList(title, page, isActive2){
    bool isActive = page == activePage ? true : false;
    return InkWell(
      onTap: (){
        setState(() {
          activePage = page;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 5, bottom: 5),
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
        decoration: BoxDecoration(
            // color: HexColor('#FFFFFF'),
            color: isActive ? MyColor('primary') : HexColor('#FFFFFF'),
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border.all(color: MyColor('line'))
        ),
        // child: Text(title),
        child: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.black),),
      ),
    );
  }

  Future<void> simpan() async {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      var pegawai_id    = await Services().getSession('pegawai_id');
      var data = {
        'id'            : pegawai_id,
        'pegawai_id_ess': widget.data['PEGAWAI_ID_ESS'],
        'no_ktp'        : valueNoKtp.text,
        'tempat_lahir'  : valueTempatLahir.text,
        'tanggal'       : valueTanggalLahir.text,
        'golongan_darah': valueGolDarah.text,
        'tinggi_badan'  : valueTinggiBadan.text,
        'berat_badan'   : valueBeratBadan.text,
        'hobbi'         : valueHobi.text,
        'alamat_ktp'    : valueAlamat.text,
        'telepon'       : valueNoTelepon.text,
        'email'         : valueEmail.text,
        'bank_id'       : valueBank.text,
        'no_rekening'   : valueNoRekening.text,
        'nama_rekening' : valueNamaRekening.text,
        'npwp'          : valueNoNpwp.text,
        'tgl_npwp'      : valueTglNpwp.text,
        'jamsostek'     : valueNoBpjsKesehatan.text,
        'bpjs'          : valueNoBpjs.text,
      };
      Services().postApi('postProfile', data).then((val) async {
        setState(() {
          _isLoading = false;
        });
        // print(val);
        if (val['api_status'] == 1) {
          setState(() {
            _isLoading = false;
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

  Future<void> kirimData() async {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      var pegawai_id    = await Services().getSession('pegawai_id');
      var data = {
        'id'            : pegawai_id,
      };
      Services().postApi('postKirimProfile', data).then((val) async {
        setState(() {
          _isLoading = false;
        });
        // print(val);
        if (val['api_status'] == 1) {
          setState(() {
            _isLoading = false;
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

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      File file = File(result.files.single.path ?? '');
      String basename = file.path.split('/').last;
      setState(() {
        valueFile          = file;
      });
    } else {
      setState(() {
        valueFile          = null;
      });
    }
  }

  executePhoto() async {
    preferences = await SharedPreferences.getInstance();
    int max = 999999;
    int randomNumber = Random().nextInt(max);
    pr.show();
      var pegawai_id    = await Services().getSession('pegawai_id');

      var data = {
        'pegawai_id'     : pegawai_id,
      };
      Services().postApiFile('postFotoProfile', data, {'file' : valueFile!.path}).then((val) async {
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
            ),
            preferences.setString('foto', randomNumber.toString()),
            print(randomNumber.toString())
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getListBank();
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
    
    String keteranganKirim = '';
    if(widget.status != 0){
      if(widget.statusPengajuan == 3){
        keteranganKirim = 'Perubahan data telah di-Approve';
      }else if(widget.statusPengajuan == -3){
        keteranganKirim = 'Perubahan data telah di-Tolak (Keterangan: ' + widget.data['UPDATE_STATUS_KETERANGAN'] + ')';
      }else if(widget.statusPengajuan == 2){
        keteranganKirim = 'Perubahan data sedang proses validasi';
      }
    }

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
      appBar: AppBar(
        title          : Text('Data Diri', style: TextStyle(color: Colors.white)),
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
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 35),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: HexColor('#FFFFFF'),
              // borderRadius: BorderRadius.all(Radius.circular(25)),
              // border: Border.all(color: MyColor('line'))
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    child: InkWell(
                      onTap: (){
                        if(valueFile != null){
                          showDialog(context: context, builder: (_) =>AlertDialog(
                              title: Text('Warning'),
                              content: Text('Apakah anda yakin merubah Foto?'),
                              actions: <Widget>[
                                  OutlinedButton(
                                    onPressed: ()=> {
                                      Navigator.pop(context),
                                      setState(() {
                                        valueFile = null;
                                      })
                                    }, child: Text('Hapus')
                                  ),
                                  ElevatedButton(
                                    onPressed: ()=> {
                                      Navigator.pop(context),
                                      executePhoto()
                                    }, child: Text('Ya'),
                                  ),
                                ],
                            ));
                        }else{
                          this.pickFile();
                        }
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Hero(
                              tag: 1,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blue,
                                child: ClipOval(
                                  child: valueFile != null ? Image.file(valueFile!, fit: BoxFit.cover, width: 75, height: 75,) : Image.network(
                                    urlAPi("getFoto", param: '?pegawai_id=${widget.data['PEGAWAI_ID']}&random=${randomFoto}'),
                                    // pId != '0' ? urlAPi("getFoto", param: '?pegawai_id=191') : urlAPi("getFoto"),
                                    fit: BoxFit.cover,
                                    width: 75,
                                    height: 75,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            margin   : EdgeInsets.only(bottom:5),
                            child    : Text( valueFile != null ? 'Simpan' : 'Ubah', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),)
                          )
                        ],
                      ),
                    ),
                  ),
                  // Text('Ubah Foto'),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // margin: EdgeInsets.only(left: 15, bottom: 10, right: 10),
                          child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                            child:  Row(
                              children: <Widget>[
                                TabMenuList('Data Pegawai', 0, true),
                                TabMenuList('Data Pribadi', 1, false),
                                TabMenuList('Rekening, NPWP, BPJS', 2, false),
                              ]
                            )
                          )
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: activePage == 0 ? true : false,
                    child: Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            FormText(
                                label          : 'NRP',
                                valueController: valueNrp,
                                disabled       : true,
                                isLoading      : loadingData,
                              ),
                              FormText(
                                label          : 'Nama',
                                valueController: valueNama,
                                disabled       : true,
                                isLoading      : loadingData,
                              ),
                              FormText(
                                label          : 'Unit Kerja',
                                valueController: valueUnit,
                                disabled       : true,
                                isLoading      : loadingData,
                              ),
                              FormText(
                                label          : 'Agama',
                                valueController: valueAgama,
                                disabled       : true,
                                isLoading      : loadingData,
                              ),
                              FormText(
                                label          : 'Jenis Kelamin',
                                valueController: valueJenisKelamin,
                                disabled       : true,
                                isLoading      : loadingData,
                              ),
                              FormText(
                                label          : 'Status Pegawai',
                                valueController: valueStatusPegawai,
                                disabled       : true,
                                isLoading      : loadingData,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: activePage == 1 ? true : false,
                    child: Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            FormText(
                              label          : 'Nomor KTP',
                              valueController: valueNoKtp,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'Tempat Lahir',
                              valueController: valueTempatLahir,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormDate(
                              label          : 'Tanggal Lahir',
                              valueController: valueTanggalLahir,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'Golongan Darah',
                              valueController: valueGolDarah,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'Tinggi Badan',
                              valueController: valueTinggiBadan,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'Berat Badan',
                              valueController: valueBeratBadan,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'Hobi',
                              valueController: valueHobi,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'Status Nikah',
                              valueController: valueStatusNikah,
                              isLoading      : loadingData,
                              disabled       : true,
                            ),
                            FormText(
                              label          : 'Alamat KTP',
                              valueController: valueAlamat,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'No Telepon',
                              valueController: valueNoTelepon,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'E-mail',
                              valueController: valueEmail,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: activePage == 2 ? true : false,
                    child: Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            FormSelect(
                              label          : 'Bank',
                              option         : optionBank,
                              valueController: valueBank,
                              disabled       : !isUpdated,
                              // refreshData: (){
                              //   setState(() {
                              //     valueBank.text = valueBank.text;
                              //   });
                              // },
                            ),
                            FormText(
                              label          : 'No Rekening',
                              valueController: valueNoRekening,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'Nama Rekening',
                              valueController: valueNamaRekening,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'NPWP',
                              valueController: valueNoNpwp,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormDate(
                              label          : 'Tanggal NPWP',
                              valueController: valueTglNpwp,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'BPJS Ketenagakerjaan',
                              valueController: valueNoBpjs,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                            FormText(
                              label          : 'BPJS Kesehatan',
                              valueController: valueNoBpjsKesehatan,
                              isLoading      : loadingData,
                              disabled       : !isUpdated,
                            ),
                          ]
                        )
                      )
                    )
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(keteranganKirim),
                        Row(
                          children: [
                            widget.statusPengajuan != 2 ? Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(right: 5, left: 5),
                                child: ElevatedButton(
                                  onPressed: !_isLoading ? (){
                                    showDialog(context: context, builder: (_) =>AlertDialog(
                                      title: Text('Warning'),
                                      content: Text('Apakah anda yakin menyimpan data ini?'),
                                      actions: <Widget>[
                                          OutlinedButton(
                                            onPressed: ()=>Navigator.pop(context), child: Text('Tidak')
                                          ),
                                          ElevatedButton(
                                            onPressed: ()=> {
                                              Navigator.pop(context),
                                              simpan()
                                            }, child: Text('Ya'),
                                          ),
                                        ],
                                    ));
                                    
                                  } : null,
                                  child: Text('Simpan'),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(13),
                                      primary: MyColor('primary'),
                                      onPrimary: Colors.white,
                                    ),
                                ),
                              ),
                            ) : Container(),
                            widget.status != 0  && widget.statusPengajuan == 1 ? 
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(right: 5, left: 5),
                                child: ElevatedButton(
                                  onPressed: !_isLoading ? (){
                                    showDialog(context: context, builder: (_) =>AlertDialog(
                                        title: Text('Warning'),
                                        content: Text('Apakah anda yakin mengirim data ini ke SDM?'),
                                        actions: <Widget>[
                                            OutlinedButton(
                                              onPressed: ()=>Navigator.pop(context), child: Text('Tidak')
                                            ),
                                            ElevatedButton(
                                              onPressed: ()=> {
                                                Navigator.pop(context),
                                                kirimData()
                                              }, child: Text('Ya'),
                                            ),
                                          ],
                                      ));
                                  } : null,
                                  child:Text('Kirim Data'),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(13),
                                      primary: Colors.green,
                                      onPrimary: Colors.white,
                                    ),
                                ),
                              ),
                            ) : Container() ,
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          )
        )
      )
     );
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }