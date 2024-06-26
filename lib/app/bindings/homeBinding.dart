import 'package:get/get.dart';
import 'package:tractian_assets_tree_challenge/app/controller/companyController.dart';
import 'package:tractian_assets_tree_challenge/app/data/repository/companyRepository.dart';



class homeBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<CompanyController>(() => CompanyController(companyRepository()));
  }
}