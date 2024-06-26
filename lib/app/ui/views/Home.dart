import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian_assets_tree_challenge/app/controller/companyController.dart';
import 'package:tractian_assets_tree_challenge/app/routes/appRoutes.dart';
import 'package:tractian_assets_tree_challenge/my_icons_icons.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final CompanyController companyController = Get.find<CompanyController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Tractian',
          style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: companyController.companies.length,
                itemBuilder: (context, index) {
                  final company = companyController.companies[index];
                  return Container(
                    margin: const EdgeInsets.all(21),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 34),
                      ),
                      onPressed: () {
                        Get.toNamed(Routes.ASSETS,
                            arguments: {'id': company.id});
                      },
                      child: Row(
                        children: [
                          const Icon(MyIcons.cubes),
                          const SizedBox(width: 20,),
                          Text(
                        "${company.name} Unit",
                        style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500,),
                      )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
