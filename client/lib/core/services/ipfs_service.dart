import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IPFSService {
  //Base Url
  final String url = 'https://ipfs.io/ipfs/';

  final nftStorageKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweEVDY0FBMGRGYkI4QmQ5Nzc3MDYxNTdmZTMyQUUyYTU2MGNFMzkwZjgiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTYzODcwODg0ODYxOSwibmFtZSI6Ik5GVCBNYXJrZXRwbGFjZSJ9.wtt_vDthKSl9FTLgLGSqMQhutD2hZ90Njijvfz0kHc4";

  Future<http.Response> getImage(String cid) async {
    try {
      final response = await http.get(Uri.parse(url + cid));

      return response;
    } catch (e) {
      debugPrint('Error at IPFS Service - getImage: $e');

      rethrow;
    }
  }

  Future<Map<String, dynamic>> getJson(String cid) async {
    try {
      final response = await http.get(Uri.parse(url + cid));

      final data = jsonDecode(response.body);

      return data;
    } catch (e) {
      debugPrint('Error at IPFS Service - getJson: $e');

      rethrow;
    }
  }

  Future<String> uploadMetaData(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.nft.storage/upload'),
        headers: {
          'Authorization': 'Bearer $nftStorageKey',
          'content-type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      final cid = data['value']['cid'];

      debugPrint('CID OF METADATA -> $cid');

      return cid;
    } catch (e) {
      debugPrint('Error at IPFS Service - uploadMetaData: $e');

      rethrow;
    }
  }

  Future<String> uploadImage(String imgPath) async {
    try {
      final bytes = File(imgPath).readAsBytesSync();

      final response = await http.post(
        Uri.parse('https://api.nft.storage/upload'),
        headers: {
          'Authorization': 'Bearer $nftStorageKey',
          'content-type': 'image/*'
        },
        body: bytes,
      );

      final data = jsonDecode(response.body);

      final cid = data['value']['cid'];

      debugPrint('CID OF IMAGE -> $cid');

      return cid;
    } catch (e) {
      debugPrint('Error at IPFS Service - uploadImage: $e');

      rethrow;
    }
  }
}
