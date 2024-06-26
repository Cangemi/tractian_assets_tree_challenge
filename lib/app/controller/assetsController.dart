import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian_assets_tree_challenge/app/data/model/AssetModel.dart';
import 'package:tractian_assets_tree_challenge/app/data/model/LocationModel.dart';
import 'package:tractian_assets_tree_challenge/app/data/repository/companyRepository.dart';

class AssetsController extends GetxController {
  final ScrollController scrollController = ScrollController();
  var locations = <Location>[];
  var assets = <Asset>[];
  var list = <String>[].obs;
  var listTreeNode = <Widget>[].obs;
  var isLoading = false.obs;
  var energyButton = false.obs;
  var energyButtonColor = Colors.white.obs;
  var criticalButton = false.obs;
  var criticalButtonColor = Colors.white.obs;
  var filter = ''.obs;
  var filterButton = ''.obs;
  RxList<Map<String, dynamic>> hierarchy = <Map<String, dynamic>>[].obs;
  var nodesLimit = 40.obs;

  final companyRepository repository;

  AssetsController(this.repository);

  void toggleEnergyButton() {
    filter.value = "";
    criticalButton.value = false;

    if (energyButton.value) {
      energyButton.value = false;
      filterButton.value = "";
    } else {
      energyButton.value = true;
      filterButton.value = "energy";
    }
  }

  void toggleCriticalButton() {
    filter.value = "";
    energyButton.value = false;

    if (criticalButton.value) {
      criticalButton.value = false;
      filterButton.value = "";
    } else {
      criticalButton.value = true;
      filterButton.value = "alert";
    }
  }

  void resetNodes() {
    nodesLimit.value = 20;
    update();
  }

  void loadMoreNodes() {
    nodesLimit.value += 20;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.maxScrollExtent -
            scrollController.position.pixels <=
        50) {
      loadMoreNodes();
    }
  }

  void getId(String id) async {
    isLoading(true);
    list.clear();
    await fetchLocations(id);
    await fetchAssets(id);
    await buildTreeList(locations, assets);
    isLoading(false);
  }

  Future<void> fetchLocations(String id) async {
    try {
      var result = await repository.fetchLocation(id);

      for (var location in result) {
        list.add(location.name);
        locations.add(location);
        if (location.parentId == null) {}
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {}
  }

  Future<void> fetchAssets(String id) async {
    try {
      var result = await repository.fetchAsset(id);
      for (var asset in result) {
        list.add(asset.name);
        assets.add(asset);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {}
  }

  List<Map<String, dynamic>> buildTreeAsset(
      var element, Map<String, List<Asset>> assetMap) {
    var hierarchyList = <Map<String, dynamic>>[];

    if (assetMap.containsKey(element.id)) {
      for (var e in assetMap[element.id]!) {
        var child = {
          'item': e,
          'children': buildTreeAsset(e, assetMap),
        };
        hierarchyList.add(child);
      }
    }

    return hierarchyList;
  }

  List<Map<String, dynamic>> buildTreeLocation(
      var element,
      Map<String, List<Location>> locationMap,
      Map<String, List<Asset>> assetMap) {
    var hierarchyList = <Map<String, dynamic>>[];

    if (locationMap.containsKey(element.id)) {
      for (var e in locationMap[element.id]!) {
        var child = {
          'item': e,
          'children': buildTreeLocation(e, locationMap, assetMap).isNotEmpty
              ? buildTreeLocation(e, locationMap, assetMap)
              : buildTreeAsset(e, assetMap),
        };
        hierarchyList.add(child);
      }
    }

    return hierarchyList;
  }

  Future<void> buildTreeList(
      List<Location> locations, List<Asset> assets) async {
    hierarchy.clear();

    var locationMap = <String, List<Location>>{};
    var assetMap = <String, List<Asset>>{};

    for (var loc in locations) {
      if (loc.parentId != null) {
        if (!locationMap.containsKey(loc.parentId)) {
          locationMap[loc.parentId!] = [];
        }
        locationMap[loc.parentId!]!.add(loc);
      }
    }

    for (var asset in assets) {
      var key = asset.locationId ?? asset.parentId;
      if (key != null) {
        if (!assetMap.containsKey(key)) {
          assetMap[key] = [];
        }
        assetMap[key]!.add(asset);
      }
    }

    var hierarchyMap = <String, Map<String, dynamic>>{};

    for (var loc in locations) {
      if (loc.parentId == null) {
        hierarchyMap[loc.id] = {
          'item': loc,
          'children': buildTreeLocation(loc, locationMap, assetMap).isNotEmpty
              ? buildTreeLocation(loc, locationMap, assetMap)
              : buildTreeAsset(loc, assetMap),
        };
        hierarchy.add(hierarchyMap[loc.id]!);
      }
    }

    for (var asset in assets) {
      if (asset.parentId == null && asset.locationId == null) {
        hierarchy.add(hierarchyMap[asset.id] = {
          'item': asset,
          'children': buildTreeAsset(asset, assetMap),
        });
      }
    }

    hierarchy.sort((a, b) {
      int aChildrenCount = a['children'] != null ? a['children'].length : 0;
      int bChildrenCount = b['children'] != null ? b['children'].length : 0;
      return bChildrenCount.compareTo(aChildrenCount);
    });
  }
}
