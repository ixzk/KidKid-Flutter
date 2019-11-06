// 网络请求封装

import 'package:dio/dio.dart';

class Http {
  
  Future<void> get(String url, [Map<String, dynamic> params]) async {
    Response response = await Dio().get(url, queryParameters: params);
    return response;
  }

  Future<void> post(String url, [Map<String, dynamic> params]) async {
    Response response = await Dio().post(url, queryParameters: params);
    return response;
  }
}