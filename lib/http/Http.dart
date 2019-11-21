// 网络请求封装

import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

typedef void HttpSuccessCallBack(result);
typedef void HttpFailureCallBack(error);

class Http {

  final charles = false;

  final Dio dio = Dio();

  static final shared = Http();

  Http() {
    if (charles) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.findProxy = (uri) {
          //proxy all request to localhost:8888
          return HttpClient.findProxyFromEnvironment(uri, environment: {"http_proxy": 'http://10.3.132.95:8888',});
        };

        return client;
      };
    }
    // dio.httpClientAdapter = (HttpClient client) {
    //   client.findProxy = (uri) {
    //     //proxy all request to localhost:8888
    //     return "PROXY 10.3.128.1:8888";
    //   };
    //   // 你也可以自己创建一个新的HttpClient实例返回。
    //   // return new HttpClient(SecurityContext);
    // };
  }
  
  static Future<void> get(String url, {Map<String, dynamic> params, HttpSuccessCallBack success, HttpFailureCallBack failure}) async {
    try {
      Response response = await Http.shared.dio.get(url, queryParameters: params);
      if (success != null) {
        success(response.toString());
      }
    } catch (exception) {
      if (failure != null) {
        failure(exception);
      }
    }
  }

  static Future<void> post(String url, {Map<String, dynamic> params,  FormData data, HttpSuccessCallBack success, HttpFailureCallBack failure}) async {
    try {
      Response response = await Http.shared.dio.post(url, queryParameters: params, data: data);
      if (success != null) {
        success(response.toString());
      }
    } catch (exception) {
      if (failure != null) {
        failure(exception);
      }
    }
  }
}