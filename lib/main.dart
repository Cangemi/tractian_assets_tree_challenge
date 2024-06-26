import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian_assets_tree_challenge/app/routes/appRoutes.dart';
import 'package:tractian_assets_tree_challenge/app/routes/appPages.dart';
import 'package:tractian_assets_tree_challenge/app/ui/theme/appTheme.dart';

void main() {
   runApp( GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Tracitan",
    initialRoute: Routes.HOME,
    getPages: appPages.routes,
    theme: appThemeData,
    ));
}


