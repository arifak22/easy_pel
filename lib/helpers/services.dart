import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
class Api {
  int apiID;
  String name;
  String uri;
  // Class screen;
 
  Api({
    required this.apiID,
    required this.name,
    required this.uri,
    // required this.screen,
  });
}

var apiList = [
  Api(apiID: 1, name: 'Login', uri:'login/cek_loginv4'),
  Api(apiID: 2, name: 'Logout', uri:'login/logout'),

  Api(apiID: 3, name: 'Waktu', uri:'services/datetime'),
  Api(apiID: 4, name: 'postPresensi', uri:'presensi/submit'),
  Api(apiID: 5, name: 'getPresensi', uri:'presensi/list'),
  Api(apiID: 6, name: 'postTempPresensi', uri:'presensi/submittemp'),

  Api(apiID: 7, name: 'getPenghasilan', uri:'penghasilan/data'),
  Api(apiID: 8, name: 'getKetidakhadiran', uri:'presensi/list_ketidakhadiran'),
  Api(apiID: 9, name: 'getKetidakhadiranDetail', uri:'presensi/ketidakhadiran_detail'),
  Api(apiID: 10, name: 'getLampiran', uri:'presensi/lampiran'),

  Api(apiID: 11, name: 'getApprovalAtasan', uri:'presensi/ketidakhadiran_atasan'),
  Api(apiID: 12, name: 'postApproval', uri:'presensi/approve'),
  Api(apiID: 13, name: 'getListAtasan', uri:'presensi/list_atasan'),
  Api(apiID: 14, name: 'getListJenisIjin', uri:'presensi/list_jenisijin'),
  Api(apiID: 15, name: 'getListIjinPenting', uri:'presensi/list_ijinpenting'),
  Api(apiID: 16, name: 'postKetidakhadiran', uri:'presensi/ajukan_ketidakhadiran'),
  Api(apiID: 17, name: 'postHapusKetidakhadiran', uri:'presensi/hapus_ketidakhadiran'),
  Api(apiID: 18, name: 'postLampiran', uri:'presensi/tambah_lampiran'),
  Api(apiID: 19, name: 'postHapusLampiran', uri:'presensi/hapus_lampiran'),
  Api(apiID: 20, name: 'postKirimAtasan', uri:'presensi/kirim_atasan'),

  Api(apiID: 21, name: 'version', uri:'services/version'),

  Api(apiID: 22, name: 'getSelfcheck', uri:'selfcheck/datav2'),
  Api(apiID: 23, name: 'getSoal', uri:'selfcheck/soal'),
  Api(apiID: 24, name: 'postSelfcheck', uri:'selfcheck/jawaban'),

  Api(apiID: 25, name: 'getLokasi', uri:'lokasi/datav2'),
  Api(apiID: 26, name: 'postLokasi', uri:'lokasi/simpan'),
  Api(apiID: 27, name: 'getFoto', uri:'profile/foto'),
  Api(apiID: 28, name: 'getProfile', uri:'profile/data'),

  Api(apiID: 29, name: 'getBank', uri:'profile/bank'),
  Api(apiID: 30, name: 'getJabatan', uri:'profile/jabatan'),
  Api(apiID: 31, name: 'getHukuman', uri:'profile/hukuman'),
];


isDebug() {
  return false;
}

appVersion(){
  return '1.0.3';
}

  
urlAPi(String uri, {String param = ''}){
  List<Api> apiData = apiList.where((element) => element.name == uri).toList();
  var url = apiData[0].uri;
  String baseUrl = isDebug() ?'http://localhost:8080/ci/api' :'https://imais.pel.co.id/ci/api';
  return baseUrl + '/' + url + param;
}
class Services {
  String baseUrl = isDebug() ?'http://localhost:8080/ci/api' :'https://imais.pel.co.id/ci/api';

  late SharedPreferences preferences;
  var res, jsonData;
  late Map<String, dynamic> response;
  // ignore: deprecated_member_use
  // List data = List();
  var uri;
  late String token;

  Future postLogin(String username, String password, String deviceID, String? fcm, String force) async {
    String url = '${baseUrl}/login/cek_loginv4';
    print(url);
    try {
      res = await http.post(
        Uri.parse(url),
        body: {
          'username': username,
          'password': password,
          'device'  : deviceID,
          'token'   : fcm,
          'force'   : force,
          'version' : appVersion()
        },
      ).timeout(Duration(seconds: 10));
      response = json.decode(res.body);
      print(response);
      if (res.statusCode == 200) {
        if (response['api_status'] == 1) {
          preferences = await SharedPreferences.getInstance();
          preferences.setString('token', appVersion());
          preferences.setString('id', response['data']["USER_LOGIN_ID"]);
          preferences.setString('pegawai_id', response['data']["PEGAWAI_ID"]);
          preferences.setString('name', response['data']["NAMA"]);
          preferences.setString('user_group', response['data']["USER_GROUP_ID"]);
          preferences.setString('position', json.encode(response['titik_absen']));
          preferences.setString('zona_waktu', response['titik_absen'][0]["ZONA_WAKTU"]);
          preferences.setString('temp', json.encode([]));
          preferences.setString('fcm', fcm);
          print(response['titik_absen']);
          return response;
        } else {
          print(response['api_status']);
          return response;
        }
        // preferences.setString('token', response["access_token"]);
      } else {
        // throw Exception('Something Wrong');
        response = {
          'api_status': 0,
          'api_message': 'Network Error',
        };
        return response;
      }
    } catch (e) {
      print(e);
      response = {
        'api_status': 0,
        'api_message': '$e',
      };
      return response;
    }
  }


