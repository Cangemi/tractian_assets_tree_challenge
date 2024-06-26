import 'package:get/get.dart';
import 'package:tractian_assets_tree_challenge/app/data/model/AssetModel.dart';

import 'dart:convert';

import 'package:tractian_assets_tree_challenge/app/data/model/CompanyModel.dart';
import 'package:http/http.dart' as http;
import 'package:tractian_assets_tree_challenge/app/data/model/LocationModel.dart';

const baseUrl = 'https://fake-api.tractian.com';

class CompanyProvider extends GetConnect {
  Future<List<Company>> fetchCompanies() async {
    final response = await http.get(Uri.parse('$baseUrl/companies'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((data) => Company.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<List<Location>> fetchLocation(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/companies/$id/locations'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((data) => Location.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load location');
    }
  }


  Future<List<Asset>> fetchAsset(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/companies/$id/assets'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((data) => Asset.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load location');
    }
  }
}
