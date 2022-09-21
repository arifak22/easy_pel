import 'package:flutter/material.dart';
import 'package:easy_pel/pages/main/presensi/list_screen.dart' as Presensi;
import 'package:easy_pel/pages/main/penghasilan/view_screen.dart' as Penghasilan;
import 'package:easy_pel/pages/main/ketidakhadiran/view_screen.dart' as Ketidakhadiran;
import 'package:easy_pel/pages/main/check/view_screen.dart' as Check;
import 'package:easy_pel/pages/main/sip/view_screen.dart' as Sip;

class Menu {
  int menuID;
  String name;
  String imageAsset;
  String description;
  dynamic screen;
  // Class screen;
 
  Menu({
    required this.menuID,
    required this.name,
    required this.imageAsset,
    required this.description,
    required this.screen
    // required this.screen,
  });
}

var menuList = [
  Menu(menuID: 1, name: 'Presensi', imageAsset: 'lib/assets/icon/clock.png', description: 'Presensi', screen: Presensi.ListScreen()),
  Menu(menuID: 2, name: 'Penghasilan', imageAsset: 'lib/assets/icon/salary.png', description: 'Penghasilan', screen: Penghasilan.ViewScreen()),
  Menu(menuID: 3, name: 'Ketidakhadiran', imageAsset: 'lib/assets/icon/attendance.png', description: 'Ketidakhadiran', screen: Ketidakhadiran.ViewScreen()),
  Menu(menuID: 4, name: 'Check App', imageAsset: 'lib/assets/icon/checking.png', description: 'Checking App', screen: Check.ViewScreen()),
  Menu(menuID: 5, name: 'PEL - SIP', imageAsset: 'lib/assets/icon/helmet.png', description: 'PEL - SIP', screen: Sip.ViewScreen()),
];