import 'dart:async';
import 'package:http/http.dart' as http;

class BaseApi {
  final Map<String, String> queryParameters;
  final String path;

  BaseApi({this.queryParameters, this.path});

  final String authority = 'developers.zomato.com';
  final String basePath = 'api/v2.1/';

  Uri get uri => Uri.https(authority, basePath + path, queryParameters);

  final _apiKey = '7b42570f0890069b2474706dbe60f007';

  Future<http.Response> get response async {
    var response = await http.get(uri, headers: {'user-key': _apiKey});
    if (response.statusCode == 200) {
      return response;
    } else {
      return null;
    }
  }
}
