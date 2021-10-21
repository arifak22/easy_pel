

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

  
  Future<void> submitLogout() async {
    pr.show();
    var fcm    = await Services().getSession('fcm');
    print(fcm);
    // return;
    var data = {
      'token'             : fcm,
    };
    Services().postApi('Logout', data).then((val) async {
      pr.hide();
      // print(val);
      if (val['api_status'] == 1) {
        print(val);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushNamedAndRemoveUntil(context, '/', (Route route)=>false);
      }else{
        print(val);
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
    return new Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<dynamic>(
                future: Services().getSession('name')!,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data);
                  }
                  return CircularProgressIndicator();
                }
              ),
              InkWell(
                onTap: () async{
                  submitLogout();
                },
                child: new Text("Logout", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }
}