import 'package:get/get.dart';
import 'package:tractian_assets_tree_challenge/app/controller/assetsController.dart';
import 'package:tractian_assets_tree_challenge/app/data/repository/companyRepository.dart';


class assetsBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<AssetsController>(() => AssetsController(companyRepository()));
  }
}