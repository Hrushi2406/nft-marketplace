import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

//TODO://Configure according to project
class NetworkService {
  NetworkService({
    required this.baseUrl,
    required this.httpService,
    this.defaultHeaders,
  });

  ///Instance of Http client
  final http.Client httpService;

  ///Base URL
  final String baseUrl;

  ///Default Headers
  Map<String, String>? defaultHeaders;

  ///Headers are set to defult
  ///
  ///And are passed with each request
  void setDefaultHeaders(Map<String, String> headers) {
    defaultHeaders = headers;
  }

  ///GET Request
  ///
  ///If headers are null then default are used
  Future<Map<String, dynamic>?> get(
    String endPoint, {
    Map<String, String>? headers,
  }) async {
    try {
      //Parse the url into uri
      final Uri _url = Uri.parse(baseUrl + endPoint);

      //Make request
      final response = await httpService.get(
        _url,
        headers: headers ?? defaultHeaders,
      );

      //Check for body
      if (response.body.isEmpty) {
        return null;
      }

      //If request is successfull then return data
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      debugPrint('Response body: ${response.body}');
    } catch (e) {
      debugPrint('Errors: $e');

      throw e.toString();
    }
  }

  ///POST Request
  ///
  ///If headers are null then default are used
  Future<Map<String, dynamic>?> post(
    String endPoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      //Parse the url into uri
      final Uri _url = Uri.parse(baseUrl + endPoint);

      //Make request
      final response = await httpService.post(
        _url,
        headers: headers ?? defaultHeaders,
        body: body,
      );

      if (response.statusCode == 201) {
        return null;
      }

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      debugPrint('Respose body: ${response.body}');
    } catch (e) {
      debugPrint('Error: $e');

      throw e.toString();
    }
  }

  ///DELETE Request
  ///
  ///If headers are null then default are used
  Future<Map<String, dynamic>?> delete(
    String endPoint, {
    Map<String, String>? headers,
  }) async {
    try {
      //Parse the url into uri
      final Uri _url = Uri.parse(baseUrl + endPoint);

      //Make request
      final response = await httpService.post(
        _url,
        headers: headers ?? defaultHeaders,
      );

      if (response.statusCode == 204) {
        return null;
      }

      debugPrint('Response body: ${response.body}');
    } catch (e) {
      debugPrint('Error: $e');

      throw e.toString();
    }
  }
}
