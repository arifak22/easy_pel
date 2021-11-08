import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget{
  final dynamic data;
  DetailScreen({required this.data});
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
  bool                  isUpdated            = false;
  bool                  _isLoading           = false;


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
  void getData(){
    print(widget.data);
    setState(() {
      loadingData             = false;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  child: ClipOval(
                    child: Image.network(
                      urlAPi("getFoto", param: '?pegawai_id=${widget.data['PEGAWAI_ID']}'),
                      // pId != '0' ? urlAPi("getFoto", param: '?pegawai_id=191') : urlAPi("getFoto"),
                      fit: BoxFit.cover,
                      width: 75,
                      height: 75,
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
                // Container(
                //   margin: EdgeInsets.all(10),
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: !_isLoading ? (){
                //       // submitPresensi();
                //     } : null,
                //     child: _isLoading
                // ? SizedBox(
                //     height: 25,
                //     width: 25,
                //     child: CircularProgressIndicator(color: Colors.white,),
                //   )
                // : Text('Ubah'),
                //     style: ElevatedButton.styleFrom(
                //       // elevation: 30,
                //       // shape: new RoundedRectangleBorder(
                //       //   borderRadius: new BorderRadius.circular(30.0),
                //       // ),
                //       // shape: CircleBorder(),
                //       padding: EdgeInsets.all(13),
                //       primary: MyColor('primary'),
                //       onPrimary: Colors.white,

                //     ),
                //   ),
                // )
              ],
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