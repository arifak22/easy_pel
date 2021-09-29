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
  Api(apiID: 1, name: 'Login', uri:'login/cek_loginv3'),
  Api(apiID: 2, name: 'Logout', uri:'login/logout'),

  Api(apiID: 3, name: 'Waktu', uri:'services/datetime'),
  Api(apiID: 4, name: 'postPresensi', uri:'presensi/submit'),
  Api(apiID: 5, name: 'getPresensi', uri:'presensi/list'),
  Api(apiID: 6, name: 'postTempPresensi', uri:'presensi/submittemp'),

  Api(apiID: 7, name: 'getPenghasilan', uri:'penghasilan/data'),
  Api(apiID: 8, name: 'getKetidakhadiran', uri:'presensi/list_ketidakhadiran'),
  Api(apiID: 9, name: 'getKetidakhadiranDetail', uri:'presensi/ketidakhadiran_detail'),
  Api(apiID: 10, name: 'getLampiran', uri:'presensi/lampiran'),


];

class Services {
 static const String baseUrl = false ?'http://localhost:8080/ci/api' :'https://imais.pel.co.id/ci/api';

  late SharedPreferences preferences;
  var res, jsonData;
  late Map<String, dynamic> response;
  // ignore: deprecated_member_use
  // List data = List();
  var uri;
  late String token;

  Future postLogin(String username, String password, String deviceID, String force) async {
    String url = '${baseUrl}/login/cek_loginv3';
    print(url);
    try {
      res = await http.post(
        Uri.parse(url),
        body: {
          'username': username,
          'password': password,
          'device'  : deviceID,
          'force'   : force
        },
      ).timeout(Duration(seconds: 10));
      response = json.decode(res.body);
      print(response);
      if (res.statusCode == 200) {
        if (response['api_status'] == 1) {
          preferences = await SharedPreferences.getInstance();
          preferences.setString('token', 'random');
          preferences.setString('id', response['data']["USER_LOGIN_ID"]);
          preferences.setString('pegawai_id', response['data']["PEGAWAI_ID"]);
          preferences.setString('name', response['data']["NAMA"]);
          preferences.setString('position', json.encode(response['titik_absen']));
          preferences.setString('zona_waktu', response['titik_absen'][0]["ZONA_WAKTU"]);
          preferences.setString('temp', json.encode([]));
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
    body['token'] = token;
    List<Api> apiData = apiList.where((element) => element.name == uri).toList();
    var url = apiData[0].uri;
   // print('${baseUrl}/$url');
   print(body);
    try {
      res = await http
          .post(Uri.parse('${baseUrl}/$url'),body: body).timeout(Duration(milliseconds: 10000));
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
    var result = preferences.getString(name);
    // print(result);
    return result;
  }
}
