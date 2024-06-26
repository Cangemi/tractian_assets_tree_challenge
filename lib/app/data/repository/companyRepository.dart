
import 'package:tractian_assets_tree_challenge/app/data/model/AssetModel.dart';
import 'package:tractian_assets_tree_challenge/app/data/model/CompanyModel.dart';
import 'package:tractian_assets_tree_challenge/app/data/model/LocationModel.dart';
import 'package:tractian_assets_tree_challenge/app/data/provider/companyProvider.dart';

class companyRepository{
  final CompanyProvider apiClient = CompanyProvider();

  Future<List<Company>> fetchCompanies() async {
    return apiClient.fetchCompanies();
  }

  Future<List<Location>> fetchLocation(String id) async {
    return apiClient.fetchLocation(id);
  }

  Future<List<Asset>> fetchAsset(String id) async{
    return apiClient.fetchAsset(id);
  }

}