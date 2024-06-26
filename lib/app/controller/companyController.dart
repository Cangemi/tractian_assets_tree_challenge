import 'package:get/get.dart';
import 'package:tractian_assets_tree_challenge/app/data/model/CompanyModel.dart';
import 'package:tractian_assets_tree_challenge/app/data/repository/companyRepository.dart';

class CompanyController extends GetxController {

  var companies = <Company>[].obs;
  var isLoading = false.obs;
  final companyRepository repository;

  CompanyController(this.repository);

  @override
  void onInit() {
    fetchCompanies();
    super.onInit();
  }

  void fetchCompanies() async {
    isLoading(true);
    try {
      var result = await repository.fetchCompanies();
      companies.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}