  Future _postApi(String url, Map<String, dynamic> body) async {
    preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token')!;
    body['token'] = token;
    // print('${baseUrl}/$url');
    // print(body);
    try {
      res = await http
          .post(Uri.parse('${baseUrl}/$url'), body: body).timeout(Duration(milliseconds: 10000));
         // print(' body : ${res.body}');
      if (res.statusCode == 200) {
        jsonData = json.decode(res.body);
        return jsonData;
      } else {
        // print(res.body);
        jsonData = {
          'api_status': 0,
          'api_message': 'Network Error',
        };
        return jsonData;
      }
    } catch (e) {
     // print(e);
      jsonData = {
        'api_status': 0,
        'api_message': '$e',
      };
      return jsonData;
    }
  }

  Future postApi(String uri, Map<String, dynamic> body) async {
    preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token')!;
    // body['token'] = token;
    List<Api> apiData = apiList.where((element) => element.name == uri).toList();
    var url = apiData[0].uri;
   // print('${baseUrl}/$url');
   print(body);
    try {
      res = await http
          .post(Uri.parse('${baseUrl}/$url'),body: body).timeout(Duration(milliseconds: 10000));
        //  print(' body : ${res.body}');
      if (res.statusCode == 200) {
        jsonData = json.decode(res.body);
        return jsonData;
      } else {
       // print(res.body);
        jsonData = {
          'api_status': 0,
          'api_message': 'Network Error',
        };
        return jsonData;
      }
    } catch (e) {
    //  print(e);
      jsonData = {
        'api_status': 0,
        'api_message': '$e',
      };
      return jsonData;
    }
  }

  Future postApiFile(String _uri, Map<String, dynamic> body, Map<String, dynamic> file) async {  
      List<Api> apiData = apiList.where((element) => element.name == _uri).toList();
      var url = apiData[0].uri;  

      // string to uri
      var uri = Uri.parse('${baseUrl}/$url');

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      for (String key in file.keys){
        var imageFile = File(file[key]);
        // open a bytestream
        var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        // get file length
        var length = await imageFile.length();
        // multipart that takes file
        var multipartFile = new http.MultipartFile(key, stream, length,
            filename: basename(imageFile.path));
        // add file to multipart
        request.files.add(multipartFile);
      }

      for (String key in body.keys){
        request.fields[key] = body[key];
      }

      try{
        // send
        var response = await request.send();
        if (response.statusCode == 200) {
        //Get the response from the server
          var responseData = await response.stream.toBytes();
          var res = String.fromCharCodes(responseData);
          jsonData = json.decode(res);
          return jsonData;
        } else {
        // print(res.body);
          jsonData = {
            'api_status': 0,
            'api_message': 'Network Error',
          };
          return jsonData;
        }
      } catch (e) {
      // print(e);
        jsonData = {
          'api_status': 0,
          'api_message': '$e',
        };
        return jsonData;
      }
      // print(response.statusCode);

      // listen for response
      // response.stream.transform(utf8.decoder).listen((value) {
      //   // print(value);
      // });
    }

  Future getApi(String uri, String parameters) async {
    preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token')!;
    List<Api> apiData = apiList.where((element) => element.name == uri).toList();
    var url = apiData[0].uri;
    // print(Uri.parse('${baseUrl}/$url?token=${token}&$parameters'));
    try {
      if (parameters == null) {
        res = await http
            .get(Uri.parse('${baseUrl}/$url?token=$token')).timeout(Duration(seconds:10));
      } else {
        res = await http
            .get(Uri.parse('${baseUrl}/$url?token=${token}&$parameters')).timeout(Duration(seconds:10));
      }
      if (res.statusCode == 200) {
        jsonData = json.decode(res.body);
        return jsonData;
      } else {
       // print(res.body);
        jsonData = {
          'api_status': 0,
          'api_message': 'Network Error',
        };
        return jsonData;
      }
    } catch (e) {
      jsonData = {
        'api_status': 0,
        'api_message': '$e',
      };
      return jsonData;
    }
  }

  Future _getApi(String url, String parameters) async {
    preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token')!;
   // print(Uri.parse('${baseUrl}/$url?token=${token}&$parameters'));
    try {
      if (parameters == null) {
        res = await http
            .get(Uri.parse('${baseUrl}/$url?token=$token')).timeout(Duration(seconds:10));
      } else {
        res = await http
            .get(Uri.parse('${baseUrl}/$url?token=${token}&$parameters')).timeout(Duration(seconds:10));
      }
      if (res.statusCode == 200) {
        jsonData = json.decode(res.body);
        return jsonData;
      } else {
       // print(res.body);
        jsonData = {
          'api_status': 0,
          'api_message': 'Network Error',
        };
        return jsonData;
      }
    } catch (e) {
      jsonData = {
        'api_status': 0,
        'api_message': '$e',
      };
      return jsonData;
    }
  }

  Future getNextPage(String url) async {
    preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token')!;
   // print('${url}?token=$token');
    try {
      res = await http.get(Uri.parse('${url}&token=$token')).timeout(Duration(seconds: 10));
      if (res.statusCode == 200) {
        jsonData = json.decode(res.body);
        return jsonData;
      } else {
       // print(res.body);
        jsonData = {
          'api_status': 0,
          'api_message': 'Network Error',
        };
        return jsonData;
      }
    } catch (e) {
      jsonData = {
          'api_status': 0,
          'api_message': '$e',
        };
        return jsonData;
    }

  }

  getSession(String name) async{
    preferences = await SharedPreferences.getInstance();
    var result = preferences.getString(name) ?? null;
    // print(result);
    return result;
  }
}
