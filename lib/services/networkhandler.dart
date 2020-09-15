import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Networkhandling {
  String baseurl = 'http://188.166.167.28:3000';
  Future get(String url) async {
    url = formatter(url);
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    url = formatter(url);
    print(url);
    print(body);
    var response = await http.post(url,
        body: json.encode(body), headers: {"Content-type": "application/json"});
    print(json.encode(body));
    return response;
  }

  Future<http.Response> patchImage(String url, String filepath) async {
    url = formatter(url);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("upload", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    var response = await request.send();
    var res = await http.Response.fromStream(response);
    return res;
  }

  NetworkImage getImage(String url) {
    String url = formatter('kindi');
    NetworkImage(url);
  }

  String formatter(String url) => baseurl + url;
}
