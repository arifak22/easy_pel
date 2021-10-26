import 'dart:async';

import 'package:easy_pel/helpers/color.dart';
import 'package:easy_pel/helpers/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class DetailScreen extends StatefulWidget{
  dynamic data;
  DetailScreen({required this.data});
  @override
  State<DetailScreen> createState() => _DetailScreenState(data);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(data);
  
  @override
  Widget build(BuildContext context) {

    Completer<GoogleMapController> _controller = Completer();
    CameraPosition currentPostion = CameraPosition(
      target: LatLng(double.parse(widget.data['LATITUDE']), double.parse(widget.data['LONGITUDE'])),
      zoom  : 16
    );

    Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; 

    var markerIdVal = 'Posisi Saya';
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(double.parse(widget.data['LATITUDE']), double.parse(widget.data['LONGITUDE'])),
      infoWindow: InfoWindow(title: markerIdVal),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );
    markers[markerId]      = marker;
    print(widget.data);
    return new Scaffold(
      appBar: appBar('Detil Lokasi'),
      body:Container(
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
                        child: Text(widget.data['TANGGAL'] + ' - ' + widget.data['JAM'], 
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
          ]
        )
      )
    );
  }
}