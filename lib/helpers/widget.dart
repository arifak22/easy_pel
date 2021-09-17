import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';

PreferredSizeWidget appBar(String text) {
  return AppBar(
        title          : Text(text, style: TextStyle(color: Colors.black)),
        elevation      : 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: HexColor('#FFFFFF'),
      );
}