import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/data/detailed_thing.model.dart';
import 'package:librarian_app/src/features/inventory/data/updated_image_model.dart';
import 'package:librarian_app/src/features/inventory/services/inventory.service.dart';

import 'thing.model.dart';

class InventoryViewModel extends ChangeNotifier {
  InventoryViewModel() {
    refresh();
  }

  final _service = InventoryService();

  bool _refreshing = false;

  bool get refreshing => _refreshing;

  set refreshing(bool value) {
    _refreshing = value;
    notifyListeners();
  }

  bool _editing = false;

  bool get editing => _editing;

  set editing(bool value) {
    _editing = value;
    notifyListeners();
  }

  List<ThingModel> get things => _service.cachedThings;

  String? selectedId;

  ThingModel? get selected => _service.getCachedThing(id: selectedId);

  List<ThingModel> getCachedThings({String? filter}) {
    return _service.getCachedThings(filter: filter);
  }

  Future<List<ThingModel>> getThings({String? filter}) async {
    return await _service.getThings(filter: filter);
  }

  Future<DetailedThingModel> getThingDetails({required String id}) async {
    return await _service.getThingDetails(id: id);
  }

  Future<ThingModel> createThing({
    required String name,
    String? spanishName,
  }) async {
    final thing = await _service.createThing(
      name: name,
      spanishName: spanishName,
    );

    refresh();

    return thing;
  }

  Future<void> updateThing({
    required String thingId,
    String? name,
    String? spanishName,
    bool? hidden,
    UpdatedImageModel? image,
  }) async {
    await _service.updateThing(
      thingId: thingId,
      name: name,
      spanishName: spanishName,
      hidden: hidden,
      image: image,
    );

    Future.delayed(Duration(seconds: image != null ? 1 : 0), refresh);
  }

  Future<void> createItems({
    required String thingId,
    required int quantity,
    required String? brand,
    required String? description,
    required double? estimatedValue,
  }) async {
    await _service.createItems(
      thingId: thingId,
      quantity: quantity,
      brand: brand,
      description: description,
      estimatedValue: estimatedValue,
    );

    notifyListeners();
  }

  void select(ThingModel thing) {
    _editing = false;
    selectedId = thing.id;
    notifyListeners();
  }

  void clearSelection() {
    selectedId = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    refreshing = true;
    await _service.updateCachedThings();
    refreshing = false;
  }
}
