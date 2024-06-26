import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tractian_assets_tree_challenge/app/bindings/assetsBinding.dart';
import 'package:tractian_assets_tree_challenge/app/bindings/homeBinding.dart';
import 'package:tractian_assets_tree_challenge/app/routes/appRoutes.dart';
import 'package:tractian_assets_tree_challenge/app/ui/views/Assets.dart';
import 'package:tractian_assets_tree_challenge/app/ui/views/Home.dart';

class appPages{
  static final routes = [
    GetPage(name: Routes.HOME, page: () => const Home(), binding: homeBinding()),
    GetPage(name: Routes.ASSETS, page: () =>  const Assets(),binding: assetsBinding()),
  ];
}