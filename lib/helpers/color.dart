import 'package:flutter/material.dart';


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class MyColor extends Color {

  static int _getColorFromHex(String type) {
    String hexColor = '#FFFFFF';
    if(type == 'primary'){
      // hexColor = '#00599D';
      hexColor = '#0280bf';
    }else if(type == 'default'){
      hexColor = '#FFFFFF';
    }else if(type == 'bg'){
      hexColor = '#EBF0F9';
    }else if(type == 'line'){
      hexColor = '#C4C4C4';
    }else if(type == 'font-default'){
      hexColor = '#000000';
    }else if(type == 'font-bg'){
      hexColor = '#4A667B';
    }
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  MyColor(final String type) : super(_getColorFromHex(type));
}