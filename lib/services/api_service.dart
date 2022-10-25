import 'dart:convert';

import 'package:flutterhw14/common/const.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _apiService = ApiService._internal();
  factory ApiService() => _apiService;
  ApiService._internal();

  Future request({
    Method method = Method.get,
    required String path,
  }) async {
    final uri = Uri.parse(baseUrl+path);
    http.Response response;

    response = await http.get(uri);

    if(response.statusCode>=200&&response.statusCode<300){
      final json = jsonDecode(response.body);
      if(json['code']==0){
        final data = json['data'];
        return data;
      }else{
        print('${json['message']}');
        throw Exception(json['message']);
      }
    }
    throw Exception('Error: ${response.statusCode}');
  }
}

ApiService apiService = ApiService();

enum Method {
  get,
  post,
  put,
  delete,
}
