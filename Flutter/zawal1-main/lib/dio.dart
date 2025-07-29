import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(
      BaseOptions(
        //baseUrl: 'https://livejob-app.com/api/',   ده هيتغير
        receiveDataWhenStatusError: true,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        // headers: {
        //   'Accept': 'application/json',
        // },
      ),
    );
  }

  static Future<Response> getData({
    @required String? url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    // dio!.options.headers = {
    //   'Authorization': 'Bearer $token' ?? '',
    //   'lang':  'en',
    // };

    return await dio!.get(
      url!,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    @required String? url,
    Map<String, dynamic>? query,
    @required dynamic data,
    String? token,
  }) async {
    // dio!.options.headers = {
    //   'Authorization': 'Bearer $token' ?? '',
    //   'lang':  'en',
    // };
    return await dio!.post(
      url!,
      queryParameters: query,
      data: data,
    );
  }

}
