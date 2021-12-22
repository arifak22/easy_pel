import 'dart:math';

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/pages/profile/detail_screen.dart';
import 'package:easy_pel/pages/profile/hukuman_screen.dart';
import 'package:easy_pel/pages/profile/jabatan_screen.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
// import 'package:easy_pel/camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_pel/helpers/services.dart';
class ViewScreen extends StatefulWidget {
  @override
  State<ViewScreen> createState() => ViewScreenState();
}
class ViewScreenState extends State<ViewScreen> {
  late ProgressDialog pr;
  String  pId              = '0';
  String  nama             = 'Pelindo Energi Logistik';
  String  jabatan          = '-';
  String  cuti_full        = '-';
  String  cuti_setengah    = '-';
  String  cuti_besar       = '-';
  int     status           = 0;
  int     status_pengajuan = -9;
  bool    isReady          = false;
  dynamic data             = [];
  String randomFoto = '';
  Future<void> submitLogout() async {
    pr.show();
    var fcm    = await Services().getSession('fcm');
    var data = {
      'token'             : fcm,
    };
    Services().postApi('Logout', data).then((val) async {
      pr.hide();
      if (val['api_status'] == 1) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushNamedAndRemoveUntil(context, '/', (Route route)=>false);
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
  }

  Future<void> getData() async {
    if(!mounted) return;
    var pegawai_id = await Services().getSession('pegawai_id');
    var toNama = await Services().getSession('name');
    var rand = await Services().getSession('foto');
    setState(() {
      randomFoto = rand;
    });
    Services().getApi('getProfile', "pegawai_id=${pegawai_id}").then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          nama             = toNama;
          pId              = pegawai_id;
          jabatan          = val['data']['JABATAN'];
          data             = val['data'];
          status           = val['status'];
          status_pengajuan = val['status_pengajuan'];
          cuti_full        = val['cuti']['cuti_full'];
          cuti_setengah    = val['cuti']['cuti_setengah'];
          cuti_besar       = val['cuti']['cuti_besar'] ?? '0';
          isReady          = true;
        });
        // print(status_pengajuan);
      }else{
        setState(() {
          nama    = toNama;
          isReady = false;
        });
      }
    });
  }
  Widget RoundCuti(color, jumlah, title){
    double fSize = 20;
    if (jumlah.length > 3){
      fSize = 11;
    }
    return 
      Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: color,
                width: 4
              ),
              borderRadius: BorderRadius.all(Radius.circular(100),),
            ),
            child: SizedBox(
              width : 50,
              height: 50,
              child : Center(
                child: Text(jumlah, style: TextStyle(fontSize: fSize, fontWeight: FontWeight.bold))
              )
            )
          ),
          Text(title)
        ],
      );
  }
  
  Widget ListMenu(icon, title, screen, refresh){
    return InkWell(
      onTap: (){
        if(isReady){
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen )).then((value) => 
            {
              if(refresh)
              getData()
            }
          );
        }
      },
      child: Container(
          decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: MyColor('line'), width: 2))
        ),
        padding: EdgeInsets.only(bottom: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(icon, size: 25),
                Container(width: 15,),
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
            Center(child: Icon(Icons.arrow_forward_ios, size: 20,))
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    double width = MediaQuery.of(context).size.width;
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
    final Color background = MyColor('primary');
    final Color fill = MyColor('bg');
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    final double fillPercent = 70.00; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return new Scaffold(
      body: Container(
        width: double.infinity,
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
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Hero(
                          tag: 1,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.network(
                                pId != '0' ? urlAPi("getFoto", param: '?pegawai_id=${pId}&number=${randomFoto}') : urlAPi("getFoto"),
                                fit: BoxFit.cover,
                                width: 55,
                                height: 55,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: width - (30 + 80 + 40 + 10 + 20), height: 25, child: Text(nama, maxLines:1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)),
                              SizedBox(width: width - (30 + 80 + 40 + 10 + 20), height: 25, child: Text(jabatan, maxLines:1, overflow: TextOverflow.fade, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                              // Text('Pembantu Pelaksana II', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            submitLogout();
                          },
                          color: Colors.white,
                          icon: Icon(Icons.logout_sharp),
                        )
                      ],
                    ),
                  )
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 35),
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: HexColor('#FFFFFF'),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: MyColor('line'))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text('CUTI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          padding: EdgeInsets.only(bottom: 15, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(color: MyColor('line'), width: 2))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RoundCuti(Colors.red, cuti_full, 'Tahunan'),
                              RoundCuti(Colors.blue, cuti_setengah, '1/2 Hari'),
                              RoundCuti(Colors.green, cuti_besar, 'Besar'),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                          child: Column(
                            children: [
                              ListMenu(Icons.document_scanner, 'Data Diri', DetailScreen(data: data, status:status, statusPengajuan: status_pengajuan), true),
                              // ListMenu(Icons.drive_folder_upload_rounded, 'Dokumen'),
                              ListMenu(Icons.badge_sharp, 'Histori Jabatan', JabatanScreen(), false),
                              ListMenu(Icons.assistant_photo, 'Hukuman', HukumanScreen(), false),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}