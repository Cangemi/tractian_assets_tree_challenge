import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian_assets_tree_challenge/app/controller/assetsController.dart';
import 'package:tractian_assets_tree_challenge/app/data/model/AssetModel.dart';
import 'package:tractian_assets_tree_challenge/app/ui/widgets/CustomButton.dart';
import 'package:tractian_assets_tree_challenge/app/ui/widgets/CustomExpansionTile.dart';
import 'package:tractian_assets_tree_challenge/app/ui/widgets/TextFieldSuggestions.dart';

class Assets extends StatelessWidget {
  const Assets({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments;
    final AssetsController assetsController = Get.find<AssetsController>();

    assetsController.getId(arguments['id']);

    Widget treeNode(String title, List<Widget> children,String type,
        {String status = "", bool isExpanded = false, bool hasChild = false}) {
      return Container(
        margin: const EdgeInsets.only(left: 2,bottom: 5,top: 5),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: CustomExpansionTile(
            title: title,
            status: status,
            isExpanded: isExpanded,
            hasChild: hasChild,
            type: type,
            children: children,
          ),
        ),
      );
    }

    List<Widget> buildTreeNodes(List<Map<String, dynamic>> nodes, String filter,
        String filterButton, int limit) {
      List<Widget> filteredNodes = [];
      String lowerCaseFilter = filter.toLowerCase();
      String lowerCaseFilterButton = filterButton.toLowerCase();
      String type ="";
      int count = 0;
      for (var node in nodes) {
        if (count >= limit) break;

        var item = node['item'];
        var itemName = item.name.toString().toLowerCase();
        var nodeChildren = node['children'] ?? [];
        var itemStatus = "";
        var itemType = "";

        bool itemNameIsEqualFilter = (itemName == lowerCaseFilter);
        bool itemIsAsset = item is Asset;

        if (itemIsAsset) {
          if(item.status != null){
            itemStatus = item.status.toString().toLowerCase();
            itemType = item.sensorType.toString().toLowerCase();
            type = "component";            
          }else{
            type = "asset";  
          }
          
        }else{
          type = "location";  
        }

        bool itemStatusIsEqualFilterButton =
            ((itemIsAsset && item.status != null ) && itemStatus == lowerCaseFilterButton);
        bool itemTypeIsEqualFilterButton =
            ((itemIsAsset && item.status != null ) && itemType == lowerCaseFilterButton);

        List<Widget> children;
        if (itemNameIsEqualFilter ||
            itemStatusIsEqualFilterButton ||
            itemTypeIsEqualFilterButton) {
          children = buildTreeNodes(nodeChildren, "", "", limit);
        } else {
          children = buildTreeNodes(nodeChildren, filter, filterButton, limit);
        }

        bool hasChild = children.isNotEmpty;
        bool isExpanded =
            (filter.isNotEmpty && hasChild || filterButton.isNotEmpty);

        if (filter.isNotEmpty || filterButton.isNotEmpty) {
          if (itemNameIsEqualFilter ||
              itemStatusIsEqualFilterButton ||
              itemTypeIsEqualFilterButton ||
              hasChild) {
            if (itemNameIsEqualFilter ||
                itemStatusIsEqualFilterButton ||
                itemTypeIsEqualFilterButton) {
              isExpanded = false;
            }

            filteredNodes.add(treeNode(item.name, children,type,
                status: (itemIsAsset && item.status != null ) ? item.status! : "",
                isExpanded: isExpanded,
                hasChild: hasChild));
            count++;
          }
        } else {
          filteredNodes.add(treeNode(item.name, children,type,
              status: (itemIsAsset && item.status != null ) ? item.status! : "",
              isExpanded: isExpanded,
              hasChild: hasChild));
          count++;
        }
      }
      return filteredNodes;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Assets',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400
            ),
        ),
         leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextFieldSuggestions(
              list: assetsController.list,
              labelText: "Buscar ativo ou Local",
              textSuggetionsColor: Colors.grey,
              suggetionsBackgroundColor: Colors.grey,
              outlineInputBorderColor: Colors.grey,
              returnedValue: (value) {
                assetsController.filter.value = value;
                assetsController.filterButton.value = "";
                assetsController.criticalButton.value = false;
                assetsController.energyButton.value = false;
                assetsController.resetNodes();
              },
              onTap: () {},
              height: 200,
            ),
          ),
          Expanded(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() => CustomButton(
                    title: "Sensor de Energia",
                    icon: Icons.bolt_outlined,
                    onPressed: () {
                      assetsController.toggleEnergyButton();
                    },
                    isPressed: assetsController.energyButton.value,
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Obx(() => CustomButton(
                    title: "Crítico",
                    icon: Icons.error_outline,
                    onPressed: () {
                      assetsController.toggleCriticalButton();
                    },
                    isPressed: assetsController.criticalButton.value,
                  )),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Obx(() {
              if (assetsController.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                ));
              }
              final nodes = buildTreeNodes(
                  assetsController.hierarchy,
                  assetsController.filter.value,
                  assetsController.filterButton.value,
                  assetsController.nodesLimit.value);
              return nodes.isNotEmpty
                  ? ListView.builder(
                    controller: assetsController.scrollController,
                      itemCount: nodes.length,
                      itemBuilder: (context, index) {

                        return nodes[index];
                      },
                    )
                  : const Center(
                      child: Text("Resultado não encontrado!"),
                    );
            }),
          ),
        ],
      ),
    );
  }
}
