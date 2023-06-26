import 'dart:async';
import 'dart:developer';

import 'package:getxtkchat/common/common.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpUtil {
  static HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  Uri baseUri = Uri.parse("https://www.tunckankilic.site");
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=utf-8',
  };

  HttpUtil._internal();

  void onError(ErrorEntity eInfo) {
    log('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');
    switch (eInfo.code) {
      case 401:
        UserStore.to.onLogout();
        EasyLoading.showError(eInfo.message);
        break;
      default:
        EasyLoading.showError('Unknown error');
        break;
    }
  }

  void cancelRequests() {
    // Perform necessary operations to cancel requests
  }

  Map<String, String> getAuthorizationHeader() {
    var headers = <String, String>{};
    if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
      headers['Authorization'] = 'Bearer ${UserStore.to.token}';
    }
    return headers;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri uri = baseUri.replace(path: path, queryParameters: queryParameters);
    var response = await http.get(uri, headers: headers);
    return jsonDecode(response.body);
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri uri = baseUri.replace(path: path, queryParameters: queryParameters);
    var response =
        await http.post(uri, headers: headers, body: jsonEncode(data));
    return jsonDecode(response.body);
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri uri = baseUri.replace(path: path, queryParameters: queryParameters);
    var response =
        await http.put(uri, headers: headers, body: jsonEncode(data));
    return jsonDecode(response.body);
  }

  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri uri = baseUri.replace(path: path, queryParameters: queryParameters);
    var response =
        await http.patch(uri, headers: headers, body: jsonEncode(data));
    return jsonDecode(response.body);
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri uri = baseUri.replace(path: path, queryParameters: queryParameters);
    var response =
        await http.delete(uri, headers: headers, body: jsonEncode(data));
    return jsonDecode(response.body);
  }

  Future<dynamic> postForm(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    // Perform necessary operations for sending form data
  }

  Future<dynamic> postStream(
    String path, {
    dynamic data,
    int dataLength = 0,
    Map<String, dynamic>? queryParameters,
  }) async {
    // Perform necessary operations for sending stream data
  }
}

class ErrorEntity implements Exception {
  int code = -1;
  String message = "";
  ErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == "") return "Exception";
    return "Exception: code $code, $message";
  }
}
