import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/data/detailed_thing_model.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_repository.dart';

import 'thing_model.dart';

class InventoryViewModel extends ChangeNotifier {
  InventoryViewModel() {
    refresh();
  }

  bool _editing = false;

  bool get editing => _editing;

  set editing(bool value) {
    _editing = value;
    notifyListeners();
  }

  final _repository = InventoryRepository();

  List<ThingModel> get things => _repository.things;

  String? selectedId;

  ThingModel? get selected =>
      selectedId != null ? things.firstWhere((t) => t.id == selectedId) : null;

  List<ThingModel> filtered(String filter) {
    if (filter.isEmpty) {
      return things;
    }

    return things
        .where((t) => t.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  Future<DetailedThingModel> getThingDetails({required String id}) async {
    return await _repository.getThingDetails(id: id);
  }

  Future<ThingModel> createThing({
    required String name,
    String? spanishName,
  }) async {
    final thing = await _repository.createThing(
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
  }) async {
    await _repository.updateThing(
      thingId: thingId,
      name: name,
      spanishName: spanishName,
    );

    refresh();
  }

  Future<void> createItems({
    required String thingId,
    required int quantity,
    required String? brand,
    required String? description,
    required double? estimatedValue,
  }) async {
    await _repository.createItems(
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
    await _repository.refresh();
    notifyListeners();
  }
}
