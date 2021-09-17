

import 'package:flutter/material.dart';
// import 'package:easy_pel/camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_pel/helpers/widget.dart';

class ViewScreen extends StatefulWidget {
  @override
  State<ViewScreen> createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: appBar('Penghasilan'),
      body: Text('Penghasilan')
    );
  }
}