import 'package:easy_pel/helpers/services.dart';
import 'package:flutter/material.dart';
import 'package:easy_pel/pages/main/check/view_screen.dart' as MenuChecking;
import 'package:easy_pel/pages/main/check/selfcheck/view_screen.dart' as MenuSelfcheck;
import 'package:easy_pel/pages/main/check/location/view_screen.dart' as MenuLocation;

import 'package:easy_pel/pages/main/ketidakhadiran/detail_screen.dart' as DetailKetidakhadiran;
import 'package:shared_preferences/shared_preferences.dart';


Future<void> handleNotif(data, context) async {
  var type = data['type'];
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getString('token') != appVersion()) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (Route route)=>false);
  }else{
    if(type != ''){
      Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
      switch (type) {
        case '1': //GO TO LIST SELFCHECK
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuChecking.ViewScreen()),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuSelfcheck.ViewScreen()),
          );
        break;

        case '2': //GO TO APPROVAL ATASAN #ID
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailKetidakhadiran.DetailScreen(id: data['id'],jenis: '0')),
          );
        break;

        case '3': //GO TO APPROVAL MANAJER SDM #ID
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailKetidakhadiran.DetailScreen(id: data['id'],jenis: '1')),
          );
        break;

        case '4': //GO TO APPROVAL SENIOR MANAJER SDM #ID
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailKetidakhadiran.DetailScreen(id: data['id'],jenis: '2')),
          );
        break;

        case '5': //GO TO LIST PENGAJUAN IJIN(SETUJU) PEGAWAI WITH #ID
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailKetidakhadiran.DetailScreen(id: data['id'],jenis: '10')),
          );
        break;

        case '6': //GO TO LIST PENGAJUAN IJIN(TOLAK) PEGAWAI WITH #ID
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailKetidakhadiran.DetailScreen(id: data['id'],jenis: '10')),
          );
        break;

        case '7': //GO TO SHARE LOCATION 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuChecking.ViewScreen()),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuLocation.ViewScreen()),
          );
        break;

        default:
      }
    }
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => ListScreen()),
      // );
  }
}