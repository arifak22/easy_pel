
import 'dart:async';
import 'dart:convert';

import 'package:easy_pel/camera/camera.dart';
import 'package:easy_pel/camera/preview.dart';
import 'package:easy_pel/pages/main/presensi/history_screen.dart';

import 'package:easy_pel/pages/main/check/location/view_screen.dart';

// import 'package:easy_pel/camera/stack.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_pel/helpers/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_pel/helpers/widget.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  late Timer _timer;
  //Init Variable
  late Position _position;
  CameraPosition currentPostion = CameraPosition(
    target: LatLng(-7.2098737, 112.7261839),
    zoom  : 16
  );

  late bool isTrue = false;
  late bool _isLoading = false;
  String waktuText = DateFormat('d MMMM y - hh:mm:ss', 'id_ID').format(DateTime.now());
  String waktu = DateFormat('y-m-d hh:mm:ss').format(DateTime.now());
  double radius = 1000.00;
  String imgPath = '';
  Set<Circle> circles = Set.from([
    Circle(
        fillColor: Color.fromRGBO(230,238,255,0.7),
        strokeColor: HexColor('#1A66FF'),
        strokeWidth: 1,
        circleId: CircleId('1'),
        center: LatLng(-7.2098737, 112.7261839),
        radius: 1000,
    )
  ]);

  void _add() async{
    if(!mounted) return;
    var validDistance = false;
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    List<dynamic>  circleList = [];
    preferences = await SharedPreferences.getInstance();
    var posList = json.decode(preferences.getString('position'));
    var i = 0;
    for(var pos in posList){
      circleList.add(Circle(
          circleId   : CircleId(i.toString()),
          fillColor  : Color.fromRGBO(230,238,255,0.7),
          strokeColor: HexColor('#1A66FF'),
          strokeWidth: 1,
          center     : LatLng(double.parse(pos['LATITUDE']), double.parse(pos['LONGITUDE'])),
          radius     : 1000,
      ));
      var _distanceInMeters = await Geolocator.distanceBetween(
        double.parse(pos['LATITUDE']), double.parse(pos['LONGITUDE']),
        position.latitude, position.longitude
      );

      if(_distanceInMeters <= radius){
        validDistance = validDistance || true;
      }else{
        validDistance = validDistance|| false;
      }

      i++;
    }
    

    var markerIdVal = 'Posisi Saya';
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: markerIdVal),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );
    setState(() {
      // adding a new marker to map
      markers[markerId]      = marker;

      _position      = position;
      isTrue         = validDistance;
      circles        = Set.from(circleList);
      // currentPostion = CameraPosition(
      //   target: LatLng(position.latitude, position.longitude),
      //   zoom  : 16
      // );
    });
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
        zoom  : 16
    )));
  }
  Future<void> getWaktu() async {
    if(!mounted) return;
    var zona_waktu    = await Services().getSession('zona_waktu');
    Services().getApi('Waktu', 'zona=${zona_waktu}').then((val) {
      if (val['api_status'] == 1) {
        setState(() {
          waktuText = val['waktu_format'];
          waktu     = val['format'];
        });
      }else{
        setState(() {
          waktuText = DateFormat('d MMMM y - HH:mm:ss', 'id_ID').format(DateTime.now());
          waktu     = DateFormat('y-MM-dd HH:mm:ss').format(DateTime.now());
        });
      }
    });
    // print("running $mounted");
  }

  @override
  void initState() {
    this._add();
    _timer = Timer.periodic(Duration(seconds:1), (Timer t)=> 
      getWaktu()
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  late SharedPreferences preferences;
  late Map<String, dynamic> data;
  Future <void> submitPresensi() async {
      setState(() {
        _isLoading = true;
      });
      Timer timer = new Timer(new Duration(seconds: 3), () async {
        var pegawai_id    = await Services().getSession('pegawai_id');
        var data = {
          'waktu'     : waktu,
          'pegawai_id': pegawai_id,
          'latitude'  : _position.latitude.toString(),
          'longitude' : _position.longitude.toString(),
        };
        print(data);
        Services().postApi('postLokasi', data).then((val) async {
          if (val['api_status'] == 1) {
            setState(() {
              _isLoading = false;
              imgPath = '';
            });
            showDialog(context: context, builder: (_) =>AlertDialog(
              title: Text('Berhasil'),
              content: Text('${val['api_message']}'),
              actions: <Widget>[ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Ok'))],
            )).then((value) => {
              Navigator.pop(context)
            });
          }else{
            setState(() {
              _isLoading = false;
            });
            showDialog(context: context, builder: (_) =>AlertDialog(
              title: Text('Something wrong'),
              content: Text('${val['api_message']}'),
              actions: <Widget>[ElevatedButton(onPressed: ()=>{Navigator.pop(context)}, child: Text('Ok'))],
            ));
          }
        });
        debugPrint("Print after 5 seconds");
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Tambah Lokasi'),
      body: Container(
        child: Column(
          children:  <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width  : double.infinity,
                margin : EdgeInsets.all(20),
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: HexColor('#FFFFFF'),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Text(waktuText, 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      ),
                      Column(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),

                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  heightFactor: 0.3,
                                  widthFactor: 2.5,
                                  child: GoogleMap(
                                    mapType: MapType.normal,
                                    circles: circles,
                                    initialCameraPosition: currentPostion,
                                    markers: Set<Marker>.of(markers.values),
                                    
                                    onMapCreated: (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 35, left: 50, right: 50),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_isLoading ? (){
                  submitPresensi();
                } : null,
                child: _isLoading
            ? SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(color: Colors.white,),
              )
            : Text('Simpan Lokasi'),
                style: ElevatedButton.styleFrom(
                  // elevation: 30,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  // shape: CircleBorder(),
                  padding: EdgeInsets.all(13),
                  primary: MyColor('primary'),
                  onPrimary: Colors.white,

                ),
              ),
            )
          ]
        )
      )
    );
  }
}