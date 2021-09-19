import 'package:flutter/material.dart';
import 'package:easy_pel/helpers/color.dart';
import 'package:intl/intl.dart';

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

const List<String> months = const <String>[
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

const List<String> value_months = const <String>[
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
];

const List<String> years = const <String>[
  '2019',
  '2020',
  '2021',
  '2022',
  '2023',
  '2024',
  '2025',
  '2026',
  '2027',
];

String toNumberRupiah(value){
  return 'Rp. ${NumberFormat.decimalPattern('id_ID').format(value)}';
}