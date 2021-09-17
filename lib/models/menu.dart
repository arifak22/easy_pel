import 'package:flutter/material.dart';
import 'package:easy_pel/pages/main/presensi/list_screen.dart' as Presensi;
import 'package:easy_pel/pages/main/penghasilan/view_screen.dart' as Penghasilan;

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
];